import 'package:app/features/users/domain/usecases/update_user_onboarding_step_usecase.dart';
import 'package:app/features/users/domain/usecases/update_user_permissions_usecase.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'events/users_events.dart';
import 'states/users_states.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc({
    required UpdateUserOnboardingStepUseCase updateUserOnboardingStepUseCase,
    required UpdateUserPermissionsUseCase updateUserPermissionsUseCase,
  })  : _updateUserOnboardingStepUseCase = updateUserOnboardingStepUseCase,
        _updateUserPermissionsUseCase = updateUserPermissionsUseCase,
        super(const UsersInitial()) {
    on<UpdateUserOnboardingStepSubmitted>(_onUpdateUserOnboardingStepSubmitted);
    on<UpdateUserOnboardingStepReset>(_onUpdateUserOnboardingStepReset);
    on<UpdateUserPermissionsSubmitted>(_onUpdateUserPermissionsSubmitted);
    on<UpdateUserPermissionsReset>(_onUpdateUserPermissionsReset);
  }

  final UpdateUserOnboardingStepUseCase _updateUserOnboardingStepUseCase;
  final UpdateUserPermissionsUseCase _updateUserPermissionsUseCase;

  Future<void> _onUpdateUserOnboardingStepSubmitted(
    UpdateUserOnboardingStepSubmitted event,
    Emitter<UsersState> emit,
  ) async {
    emit(const UpdateUserOnboardingStepLoading());

    final result = await _updateUserOnboardingStepUseCase.call(
      event.userId,
      event.onboardingStep,
    );

    result.fold(
      (failure) => emit(UpdateUserOnboardingStepError(failure)),
      (user) => emit(UpdateUserOnboardingStepSuccess(user)),
    );
  }

  void _onUpdateUserOnboardingStepReset(
    UpdateUserOnboardingStepReset event,
    Emitter<UsersState> emit,
  ) {
    emit(const UsersInitial());
  }

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
