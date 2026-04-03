// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'liveness_session_entity.dart';

class LivenessSessionEntityMapper
    extends ClassMapperBase<LivenessSessionEntity> {
  LivenessSessionEntityMapper._();

  static LivenessSessionEntityMapper? _instance;
  static LivenessSessionEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = LivenessSessionEntityMapper._());
      LivenessSessionStatusMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'LivenessSessionEntity';

  static String _$id(LivenessSessionEntity v) => v.id;
  static const Field<LivenessSessionEntity, String> _f$id = Field('id', _$id);
  static String _$userId(LivenessSessionEntity v) => v.userId;
  static const Field<LivenessSessionEntity, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$provider(LivenessSessionEntity v) => v.provider;
  static const Field<LivenessSessionEntity, String> _f$provider = Field(
    'provider',
    _$provider,
  );
  static String? _$providerSessionId(LivenessSessionEntity v) =>
      v.providerSessionId;
  static const Field<LivenessSessionEntity, String> _f$providerSessionId =
      Field('providerSessionId', _$providerSessionId, opt: true);
  static LivenessSessionStatus _$status(LivenessSessionEntity v) => v.status;
  static const Field<LivenessSessionEntity, LivenessSessionStatus> _f$status =
      Field('status', _$status);
  static Map<String, dynamic>? _$resultSummary(LivenessSessionEntity v) =>
      v.resultSummary;
  static const Field<LivenessSessionEntity, Map<String, dynamic>>
  _f$resultSummary = Field('resultSummary', _$resultSummary, opt: true);
  static String? _$rawPayloadRef(LivenessSessionEntity v) => v.rawPayloadRef;
  static const Field<LivenessSessionEntity, String> _f$rawPayloadRef = Field(
    'rawPayloadRef',
    _$rawPayloadRef,
    opt: true,
  );
  static DateTime _$createdAt(LivenessSessionEntity v) => v.createdAt;
  static const Field<LivenessSessionEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime? _$completedAt(LivenessSessionEntity v) => v.completedAt;
  static const Field<LivenessSessionEntity, DateTime> _f$completedAt = Field(
    'completedAt',
    _$completedAt,
    opt: true,
  );

  @override
  final MappableFields<LivenessSessionEntity> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #provider: _f$provider,
    #providerSessionId: _f$providerSessionId,
    #status: _f$status,
    #resultSummary: _f$resultSummary,
    #rawPayloadRef: _f$rawPayloadRef,
    #createdAt: _f$createdAt,
    #completedAt: _f$completedAt,
  };

  static LivenessSessionEntity _instantiate(DecodingData data) {
    return LivenessSessionEntity(
      id: data.dec(_f$id),
      userId: data.dec(_f$userId),
      provider: data.dec(_f$provider),
      providerSessionId: data.dec(_f$providerSessionId),
      status: data.dec(_f$status),
      resultSummary: data.dec(_f$resultSummary),
      rawPayloadRef: data.dec(_f$rawPayloadRef),
      createdAt: data.dec(_f$createdAt),
      completedAt: data.dec(_f$completedAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static LivenessSessionEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<LivenessSessionEntity>(map);
  }

  static LivenessSessionEntity fromJson(String json) {
    return ensureInitialized().decodeJson<LivenessSessionEntity>(json);
  }
}

mixin LivenessSessionEntityMappable {
  String toJson() {
    return LivenessSessionEntityMapper.ensureInitialized()
        .encodeJson<LivenessSessionEntity>(this as LivenessSessionEntity);
  }

  Map<String, dynamic> toMap() {
    return LivenessSessionEntityMapper.ensureInitialized()
        .encodeMap<LivenessSessionEntity>(this as LivenessSessionEntity);
  }

  LivenessSessionEntityCopyWith<
    LivenessSessionEntity,
    LivenessSessionEntity,
    LivenessSessionEntity
  >
  get copyWith =>
      _LivenessSessionEntityCopyWithImpl<
        LivenessSessionEntity,
        LivenessSessionEntity
      >(this as LivenessSessionEntity, $identity, $identity);
  @override
  String toString() {
    return LivenessSessionEntityMapper.ensureInitialized().stringifyValue(
      this as LivenessSessionEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return LivenessSessionEntityMapper.ensureInitialized().equalsValue(
      this as LivenessSessionEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return LivenessSessionEntityMapper.ensureInitialized().hashValue(
      this as LivenessSessionEntity,
    );
  }
}

extension LivenessSessionEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, LivenessSessionEntity, $Out> {
  LivenessSessionEntityCopyWith<$R, LivenessSessionEntity, $Out>
  get $asLivenessSessionEntity => $base.as(
    (v, t, t2) => _LivenessSessionEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class LivenessSessionEntityCopyWith<
  $R,
  $In extends LivenessSessionEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>?>?
  get resultSummary;
  $R call({
    String? id,
    String? userId,
    String? provider,
    String? providerSessionId,
    LivenessSessionStatus? status,
    Map<String, dynamic>? resultSummary,
    String? rawPayloadRef,
    DateTime? createdAt,
    DateTime? completedAt,
  });
  LivenessSessionEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _LivenessSessionEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, LivenessSessionEntity, $Out>
    implements LivenessSessionEntityCopyWith<$R, LivenessSessionEntity, $Out> {
  _LivenessSessionEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<LivenessSessionEntity> $mapper =
      LivenessSessionEntityMapper.ensureInitialized();
  @override
  MapCopyWith<$R, String, dynamic, ObjectCopyWith<$R, dynamic, dynamic>?>?
  get resultSummary => $value.resultSummary != null
      ? MapCopyWith(
          $value.resultSummary!,
          (v, t) => ObjectCopyWith(v, $identity, t),
          (v) => call(resultSummary: v),
        )
      : null;
  @override
  $R call({
    String? id,
    String? userId,
    String? provider,
    Object? providerSessionId = $none,
    LivenessSessionStatus? status,
    Object? resultSummary = $none,
    Object? rawPayloadRef = $none,
    DateTime? createdAt,
    Object? completedAt = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (userId != null) #userId: userId,
      if (provider != null) #provider: provider,
      if (providerSessionId != $none) #providerSessionId: providerSessionId,
      if (status != null) #status: status,
      if (resultSummary != $none) #resultSummary: resultSummary,
      if (rawPayloadRef != $none) #rawPayloadRef: rawPayloadRef,
      if (createdAt != null) #createdAt: createdAt,
      if (completedAt != $none) #completedAt: completedAt,
    }),
  );
  @override
  LivenessSessionEntity $make(CopyWithData data) => LivenessSessionEntity(
    id: data.get(#id, or: $value.id),
    userId: data.get(#userId, or: $value.userId),
    provider: data.get(#provider, or: $value.provider),
    providerSessionId: data.get(
      #providerSessionId,
      or: $value.providerSessionId,
    ),
    status: data.get(#status, or: $value.status),
    resultSummary: data.get(#resultSummary, or: $value.resultSummary),
    rawPayloadRef: data.get(#rawPayloadRef, or: $value.rawPayloadRef),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    completedAt: data.get(#completedAt, or: $value.completedAt),
  );

  @override
  LivenessSessionEntityCopyWith<$R2, LivenessSessionEntity, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _LivenessSessionEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

