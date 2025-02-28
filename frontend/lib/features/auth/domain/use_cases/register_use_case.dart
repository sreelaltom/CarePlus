import 'package:dartz/dartz.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/domain/user_entity.dart';
import 'package:frontend/service_locator.dart';

class RegisterUseCase {
  Future<Either<String,UserEntity>> call({
    String? email,
    String? registrationId,
    required String name,
    required bool isPatient,
    required bool isDoctor,
    required String phone,
    required String password,
  }) async {
    return await serviceLocator<AuthRepository>().register(
      email: email,
      registrationId: registrationId,
      username: name,
      password: password,
      phone: phone,
      isPatient: isPatient,
      isDoctor: isDoctor,
    );
  }
}
