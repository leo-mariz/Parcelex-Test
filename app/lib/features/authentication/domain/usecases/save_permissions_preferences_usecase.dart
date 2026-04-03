import 'package:app/core/errors/failures.dart';
import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:app/features/users/domain/usecases/update_user_permissions_usecase.dart';
import 'package:fpdart/fpdart.dart';

/// Delega para [UpdateUserPermissionsUseCase] (mantido no [AuthBloc] por compatibilidade).
class SavePermissionsPreferencesUseCase {
  SavePermissionsPreferencesUseCase({
    required UpdateUserPermissionsUseCase updateUserPermissionsUseCase,
  }) : _updateUserPermissionsUseCase = updateUserPermissionsUseCase;

  final UpdateUserPermissionsUseCase _updateUserPermissionsUseCase;

  Future<Either<Failure, UserEntity>> call(PermissionsDto dto) =>
      _updateUserPermissionsUseCase.call(dto);
}
