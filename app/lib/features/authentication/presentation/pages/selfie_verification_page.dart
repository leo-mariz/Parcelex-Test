import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/setup_locator.dart';
import '../../../../core/enums/authentication/onboarding_step.dart';
import '../../../../core/presentation/app_scaffold_messenger.dart';
import '../../../../core/config/app_router.gr.dart';
import '../../../../core/design_system/app_palette.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/services/auth_services.dart';
import '../../../users/presentation/bloc/events/users_events.dart';
import '../../../users/presentation/bloc/users_bloc.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/events/auth_events.dart';
import '../bloc/states/auth_states.dart';

/// Análise pós-liveness: timer visual enquanto [LivenessAnalysisLoading];
/// ao receber sucesso ou falha do [AuthBloc], anima para o ícone correspondente.
@RoutePage(deferredLoading: true)
class SelfieVerificationPage extends StatefulWidget {
  const SelfieVerificationPage({super.key});

  /// Duração da fase “analisando” (UI). A conclusão real vem do [AuthBloc].
  static const int mockCountdownSeconds = 60;

  /// Espera após o [AuthBloc] emitir sucesso/erro antes de mostrar o ícone.
  static const Duration resultIconRevealDelay = Duration(seconds: 2);

  @override
  State<SelfieVerificationPage> createState() => _SelfieVerificationPageState();
}

enum _VerificationPhase { analyzing, success, error }

class _SelfieVerificationPageState extends State<SelfieVerificationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _countdownController;
  _VerificationPhase _phase = _VerificationPhase.analyzing;
  Timer? _errorExitTimer;
  Timer? _resultIconDelayTimer;
  bool _analysisOutcomeHandlingStarted = false;
  AuthBloc? _authBloc;
  String? _errorDetail;

  @override
  void initState() {
    super.initState();
    final total = SelfieVerificationPage.mockCountdownSeconds;
    _countdownController = AnimationController(
      vsync: this,
      duration: Duration(seconds: total),
    );
    _countdownController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _authBloc ??= context.read<AuthBloc>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _syncFromAuthState(_authBloc!.state);
    });
  }

  void _syncFromAuthState(AuthState state) {
    if (_phase != _VerificationPhase.analyzing ||
        _analysisOutcomeHandlingStarted) {
      return;
    }
    if (state is LivenessAnalysisSuccess) {
      _applyAnalysisSuccess(state);
    } else if (state is LivenessAnalysisError) {
      _applyAnalysisFailure(message: state.failure.message);
    }
  }

  void _applyAnalysisSuccess(LivenessAnalysisSuccess state) {
    if (!mounted ||
        _phase != _VerificationPhase.analyzing ||
        _analysisOutcomeHandlingStarted) {
      return;
    }
    _analysisOutcomeHandlingStarted = true;
    _countdownController.stop();
    final passed = state.result.passed;
    final failureDetail =
        state.result.failureReason ?? 'Verificação não aprovada.';
    _resultIconDelayTimer?.cancel();
    _resultIconDelayTimer = Timer(SelfieVerificationPage.resultIconRevealDelay, () {
      _resultIconDelayTimer = null;
      if (!mounted) return;
      if (_phase != _VerificationPhase.analyzing) return;
      setState(() {
        _phase = passed ? _VerificationPhase.success : _VerificationPhase.error;
        _errorDetail = passed ? null : failureDetail;
      });
      if (passed) {
        final uid = getIt<AuthService>().currentUser?.uid;
        if (uid != null && uid.isNotEmpty) {
          context.read<UsersBloc>().add(
                UpdateUserOnboardingStepSubmitted(
                  userId: uid,
                  onboardingStep: OnboardingStep.permissions,
                ),
              );
          if (!mounted) return;
          context.router.replace(
            AuthLoadingRoute(
              cpfMasked: '',
              awaitingOnboardingStepUpdate: true,
            ),
          );
        } else {
          appScaffoldMessengerKey.currentState?.showSnackBar(
            const SnackBar(
              content: Text('Sessão inválida. Faça login novamente.'),
            ),
          );
        }
      } else {
        _scheduleErrorExit();
      }
    });
  }

  void _applyAnalysisFailure({required String message}) {
    if (!mounted ||
        _phase != _VerificationPhase.analyzing ||
        _analysisOutcomeHandlingStarted) {
      return;
    }
    _analysisOutcomeHandlingStarted = true;
    _countdownController.stop();
    _resultIconDelayTimer?.cancel();
    _resultIconDelayTimer = Timer(SelfieVerificationPage.resultIconRevealDelay, () {
      _resultIconDelayTimer = null;
      if (!mounted) return;
      if (_phase != _VerificationPhase.analyzing) return;
      setState(() {
        _phase = _VerificationPhase.error;
        _errorDetail = message;
      });
      _scheduleErrorExit();
    });
  }

  void _scheduleErrorExit() {
    _errorExitTimer?.cancel();
    _errorExitTimer = Timer(const Duration(seconds: 2), () {
      _errorExitTimer = null;
      if (!mounted) return;
      unawaited(_popBackToSelfieSubmission());
    });
  }

  /// Remove [SelfieVerificationRoute] e [SelfieLivenessRoute] da pilha.
  Future<void> _popBackToSelfieSubmission() async {
    if (!mounted) return;
    await context.router.maybePop();
    if (!mounted) return;
    await context.router.maybePop();
  }

  @override
  void dispose() {
    _errorExitTimer?.cancel();
    _resultIconDelayTimer?.cancel();
    _countdownController.dispose();
    _authBloc?.add(const LivenessAnalysisReset());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;
    final horizontal = AppSpacing.pageHorizontal;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, current) =>
          current is LivenessAnalysisSuccess ||
          current is LivenessAnalysisError,
      listener: (context, state) {
        if (state is LivenessAnalysisSuccess) {
          _applyAnalysisSuccess(state);
        } else if (state is LivenessAnalysisError) {
          _applyAnalysisFailure(message: state.failure.message);
        }
      },
      child: Scaffold(
        backgroundColor: Theme.of(context).colorScheme.surface,
        body: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: horizontal),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: DSSize.height(64)),
                AnimatedSize(
                  duration: const Duration(milliseconds: 380),
                  curve: Curves.easeInOutCubic,
                  alignment: Alignment.topCenter,
                  child: _phase == _VerificationPhase.analyzing
                      ? Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Aguarde alguns instantes',
                              style: typo.headlineMedium,
                            ),
                            SizedBox(height: DSSize.height(16)),
                            Text(
                              'Estamos realizando a análise de segurança das '
                              'informações enviadas.',
                              style: typo.bodyLarge400,
                            ),
                            SizedBox(height: DSSize.height(32)),
                          ],
                        )
                      : SizedBox(height: DSSize.height(80)),
                ),
                Expanded(
                  child: Align(
                    alignment: Alignment.topCenter,
                    child: Padding(
                      padding: EdgeInsets.only(top: AppSpacing.sectionGap),
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 450),
                        switchInCurve: Curves.easeOutCubic,
                        switchOutCurve: Curves.easeInCubic,
                        transitionBuilder: (child, animation) {
                          return FadeTransition(
                            opacity: animation,
                            child: ScaleTransition(
                              scale: Tween<double>(begin: 0.88, end: 1).animate(
                                CurvedAnimation(
                                  parent: animation,
                                  curve: Curves.easeOutCubic,
                                ),
                              ),
                              child: child,
                            ),
                          );
                        },
                        child: KeyedSubtree(
                          key: ValueKey(_phase),
                          child: _phase == _VerificationPhase.analyzing
                              ? AnimatedBuilder(
                                  animation: _countdownController,
                                  builder: (context, child) {
                                    final remaining =
                                        1.0 - _countdownController.value;
                                    return _CountdownRing(
                                      progressRemaining:
                                          remaining.clamp(0.0, 1.0),
                                      totalSeconds: SelfieVerificationPage
                                          .mockCountdownSeconds,
                                    );
                                  },
                                )
                              : _phase == _VerificationPhase.success
                                  ? const _ResultIcon(success: true)
                                  : Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        const _ResultIcon(success: false),
                                        SizedBox(height: DSSize.height(20)),
                                        Padding(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: DSSize.width(12),
                                          ),
                                          child: Text(
                                            _errorDetail ??
                                                'Não foi possível concluir a '
                                                    'verificação. Tente novamente.',
                                            textAlign: TextAlign.center,
                                            style: typo.bodyMedium400,
                                          ),
                                        ),
                                      ],
                                    ),
                        ),
                      ),
                    ),
                  ),
                ),
                if (kDebugMode) ...[
                  Padding(
                    padding: EdgeInsets.only(bottom: DSSize.height(12)),
                    child: BlocBuilder<AuthBloc, AuthState>(
                      buildWhen: (p, c) =>
                          c is LivenessAnalysisLoading ||
                          c is LivenessAnalysisSuccess ||
                          c is LivenessAnalysisError ||
                          c is LivenessAnalysisInitial,
                      builder: (context, state) {
                        return Text(
                          'Debug: AuthBloc liveness = ${state.runtimeType}',
                          textAlign: TextAlign.center,
                          style: typo.bodyMedium400.copyWith(
                            color: Theme.of(context)
                                .colorScheme
                                .onSurfaceVariant,
                          ),
                        );
                      },
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CountdownRing extends StatelessWidget {
  const _CountdownRing({
    required this.progressRemaining,
    required this.totalSeconds,
  });

  /// Fração do tempo restante em relação ao total (`1` = início, `0` = fim).
  final double progressRemaining;
  final int totalSeconds;

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;
    final side = DSSize.width(144);
    final stroke = DSSize.width(8);
    final progress = totalSeconds <= 0
        ? 0.0
        : progressRemaining.clamp(0.0, 1.0);
    final secondsLabel =
        (progress * totalSeconds).round().clamp(0, totalSeconds);

    return SizedBox(
      width: side,
      height: side,
      child: Stack(
        alignment: Alignment.center,
        children: [
          CustomPaint(
            size: Size(side, side),
            painter: _CountdownRingPainter(
              progress: progress,
              trackColor: AppPalette.borderDefault,
              progressColor: AppPalette.borderFocus,
              strokeWidth: stroke,
            ),
          ),
          Text(
            '${secondsLabel}s',
            style: typo.displayHero.copyWith(
              color: AppPalette.borderFocus,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Trilho completo [borderDefault]; arco [borderFocus] no topo, diminuindo com o tempo.
class _CountdownRingPainter extends CustomPainter {
  _CountdownRingPainter({
    required this.progress,
    required this.trackColor,
    required this.progressColor,
    required this.strokeWidth,
  });

  final double progress;
  final Color trackColor;
  final Color progressColor;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.shortestSide - strokeWidth) / 2;

    final trackPaint = Paint()
      ..color = trackColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, trackPaint);

    if (progress <= 0) return;

    final rect = Rect.fromCircle(center: center, radius: radius);
    final arcPaint = Paint()
      ..color = progressColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final sweep = 2 * math.pi * progress;
    canvas.drawArc(
      rect,
      -math.pi / 2,
      sweep,
      false,
      arcPaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CountdownRingPainter oldDelegate) {
    return oldDelegate.progress != progress ||
        oldDelegate.trackColor != trackColor ||
        oldDelegate.progressColor != progressColor ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _ResultIcon extends StatelessWidget {
  const _ResultIcon({required this.success});

  final bool success;

  @override
  Widget build(BuildContext context) {
    final color =
        success ? AppPalette.surfaceSuccess : AppPalette.textError;
    final side = DSSize.width(144);
    final stroke = DSSize.width(8);
    final iconW = DSSize.width(36);
    final iconH = DSSize.height(36);

    return Container(
      width: side,
      height: side,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: color, width: stroke),
      ),
      alignment: Alignment.center,
      child: CustomPaint(
        size: Size(iconW, iconH),
        painter: success
            ? _ThickCheckPainter(color: color, strokeWidth: stroke)
            : _ThickCrossPainter(color: color, strokeWidth: stroke),
      ),
    );
  }
}

/// Check com traço configurável (Figma ~8px).
class _ThickCheckPainter extends CustomPainter {
  _ThickCheckPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    final w = size.width;
    final h = size.height;
    final path = Path()
      ..moveTo(w * 0.14, h * 0.52)
      ..lineTo(w * 0.42, h * 0.78)
      ..lineTo(w * 0.88, h * 0.22);
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant _ThickCheckPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}

/// Cruz (erro) com traço configurável.
class _ThickCrossPainter extends CustomPainter {
  _ThickCrossPainter({required this.color, required this.strokeWidth});

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    final pad = strokeWidth / 2;
    canvas.drawLine(
      Offset(pad, pad),
      Offset(size.width - pad, size.height - pad),
      paint,
    );
    canvas.drawLine(
      Offset(size.width - pad, pad),
      Offset(pad, size.height - pad),
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant _ThickCrossPainter oldDelegate) =>
      oldDelegate.color != color || oldDelegate.strokeWidth != strokeWidth;
}
