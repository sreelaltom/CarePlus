part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {}

class SelectUserAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

class SelectDoctorAuthEvent extends AuthEvent {
  @override
  List<Object?> get props => [];
}

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
  
  @override
  List<Object?> get props => [isPatient, isDoctor, email, registrationId, password];
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
  
  @override
  List<Object?> get props => [name, isPatient, isDoctor, email, registrationId, password, phone];
}

class LogoutEvent extends AuthEvent {
  final BuildContext context;

  LogoutEvent({required this.context});
  
  @override
  List<Object?> get props => [context];
}


