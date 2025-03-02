import 'package:dartz/dartz.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/domain/user_entity.dart';
import 'package:frontend/service_locator.dart';

class LoginUseCase {
  Future<Either<String, UserEntity>> call({
    String? email,
    String? registrationID,
    required String password,
  }) async {
    return await serviceLocator<AuthRepository>().login(
      email: email,
      registrationID: registrationID,
      password: password,
    );
  }
}
