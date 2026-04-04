import 'dart:async';

import 'package:app/core/presentation/notifications/app_notifications.dart';
import 'package:app/features/authentication/data/dtos/onboarding_dto.dart';
import 'package:app/features/authentication/data/dtos/verify_sms_otp_dto.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/events/auth_events.dart';
import 'package:app/features/authentication/presentation/bloc/states/auth_states.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/foundation.dart' show kIsWeb, defaultTargetPlatform, TargetPlatform;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sms_autofill/sms_autofill.dart';

import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/presentation/widgets/app_numeric_keypad.dart';
import '../../../../core/presentation/widgets/app_primary_button.dart';
import '../../../../core/presentation/widgets/app_otp_box_field.dart';
import '../../../../core/presentation/widgets/app_otp_verification_feedback.dart';
import '../../../../core/config/app_router.gr.dart';
import '../../../../core/design_system/app_typography.dart';
import '../navigation/otp_post_login_route.dart';
import '../widgets/auth_step_scaffold.dart';

/// Validação do código enviado por SMS (OTP + teclado numérico).
@RoutePage(deferredLoading: true)
class SmsConfirmationPage extends StatefulWidget {
  const SmsConfirmationPage({
    super.key,
    required this.phoneNumberMasked,
    this.alreadyPhoneVerified = false,
    this.phoneNumberE164 = '',
    this.verificationId = '',
    this.forceResendingToken,
    this.pendingOnboarding,
  });

  /// Telefone já mascarado para exibição.
  final String phoneNumberMasked;

  /// `true` quando o Firebase concluiu a verificação sem OTP manual (ex.: iOS após reCAPTCHA).
  final bool alreadyPhoneVerified;

  /// E.164 para reenvio de SMS ([SendLoginSmsSubmitted]).
  final String phoneNumberE164;

  /// [VerifySmsOtpDto.verificationId] inicial; atualizado após reenvio bem-sucedido.
  final String verificationId;

  final int? forceResendingToken;

  /// Perfil a gravar após OTP, no fluxo de cadastro.
  final OnboardingDto? pendingOnboarding;

  @override
  State<SmsConfirmationPage> createState() => _SmsConfirmationPageState();
}

class _SmsConfirmationPageState extends State<SmsConfirmationPage>
    with CodeAutoFill {
  /// [sms_autofill.listenForCode] só existe no Android; iOS usa [AutofillHints.oneTimeCode].
  static bool get _shouldUseAndroidSmsAutofill =>
      !kIsWeb && defaultTargetPlatform == TargetPlatform.android;

  /// Teclado numérico do sistema não deve aparecer; autofill continua no campo invisível.
  static bool get _suppressSystemKeyboardForOtp =>
      !kIsWeb &&
      (defaultTargetPlatform == TargetPlatform.iOS ||
          defaultTargetPlatform == TargetPlatform.android);

  static const int _otpLength = 6;
  static const Duration _successHoldBeforeSelfie = Duration(milliseconds: 1000);

  late String _verificationId;
  int? _forceResendingToken;

  String _code = '';
  OtpVerificationPhase _verifyPhase = OtpVerificationPhase.idle;
  String _otpErrorMessage = 'Código inválido. Tente novamente.';
  bool _resendLoading = false;
  int _resendSeconds = 60;
  Timer? _resendTimer;

  /// Android ([listenForCode]): código detectado no SMS, exibido acima do teclado custom.
  String? _smsKeypadOffer;

  late final TextEditingController _autofillController;
  late final FocusNode _autofillFocusNode;

  @override
  void initState() {
    super.initState();
    _verificationId = widget.verificationId;
    _forceResendingToken = widget.forceResendingToken;
    _autofillController = TextEditingController();
    _autofillFocusNode = FocusNode();
    if (_suppressSystemKeyboardForOtp) {
      _autofillFocusNode.addListener(_hideSystemKeyboardIfOtpFieldFocused);
    }
    if (_shouldUseAndroidSmsAutofill) {
      listenForCode();
    }
    _startResendTimer();
    if (!widget.alreadyPhoneVerified && _suppressSystemKeyboardForOtp) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || widget.alreadyPhoneVerified) return;
        if (_verifyPhase == OtpVerificationPhase.verifying ||
            _verifyPhase == OtpVerificationPhase.success ||
            _resendLoading) {
          return;
        }
        _autofillFocusNode.requestFocus();
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted) {
            unawaited(
              SystemChannels.textInput.invokeMethod<void>('TextInput.hide'),
            );
          }
        });
      });
    }
  }

  void _hideSystemKeyboardIfOtpFieldFocused() {
    if (!_suppressSystemKeyboardForOtp || !_autofillFocusNode.hasFocus) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || !_autofillFocusNode.hasFocus) return;
      unawaited(
        SystemChannels.textInput.invokeMethod<void>('TextInput.hide'),
      );
    });
  }

  void _syncAutofillControllerFromCode() {
    if (_autofillController.text == _code) return;
    _autofillController.value = TextEditingValue(
      text: _code,
      selection: TextSelection.collapsed(
        offset: _code.length.clamp(0, _otpLength),
      ),
    );
  }

  void _onAutofillTextChanged(String value) {
    final digits = value.replaceAll(RegExp(r'\D'), '');
    final trimmed = digits.length > _otpLength
        ? digits.substring(0, _otpLength)
        : digits;
    if (trimmed == _code) return;
    setState(() {
      if (_verifyPhase == OtpVerificationPhase.error) {
        _verifyPhase = OtpVerificationPhase.idle;
      }
      _code = trimmed;
    });
    if (_code.length == _otpLength) {
      _submitOtp();
    }
  }

  @override
  void codeUpdated() {
    if (!mounted || widget.alreadyPhoneVerified) return;
    final raw = code;
    if (raw == null || raw.isEmpty) return;
    final digits = raw.replaceAll(RegExp(r'\D'), '');
    if (digits.isEmpty) return;
    final trimmed =
        digits.length > _otpLength ? digits.substring(0, _otpLength) : digits;

    if (_shouldUseAndroidSmsAutofill) {
      setState(() => _smsKeypadOffer = trimmed);
      return;
    }

    setState(() {
      if (_verifyPhase == OtpVerificationPhase.error) {
        _verifyPhase = OtpVerificationPhase.idle;
      }
      _code = trimmed;
    });
    _syncAutofillControllerFromCode();
    if (_code.length == _otpLength) {
      _submitOtp();
    }
  }

  void _applySmsKeypadOffer() {
    final offer = _smsKeypadOffer;
    if (offer == null) return;
    setState(() {
      _smsKeypadOffer = null;
      if (_verifyPhase == OtpVerificationPhase.error) {
        _verifyPhase = OtpVerificationPhase.idle;
      }
      _code = offer;
    });
    _syncAutofillControllerFromCode();
    if (_code.length == _otpLength) {
      _submitOtp();
    }
  }

  void _dismissSmsKeypadOffer() {
    if (_smsKeypadOffer == null) return;
    setState(() => _smsKeypadOffer = null);
  }

  @override
  void dispose() {
    _resendTimer?.cancel();
    if (_shouldUseAndroidSmsAutofill && !widget.alreadyPhoneVerified) {
      unawaited(cancel());
      unawaited(unregisterListener());
    }
    if (_suppressSystemKeyboardForOtp) {
      _autofillFocusNode.removeListener(_hideSystemKeyboardIfOtpFieldFocused);
    }
    _autofillFocusNode.dispose();
    _autofillController.dispose();
    super.dispose();
  }

  void _startResendTimer() {
    _resendTimer?.cancel();
    _resendTimer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      if (_resendSeconds <= 0) {
        _resendTimer?.cancel();
        setState(() {});
        return;
      }
      setState(() => _resendSeconds--);
    });
  }

  int get _activeOtpIndex {
    if (_code.length >= _otpLength) return -1;
    return _code.length;
  }

  void _handleAuthState(BuildContext context, AuthState state) {
    if (state is VerifySmsOtpLoading) {
      setState(() => _verifyPhase = OtpVerificationPhase.verifying);
      return;
    }
    if (state is VerifySmsOtpSuccess) {
      setState(() => _verifyPhase = OtpVerificationPhase.success);
      context.read<AuthBloc>().add(const VerifySmsOtpReset());
      Future<void>.delayed(_successHoldBeforeSelfie, () {
        if (!mounted) return;
        if (_verifyPhase != OtpVerificationPhase.success) return;
        if (!context.mounted) return;
        context.router.replace(
          routeAfterOtpSuccess(userProfile: state.data.userProfile),
        );
      });
      return;
    }
    if (state is VerifySmsOtpError) {
      setState(() {
        _verifyPhase = OtpVerificationPhase.error;
        _otpErrorMessage = state.failure.message;
      });
      _syncAutofillControllerFromCode();
      return;
    }
    if (state is SendLoginSmsLoading) {
      setState(() => _resendLoading = true);
      return;
    }
    if (state is SendLoginSmsSuccess) {
      final id = state.data.verificationId;
      if (id != null && id.isNotEmpty) {
        _verificationId = id;
      }
      _forceResendingToken = state.data.forceResendingToken;
      setState(() {
        _resendLoading = false;
        _resendSeconds = 60;
      });
      _startResendTimer();
      setState(() => _smsKeypadOffer = null);
      showAppWarning('Novo SMS enviado.');
      context.read<AuthBloc>().add(const SendLoginSmsReset());
      return;
    }
    if (state is SendLoginSmsError) {
      setState(() => _resendLoading = false);
      showAppError(state.failure.message);
      context.read<AuthBloc>().add(const SendLoginSmsReset());
    }
  }

  void _submitOtp() {
    if (widget.alreadyPhoneVerified) return;
    if (_verificationId.isEmpty) return;
    if (_verifyPhase == OtpVerificationPhase.verifying) return;
    context.read<AuthBloc>().add(
          VerifySmsOtpSubmitted(
            VerifySmsOtpDto(
              verificationId: _verificationId,
              smsCode: _code,
              pendingOnboarding: widget.pendingOnboarding,
            ),
          ),
        );
  }

  void _onDigit(String d) {
    if (_resendLoading) return;
    if (_verifyPhase == OtpVerificationPhase.verifying) return;
    if (_code.length >= _otpLength) return;

    if (!_suppressSystemKeyboardForOtp) {
      _autofillFocusNode.unfocus();
    }

    if (_verifyPhase == OtpVerificationPhase.error) {
      setState(() {
        _verifyPhase = OtpVerificationPhase.idle;
        _code = d;
      });
      _syncAutofillControllerFromCode();
      if (_code.length == _otpLength) {
        _submitOtp();
      }
      return;
    }

    setState(() {
      _code += d;
    });
    _syncAutofillControllerFromCode();
    if (_code.length == _otpLength) {
      _submitOtp();
    }
  }

  void _onBackspace() {
    if (_resendLoading) return;
    if (_verifyPhase == OtpVerificationPhase.verifying) return;
    if (_code.isEmpty) return;
    if (!_suppressSystemKeyboardForOtp) {
      _autofillFocusNode.unfocus();
    }
    setState(() {
      _code = _code.substring(0, _code.length - 1);
      if (_code.length < _otpLength) {
        _verifyPhase = OtpVerificationPhase.idle;
      }
    });
    _syncAutofillControllerFromCode();
  }

  void _onResend() {
    if (_resendSeconds > 0 || _resendLoading) return;
    if (_verifyPhase == OtpVerificationPhase.verifying) return;
    if (widget.phoneNumberE164.isEmpty) {
      showAppError('Não foi possível reenviar o SMS.');
      return;
    }
    context.read<AuthBloc>().add(
          SendLoginSmsSubmitted(
            widget.phoneNumberE164,
            forceResendingToken: _forceResendingToken,
          ),
        );
  }

  void _continueToSelfie() {
    context.router.replace(const SelfieSubmissionRoute());
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final typo = context.appTypography;
    final horizontal = AppSpacing.pageHorizontal;

    if (widget.alreadyPhoneVerified) {
      return AuthStepScaffold(
        body: SingleChildScrollView(
          padding: EdgeInsets.only(
            left: horizontal,
            right: horizontal,
            top: DSSize.height(16),
            bottom: DSSize.height(24),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Telefone verificado',
                style: typo.headlineSmall,
              ),
              SizedBox(height: AppSpacing.sectionGap),
              Text.rich(
                TextSpan(
                  style: typo.bodyMedium400,
                  children: [
                    const TextSpan(
                      text: 'Seu número ',
                    ),
                    TextSpan(
                      text: widget.phoneNumberMasked,
                      style: typo.bodyMedium400.copyWith(
                        fontWeight: FontWeight.w700,
                        color: cs.onSurface,
                      ),
                    ),
                    const TextSpan(
                      text:
                          ' foi confirmado. Toque em continuar para a próxima etapa.',
                    ),
                  ],
                ),
              ),
              SizedBox(height: DSSize.height(32)),
              const AppOtpVerificationFeedback(phase: OtpVerificationPhase.success),
            ],
          ),
        ),
        bottom: Padding(
          padding: EdgeInsets.fromLTRB(
            horizontal,
            0,
            horizontal,
            DSSize.height(24),
          ),
          child: AppPrimaryButton(
            label: 'Continuar',
            onPressed: _continueToSelfie,
          ),
        ),
        hasMinimumBottomPadding: true,
      );
    }

    final scrollBody = SingleChildScrollView(
      padding: EdgeInsets.only(
        left: horizontal,
        right: horizontal,
        top: DSSize.height(16),
        bottom: DSSize.height(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Código SMS',
            style: typo.headlineSmall,
          ),
          SizedBox(height: AppSpacing.sectionGap),
          Text.rich(
            TextSpan(
              style: typo.bodyMedium400,
              children: [
                const TextSpan(
                  text:
                      'Para continuar, digite o código de 6 dígitos que enviamos por SMS para ',
                ),
                TextSpan(
                  text: widget.phoneNumberMasked,
                  style: typo.bodyMedium400.copyWith(
                    fontWeight: FontWeight.w700,
                    color: cs.onSurface,
                  ),
                ),
              ],
            ),
          ),
          
          SizedBox(height: DSSize.height(24)),
          AutofillGroup(
            child: Stack(
              alignment: Alignment.center,
              children: [
                AppOtpBoxField(
                  length: _otpLength,
                  value: _code,
                  activeIndex: _activeOtpIndex,
                  visualPhase: switch (_verifyPhase) {
                    OtpVerificationPhase.idle => AppOtpBoxVisualPhase.editing,
                    OtpVerificationPhase.verifying =>
                      AppOtpBoxVisualPhase.verifying,
                    OtpVerificationPhase.success =>
                      AppOtpBoxVisualPhase.success,
                    OtpVerificationPhase.error => AppOtpBoxVisualPhase.error,
                  },
                ),
                Positioned.fill(
                  child: TextField(
                    controller: _autofillController,
                    focusNode: _autofillFocusNode,
                    readOnly: _verifyPhase == OtpVerificationPhase.verifying ||
                        _verifyPhase == OtpVerificationPhase.success ||
                        _resendLoading,
                    keyboardType: _suppressSystemKeyboardForOtp
                        ? TextInputType.none
                        : TextInputType.number,
                    textAlign: TextAlign.center,
                    maxLength: _otpLength,
                    autofillHints: const [AutofillHints.oneTimeCode],
                    enableSuggestions: false,
                    autocorrect: false,
                    smartDashesType: SmartDashesType.disabled,
                    smartQuotesType: SmartQuotesType.disabled,
                    spellCheckConfiguration:
                        const SpellCheckConfiguration.disabled(),
                    inputFormatters: [
                      FilteringTextInputFormatter.digitsOnly,
                      LengthLimitingTextInputFormatter(_otpLength),
                    ],
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      enabledBorder: InputBorder.none,
                      focusedBorder: InputBorder.none,
                      disabledBorder: InputBorder.none,
                      errorBorder: InputBorder.none,
                      focusedErrorBorder: InputBorder.none,
                      counterText: '',
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                      filled: false,
                    ),
                    style: const TextStyle(
                      color: Colors.transparent,
                      fontSize: 1,
                      height: 1,
                    ),
                    cursorColor: Colors.transparent,
                    cursorWidth: 0,
                    showCursor: false,
                    enableInteractiveSelection: false,
                    onChanged: _onAutofillTextChanged,
                  ),
                ),
              ],
            ),
          ),
          if (_resendLoading || _verifyPhase != OtpVerificationPhase.idle) ...[
            SizedBox(height: DSSize.height(20)),
            if (_resendLoading)
              const AppOtpVerificationFeedback(
                phase: OtpVerificationPhase.verifying,
                verifyingMessage: 'Enviando SMS...',
              )
            else
              AppOtpVerificationFeedback(
                phase: _verifyPhase,
                errorMessage: _otpErrorMessage,
              ),
          ],
        ],
      ),
    );

    final maxContent = AppSpacing.contentMaxWidth;
    final bottomBar = Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Align(
          alignment: Alignment.center,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: maxContent ?? double.infinity),
            child: Padding(
              padding: EdgeInsets.fromLTRB(
                horizontal,
                0,
                horizontal,
                DSSize.height(12),
              ),
              child: AppPrimaryButton(
                label: _resendSeconds > 0
                    ? 'Reenviar SMS (${_resendSeconds}s)'
                    : 'Reenviar SMS',
                onPressed: _onResend,
                enabled:
                    _resendSeconds == 0 && !_resendLoading && _verifyPhase != OtpVerificationPhase.verifying,
                textStyle: typo.bodyLarge500,
              ),
            ),
          ),
        ),
        AppNumericKeypad(
          onDigit: _onDigit,
          onBackspace: _onBackspace,
          topAccessory: _smsKeypadOffer == null
              ? null
              : _SmsOtpKeypadOfferBar(
                  code: _smsKeypadOffer!,
                  onUse: _applySmsKeypadOffer,
                  onDismiss: _dismissSmsKeypadOffer,
                ),
        ),
      ],
    );

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is VerifySmsOtpLoading ||
          current is VerifySmsOtpSuccess ||
          current is VerifySmsOtpError ||
          current is SendLoginSmsLoading ||
          current is SendLoginSmsSuccess ||
          current is SendLoginSmsError,
      listener: _handleAuthState,
      child: AuthStepScaffold(
        body: scrollBody,
        bottom: bottomBar,
        hasMinimumBottomPadding: false,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

/// Faixa estilo “sugestão de SMS” acima do teclado numérico (Android / User Consent API).
class _SmsOtpKeypadOfferBar extends StatelessWidget {
  const _SmsOtpKeypadOfferBar({
    required this.code,
    required this.onUse,
    required this.onDismiss,
  });

  final String code;
  final VoidCallback onUse;
  final VoidCallback onDismiss;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Material(
      color: cs.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(DSSize.width(12)),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onUse,
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: DSSize.width(12),
            vertical: DSSize.height(10),
          ),
          child: Row(
            children: [
              Icon(
                Icons.sms_outlined,
                size: DSSize.width(20),
                color: cs.primary,
              ),
              SizedBox(width: DSSize.width(10)),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Toque para usar o código',
                      style: TextStyle(
                        fontSize: 12,
                        color: cs.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      code,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 2,
                        color: cs.onSurface,
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: const Icon(Icons.close, size: 20),
                onPressed: onDismiss,
                visualDensity: VisualDensity.compact,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
