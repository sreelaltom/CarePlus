import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<String, dynamic>> userLogin({
    required String email,
    required String password,
  });
  Future<Either<String, dynamic>> doctorLogin({
    required String regId,
    required String password,
  });
  Future<Either<String, dynamic>> doctorSignup({
    required String regId,
    required String phone,
    required String fullname,
    required String password,
  });
  Future<Either<String, dynamic>> userSignup({
    required String email,
    required String phone,
    required String fullname,
    required String password,
  });
}
