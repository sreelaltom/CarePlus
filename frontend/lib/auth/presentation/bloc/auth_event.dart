abstract class AuthEvent {}

class LoginEvent extends AuthEvent {
  final String password;

  LoginEvent({required this.password});
}

class UserLoginEvent extends LoginEvent {
  final String email;

  UserLoginEvent({
    required this.email,
    required super.password,
  });
}

class DoctorLoginEvent extends LoginEvent {
  final String regId;

  DoctorLoginEvent({
    required this.regId,
    required super.password,
  });
}

class SignupEvent extends AuthEvent {
  final String phone;
  final String fullname;
  final String password;

  SignupEvent({
    required this.phone,
    required this.fullname,
    required this.password,
  });
}

class UserSignupEvent extends SignupEvent {
  final String email;

  UserSignupEvent({
    required this.email,
    required super.phone,
    required super.fullname,
    required super.password,
  });
}

class DoctorSignupEvent extends SignupEvent {
  final String regId;

  DoctorSignupEvent({
    required this.regId,
    required super.phone,
    required super.fullname,
    required super.password,
  });
}

class SelectUserAuthEvent extends AuthEvent {}

class SelectDoctorAuthEvent extends AuthEvent {}
