// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
// ignore_for_file: type=lint
// ignore_for_file: invalid_use_of_protected_member
// ignore_for_file: unused_element, unnecessary_cast, override_on_non_overriding_member
// ignore_for_file: strict_raw_type, inference_failure_on_untyped_parameter

part of 'user_entity.dart';

class UserEntityMapper extends ClassMapperBase<UserEntity> {
  UserEntityMapper._();

  static UserEntityMapper? _instance;
  static UserEntityMapper ensureInitialized() {
    if (_instance == null) {
      MapperContainer.globals.use(_instance = UserEntityMapper._());
      OnboardingStepMapper.ensureInitialized();
      PermissionPromptStateEntityMapper.ensureInitialized();
    }
    return _instance!;
  }

  @override
  final String id = 'UserEntity';

  static String? _$id(UserEntity v) => v.id;
  static const Field<UserEntity, String> _f$id = Field('id', _$id, opt: true);
  static String _$email(UserEntity v) => v.email;
  static const Field<UserEntity, String> _f$email = Field('email', _$email);
  static String _$phoneNumber(UserEntity v) => v.phoneNumber;
  static const Field<UserEntity, String> _f$phoneNumber = Field(
    'phoneNumber',
    _$phoneNumber,
  );
  static String _$fullName(UserEntity v) => v.fullName;
  static const Field<UserEntity, String> _f$fullName = Field(
    'fullName',
    _$fullName,
  );
  static OnboardingStep _$onboardingStep(UserEntity v) => v.onboardingStep;
  static const Field<UserEntity, OnboardingStep> _f$onboardingStep = Field(
    'onboardingStep',
    _$onboardingStep,
  );
  static PermissionPromptStateEntity _$permissionPrompts(UserEntity v) =>
      v.permissionPrompts;
  static const Field<UserEntity, PermissionPromptStateEntity>
  _f$permissionPrompts = Field(
    'permissionPrompts',
    _$permissionPrompts,
    opt: true,
    def: const PermissionPromptStateEntity(),
  );
  static DateTime _$createdAt(UserEntity v) => v.createdAt;
  static const Field<UserEntity, DateTime> _f$createdAt = Field(
    'createdAt',
    _$createdAt,
  );
  static DateTime _$updatedAt(UserEntity v) => v.updatedAt;
  static const Field<UserEntity, DateTime> _f$updatedAt = Field(
    'updatedAt',
    _$updatedAt,
  );
  static String? _$cpf(UserEntity v) => v.cpf;
  static const Field<UserEntity, String> _f$cpf = Field(
    'cpf',
    _$cpf,
    opt: true,
  );

  @override
  final MappableFields<UserEntity> fields = const {
    #id: _f$id,
    #email: _f$email,
    #phoneNumber: _f$phoneNumber,
    #fullName: _f$fullName,
    #onboardingStep: _f$onboardingStep,
    #permissionPrompts: _f$permissionPrompts,
    #createdAt: _f$createdAt,
    #updatedAt: _f$updatedAt,
    #cpf: _f$cpf,
  };

  static UserEntity _instantiate(DecodingData data) {
    return UserEntity(
      id: data.dec(_f$id),
      email: data.dec(_f$email),
      phoneNumber: data.dec(_f$phoneNumber),
      fullName: data.dec(_f$fullName),
      onboardingStep: data.dec(_f$onboardingStep),
      permissionPrompts: data.dec(_f$permissionPrompts),
      createdAt: data.dec(_f$createdAt),
      updatedAt: data.dec(_f$updatedAt),
      cpf: data.dec(_f$cpf),
    );
  }

  @override
  final Function instantiate = _instantiate;

  static UserEntity fromMap(Map<String, dynamic> map) {
    return ensureInitialized().decodeMap<UserEntity>(map);
  }

  static UserEntity fromJson(String json) {
    return ensureInitialized().decodeJson<UserEntity>(json);
  }
}

mixin UserEntityMappable {
  String toJson() {
    return UserEntityMapper.ensureInitialized().encodeJson<UserEntity>(
      this as UserEntity,
    );
  }

  Map<String, dynamic> toMap() {
    return UserEntityMapper.ensureInitialized().encodeMap<UserEntity>(
      this as UserEntity,
    );
  }

  UserEntityCopyWith<UserEntity, UserEntity, UserEntity> get copyWith =>
      _UserEntityCopyWithImpl<UserEntity, UserEntity>(
        this as UserEntity,
        $identity,
        $identity,
      );
  @override
  String toString() {
    return UserEntityMapper.ensureInitialized().stringifyValue(
      this as UserEntity,
    );
  }

  @override
  bool operator ==(Object other) {
    return UserEntityMapper.ensureInitialized().equalsValue(
      this as UserEntity,
      other,
    );
  }

  @override
  int get hashCode {
    return UserEntityMapper.ensureInitialized().hashValue(this as UserEntity);
  }
}

extension UserEntityValueCopy<$R, $Out>
    on ObjectCopyWith<$R, UserEntity, $Out> {
  UserEntityCopyWith<$R, UserEntity, $Out> get $asUserEntity =>
      $base.as((v, t, t2) => _UserEntityCopyWithImpl<$R, $Out>(v, t, t2));
}

abstract class UserEntityCopyWith<$R, $In extends UserEntity, $Out>
    implements ClassCopyWith<$R, $In, $Out> {
  PermissionPromptStateEntityCopyWith<
    $R,
    PermissionPromptStateEntity,
    PermissionPromptStateEntity
  >
  get permissionPrompts;
  $R call({
    String? id,
    String? email,
    String? phoneNumber,
    String? fullName,
    OnboardingStep? onboardingStep,
    PermissionPromptStateEntity? permissionPrompts,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? cpf,
  });
  UserEntityCopyWith<$R2, $In, $Out2> $chain<$R2, $Out2>(Then<$Out2, $R2> t);
}

class _UserEntityCopyWithImpl<$R, $Out>
    extends ClassCopyWithBase<$R, UserEntity, $Out>
    implements UserEntityCopyWith<$R, UserEntity, $Out> {
  _UserEntityCopyWithImpl(super.value, super.then, super.then2);

  @override
  late final ClassMapperBase<UserEntity> $mapper =
      UserEntityMapper.ensureInitialized();
  @override
  PermissionPromptStateEntityCopyWith<
    $R,
    PermissionPromptStateEntity,
    PermissionPromptStateEntity
  >
  get permissionPrompts => $value.permissionPrompts.copyWith.$chain(
    (v) => call(permissionPrompts: v),
  );
  @override
  $R call({
    Object? id = $none,
    String? email,
    String? phoneNumber,
    String? fullName,
    OnboardingStep? onboardingStep,
    PermissionPromptStateEntity? permissionPrompts,
    DateTime? createdAt,
    DateTime? updatedAt,
    Object? cpf = $none,
  }) => $apply(
    FieldCopyWithData({
      if (id != $none) #id: id,
      if (email != null) #email: email,
      if (phoneNumber != null) #phoneNumber: phoneNumber,
      if (fullName != null) #fullName: fullName,
      if (onboardingStep != null) #onboardingStep: onboardingStep,
      if (permissionPrompts != null) #permissionPrompts: permissionPrompts,
      if (createdAt != null) #createdAt: createdAt,
      if (updatedAt != null) #updatedAt: updatedAt,
      if (cpf != $none) #cpf: cpf,
    }),
  );
  @override
  UserEntity $make(CopyWithData data) => UserEntity(
    id: data.get(#id, or: $value.id),
    email: data.get(#email, or: $value.email),
    phoneNumber: data.get(#phoneNumber, or: $value.phoneNumber),
    fullName: data.get(#fullName, or: $value.fullName),
    onboardingStep: data.get(#onboardingStep, or: $value.onboardingStep),
    permissionPrompts: data.get(
      #permissionPrompts,
      or: $value.permissionPrompts,
    ),
    createdAt: data.get(#createdAt, or: $value.createdAt),
    updatedAt: data.get(#updatedAt, or: $value.updatedAt),
    cpf: data.get(#cpf, or: $value.cpf),
  );

  @override
  UserEntityCopyWith<$R2, UserEntity, $Out2> $chain<$R2, $Out2>(
    Then<$Out2, $R2> t,
  ) => _UserEntityCopyWithImpl<$R2, $Out2>($value, $cast, t);
}

