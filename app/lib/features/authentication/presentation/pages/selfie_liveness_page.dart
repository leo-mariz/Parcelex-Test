import 'dart:async';
import 'dart:ui' show lerpDouble;

import 'package:auto_route/auto_route.dart';
import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_router.gr.dart';
import '../../../../core/config/setup_locator.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/presentation/notifications/app_notifications.dart';
import '../../../../core/services/auth_services.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_palette.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/enums/face_framing/face_framing_phase.dart';
import '../../../../core/models/face_framing_snapshot.dart';
import '../../../../core/presentation/widgets/app_circle_close_button.dart';
import '../../../../core/services/face_framing_detector.dart';
import '../../../liveness/data/dtos/liveness_dto.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/events/auth_events.dart';
import '../../../liveness/presentation/cubit/face_framing_cubit.dart';

/// Fração da largura da tela para a elipse base (referência entre etapas 1 e 2).
const double _kLivenessOvalWidthFraction = 0.62;
const double _kLivenessOvalAspect = 1.34;

/// Etapa 1: elipse menor — usuário centraliza o rosto.
const double _kStage1Scale = 0.88;

/// Etapa 2: elipse maior — usuário aproxima até preencher.
const double _kStage2Scale = 1.16;

/// Tempo estável em [framed] na etapa 1 antes de expandir a elipse.
const Duration _kStage1FramedHold = Duration(milliseconds: 800);

/// Duração da animação de crescimento da elipse.
const Duration _kOvalExpandDuration = Duration(milliseconds: 420);

/// Etapa 2 (elipse maior na UI): faixa de largura relativa do rosto no frame da câmera.
/// Fora do “framed” global (0.18–0.42) de propósito — a elipse grande pede rosto maior.
const double _kStage2MinFaceWidthFraction = 0.34;
const double _kStage2MaxFaceWidthFraction = 0.52;

/// Tempo estável “ok” na etapa 2 antes de concluir o liveness.
const Duration _kStage2FramedHold = Duration(milliseconds: 1000);

/// Fluxo: (1) encaixar na elipse menor → (2) animação aumenta elipse → (3) aproximar até
/// encaixar na maior → emite análise e segue.
@RoutePage(deferredLoading: true)
class SelfieLivenessPage extends StatelessWidget {
  const SelfieLivenessPage({
    super.key,
    this.providerSessionId,
    this.livenessSessionId,
  });

  final String? providerSessionId;
  final String? livenessSessionId;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => FaceFramingCubit(getIt<FaceFramingDetector>()),
      child: _SelfieLivenessContent(
        providerSessionId: providerSessionId,
        livenessSessionId: livenessSessionId,
      ),
    );
  }
}

enum _LivenessUiStage {
  /// Elipse menor; aguardando [framed] estável.
  waitingAlign,

  /// Animação de expansão da elipse.
  expanding,

  /// Elipse maior; aguardando rosto maior (aproximação) + [framed] estável.
  waitingApproach,
}

class _SelfieLivenessContent extends StatefulWidget {
  const _SelfieLivenessContent({
    this.providerSessionId,
    this.livenessSessionId,
  });

  final String? providerSessionId;
  final String? livenessSessionId;

  @override
  State<_SelfieLivenessContent> createState() => _SelfieLivenessContentState();
}

class _SelfieLivenessContentState extends State<_SelfieLivenessContent>
    with SingleTickerProviderStateMixin {
  static const Duration _frameThrottle = Duration(milliseconds: 180);

  CameraController? _controller;
  String? _cameraError;
  DateTime? _lastFrameProcessed;
  Timer? _stage1HoldTimer;
  Timer? _stage2HoldTimer;
  bool _analysisDispatched = false;

  _LivenessUiStage _uiStage = _LivenessUiStage.waitingAlign;
  late final AnimationController _ovalExpandController;

  @override
  void initState() {
    super.initState();
    _ovalExpandController = AnimationController(
      vsync: this,
      duration: _kOvalExpandDuration,
    )
      ..addListener(() => setState(() {}))
      ..addStatusListener(_onExpandStatus);
    unawaited(_initCamera());
  }

  void _onExpandStatus(AnimationStatus status) {
    if (status == AnimationStatus.completed && mounted) {
      setState(() => _uiStage = _LivenessUiStage.waitingApproach);
    }
  }

  void _onFramingSnapshot(FaceFramingSnapshot snap) {
    if (_analysisDispatched) return;

    switch (_uiStage) {
      case _LivenessUiStage.waitingAlign:
        if (snap.phase == FaceFramingPhase.framed) {
          _stage1HoldTimer ??= Timer(_kStage1FramedHold, () {
            _stage1HoldTimer = null;
            if (!mounted || _analysisDispatched) return;
            if (_uiStage != _LivenessUiStage.waitingAlign) return;
            setState(() => _uiStage = _LivenessUiStage.expanding);
            _ovalExpandController.forward(from: 0);
          });
        } else {
          _stage1HoldTimer?.cancel();
          _stage1HoldTimer = null;
        }
        break;
      case _LivenessUiStage.expanding:
        break;
      case _LivenessUiStage.waitingApproach:
        final ok = _stage2FaceInTargetBand(snap);
        if (ok) {
          _stage2HoldTimer ??= Timer(_kStage2FramedHold, () {
            _stage2HoldTimer = null;
            if (!mounted || _analysisDispatched) return;
            if (_uiStage != _LivenessUiStage.waitingApproach) return;
            unawaited(_dispatchLivenessAndNavigate());
          });
        } else {
          _stage2HoldTimer?.cancel();
          _stage2HoldTimer = null;
        }
        break;
    }
  }

  Future<void> _dispatchLivenessAndNavigate() async {
    if (_analysisDispatched || !mounted) return;
    _analysisDispatched = true;
    _stage1HoldTimer?.cancel();
    _stage2HoldTimer?.cancel();

    final uid = getIt<AuthService>().currentUser?.uid;
    if (uid == null || uid.isEmpty) {
      _analysisDispatched = false;
      showAppError('Sessão inválida. Faça login novamente.');
      return;
    }

    await _detachAndDisposeCamera();
    if (!mounted) return;

    final metadata = <String, Object?>{};
    final sessionId = widget.livenessSessionId;
    if (sessionId != null) {
      metadata['livenessSessionId'] = sessionId;
    }

    context.read<AuthBloc>().add(
          SendLivenessRequested(
            LivenessDto(
              userId: uid,
              providerSessionId: widget.providerSessionId,
              capturedAt: DateTime.now(),
              metadata: metadata,
            ),
          ),
        );

    if (!mounted) return;
    await context.router.push(const SelfieVerificationRoute());
  }

  Future<void> _initCamera() async {
    if (kIsWeb) {
      if (mounted) {
        setState(() => _cameraError = 'Câmera não disponível na web.');
      }
      return;
    }
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        if (mounted) {
          setState(() => _cameraError = 'Nenhuma câmera encontrada.');
        }
        return;
      }
      CameraDescription camera;
      try {
        camera = cameras.firstWhere(
          (c) => c.lensDirection == CameraLensDirection.front,
        );
      } on StateError {
        camera = cameras.first;
      }

      final format = defaultTargetPlatform == TargetPlatform.android
          ? ImageFormatGroup.nv21
          : ImageFormatGroup.bgra8888;

      final controller = CameraController(
        camera,
        ResolutionPreset.medium,
        enableAudio: false,
        imageFormatGroup: format,
      );

      await controller.initialize();
      if (!mounted) {
        await controller.dispose();
        return;
      }

      setState(() => _controller = controller);

      await controller.startImageStream(_onCameraImage);
    } catch (e, st) {
      debugPrint('SelfieLiveness camera init failed: $e\n$st');
      if (mounted) {
        setState(() => _cameraError = 'Não foi possível abrir a câmera.');
      }
    }
  }

  void _onCameraImage(CameraImage image) {
    if (_analysisDispatched || !mounted) return;
    final now = DateTime.now();
    if (_lastFrameProcessed != null &&
        now.difference(_lastFrameProcessed!) < _frameThrottle) {
      return;
    }
    _lastFrameProcessed = now;

    final c = _controller;
    if (c == null || !c.value.isInitialized) return;

    unawaited(context.read<FaceFramingCubit>().onCameraImage(image, c));
  }

  Future<void> _detachAndDisposeCamera() async {
    final c = _controller;
    if (c == null) return;
    _controller = null;
    if (mounted) {
      setState(() {});
    }
    await _tearDownCamera(c);
  }

  Future<void> _tearDownCamera(CameraController c) async {
    try {
      if (c.value.isStreamingImages) {
        await c.stopImageStream();
      }
    } catch (e, st) {
      debugPrint('stopImageStream: $e\n$st');
    }
    await c.dispose();
  }

  @override
  void dispose() {
    _stage1HoldTimer?.cancel();
    _stage2HoldTimer?.cancel();
    _ovalExpandController.dispose();
    final c = _controller;
    _controller = null;
    if (c != null) {
      unawaited(_tearDownCamera(c));
    }
    super.dispose();
  }

  /// Progresso visual 0 = elipse etapa 1, 1 = elipse etapa 2.
  double get _ovalExpandT {
    switch (_uiStage) {
      case _LivenessUiStage.waitingAlign:
        return 0;
      case _LivenessUiStage.expanding:
        return Curves.easeInOutCubic.transform(_ovalExpandController.value);
      case _LivenessUiStage.waitingApproach:
        return 1;
    }
  }

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;
    final topPad = MediaQuery.paddingOf(context).top;
    final bottomPad = MediaQuery.paddingOf(context).bottom;
    final horizontal = AppSpacing.pageHorizontal;

    return BlocListener<FaceFramingCubit, FaceFramingSnapshot>(
      listenWhen: (prev, next) => prev != next,
      listener: (context, snap) => _onFramingSnapshot(snap),
      child: Scaffold(
        backgroundColor: AppPalette.surfaceDefault,
        body: LayoutBuilder(
          builder: (context, constraints) {
            final size = Size(constraints.maxWidth, constraints.maxHeight);
            return BlocBuilder<FaceFramingCubit, FaceFramingSnapshot>(
              buildWhen: (prev, next) =>
                  prev.phase != next.phase ||
                  prev.faceWidthFraction != next.faceWidthFraction,
              builder: (context, snap) {
                final base = _faceGuideOvalBase(size.width);
                final s1 = _FaceGuideOval(
                  width: base.width * _kStage1Scale,
                  height: base.height * _kStage1Scale,
                );
                var s2w = base.width * _kStage2Scale;
                var s2h = base.height * _kStage2Scale;
                final maxW = size.width * 0.88;
                final maxH = size.height * 0.65;
                if (s2w > maxW) {
                  final r = maxW / s2w;
                  s2w *= r;
                  s2h *= r;
                }
                if (s2h > maxH) {
                  final r = maxH / s2h;
                  s2w *= r;
                  s2h *= r;
                }
                final s2 = _FaceGuideOval(width: s2w, height: s2h);
                final t = _ovalExpandT;
                final guide = _FaceGuideOval(
                  width: lerpDouble(s1.width, s2.width, t)!,
                  height: lerpDouble(s1.height, s2.height, t)!,
                );
                final ovalRect = guide.centeredIn(size);

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Positioned.fill(child: _buildCameraLayer()),
                    Positioned.fill(
                      child: IgnorePointer(
                        child: CustomPaint(
                          painter: _OvalHoleOverlayPainter(
                            ovalRect: ovalRect,
                            overlayColor: AppPalette.surfaceDefault,
                          ),
                        ),
                      ),
                    ),
                    SafeArea(
                      bottom: false,
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          horizontal,
                          DSSize.height(16),
                          horizontal,
                          0,
                        ),
                        child: Align(
                          alignment: Alignment.topLeft,
                          child: AppCircleCloseButton(
                            onPressed: () => context.router.maybePop(),
                          ),
                        ),
                      ),
                    ),
                    Positioned(
                      left: horizontal,
                      right: horizontal,
                      top: topPad + DSSize.height(72),
                      child: Center(
                        child: ConstrainedBox(
                          constraints:
                              BoxConstraints(maxWidth: DSSize.width(216)),
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppPalette.successGreen50,
                              borderRadius:
                                  BorderRadius.circular(DSSize.width(12)),
                            ),
                            child: Padding(
                              padding: EdgeInsets.all(DSSize.width(16)),
                              child: Text(
                                _hintForUiStage(_uiStage, snap),
                                textAlign: TextAlign.center,
                                style: typo.labelCta.copyWith(
                                  color: AppPalette.textDefault,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: _LivenessOvalFrame(
                        width: guide.width,
                        height: guide.height,
                        borderColor:
                            _ovalBorderForUiStage(_uiStage, snap),
                        liveCamera: _controller?.value.isInitialized ?? false,
                      ),
                    ),
                    Positioned(
                      left: 0,
                      right: 0,
                      bottom: bottomPad + DSSize.height(132),
                      child: const _ParcelexLogoFooter(),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildCameraLayer() {
    if (_cameraError != null) {
      return ColoredBox(
        color: AppPalette.surfaceDefault,
        child: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: AppSpacing.pageHorizontal),
            child: Text(
              _cameraError!,
              textAlign: TextAlign.center,
              style: context.appTypography.bodyMedium400.copyWith(
                color: AppPalette.textDefault,
              ),
            ),
          ),
        ),
      );
    }

    final c = _controller;
    if (c == null || !c.value.isInitialized) {
      return const ColoredBox(color: Colors.black);
    }

    final previewSize = c.value.previewSize;
    if (previewSize == null) {
      return CameraPreview(c);
    }

    return FittedBox(
      fit: BoxFit.cover,
      clipBehavior: Clip.hardEdge,
      child: SizedBox(
        width: previewSize.height,
        height: previewSize.width,
        child: CameraPreview(c),
      ),
    );
  }
}

class _FaceGuideOval {
  _FaceGuideOval({required this.width, required this.height});

  final double width;
  final double height;

  Rect centeredIn(Size size) {
    final left = (size.width - width) / 2;
    final top = (size.height - height) / 2;
    return Rect.fromLTWH(left, top, width, height);
  }
}

bool _stage2FaceInTargetBand(FaceFramingSnapshot snap) {
  if (snap.phase == FaceFramingPhase.noFace) return false;
  final f = snap.faceWidthFraction;
  if (f == null) return false;
  return f >= _kStage2MinFaceWidthFraction &&
      f <= _kStage2MaxFaceWidthFraction;
}

_FaceGuideOval _faceGuideOvalBase(double screenWidth) {
  final w =
      (screenWidth * _kLivenessOvalWidthFraction).clamp(232.0, 300.0);
  final h = w * _kLivenessOvalAspect;
  return _FaceGuideOval(width: w, height: h);
}

class _OvalHoleOverlayPainter extends CustomPainter {
  _OvalHoleOverlayPainter({
    required this.ovalRect,
    required this.overlayColor,
  });

  final Rect ovalRect;
  final Color overlayColor;

  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..addRect(Rect.fromLTWH(0, 0, size.width, size.height))
      ..addOval(ovalRect)
      ..fillType = PathFillType.evenOdd;
    canvas.drawPath(path, Paint()..color = overlayColor);
  }

  @override
  bool shouldRepaint(covariant _OvalHoleOverlayPainter oldDelegate) {
    return oldDelegate.ovalRect != ovalRect ||
        oldDelegate.overlayColor != overlayColor;
  }
}

String _hintForUiStage(_LivenessUiStage stage, FaceFramingSnapshot snap) {
  switch (stage) {
    case _LivenessUiStage.waitingAlign:
      switch (snap.phase) {
        case FaceFramingPhase.noFace:
          return 'Centralize o rosto';
        case FaceFramingPhase.tooFar:
          return 'Aproxime um pouco';
        case FaceFramingPhase.tooClose:
          return 'Afaste um pouco';
        case FaceFramingPhase.framed:
          return 'Permaneça assim';
      }
    case _LivenessUiStage.expanding:
      return 'Ajustando o enquadramento…';
    case _LivenessUiStage.waitingApproach:
      if (_stage2FaceInTargetBand(snap)) {
        return 'Perfeito, permaneça assim';
      }
      final f = snap.faceWidthFraction;
      if (snap.phase == FaceFramingPhase.noFace || f == null) {
        return 'Posicione o rosto';
      }
      if (f < _kStage2MinFaceWidthFraction) {
        return 'Aproxime o rosto';
      }
      return 'Afaste um pouco';
  }
}

Color _ovalBorderForUiStage(_LivenessUiStage stage, FaceFramingSnapshot snap) {
  final framedOk = snap.phase == FaceFramingPhase.framed;
  switch (stage) {
    case _LivenessUiStage.waitingAlign:
      if (framedOk) return AppPalette.surfaceSuccess;
      return AppPalette.livenessBorder;
    case _LivenessUiStage.expanding:
      return AppPalette.livenessBorder;
    case _LivenessUiStage.waitingApproach:
      if (_stage2FaceInTargetBand(snap)) {
        return AppPalette.surfaceSuccess;
      }
      final f = snap.faceWidthFraction;
      if (f != null && f < _kStage2MinFaceWidthFraction) {
        return AppPalette.livenessBorder.withValues(alpha: 0.85);
      }
      return AppPalette.livenessBorder;
  }
}

class _LivenessOvalFrame extends StatelessWidget {
  const _LivenessOvalFrame({
    required this.width,
    required this.height,
    required this.borderColor,
    required this.liveCamera,
  });

  final double width;
  final double height;
  final Color borderColor;
  final bool liveCamera;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: height,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          ClipOval(
            child: liveCamera
                ? ColoredBox(
                    color: Colors.transparent,
                    child: SizedBox(width: width, height: height),
                  )
                : ColoredBox(
                    color: Theme.of(context).colorScheme.surfaceContainerHighest,
                    child: SizedBox(
                      width: width,
                      height: height,
                      child: Icon(
                        Icons.face_rounded,
                        size: width * 0.35,
                        color: Theme.of(context)
                            .colorScheme
                            .onSurfaceVariant
                            .withValues(alpha: 0.45),
                      ),
                    ),
                  ),
          ),
          CustomPaint(
            size: Size(width, height),
            painter: _OvalStrokePainter(color: borderColor, strokeWidth: 6),
          ),
          Positioned(
            top: -DSSize.width(20),
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: DSSize.width(42),
                height: DSSize.width(42),
                decoration: const BoxDecoration(
                  color: AppPalette.livenessBorder,
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: Padding(
                  padding: EdgeInsets.all(DSSize.width(12)),
                  child: CircularProgressIndicator(
                    strokeWidth: DSSize.width(3),
                    color: AppPalette.surfaceDefault,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _OvalStrokePainter extends CustomPainter {
  _OvalStrokePainter({
    required this.color,
    required this.strokeWidth,
  });

  final Color color;
  final double strokeWidth;

  @override
  void paint(Canvas canvas, Size size) {
    final rect = Rect.fromLTWH(0, 0, size.width, size.height);
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth;
    canvas.drawOval(rect.deflate(strokeWidth / 2), paint);
  }

  @override
  bool shouldRepaint(covariant _OvalStrokePainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth;
  }
}

class _ParcelexLogoFooter extends StatelessWidget {
  const _ParcelexLogoFooter();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Image.asset(
        AppAssets.parcelexLogo,
        height: DSSize.height(36),
        fit: BoxFit.contain,
      ),
    );
  }
}
