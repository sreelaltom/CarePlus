abstract class LoginUseCase {
  final String password;

  LoginUseCase({required this.password});
}

class DoctorLoginUseCase extends LoginUseCase {
  final String registrationID;
  DoctorLoginUseCase({
    required this.registrationID,
    required super.password,
  });
}

class UserLoginUseCase extends LoginUseCase {
  final String email;
  UserLoginUseCase({
    required this.email,
    required super.password,
  });
}
