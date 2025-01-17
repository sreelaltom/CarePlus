abstract class SignupUseCase {
  final String fullName;
  final String phone;
  final String password;

  SignupUseCase({
    required this.fullName,
    required this.phone,
    required this.password,
  });
}

class DoctorSignupUseCase extends SignupUseCase {
  final String registrationID;

  DoctorSignupUseCase({
    required this.registrationID,
    required super.fullName,
    required super.phone,
    required super.password,
  });

  
}

class UserSignupUseCase extends SignupUseCase {
  final String email;

  UserSignupUseCase({
    required this.email,
    required super.fullName,
    required super.phone,
    required super.password,
  });
}
