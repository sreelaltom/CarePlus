import 'package:dartz/dartz.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/domain/entities/session.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/service_locator.dart';

class LoginUseCase {
  Future<Either<String, (User, Session)>> call({
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
