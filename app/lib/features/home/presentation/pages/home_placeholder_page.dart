import 'package:app/core/config/app_router.gr.dart';
import 'package:app/core/design_system/app_typography.dart';
import 'package:app/core/presentation/notifications/app_notifications.dart';
import 'package:app/core/presentation/theme/app_semantic_colors.dart';
import 'package:app/features/authentication/presentation/bloc/auth_bloc.dart';
import 'package:app/features/authentication/presentation/bloc/events/auth_events.dart';
import 'package:app/features/authentication/presentation/bloc/states/auth_states.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Placeholder da home pós-onboarding (texto central, fundo de superfície).
@RoutePage(deferredLoading: true)
class HomePlaceholderPage extends StatelessWidget {
  const HomePlaceholderPage({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = context.appColors;
    final typo = context.appTypography;

    return BlocConsumer<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is LogoutSuccess || current is LogoutError,
      listener: (context, state) {
        if (state is LogoutSuccess) {
          context.read<AuthBloc>().add(const LogoutReset());
          context.router.replaceAll([const LoginWelcomeRoute()]);
        } else if (state is LogoutError) {
          showAppError(state.failure.message);
        }
      },
      builder: (context, state) {
        final loading = state is LogoutLoading;

        return Scaffold(
          backgroundColor: colors.surfaceDefault,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Entrou na plataforma',
                  textAlign: TextAlign.center,
                  style: typo.headlineMedium.copyWith(
                    color: colors.textPrimary,
                  ),
                ),
                SizedBox(height: MediaQuery.sizeOf(context).height * 0.04),
                if (loading)
                  const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                else
                  TextButton(
                    onPressed: () {
                      context.read<AuthBloc>().add(const LogoutRequested());
                    },
                    child: Text(
                      'Sair',
                      style: typo.bodyMedium500.copyWith(
                        color: colors.borderFocus,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
