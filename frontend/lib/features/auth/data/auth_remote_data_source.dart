import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:frontend/features/auth/data/models/session_model.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
import 'package:frontend/core/config/storage_manager.dart';
import 'package:frontend/core/network/api_urls.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'dart:developer' as developer;

import 'package:frontend/service_locator.dart';

abstract interface class AuthRemoteDataSource {
  Future<Either<String, UserModel>> register({
    String? email,
    String? registrationId,
    required String username,
    required String password,
    required String phone,
    required bool isPatient,
    required bool isDoctor,
  });

  Future<Either<String, (UserModel, SessionModel)>> login({
    String? email,
    String? registrationID,
    required String password,
  });

  Future<void> refreshToken();
}

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  @override
  Future<Either<String, UserModel>> register({
    String? email,
    String? registrationId,
    required String username,
    required String password,
    required String phone,
    required bool isPatient,
    required bool isDoctor,
  }) async {
    try {
      final client = DioClient();
      final response = await client.post(
        ApiUrls.register,
        data: {
          'email': email,
          'registration_id': registrationId,
          'username': username,
          'password': password,
          'phone_number': phone,
          'is_doctor': isDoctor,
          'is_patient': isPatient
        },
      );
      final body = response.data as Map<String, dynamic>;

      switch (response.statusCode) {
        case 201:
          return Right(UserModel.fromMap(body));
        case 409:
          return Left(body['error'] as String);
        default:
          developer.log("UNHANDLED STATUS CODE: ${response.statusCode}");
          return Left("Unhandled status code found");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 409) {
        // developer.log(e.response?.data);
        return Left((e.response?.data as Map<String, dynamic>)["error"] ??
            "Credentials already existsssssss.");
      }
      return Left(e.toString());
    }
  }

  @override
  Future<Either<String, (UserModel, SessionModel)>> login({
    String? email,
    String? registrationID,
    required String password,
  }) async {
    try {
      final client = DioClient();
      final response = await client.post(
        ApiUrls.login,
        data: {
          "email": email,
          "registration_id": registrationID,
          "password": password,
        },
      );
      final body = response.data as Map<String, dynamic>;
      switch (response.statusCode) {
        case 200:
          // await SessionManager().createSession(
          //   userID: (body['uid'] as int).toString(),
          //   accessToken: body['access'],
          //   refreshToken: body['refresh'],
          // );
          return Right((
            UserModel.fromMap(body),
            SessionModel.fromMap(body),
          ));
        case 404:
          return Left("User not found");
        default:
          developer.log("UNHANDLED STATUS CODE: ${response.statusCode}");
          return Left("Unhandled status code found");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 404) {
        return Left("Invalid Credentials");
      }
      return Left(e.toString());
    }
  }

  @override
  Future<void> refreshToken() async {
    try {
      final client = DioClient();
      final response = await client.post(ApiUrls.refreshToken);
      final body = response.data as Map<String, dynamic>;
      switch (response.statusCode) {
        case 200:
          final accessToken = body['access_token'];
          final storage = SecureStorageManager();
          await storage.store(key: StorageKeys.accessToken, value: accessToken);
        default:
          developer.log("UNHANDLED STATUS CODE: ${response.statusCode}");
      }
    } on DioException catch (e) {
      if (e.response?.statusCode == 403) {
        serviceLocator<SessionCubit>().terminateSession();
      }
    } catch (e) {
      developer.log("UNHANDLED EXCEPTION WHILE TOKEN REFRESH");
      developer.log(e.toString());
    }
  }
}
