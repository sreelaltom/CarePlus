import 'package:dio/dio.dart';
import 'package:frontend/core/errors/error_handler.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/features/auth/data/models/session_model.dart';
import 'package:frontend/features/auth/data/models/user_model.dart';
import 'package:frontend/core/network/api_urls.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'dart:developer' as developer;

abstract interface class AuthRemoteDataSource {
  Future<UserModel> register({
    String? email,
    String? registrationId,
    required String username,
    required String password,
    required String phone,
    required bool isPatient,
    required bool isDoctor,
  });

  Future<(UserModel, SessionModel)> login({
    String? email,
    String? registrationID,
    required String password,
  });

  Future<String?> refreshToken({required String token});
}

class AuthRemoteDataSourceImplementation implements AuthRemoteDataSource {
  @override
  Future<UserModel> register({
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
          return UserModel.fromMap(body);
        default:
          developer.log(
              "REGISTER_API : Unhandled status code(${response.statusCode})");
          throw AppException<Internal>(type: Internal.unknown);
      }
    } on Exception catch (e) {
      throw ErrorHandler.serverOrNetworkException(e);
    } catch (e) {
      throw AppException<Internal>(type: Internal.unknown);
    }
  }

  @override
  Future<(UserModel, SessionModel)> login({
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
          return (
            UserModel.fromMap(body),
            SessionModel.fromMap(body),
          );
        default:
          developer
              .log("LOGIN_API : Unhandled status code(${response.statusCode})");
          throw AppException<Internal>(type: Internal.unknown);
      }
    } on Exception catch (e) {
      throw ErrorHandler.serverOrNetworkException(e);
    } catch (e) {
      throw AppException<Internal>(type: Internal.unknown);
    }
  }

  @override
  Future<String?> refreshToken({required String token}) async {
    try {
      final client = DioClient();

      final response = await client.post(
        ApiUrls.refreshToken,
        data: {"refresh": token},
      );
      final body = response.data as Map<String, dynamic>;
      switch (response.statusCode) {
        case 200:
          final accessToken = body['access'];
          return accessToken;
        default:
          developer.log(
              "REFRESH_TOKEN_API : Unhandled status code(${response.statusCode})");
          return null;
      }
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionError) {
        developer.log("REFRESH TOKEN API: connection error occurred");
      } else {
        developer.log("REFRESH TOKEN API: $e");
      }
      return null;
    } catch (e) {
      developer.log("REFRESH TOKEN API: Unhandled exception caught");
      developer.log(e.toString());
      return null;
    }
  }
}
