// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'permission_prompt_state_entity.dart';

class PermissionPromptRecordEntityMapper
    extends ClassMapperBase<PermissionPromptRecordEntity> {
  PermissionPromptRecordEntityMapper._();

  static PermissionPromptRecordEntityMapper? _instance;
  static PermissionPromptRecordEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PermissionPromptRecordEntityMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'PermissionPromptRecordEntity';

  static bool _$seen(PermissionPromptRecordEntity v) => v.seen;
  static const Field<PermissionPromptRecordEntity, bool> _f$seen = Field(
    'seen',
    _$seen,
    opt: true,
    def: false,
  );
  static bool _$skipped(PermissionPromptRecordEntity v) => v.skipped;
  static const Field<PermissionPromptRecordEntity, bool> _f$skipped = Field(
    'skipped',
    _$skipped,
    opt: true,
    def: false,
  );
  static DateTime? _$completedAt(PermissionPromptRecordEntity v) =>
      v.completedAt;
  static const Field<PermissionPromptRecordEntity, DateTime> _f$completedAt =
      Field('completedAt', _$completedAt, opt: true);

  @override
  final MappableFields<PermissionPromptRecordEntity> fields = const {
    #seen: _f$seen,
    #skipped: _f$skipped,
    #completedAt: _f$completedAt,
  };

  static PermissionPromptRecordEntity _instantiate(DecodingData data) {
    return PermissionPromptRecordEntity(
      seen: data.dec(_f$seen),
      skipped: data.dec(_f$skipped),
      completedAt: data.dec(_f$completedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PermissionPromptRecordEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PermissionPromptRecordEntity>(map);
  }

  static PermissionPromptRecordEntity fromJson(String json) {
    return ensureInitialized().decodeJson<PermissionPromptRecordEntity>(json);
  }
}

mixin PermissionPromptRecordEntityMappable {
  String toJson() {
    return PermissionPromptRecordEntityMapper.ensureInitialized()
        .encodeJson<PermissionPromptRecordEntity>(
          this as PermissionPromptRecordEntity,
        );
  }

  Map<String, dynamic> toMap() {
    return PermissionPromptRecordEntityMapper.ensureInitialized()
        .encodeMap<PermissionPromptRecordEntity>(
          this as PermissionPromptRecordEntity,
        );
  }

  PermissionPromptRecordEntityCopyWith<
    PermissionPromptRecordEntity,
    PermissionPromptRecordEntity,
    PermissionPromptRecordEntity
  >
  get copyWith =>
      _PermissionPromptRecordEntityCopyWithImpl<
        PermissionPromptRecordEntity,
        PermissionPromptRecordEntity
      >(this as PermissionPromptRecordEntity, $identity, $identity);
  @override
  String toString() {
    return PermissionPromptRecordEntityMapper.ensureInitialized()
        .stringifyValue(this as PermissionPromptRecordEntity);
  }

  @override
  bool operator ==(Object other) {
    return PermissionPromptRecordEntityMapper.ensureInitialized().equalsValue(
      this as PermissionPromptRecordEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return PermissionPromptRecordEntityMapper.ensureInitialized().hashValue(
      this as PermissionPromptRecordEntity,
    );
  }
}

extension PermissionPromptRecordEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PermissionPromptRecordEntity, $Out> {
  PermissionPromptRecordEntityCopyWith<$R, PermissionPromptRecordEntity, $Out>
  get $asPermissionPromptRecordEntity => $base.as(
    (v, t, t2) => _PermissionPromptRecordEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PermissionPromptRecordEntityCopyWith<
  $R,
  $In extends PermissionPromptRecordEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({bool? seen, bool? skipped, DateTime? completedAt});
  PermissionPromptRecordEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PermissionPromptRecordEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PermissionPromptRecordEntity, $Out>
    implements
        PermissionPromptRecordEntityCopyWith<
          $R,
          PermissionPromptRecordEntity,
          $Out
        > {
  _PermissionPromptRecordEntityCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PermissionPromptRecordEntity> $mapper =
      PermissionPromptRecordEntityMapper.ensureInitialized();
  @override
  $R call({bool? seen, bool? skipped, Object? completedAt = $none}) => $apply(
    FieldCopyWithData({
      if (seen != null) #seen: seen,
      if (skipped != null) #skipped: skipped,
      if (completedAt != $none) #completedAt: completedAt,
    }),
  );
  @override
  PermissionPromptRecordEntity $make(CopyWithData data) =>
      PermissionPromptRecordEntity(
        seen: data.get(#seen, or: $value.seen),
        skipped: data.get(#skipped, or: $value.skipped),
        completedAt: data.get(#completedAt, or: $value.completedAt),
      );

  @override
  PermissionPromptRecordEntityCopyWith<$R2, PermissionPromptRecordEntity, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PermissionPromptRecordEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

class PermissionPromptStateEntityMapper
    extends ClassMapperBase<PermissionPromptStateEntity> {
  PermissionPromptStateEntityMapper._();

  static PermissionPromptStateEntityMapper? _instance;
  static PermissionPromptStateEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = PermissionPromptStateEntityMapper._(),
      );
      PermissionPromptRecordEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'PermissionPromptStateEntity';

  static PermissionPromptRecordEntity _$notification(
    PermissionPromptStateEntity v,
  ) => v.notification;
  static const Field<PermissionPromptStateEntity, PermissionPromptRecordEntity>
  _f$notification = Field(
    'notification',
    _$notification,
    opt: true,
    def: const PermissionPromptRecordEntity(),
  );
  static PermissionPromptRecordEntity _$location(
    PermissionPromptStateEntity v,
  ) => v.location;
  static const Field<PermissionPromptStateEntity, PermissionPromptRecordEntity>
  _f$location = Field(
    'location',
    _$location,
    opt: true,
    def: const PermissionPromptRecordEntity(),
  );
  static PermissionPromptRecordEntity _$biometric(
    PermissionPromptStateEntity v,
  ) => v.biometric;
  static const Field<PermissionPromptStateEntity, PermissionPromptRecordEntity>
  _f$biometric = Field(
    'biometric',
    _$biometric,
    opt: true,
    def: const PermissionPromptRecordEntity(),
  );

  @override
  final MappableFields<PermissionPromptStateEntity> fields = const {
    #notification: _f$notification,
    #location: _f$location,
    #biometric: _f$biometric,
  };

  static PermissionPromptStateEntity _instantiate(DecodingData data) {
    return PermissionPromptStateEntity(
      notification: data.dec(_f$notification),
      location: data.dec(_f$location),
      biometric: data.dec(_f$biometric),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static PermissionPromptStateEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<PermissionPromptStateEntity>(map);
  }

  static PermissionPromptStateEntity fromJson(String json) {
    return ensureInitialized().decodeJson<PermissionPromptStateEntity>(json);
  }
}

mixin PermissionPromptStateEntityMappable {
  String toJson() {
    return PermissionPromptStateEntityMapper.ensureInitialized()
        .encodeJson<PermissionPromptStateEntity>(
          this as PermissionPromptStateEntity,
        );
  }

  Map<String, dynamic> toMap() {
    return PermissionPromptStateEntityMapper.ensureInitialized()
        .encodeMap<PermissionPromptStateEntity>(
          this as PermissionPromptStateEntity,
        );
  }

  PermissionPromptStateEntityCopyWith<
    PermissionPromptStateEntity,
    PermissionPromptStateEntity,
    PermissionPromptStateEntity
  >
  get copyWith =>
      _PermissionPromptStateEntityCopyWithImpl<
        PermissionPromptStateEntity,
        PermissionPromptStateEntity
      >(this as PermissionPromptStateEntity, $identity, $identity);
  @override
  String toString() {
    return PermissionPromptStateEntityMapper.ensureInitialized().stringifyValue(
      this as PermissionPromptStateEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return PermissionPromptStateEntityMapper.ensureInitialized().equalsValue(
      this as PermissionPromptStateEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return PermissionPromptStateEntityMapper.ensureInitialized().hashValue(
      this as PermissionPromptStateEntity,
    );
  }
}

extension PermissionPromptStateEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, PermissionPromptStateEntity, $Out> {
  PermissionPromptStateEntityCopyWith<$R, PermissionPromptStateEntity, $Out>
  get $asPermissionPromptStateEntity => $base.as(
    (v, t, t2) => _PermissionPromptStateEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class PermissionPromptStateEntityCopyWith<
  $R,
  $In extends PermissionPromptStateEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  PermissionPromptRecordEntityCopyWith<
    $R,
    PermissionPromptRecordEntity,
    PermissionPromptRecordEntity
  >
  get notification;
  PermissionPromptRecordEntityCopyWith<
    $R,
    PermissionPromptRecordEntity,
    PermissionPromptRecordEntity
  >
  get location;
  PermissionPromptRecordEntityCopyWith<
    $R,
    PermissionPromptRecordEntity,
    PermissionPromptRecordEntity
  >
  get biometric;
  $R call({
    PermissionPromptRecordEntity? notification,
    PermissionPromptRecordEntity? location,
    PermissionPromptRecordEntity? biometric,
  });
  PermissionPromptStateEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _PermissionPromptStateEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, PermissionPromptStateEntity, $Out>
    implements
        PermissionPromptStateEntityCopyWith<
          $R,
          PermissionPromptStateEntity,
          $Out
        > {
  _PermissionPromptStateEntityCopyWithImpl(
    super.value,
    super.then,
    super.then2,
  );

  @override
  late final ClassMapperBase<PermissionPromptStateEntity> $mapper =
      PermissionPromptStateEntityMapper.ensureInitialized();
  @override
  PermissionPromptRecordEntityCopyWith<
    $R,
    PermissionPromptRecordEntity,
    PermissionPromptRecordEntity
  >
  get notification =>
      $value.notification.copyWith.$chain((v) => call(notification: v));
  @override
  PermissionPromptRecordEntityCopyWith<
    $R,
    PermissionPromptRecordEntity,
    PermissionPromptRecordEntity
  >
  get location => $value.location.copyWith.$chain((v) => call(location: v));
  @override
  PermissionPromptRecordEntityCopyWith<
    $R,
    PermissionPromptRecordEntity,
    PermissionPromptRecordEntity
  >
  get biometric => $value.biometric.copyWith.$chain((v) => call(biometric: v));
  @override
  $R call({
    PermissionPromptRecordEntity? notification,
    PermissionPromptRecordEntity? location,
    PermissionPromptRecordEntity? biometric,
  }) => $apply(
    FieldCopyWithData({
      if (notification != null) #notification: notification,
      if (location != null) #location: location,
      if (biometric != null) #biometric: biometric,
    }),
  );
  @override
  PermissionPromptStateEntity $make(CopyWithData data) =>
      PermissionPromptStateEntity(
        notification: data.get(#notification, or: $value.notification),
        location: data.get(#location, or: $value.location),
        biometric: data.get(#biometric, or: $value.biometric),
      );

  @override
  PermissionPromptStateEntityCopyWith<$R2, PermissionPromptStateEntity, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _PermissionPromptStateEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

