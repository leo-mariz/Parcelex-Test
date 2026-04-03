// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'email_otp_challenge_entity.dart';

class EmailOtpChallengeEntityMapper
    extends ClassMapperBase<EmailOtpChallengeEntity> {
  EmailOtpChallengeEntityMapper._();

  static EmailOtpChallengeEntityMapper? _instance;
  static EmailOtpChallengeEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(
        _instance = EmailOtpChallengeEntityMapper._(),
      );
    }
    return _instance!;
  }

  @override
  final String id = 'EmailOtpChallengeEntity';

  static String _$id(EmailOtpChallengeEntity v) => v.id;
  static const Field<EmailOtpChallengeEntity, String> _f$id = Field('id', _$id);
  static String _$userId(EmailOtpChallengeEntity v) => v.userId;
  static const Field<EmailOtpChallengeEntity, String> _f$userId = Field(
    'userId',
    _$userId,
  );
  static String _$codeHash(EmailOtpChallengeEntity v) => v.codeHash;
  static const Field<EmailOtpChallengeEntity, String> _f$codeHash = Field(
    'codeHash',
    _$codeHash,
  );
  static DateTime _$expiresAt(EmailOtpChallengeEntity v) => v.expiresAt;
  static const Field<EmailOtpChallengeEntity, DateTime> _f$expiresAt = Field(
    'expiresAt',
    _$expiresAt,
  );
  static int _$attemptCount(EmailOtpChallengeEntity v) => v.attemptCount;
  static const Field<EmailOtpChallengeEntity, int> _f$attemptCount = Field(
    'attemptCount',
    _$attemptCount,
    opt: true,
    def: 0,
  );
  static DateTime? _$consumedAt(EmailOtpChallengeEntity v) => v.consumedAt;
  static const Field<EmailOtpChallengeEntity, DateTime> _f$consumedAt = Field(
    'consumedAt',
    _$consumedAt,
    opt: true,
  );
  static DateTime _$createdAt(EmailOtpChallengeEntity v) => v.createdAt;
  static const Field<EmailOtpChallengeEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );

  @override
  final MappableFields<EmailOtpChallengeEntity> fields = const {
    #id: _f$id,
    #userId: _f$userId,
    #codeHash: _f$codeHash,
    #expiresAt: _f$expiresAt,
    #attemptCount: _f$attemptCount,
    #consumedAt: _f$consumedAt,
    #createdAt: _f$createdAt,
  };

  static EmailOtpChallengeEntity _instantiate(DecodingData data) {
    return EmailOtpChallengeEntity(
      id: data.dec(_f$id),
      userId: data.dec(_f$userId),
      codeHash: data.dec(_f$codeHash),
      expiresAt: data.dec(_f$expiresAt),
      attemptCount: data.dec(_f$attemptCount),
      consumedAt: data.dec(_f$consumedAt),
      createdAt: data.dec(_f$createdAt),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static EmailOtpChallengeEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<EmailOtpChallengeEntity>(map);
  }

  static EmailOtpChallengeEntity fromJson(String json) {
    return ensureInitialized().decodeJson<EmailOtpChallengeEntity>(json);
  }
}

mixin EmailOtpChallengeEntityMappable {
  String toJson() {
    return EmailOtpChallengeEntityMapper.ensureInitialized()
        .encodeJson<EmailOtpChallengeEntity>(this as EmailOtpChallengeEntity);
  }

  Map<String, dynamic> toMap() {
    return EmailOtpChallengeEntityMapper.ensureInitialized()
        .encodeMap<EmailOtpChallengeEntity>(this as EmailOtpChallengeEntity);
  }

  EmailOtpChallengeEntityCopyWith<
    EmailOtpChallengeEntity,
    EmailOtpChallengeEntity,
    EmailOtpChallengeEntity
  >
  get copyWith =>
      _EmailOtpChallengeEntityCopyWithImpl<
        EmailOtpChallengeEntity,
        EmailOtpChallengeEntity
      >(this as EmailOtpChallengeEntity, $identity, $identity);
  @override
  String toString() {
    return EmailOtpChallengeEntityMapper.ensureInitialized().stringifyValue(
      this as EmailOtpChallengeEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return EmailOtpChallengeEntityMapper.ensureInitialized().equalsValue(
      this as EmailOtpChallengeEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return EmailOtpChallengeEntityMapper.ensureInitialized().hashValue(
      this as EmailOtpChallengeEntity,
    );
  }
}

extension EmailOtpChallengeEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, EmailOtpChallengeEntity, $Out> {
  EmailOtpChallengeEntityCopyWith<$R, EmailOtpChallengeEntity, $Out>
  get $asEmailOtpChallengeEntity => $base.as(
    (v, t, t2) => _EmailOtpChallengeEntityCopyWithImpl<$R, $Out>(v, t, t2),
  );
}

abstract class EmailOtpChallengeEntityCopyWith<
  $R,
  $In extends EmailOtpChallengeEntity,
  $Out
>
    implements ClassCopyWith<$R, $In, $Out> {
  $R call({
    String? id,
    String? userId,
    String? codeHash,
    DateTime? expiresAt,
    int? attemptCount,
    DateTime? consumedAt,
    DateTime? createdAt,
  });
  EmailOtpChallengeEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  );
}

class _EmailOtpChallengeEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, EmailOtpChallengeEntity, $Out>
    implements
        EmailOtpChallengeEntityCopyWith<$R, EmailOtpChallengeEntity, $Out> {
  _EmailOtpChallengeEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<EmailOtpChallengeEntity> $mapper =
      EmailOtpChallengeEntityMapper.ensureInitialized();
  @override
  $R call({
    String? id,
    String? userId,
    String? codeHash,
    DateTime? expiresAt,
    int? attemptCount,
    Object? consumedAt = $none,
    DateTime? createdAt,
  }) => $apply(
    FieldCopyWithData({
      if (id != null) #id: id,
      if (userId != null) #userId: userId,
      if (codeHash != null) #codeHash: codeHash,
      if (expiresAt != null) #expiresAt: expiresAt,
      if (attemptCount != null) #attemptCount: attemptCount,
      if (consumedAt != $none) #consumedAt: consumedAt,
      if (createdAt != null) #createdAt: createdAt,
    }),
  );
  @override
  EmailOtpChallengeEntity $make(CopyWithData data) => EmailOtpChallengeEntity(
    id: data.get(#id, or: $value.id),
    userId: data.get(#userId, or: $value.userId),
    codeHash: data.get(#codeHash, or: $value.codeHash),
    expiresAt: data.get(#expiresAt, or: $value.expiresAt),
    attemptCount: data.get(#attemptCount, or: $value.attemptCount),
    consumedAt: data.get(#consumedAt, or: $value.consumedAt),
    createdAt: data.get(#createdAt, or: $value.createdAt),
  );

  @override
  EmailOtpChallengeEntityCopyWith<$R2, EmailOtpChallengeEntity, $Out2>
  $chain<$R2, $Out2>(Then<$Out2, $R2> t) =>
      _EmailOtpChallengeEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

