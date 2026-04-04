import 'dart:async';
import 'dart:math' as math;

import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_router.gr.dart';
import '../../../../core/design_system/app_palette.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/events/auth_events.dart';
import '../bloc/states/auth_states.dart';

/// Análise pós-liveness: timer na análise; após o [AuthBloc] concluir, respeita
/// tempos mínimos antes dos ícones e antes de navegar.
@RoutePage(deferredLoading: true)
class SelfieVerificationPage extends StatefulWidget {
  const SelfieVerificationPage({super.key});

  /// Duração da fase “analisando” (UI). A conclusão real vem do [AuthBloc].
  static const int mockCountdownSeconds = 60;

  /// Tempo mínimo com a tela de timer desde a abertura da página.
  static const Duration minimumTimerVisibleDuration = Duration(seconds: 3);

  /// Após a API responder, permanece na análise (timer) por este tempo.
  static const Duration postResultAnalyzingHold = Duration(seconds: 1);

  /// Com o ícone de sucesso/erro visível antes de redirecionar ou voltar.
  static const Duration postIconNavigationDelay = Duration(milliseconds: 2300);

  @override
  State<SelfieVerificationPage> createState() => _SelfieVerificationPageState();
}

enum _VerificationPhase { analyzing, success, error }

class _SelfieVerificationPageState extends State<SelfieVerificationPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _countdownController;
  late final DateTime _pageOpenedAt;
  _VerificationPhase _phase = _VerificationPhase.analyzing;
  Timer? _outcomeChainTimer;
  bool _analysisOutcomeHandlingStarted = false;
  AuthBloc? _authBloc;
  String? _errorDetail;

  @override
  void initState() {
    super.initState();
    _pageOpenedAt = DateTime.now();
    final total = SelfieVerificationPage.mockCountdownSeconds;
    _countdownController = AnimationController(
      vsync: this,
      duration: Duration(seconds: total),
    );
    _countdownController.forward();
  }

  void _cancelOutcomeChain() {
    _outcomeChainTimer?.cancel();
    _outcomeChainTimer = null;
  }

  /// Garante ≥ [minimumTimerVisibleDuration] desde [_pageOpenedAt], depois
  /// [postResultAnalyzingHold] ainda em análise, ícones, [postIconNavigationDelay], [onEnd].
  void _runOutcomeSequence({required void Function() showIconsAndThenEnd}) {
    _cancelOutcomeChain();

    final elapsed = DateTime.now().difference(_pageOpenedAt);
    final waitMinTimer = SelfieVerificationPage.minimumTimerVisibleDuration -
        elapsed;
    final phase1 = waitMinTimer.isNegative ? Duration.zero : waitMinTimer;

    _outcomeChainTimer = Timer(phase1, () {
      _outcomeChainTimer = null;
      if (!mounted) return;
      _outcomeChainTimer = Timer(
        SelfieVerificationPage.postResultAnalyzingHold,
        () {
          _outcomeChainTimer = null;
          if (!mounted) return;
          _countdownController.stop();
          showIconsAndThenEnd();
        },
      );
    });
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
    if (state is SendLivenessSuccess) {
      _applySendLivenessSuccess(state);
    } else if (state is SendLivenessError) {
      _applyAnalysisFailure(message: state.failure.message);
    }
  }

  void _applySendLivenessSuccess(SendLivenessSuccess state) {
    if (!mounted ||
        _phase != _VerificationPhase.analyzing ||
        _analysisOutcomeHandlingStarted) {
      return;
    }
    _analysisOutcomeHandlingStarted = true;

    _runOutcomeSequence(
      showIconsAndThenEnd: () {
        if (!mounted) return;
        setState(() {
          _phase = _VerificationPhase.success;
          _errorDetail = null;
        });

        _outcomeChainTimer = Timer(
          SelfieVerificationPage.postIconNavigationDelay,
          () {
            _outcomeChainTimer = null;
            if (!mounted) return;
            context.router.replace(const NotificationPermissionRoute());
          },
        );
      },
    );
  }

  void _applyAnalysisFailure({required String message}) {
    if (!mounted ||
        _phase != _VerificationPhase.analyzing ||
        _analysisOutcomeHandlingStarted) {
      return;
    }
    _analysisOutcomeHandlingStarted = true;

    _runOutcomeSequence(
      showIconsAndThenEnd: () {
        if (!mounted) return;
        setState(() {
          _phase = _VerificationPhase.error;
          _errorDetail = message;
        });

        _outcomeChainTimer = Timer(
          SelfieVerificationPage.postIconNavigationDelay,
          () {
            _outcomeChainTimer = null;
            if (!mounted) return;
            unawaited(_popBackToSelfieSubmission());
          },
        );
      },
    );
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
    _cancelOutcomeChain();
    _countdownController.dispose();
    _authBloc?.add(const SendLivenessReset());
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;
    final horizontal = AppSpacing.pageHorizontal;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (prev, current) =>
          current is SendLivenessSuccess || current is SendLivenessError,
      listener: (context, state) {
        if (state is SendLivenessSuccess) {
          _applySendLivenessSuccess(state);
        } else if (state is SendLivenessError) {
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
                          c is SendLivenessLoading ||
                          c is SendLivenessSuccess ||
                          c is SendLivenessError ||
                          c is SendLivenessInitial,
                      builder: (context, state) {
                        return Text(
                          'Debug: AuthBloc sendLiveness = ${state.runtimeType}',
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
