import 'package:app/core/errors/failures.dart';
import 'package:app/features/users/domain/entities/user_entity.dart';
import 'package:equatable/equatable.dart';

/// Estados do [UsersBloc] (por caso de uso).
sealed class UsersState extends Equatable {
  const UsersState();

  @override
  List<Object?> get props => [];
}

/// Estado ocioso (nenhuma operação em andamento).
final class UsersInitial extends UsersState {
  const UsersInitial();
}

// —— UpdateUserPermissionsUseCase ——

final class UpdateUserPermissionsLoading extends UsersState {
  const UpdateUserPermissionsLoading();
}

final class UpdateUserPermissionsSuccess extends UsersState {
  const UpdateUserPermissionsSuccess(this.user);

  final UserEntity user;

  @override
  List<Object?> get props => [user];
}

final class UpdateUserPermissionsError extends UsersState {
  const UpdateUserPermissionsError(this.failure);

  final Failure failure;

  @override
  List<Object?> get props => [failure];
}
