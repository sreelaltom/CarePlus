import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/features/auth/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/auth/domain/use_cases/register_use_case.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/features/auth/domain/entities/session.dart';
import 'package:frontend/service_locator.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SelectDoctorAuthEvent>(_switchToDoctorAuth);
    on<SelectUserAuthEvent>(_switchToUserAuth);
    on<LoginEvent>(_loginUser);
    on<RegisterEvent>(_registerUser);
    // on<SessionExpiredEvent>(_terminateSession);
    // on<LogoutEvent>(_logoutUser);
  }

  void _switchToDoctorAuth(
    SelectDoctorAuthEvent event,
    Emitter<AuthState> emit,
  ) =>
      emit(DoctorAuthState());
  void _switchToUserAuth(
    SelectUserAuthEvent event,
    Emitter<AuthState> emit,
  ) =>
      emit(UserAuthState());

  Future<void> _registerUser(
    RegisterEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthProcessing());
    final response = await serviceLocator<RegisterUseCase>().call(
      email: event.email,
      registrationId: event.registrationId,
      name: event.name,
      isPatient: event.isPatient,
      isDoctor: event.isDoctor,
      phone: event.phone,
      password: event.password,
    );
    response.fold(
      (error) => emit(AuthFailure(error: error)),
      (user) => emit(AuthSuccess(user: user)),
    );
  }

  Future<void> _loginUser(
    LoginEvent event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthProcessing());
    final response = await serviceLocator<LoginUseCase>().call(
      email: event.email,
      registrationID: event.registrationId,
      password: event.password,
    );
    response.fold(
      (error) async => emit(AuthFailure(error: error)),
      (userAndSession) async {
        emit(
          AuthSuccess(
            user: userAndSession.$1,
            session: userAndSession.$2,
            type: AuthSuccessType.login,
          ),
        );
        await Dependencies.disposeAuth();
      },
    );
  }

  // void _terminateSession(
  //   SessionExpiredEvent event,
  //   Emitter<AuthState> emit,
  // ) async {
  //   await Dependencies.initAuth();
  //   emit(AuthFailure(type: AuthFailureType.sessionExpired));
  // }

  
}
