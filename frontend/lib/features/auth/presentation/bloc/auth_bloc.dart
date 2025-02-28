import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/routes/route_constants.dart';
import 'package:frontend/features/auth/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/auth/domain/use_cases/register_use_case.dart';
import 'package:frontend/features/auth/domain/user_entity.dart';
import 'package:frontend/core/config/session_manager.dart';
import 'package:frontend/core/config/storage_manager.dart';
import 'package:frontend/service_locator.dart';
import 'package:go_router/go_router.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SelectDoctorAuthEvent>(_switchToDoctorAuth);
    on<SelectUserAuthEvent>(_switchToUserAuth);
    on<LoginEvent>(_loginUser);
    on<RegisterEvent>(_registerUser);
    on<SessionExpiredEvent>(_terminateSession);
    on<LogoutEvent>(_logoutUser);
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
      (user) async {
        if (SessionManager().hasSession.value) {
          if (!emit.isDone) {
            emit(AuthSuccess(user: user, type: AuthSuccessType.login));
          }
          await Dependencies.disposeAuth();
          SessionManager().addSessionListener(() {
            if (!SessionManager().hasSession.value) {
              add(SessionExpiredEvent());
            }
          });
        } else {
          emit(
            AuthFailure(error: 'An unexpected error occurred. Try again later'),
          );
        }
      },
    );
  }

  void _terminateSession(
    SessionExpiredEvent event,
    Emitter<AuthState> emit,
  ) async {
    await Dependencies.initAuth();
    emit(AuthFailure(type: AuthFailureType.sessionExpired));
  }

  void _logoutUser(
    LogoutEvent event,
    Emitter<AuthState> emit,
  ) async {
    await SessionManager().clearSession(isLogout: true);
    if (event.context.mounted) {
      event.context.goNamed(RouteNames.login);
    }
    await Dependencies.initAuth();

    emit(AuthFailure(type: AuthFailureType.logout));
    emit(UserAuthState());
    // await Future.delayed(const Duration(milliseconds: 500), () => !emit.isDone ? emit(UserAuthState()) : null);
  }
}
