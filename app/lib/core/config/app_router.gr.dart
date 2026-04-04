// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:app/features/authentication/data/dtos/onboarding_dto.dart'
    as _i16;
import 'package:app/features/authentication/presentation/pages/auth_loading_page.dart'
    deferred as _i1;
import 'package:app/features/authentication/presentation/pages/biometric_permission_page.dart'
    deferred as _i2;
import 'package:app/features/authentication/presentation/pages/create_account_page.dart'
    deferred as _i3;
import 'package:app/features/authentication/presentation/pages/location_permission_page.dart'
    deferred as _i5;
import 'package:app/features/authentication/presentation/pages/login_welcome_page.dart'
    deferred as _i6;
import 'package:app/features/authentication/presentation/pages/notification_permission_page.dart'
    deferred as _i7;
import 'package:app/features/authentication/presentation/pages/selfie_liveness_page.dart'
    deferred as _i8;
import 'package:app/features/authentication/presentation/pages/selfie_submission_page.dart'
    deferred as _i9;
import 'package:app/features/authentication/presentation/pages/selfie_verification_page.dart'
    deferred as _i10;
import 'package:app/features/authentication/presentation/pages/sms_confirmation_page.dart'
    deferred as _i11;
import 'package:app/features/home/presentation/pages/home_placeholder_page.dart'
    deferred as _i4;
import 'package:app/features/permissions/data/dtos/permissions_dto.dart'
    as _i14;
import 'package:auto_route/auto_route.dart' as _i12;
import 'package:flutter/foundation.dart' as _i15;
import 'package:flutter/material.dart' as _i13;

/// generated route for
/// [_i1.AuthLoadingPage]
class AuthLoadingRoute extends _i12.PageRouteInfo<AuthLoadingRouteArgs> {
  AuthLoadingRoute({
    _i13.Key? key,
    _i13.Widget? center,
    required String cpfMasked,
    bool isRegisterOnboarding = false,
    bool awaitingLivenessInit = false,
    bool awaitingUserPermissionsUpdate = false,
    _i14.PermissionsDto? permissionsDto,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         AuthLoadingRoute.name,
         args: AuthLoadingRouteArgs(
           key: key,
           center: center,
           cpfMasked: cpfMasked,
           isRegisterOnboarding: isRegisterOnboarding,
           awaitingLivenessInit: awaitingLivenessInit,
           awaitingUserPermissionsUpdate: awaitingUserPermissionsUpdate,
           permissionsDto: permissionsDto,
         ),
         initialChildren: children,
       );

  static const String name = 'AuthLoadingRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<AuthLoadingRouteArgs>();
      return _i12.DeferredWidget(
        _i1.loadLibrary,
        () => _i1.AuthLoadingPage(
          key: args.key,
          center: args.center,
          cpfMasked: args.cpfMasked,
          isRegisterOnboarding: args.isRegisterOnboarding,
          awaitingLivenessInit: args.awaitingLivenessInit,
          awaitingUserPermissionsUpdate: args.awaitingUserPermissionsUpdate,
          permissionsDto: args.permissionsDto,
        ),
      );
    },
  );
}

class AuthLoadingRouteArgs {
  const AuthLoadingRouteArgs({
    this.key,
    this.center,
    required this.cpfMasked,
    this.isRegisterOnboarding = false,
    this.awaitingLivenessInit = false,
    this.awaitingUserPermissionsUpdate = false,
    this.permissionsDto,
  });

  final _i13.Key? key;

  final _i13.Widget? center;

  final String cpfMasked;

  final bool isRegisterOnboarding;

  final bool awaitingLivenessInit;

  final bool awaitingUserPermissionsUpdate;

  final _i14.PermissionsDto? permissionsDto;

  @override
  String toString() {
    return 'AuthLoadingRouteArgs{key: $key, center: $center, cpfMasked: $cpfMasked, isRegisterOnboarding: $isRegisterOnboarding, awaitingLivenessInit: $awaitingLivenessInit, awaitingUserPermissionsUpdate: $awaitingUserPermissionsUpdate, permissionsDto: $permissionsDto}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! AuthLoadingRouteArgs) return false;
    return key == other.key &&
        center == other.center &&
        cpfMasked == other.cpfMasked &&
        isRegisterOnboarding == other.isRegisterOnboarding &&
        awaitingLivenessInit == other.awaitingLivenessInit &&
        awaitingUserPermissionsUpdate == other.awaitingUserPermissionsUpdate &&
        permissionsDto == other.permissionsDto;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      center.hashCode ^
      cpfMasked.hashCode ^
      isRegisterOnboarding.hashCode ^
      awaitingLivenessInit.hashCode ^
      awaitingUserPermissionsUpdate.hashCode ^
      permissionsDto.hashCode;
}

/// generated route for
/// [_i2.BiometricPermissionPage]
class BiometricPermissionRoute
    extends _i12.PageRouteInfo<BiometricPermissionRouteArgs> {
  BiometricPermissionRoute({
    _i13.Key? key,
    required _i14.PermissionPromptResult notificationPermissionResult,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         BiometricPermissionRoute.name,
         args: BiometricPermissionRouteArgs(
           key: key,
           notificationPermissionResult: notificationPermissionResult,
         ),
         initialChildren: children,
       );

  static const String name = 'BiometricPermissionRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<BiometricPermissionRouteArgs>();
      return _i12.DeferredWidget(
        _i2.loadLibrary,
        () => _i2.BiometricPermissionPage(
          key: args.key,
          notificationPermissionResult: args.notificationPermissionResult,
        ),
      );
    },
  );
}

class BiometricPermissionRouteArgs {
  const BiometricPermissionRouteArgs({
    this.key,
    required this.notificationPermissionResult,
  });

  final _i13.Key? key;

  final _i14.PermissionPromptResult notificationPermissionResult;

  @override
  String toString() {
    return 'BiometricPermissionRouteArgs{key: $key, notificationPermissionResult: $notificationPermissionResult}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! BiometricPermissionRouteArgs) return false;
    return key == other.key &&
        notificationPermissionResult == other.notificationPermissionResult;
  }

  @override
  int get hashCode => key.hashCode ^ notificationPermissionResult.hashCode;
}

/// generated route for
/// [_i3.CreateAccountPage]
class CreateAccountRoute extends _i12.PageRouteInfo<CreateAccountRouteArgs> {
  CreateAccountRoute({
    _i13.Key? key,
    required String cpfMasked,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         CreateAccountRoute.name,
         args: CreateAccountRouteArgs(key: key, cpfMasked: cpfMasked),
         initialChildren: children,
       );

  static const String name = 'CreateAccountRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<CreateAccountRouteArgs>();
      return _i12.DeferredWidget(
        _i3.loadLibrary,
        () => _i3.CreateAccountPage(key: args.key, cpfMasked: args.cpfMasked),
      );
    },
  );
}

class CreateAccountRouteArgs {
  const CreateAccountRouteArgs({this.key, required this.cpfMasked});

  final _i13.Key? key;

  final String cpfMasked;

  @override
  String toString() {
    return 'CreateAccountRouteArgs{key: $key, cpfMasked: $cpfMasked}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! CreateAccountRouteArgs) return false;
    return key == other.key && cpfMasked == other.cpfMasked;
  }

  @override
  int get hashCode => key.hashCode ^ cpfMasked.hashCode;
}

/// generated route for
/// [_i4.HomePlaceholderPage]
class HomePlaceholderRoute extends _i12.PageRouteInfo<void> {
  const HomePlaceholderRoute({List<_i12.PageRouteInfo>? children})
    : super(HomePlaceholderRoute.name, initialChildren: children);

  static const String name = 'HomePlaceholderRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i12.DeferredWidget(
        _i4.loadLibrary,
        () => _i4.HomePlaceholderPage(),
      );
    },
  );
}

/// generated route for
/// [_i5.LocationPermissionPage]
class LocationPermissionRoute
    extends _i12.PageRouteInfo<LocationPermissionRouteArgs> {
  LocationPermissionRoute({
    _i13.Key? key,
    required _i14.PermissionPromptResult notificationPermissionResult,
    required _i14.PermissionPromptResult biometricPermissionResult,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         LocationPermissionRoute.name,
         args: LocationPermissionRouteArgs(
           key: key,
           notificationPermissionResult: notificationPermissionResult,
           biometricPermissionResult: biometricPermissionResult,
         ),
         initialChildren: children,
       );

  static const String name = 'LocationPermissionRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<LocationPermissionRouteArgs>();
      return _i12.DeferredWidget(
        _i5.loadLibrary,
        () => _i5.LocationPermissionPage(
          key: args.key,
          notificationPermissionResult: args.notificationPermissionResult,
          biometricPermissionResult: args.biometricPermissionResult,
        ),
      );
    },
  );
}

class LocationPermissionRouteArgs {
  const LocationPermissionRouteArgs({
    this.key,
    required this.notificationPermissionResult,
    required this.biometricPermissionResult,
  });

  final _i13.Key? key;

  final _i14.PermissionPromptResult notificationPermissionResult;

  final _i14.PermissionPromptResult biometricPermissionResult;

  @override
  String toString() {
    return 'LocationPermissionRouteArgs{key: $key, notificationPermissionResult: $notificationPermissionResult, biometricPermissionResult: $biometricPermissionResult}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! LocationPermissionRouteArgs) return false;
    return key == other.key &&
        notificationPermissionResult == other.notificationPermissionResult &&
        biometricPermissionResult == other.biometricPermissionResult;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      notificationPermissionResult.hashCode ^
      biometricPermissionResult.hashCode;
}

/// generated route for
/// [_i6.LoginWelcomePage]
class LoginWelcomeRoute extends _i12.PageRouteInfo<void> {
  const LoginWelcomeRoute({List<_i12.PageRouteInfo>? children})
    : super(LoginWelcomeRoute.name, initialChildren: children);

  static const String name = 'LoginWelcomeRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i12.DeferredWidget(_i6.loadLibrary, () => _i6.LoginWelcomePage());
    },
  );
}

/// generated route for
/// [_i7.NotificationPermissionPage]
class NotificationPermissionRoute extends _i12.PageRouteInfo<void> {
  const NotificationPermissionRoute({List<_i12.PageRouteInfo>? children})
    : super(NotificationPermissionRoute.name, initialChildren: children);

  static const String name = 'NotificationPermissionRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i12.DeferredWidget(
        _i7.loadLibrary,
        () => _i7.NotificationPermissionPage(),
      );
    },
  );
}

/// generated route for
/// [_i8.SelfieLivenessPage]
class SelfieLivenessRoute extends _i12.PageRouteInfo<SelfieLivenessRouteArgs> {
  SelfieLivenessRoute({
    _i15.Key? key,
    String? providerSessionId,
    String? livenessSessionId,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         SelfieLivenessRoute.name,
         args: SelfieLivenessRouteArgs(
           key: key,
           providerSessionId: providerSessionId,
           livenessSessionId: livenessSessionId,
         ),
         initialChildren: children,
       );

  static const String name = 'SelfieLivenessRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SelfieLivenessRouteArgs>(
        orElse: () => const SelfieLivenessRouteArgs(),
      );
      return _i12.DeferredWidget(
        _i8.loadLibrary,
        () => _i8.SelfieLivenessPage(
          key: args.key,
          providerSessionId: args.providerSessionId,
          livenessSessionId: args.livenessSessionId,
        ),
      );
    },
  );
}

class SelfieLivenessRouteArgs {
  const SelfieLivenessRouteArgs({
    this.key,
    this.providerSessionId,
    this.livenessSessionId,
  });

  final _i15.Key? key;

  final String? providerSessionId;

  final String? livenessSessionId;

  @override
  String toString() {
    return 'SelfieLivenessRouteArgs{key: $key, providerSessionId: $providerSessionId, livenessSessionId: $livenessSessionId}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SelfieLivenessRouteArgs) return false;
    return key == other.key &&
        providerSessionId == other.providerSessionId &&
        livenessSessionId == other.livenessSessionId;
  }

  @override
  int get hashCode =>
      key.hashCode ^ providerSessionId.hashCode ^ livenessSessionId.hashCode;
}

/// generated route for
/// [_i9.SelfieSubmissionPage]
class SelfieSubmissionRoute extends _i12.PageRouteInfo<void> {
  const SelfieSubmissionRoute({List<_i12.PageRouteInfo>? children})
    : super(SelfieSubmissionRoute.name, initialChildren: children);

  static const String name = 'SelfieSubmissionRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i12.DeferredWidget(
        _i9.loadLibrary,
        () => _i9.SelfieSubmissionPage(),
      );
    },
  );
}

/// generated route for
/// [_i10.SelfieVerificationPage]
class SelfieVerificationRoute extends _i12.PageRouteInfo<void> {
  const SelfieVerificationRoute({List<_i12.PageRouteInfo>? children})
    : super(SelfieVerificationRoute.name, initialChildren: children);

  static const String name = 'SelfieVerificationRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      return _i12.DeferredWidget(
        _i10.loadLibrary,
        () => _i10.SelfieVerificationPage(),
      );
    },
  );
}

/// generated route for
/// [_i11.SmsConfirmationPage]
class SmsConfirmationRoute
    extends _i12.PageRouteInfo<SmsConfirmationRouteArgs> {
  SmsConfirmationRoute({
    _i15.Key? key,
    required String phoneNumberMasked,
    bool alreadyPhoneVerified = false,
    String phoneNumberE164 = '',
    String verificationId = '',
    int? forceResendingToken,
    _i16.OnboardingDto? pendingOnboarding,
    List<_i12.PageRouteInfo>? children,
  }) : super(
         SmsConfirmationRoute.name,
         args: SmsConfirmationRouteArgs(
           key: key,
           phoneNumberMasked: phoneNumberMasked,
           alreadyPhoneVerified: alreadyPhoneVerified,
           phoneNumberE164: phoneNumberE164,
           verificationId: verificationId,
           forceResendingToken: forceResendingToken,
           pendingOnboarding: pendingOnboarding,
         ),
         initialChildren: children,
       );

  static const String name = 'SmsConfirmationRoute';

  static _i12.PageInfo page = _i12.PageInfo(
    name,
    builder: (data) {
      final args = data.argsAs<SmsConfirmationRouteArgs>();
      return _i12.DeferredWidget(
        _i11.loadLibrary,
        () => _i11.SmsConfirmationPage(
          key: args.key,
          phoneNumberMasked: args.phoneNumberMasked,
          alreadyPhoneVerified: args.alreadyPhoneVerified,
          phoneNumberE164: args.phoneNumberE164,
          verificationId: args.verificationId,
          forceResendingToken: args.forceResendingToken,
          pendingOnboarding: args.pendingOnboarding,
        ),
      );
    },
  );
}

class SmsConfirmationRouteArgs {
  const SmsConfirmationRouteArgs({
    this.key,
    required this.phoneNumberMasked,
    this.alreadyPhoneVerified = false,
    this.phoneNumberE164 = '',
    this.verificationId = '',
    this.forceResendingToken,
    this.pendingOnboarding,
  });

  final _i15.Key? key;

  final String phoneNumberMasked;

  final bool alreadyPhoneVerified;

  final String phoneNumberE164;

  final String verificationId;

  final int? forceResendingToken;

  final _i16.OnboardingDto? pendingOnboarding;

  @override
  String toString() {
    return 'SmsConfirmationRouteArgs{key: $key, phoneNumberMasked: $phoneNumberMasked, alreadyPhoneVerified: $alreadyPhoneVerified, phoneNumberE164: $phoneNumberE164, verificationId: $verificationId, forceResendingToken: $forceResendingToken, pendingOnboarding: $pendingOnboarding}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is! SmsConfirmationRouteArgs) return false;
    return key == other.key &&
        phoneNumberMasked == other.phoneNumberMasked &&
        alreadyPhoneVerified == other.alreadyPhoneVerified &&
        phoneNumberE164 == other.phoneNumberE164 &&
        verificationId == other.verificationId &&
        forceResendingToken == other.forceResendingToken &&
        pendingOnboarding == other.pendingOnboarding;
  }

  @override
  int get hashCode =>
      key.hashCode ^
      phoneNumberMasked.hashCode ^
      alreadyPhoneVerified.hashCode ^
      phoneNumberE164.hashCode ^
      verificationId.hashCode ^
      forceResendingToken.hashCode ^
      pendingOnboarding.hashCode;
}
