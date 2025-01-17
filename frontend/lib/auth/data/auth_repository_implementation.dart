import 'package:dartz/dartz.dart';
import 'package:frontend/auth/domain/auth_repository.dart';

class AuthRepositoryImplementation extends AuthRepository {
  @override
  Future<Either<String, dynamic>> doctorLogin(
      {required String regId, required String password}) {
    // todo: implement doctorLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<String, dynamic>> doctorSignup({
    required String regId,
    required String phone,
    required String fullname,
    required String password,
  }) {
    // todo: implement doctorSignup
    throw UnimplementedError();
  }

  @override
  Future<Either<String, dynamic>> userLogin({
    required String email,
    required String password,
  }) {
    // todo: implement userLogin
    throw UnimplementedError();
  }

  @override
  Future<Either<String, dynamic>> userSignup({
    required String email,
    required String phone,
    required String fullname,
    required String password,
  }) {
    // todo: implement userSignup
    throw UnimplementedError();
  }
}
