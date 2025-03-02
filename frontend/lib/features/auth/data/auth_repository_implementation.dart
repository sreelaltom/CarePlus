import 'package:dartz/dartz.dart';
import 'package:frontend/features/auth/data/auth_remote_data_source.dart';
// import 'package:frontend/auth/data/user_model.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/domain/user_entity.dart';
import 'package:frontend/service_locator.dart';

class AuthRepositoryImplementation implements AuthRepository {
  @override
  Future<Either<String, UserEntity>> register({
    String? email,
    String? registrationId,
    required String username,
    required String password,
    required String phone,
    required bool isPatient,
    required bool isDoctor,
  }) async {
    try {
      final response = await serviceLocator<AuthRemoteDataSource>().register(
        email: email,
        registrationId: registrationId,
        username: username,
        password: password,
        phone: phone,
        isPatient: isPatient,
        isDoctor: isDoctor,
      );
      return response.fold(
        (error) => Left(error),
        (user) => Right(user),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, UserEntity>> login({
    String? email,
    String? registrationID,
    required String password,
  }) async {
    try {
      final response = await serviceLocator<AuthRemoteDataSource>().login(
        email: email,
        registrationID: registrationID,
        password: password,
      );
      return response.fold(
        (error) => Left(error),
        (user) => Right(user),
      );
    } catch (e) {
      return Left(e.toString());
    }
  }
}
