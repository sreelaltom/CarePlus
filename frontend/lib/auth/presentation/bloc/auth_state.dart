abstract class AuthState {}

class AuthInitial extends AuthState {}

class AuthSuccess extends AuthState {}

class AuthProcessing extends AuthState {}

class AuthFailure extends AuthState {}

class UserAuthState extends AuthState {}

class DoctorAuthState extends AuthState {}