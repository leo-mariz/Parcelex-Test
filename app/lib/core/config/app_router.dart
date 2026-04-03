import 'package:auto_route/auto_route.dart';

import 'app_router.gr.dart';

@AutoRouterConfig(replaceInRouteName: 'Page,Route')
class AppRouter extends RootStackRouter {
  @override
  RouteType get defaultRouteType => const RouteType.material();

  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: LoginWelcomeRoute.page, initial: true),
        AutoRoute(page: CreateAccountRoute.page),
        AutoRoute(page: SmsConfirmationRoute.page),
        AutoRoute(page: SelfieSubmissionRoute.page),
        AutoRoute(page: SelfieLivenessRoute.page),
        AutoRoute(page: SelfieVerificationRoute.page),
        AutoRoute(page: NotificationPermissionRoute.page),
        AutoRoute(page: LocationPermissionRoute.page),
        AutoRoute(page: BiometricPermissionRoute.page),
        AutoRoute(page: AuthLoadingRoute.page),
        AutoRoute(page: HomePlaceholderRoute.page),
      ];
}
