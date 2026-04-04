import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/config/app_router.gr.dart';
import '../../../../core/presentation/notifications/app_notifications.dart';
import '../../../../core/design_system/app_typography.dart';
import '../../../../core/design_system/app_spacing.dart';
import '../../../../core/design_system/ds_size.dart';
import '../../../../core/presentation/widgets/app_circle_close_button.dart';
import '../../../../core/presentation/widgets/app_primary_button.dart';
import '../bloc/auth_bloc.dart';
import '../bloc/events/auth_events.dart';
import '../bloc/states/auth_states.dart';
import '../widgets/auth_step_scaffold.dart';
import '../widgets/selfie_tips_card.dart';

/// Envio da selfie para reforço de segurança da conta.
@RoutePage(deferredLoading: true)
class SelfieSubmissionPage extends StatelessWidget {
  const SelfieSubmissionPage({super.key});

  @override
  Widget build(BuildContext context) {
    final typo = context.appTypography;
    final horizontal = AppSpacing.pageHorizontal;

    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (previous, current) =>
          current is EnableCameraPermissionSuccess ||
          current is EnableCameraPermissionError,
      listener: (context, state) {
        if (state is EnableCameraPermissionSuccess) {
          // Dispara antes do push: a sessão costuma completar rápido (mock); o BLoC
          // mantém Success/Error até [InitLivenessSessionReset] na AuthLoadingPage.
          context.read<AuthBloc>().add(const InitLivenessSessionRequested());
          context.router.push(
            AuthLoadingRoute(
              cpfMasked: '',
              awaitingLivenessInit: true,
            ),
          );
        }
        if (state is EnableCameraPermissionError) {
          showAppError(state.failure.message);
          context.read<AuthBloc>().add(const EnableCameraPermissionReset());
        }
      },
      child: _SelfieSubmissionBody(
        typo: typo,
        horizontal: horizontal,
        onContinue: () {
          context.read<AuthBloc>().add(const EnableCameraPermissionRequested());
        },
      ),
    );
  }
}

class _SelfieSubmissionBody extends StatelessWidget {
  const _SelfieSubmissionBody({
    required this.typo,
    required this.horizontal,
    required this.onContinue,
  });

  final AppTypographyStyles typo;
  final double horizontal;
  final VoidCallback onContinue;

  @override
  Widget build(BuildContext context) {
    final loading = context.select<AuthBloc, bool>(
      (b) => b.state is EnableCameraPermissionLoading,
    );

    final scrollable = SingleChildScrollView(
      padding: EdgeInsets.only(
        left: horizontal,
        right: horizontal,
        top: DSSize.height(16),
        bottom: DSSize.height(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Envio da selfie',
            style: typo.headlineSmall,
          ),
          SizedBox(height: AppSpacing.sectionGap),
          Text(
            'Usamos sua foto para deixar sua conta mais segura.',
            style: typo.bodyLarge400,
          ),
          SizedBox(height: DSSize.height(16)),
          const SelfieTipsCard(),
        ],
      ),
    );

    final body = Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Expanded(child: scrollable),
      ],
    );

    final bottomBar = SafeArea(
      top: false,
      left: false,
      right: false,
      child: Padding(
        padding: EdgeInsets.fromLTRB(
          horizontal,
          DSSize.height(8),
          horizontal,
          DSSize.height(24),
        ),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: AppSpacing.contentMaxWidth ?? double.infinity,
            ),
            child: AppPrimaryButton(
              label: 'Continuar',
              onPressed: onContinue,
              enabled: !loading,
              textStyle: typo.labelCta,
            ),
          ),
        ),
      ),
    );

    return AuthStepScaffold(
      leading: const AppCircleCloseButton(),
      body: body,
      bottom: bottomBar,
    );
  }
}
