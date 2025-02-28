import 'package:dio/dio.dart';
import 'package:frontend/core/common/app_extensions.dart';
import 'package:frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:frontend/core/config/session_manager.dart';
import 'package:frontend/core/config/storage_manager.dart';
import 'package:frontend/core/network/api_urls.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/service_locator.dart';
import 'package:logger/logger.dart';

class LoggerInterceptor extends Interceptor {
  Logger logger = Logger(printer: PrettyPrinter(methodCount: 0));

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // super.onError(err, handler);
    final options = err.requestOptions;
    final requestPath = '${options.baseUrl}${options.path}';
    logger.e('${options.method} request ==> $requestPath');
    logger.d('Error type: ${err.error} \n Error message: ${err.message}');
    handler.next(err);
  }

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // super.onRequest(options, handler);
    final requestPath = '${options.baseUrl}${options.path}';
    logger.i('${options.method} request ==> $requestPath');
    logger.d(
      'HEADERS: ${options.headers}\n'
      '''
        DATA: {
          email: ${options.data['email']},
          registration_id: ${options.data['registration_id']},
          username: ${options.data['username']},
          password: ${options.data['password']},
          phone_number: ${options.data['phone_number']},
          is_doctor: ${options.data['is_doctor']},
          is_patient: ${options.data['is_patient']},
        }
      ''',
    );
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    // super.onResponse(response, handler);
    logger.d(
      'STATUS CODE: ${response.statusCode}\n'
      'STATUS MESSAGE: ${response.statusMessage}\n'
      'HEADERS: ${response.headers}\n'
      'DATA: ${response.data}',
    );
    handler.next(response);
  }
}

class AuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (SessionManager().hasSession.value) {
        final storage = SecureStorageManager();
        final token = await storage.retrieve(
          key: options.path != ApiUrls.refreshToken
              ? StorageKeys.accessToken
              : StorageKeys.refreshToken,
        );
        options.headers['Authorization'] = "Bearer ${options.path != token}";
      }
      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          response: Response(
            requestOptions: options,
            data: {"error": "error in authorization interceptor"},
            statusCode: 400,
          ),
        ),
      );
    }
    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (response.statusCode == 409) {
      final interceptedData = {
        if ((response.data as Map<String, dynamic>).keys.length == 1)
          "error":
              "${(response.data as Map<String, dynamic>).keys.first.replaceAll("_", " ").capitalize} already exists."
        else
          "error": "Credentials already exists."
      };
      response.data = interceptedData;
    }
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final client = DioClient();
      RequestOptions requestOptions = err.requestOptions;

      if (requestOptions.path != ApiUrls.refreshToken) {
        await serviceLocator<AuthRemoteDataSource>().refreshToken();
        final response = await client.request(
          requestOptions.path,
          cancelToken: requestOptions.cancelToken,
          data: requestOptions.data,
          queryParameters: requestOptions.queryParameters,
          onReceiveProgress: requestOptions.onReceiveProgress,
          onSendProgress: requestOptions.onSendProgress,
        );
        handler.resolve(response);
      }  else {
        handler.reject(
          DioException(
            requestOptions: requestOptions,
            response: Response(
              requestOptions: requestOptions,
              statusCode: 403,
              data: {"error": "Refresh token revoked"},
            ),
          ),
        );
      }
    }else if (err.response?.statusCode == 409) {
        final interceptedData = {
          if ((err.response?.data as Map<String, dynamic>).keys.length == 1)
            "error":
                "${(err.response?.data as Map<String, dynamic>).keys.first.replaceAll("_", " ").capitalize} already exists."
          else
            "error": "Credentials already exists."
        };
        err.response?.data = interceptedData;
      }
    handler.next(err);
  }
}
