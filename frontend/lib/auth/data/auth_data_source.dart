import 'package:dartz/dartz.dart';


abstract class AuthDataSource {
  Future<Either<String, dynamic>> userLogin({
    required String email,
    required String password,
  });
  Future<Either<String, dynamic>> doctorLogin({
    required String regId,
    required String password,
  });

  Future<Either<String, dynamic>> userSignup({
    required String email,
    required String phone,
    required String fullName,
    required String password,
  });
  Future<Either<String, dynamic>> doctorSignup({
    required String regId,
    required String phone,
    required String fullName,
    required String password,
  });
}

class AuthRemoteDataSource extends AuthDataSource {
  @override
  Future<Either<String, dynamic>> doctorLogin({
    required String regId,
    required String password,
  }) async {
    //todo: implement doctorSignup
    throw UnimplementedError();
  }

  @override
  Future<Either<String, dynamic>> doctorSignup({
    required String regId,
    required String phone,
    required String fullName,
    required String password,
  }) {
    //todo: implement doctorSignup
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
    required String fullName,
    required String password,
  }) {
    // todo: implement userSignup
    throw UnimplementedError();
  }
}
