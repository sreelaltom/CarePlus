import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/auth/data/auth_remote_data_source.dart';
// import 'package:frontend/auth/data/user_model.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/domain/entities/session.dart';
import 'package:frontend/features/auth/domain/entities/user.dart';
import 'package:frontend/service_locator.dart';

class AuthRepositoryImplementation implements AuthRepository {
  @override
  Future<Either<Failure, User>> register({
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
      return Right(response);
    } on AppException catch (e) {
      return Left(Failure.from(e));
    }
  }

  @override
  Future<Either<Failure, (User, Session)>> login({
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
      return Right(response);
    } on AppException catch (e) {
      return Left(Failure.from(e));
    }
  }
}
