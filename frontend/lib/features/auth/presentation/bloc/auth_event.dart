part of 'auth_bloc.dart';

abstract class AuthEvent {}

class SelectUserAuthEvent extends AuthEvent {}

class SelectDoctorAuthEvent extends AuthEvent {}

class LoginEvent extends AuthEvent {
  final bool isPatient;
  final bool isDoctor;
  final String? email;
  final String? registrationId;
  final String password;

  LoginEvent({
    required this.isPatient,
    required this.isDoctor,
    required this.email,
    required this.registrationId,
    required this.password,
  });
}

class RegisterEvent extends AuthEvent {
  final String name;
  final bool isPatient;
  final bool isDoctor;
  final String? email;
  final String? registrationId;
  final String password;
  final String phone;

  RegisterEvent({
    required this.name,
    required this.isPatient,
    required this.isDoctor,
    this.email,
    this.registrationId,
    required this.password,
    required this.phone,
  });
}

class LogoutEvent extends AuthEvent {
  final BuildContext context;

  LogoutEvent({required this.context});
}

class SessionExpiredEvent extends AuthEvent {}
