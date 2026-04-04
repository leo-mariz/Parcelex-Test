import 'package:app/features/users/domain/usecases/update_user_permissions_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/users_events.dart';
import 'states/users_states.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({
    required UpdateUserPermissionsUseCase updateUserPermissionsUseCase,
  })  : 
        _updateUserPermissionsUseCase = updateUserPermissionsUseCase,
        super(const UsersInitial()) {
    on<UpdateUserPermissionsSubmitted>(_onUpdateUserPermissionsSubmitted);
    on<UpdateUserPermissionsReset>(_onUpdateUserPermissionsReset);
  }

  final UpdateUserPermissionsUseCase _updateUserPermissionsUseCase;

  Future<void> _onUpdateUserPermissionsSubmitted(
    UpdateUserPermissionsSubmitted event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UpdateUserPermissionsLoading());

    final result = await _updateUserPermissionsUseCase.call(event.dto);

    result.fold(
      (failure) => emit(UpdateUserPermissionsError(failure)),
      (user) => emit(UpdateUserPermissionsSuccess(user)),
    );
  }

  void _onUpdateUserPermissionsReset(
    UpdateUserPermissionsReset event,
    Emitter<UsersState> emit,
  ) {
    emit(const UsersInitial());
  }
}
