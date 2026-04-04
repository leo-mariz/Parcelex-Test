// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'onboarding_step.dart';

class OnboardingStepMapper extends EnumMapper<OnboardingStep> {
  OnboardingStepMapper._();

  static OnboardingStepMapper? _instance;
  static OnboardingStepMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = OnboardingStepMapper._());
    }
    return _instance!;
  }

  static OnboardingStep fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  OnboardingStep decode(dynamic value) {
    switch (value) {
      case r'none':
        return OnboardingStep.none;
      case r'profileComplete':
        return OnboardingStep.profileComplete;
      case r'liveness':
        return OnboardingStep.liveness;
      case r'permissions':
        return OnboardingStep.permissions;
      case r'done':
        return OnboardingStep.done;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(OnboardingStep self) {
    switch (self) {
      case OnboardingStep.none:
        return r'none';
      case OnboardingStep.profileComplete:
        return r'profileComplete';
      case OnboardingStep.liveness:
        return r'liveness';
      case OnboardingStep.permissions:
        return r'permissions';
      case OnboardingStep.done:
        return r'done';
    }
  }
}

extension OnboardingStepMapperExtension on OnboardingStep {
  String toValue() {
    OnboardingStepMapper.ensureInitialized();
    return MapperContainer.globals.toValue<OnboardingStep>(this) as String;
  }
}

