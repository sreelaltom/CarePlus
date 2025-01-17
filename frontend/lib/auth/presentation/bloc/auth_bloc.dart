import 'package:bloc/bloc.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/auth/presentation/bloc/auth_event.dart';
import 'package:frontend/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  AuthBloc() : super(AuthInitial()) {
    on<SelectDoctorAuthEvent>(_switchToDoctorAuth);
    on<SelectUserAuthEvent>(_switchToUserAuth);
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
}
