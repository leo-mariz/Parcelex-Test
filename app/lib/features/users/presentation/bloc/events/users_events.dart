import 'package:app/features/permissions/data/dtos/permissions_dto.dart';
import 'package:equatable/equatable.dart';

/// Eventos do [UsersBloc] (por caso de uso).
sealed class UsersEvent extends Equatable {
  const UsersEvent();

  @override
  List<Object?> get props => [];
}

// —— UpdateUserPermissionsUseCase ——

final class UpdateUserPermissionsSubmitted extends UsersEvent {
  const UpdateUserPermissionsSubmitted(this.dto);

  final PermissionsDto dto;

  @override
  List<Object?> get props => [dto.notification, dto.location, dto.biometric];
}

final class UpdateUserPermissionsReset extends UsersEvent {
  const UpdateUserPermissionsReset();
}
