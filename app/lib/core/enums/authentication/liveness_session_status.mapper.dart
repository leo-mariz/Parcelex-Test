// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'liveness_session_status.dart';

class LivenessSessionStatusMapper extends EnumMapper<LivenessSessionStatus> {
  LivenessSessionStatusMapper._();

  static LivenessSessionStatusMapper? _instance;
  static LivenessSessionStatusMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LivenessSessionStatusMapper._());
    }
    return _instance!;
  }

  static LivenessSessionStatus fromValue(dynamic value) {
    ensureInitialized();
    return MapperContainer.globals.fromValue(value);
  }

  @override
  LivenessSessionStatus decode(dynamic value) {
    switch (value) {
      case r'started':
        return LivenessSessionStatus.started;
      case r'succeeded':
        return LivenessSessionStatus.succeeded;
      case r'failed':
        return LivenessSessionStatus.failed;
      case r'expired':
        return LivenessSessionStatus.expired;
      default:
        throw MapperException.unknownEnumValue(value);
    }
  }

  @override
  dynamic encode(LivenessSessionStatus self) {
    switch (self) {
      case LivenessSessionStatus.started:
        return r'started';
      case LivenessSessionStatus.succeeded:
        return r'succeeded';
      case LivenessSessionStatus.failed:
        return r'failed';
      case LivenessSessionStatus.expired:
        return r'expired';
    }
  }
}

extension LivenessSessionStatusMapperExtension on LivenessSessionStatus {
  String toValue() {
    LivenessSessionStatusMapper.ensureInitialized();
    return MapperContainer.globals.toValue<LivenessSessionStatus>(this)
        as String;
  }
}

