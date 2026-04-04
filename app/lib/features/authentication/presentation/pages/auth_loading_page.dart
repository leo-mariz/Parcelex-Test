import 'package:app/core/presentation/notifications/app_notifications.dart';
import 'package:app/core/utils/phone_display_mask.dart';
import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/events/auth_events.dart';
import 'package:app/features/authentication/presentation/bloc/states/auth_states.dart';
import 'package:app/features/users/presentation/bloc/events/users_events.dart';
import 'package:app/features/users/presentation/bloc/states/users_states.dart';
import 'package:app/features/users/presentation/bloc/users_bloc.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/config/app_router.gr.dart';
import '../../../../core/presentation/widgets/app_brand_loading_indicator.dart';
import '../../../../core/presentation/widgets/app_page_scaffold.dart';

/// Carregamento pós-login (verificação de CPF / envio de SMS).
@RoutePage(deferredLoading: true)
class AuthLoadingPage extends StatefulWidget {
  const AuthLoadingPage({
    super.key,
    this.center,
    required this.cpfMasked,
    this.isRegisterOnboarding = false,
    this.awaitingLivenessInit = false,
    this.awaitingUserPermissionsUpdate = false,
    this.permissionsDto,
  });

  /// CPF mascarado para [CreateAccountRoute] quando o usuário não existe.
  final String cpfMasked;

  /// `true`: aguarda [RegisterOnboardingSubmitted] (tela “Crie sua conta”).
  /// `false`: fluxo login (verificar CPF + SMS).
  final bool isRegisterOnboarding;

  /// `true`: aguarda [InitLivenessSessionRequested] (selfie → sessão de liveness).
  final bool awaitingLivenessInit;

  /// `true`: dispara [UpdateUserPermissionsSubmitted] com [permissionsDto] e aguarda o [UsersBloc].
  final bool awaitingUserPermissionsUpdate;

  /// Decisões das telas de permissão (obrigatório se [awaitingUserPermissionsUpdate]).
  final PermissionsDto? permissionsDto;

  /// Se não for [null], substitui o ícone padrão do asset Parcelex.
  final Widget? center;

  @override
  State<AuthLoadingPage> createState() => _AuthLoadingPageState();
}

class _AuthLoadingPageState extends State<AuthLoadingPage> {
  static const Duration _minLoadingVisible = Duration(seconds: 2);

  late final DateTime _loadingStartedAt;

  bool _handledVerifyCpfSuccess = false;
  bool _sendLoginSmsDispatched = false;
  bool _handledTerminalError = false;
  bool _handledSendLoginSmsSuccess = false;
  bool _handledRegisterOnboardingSuccess = false;
  bool _handledInitLivenessSuccess = false;
  bool _handledInitLivenessError = false;
  bool _userPermissionsSubmitDispatched = false;
  bool _handledUserPermissionsSuccess = false;
  bool _handledUserPermissionsError = false;

  void _showRootSnackBar(String message) {
    showAppError(message);
  }

  /// Garante que o loading fique visível pelo menos [_minLoadingVisible] (UX).
  void _afterMinLoading(void Function() action) {
    final elapsed = DateTime.now().difference(_loadingStartedAt);
    final remaining = _minLoadingVisible - elapsed;
    void run() {
      if (!mounted) return;
      action();
    }

    if (remaining <= Duration.zero) {
      run();
    } else {
      Future<void>.delayed(remaining, run);
    }
  }

  void _processUserPermissionsState(BuildContext context, UsersState state) {
    if (!widget.awaitingUserPermissionsUpdate) return;
    if (state is UpdateUserPermissionsError) {
      if (_handledUserPermissionsError) return;
      _handledUserPermissionsError = true;
      final message = state.failure.message;
      _afterMinLoading(() {
        context.read<UsersBloc>().add(const UpdateUserPermissionsReset());
        context.router.replaceAll([const NotificationPermissionRoute()]);
        _showRootSnackBar(message);
      });
      return;
    }
    if (state is UpdateUserPermissionsSuccess) {
      if (_handledUserPermissionsSuccess) return;
      _handledUserPermissionsSuccess = true;
      _afterMinLoading(() {
        context.read<UsersBloc>().add(const UpdateUserPermissionsReset());
        context.router.replaceAll([const HomePlaceholderRoute()]);
      });
    }
  }

  void _processState(BuildContext context, AuthState state) {
    if (widget.awaitingLivenessInit) {
      if (state is InitLivenessSessionError) {
        if (_handledInitLivenessError) return;
        _handledInitLivenessError = true;
        final message = state.failure.message;
        _afterMinLoading(() {
          context.read<AuthBloc>().add(const InitLivenessSessionReset());
          context.router.maybePop();
          _showRootSnackBar(message);
        });
        return;
      }
      if (state is InitLivenessSessionSuccess) {
        if (_handledInitLivenessSuccess) return;
        _handledInitLivenessSuccess = true;
        _afterMinLoading(() {
          context.read<AuthBloc>().add(const InitLivenessSessionReset());
          context.router.replace(
            SelfieLivenessRoute(
              providerSessionId: state.result.providerSessionId,
              livenessSessionId: state.result.sessionId,
            ),
          );
        });
        return;
      }
      return;
    }

    if (widget.isRegisterOnboarding) {
      if (state is RegisterOnboardingError) {
        if (_handledTerminalError) return;
        _handledTerminalError = true;
        final message = state.failure.message;
        _afterMinLoading(() {
          context.read<AuthBloc>().add(const RegisterOnboardingReset());
          context.router.maybePop();
          _showRootSnackBar(message);
        });
        return;
      }
      if (state is RegisterOnboardingSuccess) {
        if (_handledRegisterOnboardingSuccess) return;
        _handledRegisterOnboardingSuccess = true;
        final data = state.data;
        final masked = maskPhoneForOtpDisplay(data.sms.phoneNumberE164);
        final autoVerified = !data.sms.needsManualOtp;
        _afterMinLoading(() {
          context.read<AuthBloc>().add(const RegisterOnboardingReset());
          context.router.replace(
            SmsConfirmationRoute(
              phoneNumberMasked: masked,
              alreadyPhoneVerified: autoVerified,
              phoneNumberE164: data.sms.phoneNumberE164,
              verificationId: data.sms.verificationId ?? '',
              forceResendingToken: data.sms.forceResendingToken,
              pendingOnboarding: autoVerified ? null : data.pendingOnboarding,
            ),
          );
        });
        return;
      }
      return;
    }

    if (state is VerifyCpfError) {
      if (_handledTerminalError) return;
      _handledTerminalError = true;
      final message = state.failure.message;
      _afterMinLoading(() {
        context.read<AuthBloc>().add(const VerifyCpfReset());
        context.router.maybePop();
        _showRootSnackBar(message);
      });
      return;
    }

    if (state is SendLoginSmsError) {
      if (_handledTerminalError) return;
      _handledTerminalError = true;
      final message = state.failure.message;
      _afterMinLoading(() {
        context.read<AuthBloc>().add(const SendLoginSmsReset());
        context.read<AuthBloc>().add(const VerifyCpfReset());
        context.router.maybePop();
        _showRootSnackBar(message);
      });
      return;
    }

    if (state is VerifyCpfSuccess) {
      if (_handledVerifyCpfSuccess) return;
      _handledVerifyCpfSuccess = true;

      if (!state.exists) {
        _afterMinLoading(() {
          context.read<AuthBloc>().add(const VerifyCpfReset());
          context.router.replace(CreateAccountRoute(cpfMasked: widget.cpfMasked));
        });
        return;
      }

      final phone = state.phoneNumber;
      if (phone != null && phone.trim().isNotEmpty) {
        if (!_sendLoginSmsDispatched) {
          _sendLoginSmsDispatched = true;
          context.read<AuthBloc>().add(
                SendLoginSmsSubmitted(phone.trim()),
              );
        }
        return;
      }

      _afterMinLoading(() {
        context.read<AuthBloc>().add(const VerifyCpfReset());
        context.router.maybePop();
        _showRootSnackBar(
          'CPF encontrado, mas não há telefone cadastrado. Entre em contato com o suporte.',
        );
      });
      return;
    }

    if (state is SendLoginSmsSuccess) {
      if (_handledSendLoginSmsSuccess) return;
      _handledSendLoginSmsSuccess = true;
      final masked = maskPhoneForOtpDisplay(state.data.phoneNumberE164);
      _afterMinLoading(() {
        context.read<AuthBloc>().add(const SendLoginSmsReset());
        context.read<AuthBloc>().add(const VerifyCpfReset());
        context.router.replace(
          SmsConfirmationRoute(
            phoneNumberMasked: masked,
            phoneNumberE164: state.data.phoneNumberE164,
            verificationId: state.data.verificationId ?? '',
            forceResendingToken: state.data.forceResendingToken,
          ),
        );
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _loadingStartedAt = DateTime.now();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (widget.awaitingUserPermissionsUpdate) {
        final dto = widget.permissionsDto;
        if (dto != null && !_userPermissionsSubmitDispatched) {
          _userPermissionsSubmitDispatched = true;
          context.read<UsersBloc>().add(UpdateUserPermissionsSubmitted(dto));
        }
        final us = context.read<UsersBloc>().state;
        if (us is UpdateUserPermissionsError ||
            us is UpdateUserPermissionsSuccess) {
          _processUserPermissionsState(context, us);
        }
        return;
      }
      final s = context.read<AuthBloc>().state;
      if (widget.awaitingLivenessInit) {
        if (s is InitLivenessSessionError || s is InitLivenessSessionSuccess) {
          _processState(context, s);
        }
        return;
      }
      if (widget.isRegisterOnboarding) {
        if (s is RegisterOnboardingError || s is RegisterOnboardingSuccess) {
          _processState(context, s);
        }
        return;
      }
      if (s is VerifyCpfError ||
          s is SendLoginSmsError ||
          s is VerifyCpfSuccess ||
          s is SendLoginSmsSuccess) {
        _processState(context, s);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<UsersBloc, UsersState>(
      listenWhen: (previous, current) {
        if (widget.awaitingUserPermissionsUpdate) {
          return current is UpdateUserPermissionsSuccess ||
              current is UpdateUserPermissionsError;
        }
        return false;
      },
      listener: (context, state) {
        if (widget.awaitingUserPermissionsUpdate) {
          _processUserPermissionsState(context, state);
        }
      },
      child: BlocListener<AuthBloc, AuthState>(
        listenWhen: (previous, current) {
          if (widget.awaitingUserPermissionsUpdate) {
            return false;
          }
          if (widget.awaitingLivenessInit) {
            return current is InitLivenessSessionError ||
                current is InitLivenessSessionSuccess;
          }
          if (widget.isRegisterOnboarding) {
            return current is RegisterOnboardingError ||
                current is RegisterOnboardingSuccess;
          }
          return current is VerifyCpfError ||
              current is SendLoginSmsError ||
              current is VerifyCpfSuccess ||
              current is SendLoginSmsSuccess;
        },
        listener: (context, state) => _processState(context, state),
        child: AppPageScaffold(
        scrollBody: false,
        applyMaxContentWidth: false,
        useDesignSystemHorizontalPadding: false,
        body: Center(
          child: AppBrandLoadingIndicator(center: widget.center),
        ),
      ),
      ),
    );
  }
}
