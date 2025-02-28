import 'package:dartz/dartz.dart';
import 'package:frontend/features/auth/domain/user_entity.dart';

abstract interface class AuthRepository {
  Future<Either<String, UserEntity>> register({
    String? email,
    String? registrationId,
    required String username,
    required String password,
    required String phone,
    required bool isPatient,
    required bool isDoctor,
  });

  Future<Either<String,UserEntity>> login({

    String? email,
    String? registrationID,
    required String password,
  });
}
