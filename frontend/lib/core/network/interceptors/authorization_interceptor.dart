import 'package:dio/dio.dart';
import 'package:frontend/core/common/app_extensions.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:frontend/features/auth/domain/entities/session.dart';
import 'package:frontend/core/network/api_urls.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:frontend/service_locator.dart';



class AuthorizationInterceptor extends Interceptor {
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    try {
      if (serviceLocator.isRegistered<Session>() &&
          options.path != ApiUrls.refreshToken) {
        final session = serviceLocator<Session>();
        options.headers['Authorization'] = "Bearer ${session.accessToken}";
      }
      handler.next(options);
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          type: DioExceptionType.unknown,
          response: Response(
            requestOptions: options,
            statusMessage:  "error in authorization interceptor",
            statusCode: Internal.interceptorError.errorCode,
          ),
        ),
      );
    }
    // super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode == 401) {
      final client = DioClient();
      RequestOptions requestOptions = err.requestOptions;

      if (requestOptions.path != ApiUrls.refreshToken) {
        //Check whether user is having a valid session
        if (serviceLocator.isRegistered<Session>()) {
          //retrieve the refresh token
          final refreshToken = serviceLocator<Session>().refreshToken;
          //obtain the new access token(if failed refreshedAccessToken will be null)
          final refreshedAccessToken =
              await serviceLocator<AuthRemoteDataSource>()
                  .refreshToken(token: refreshToken);
          //if we obtain a new access token
          if (refreshedAccessToken != null) {
            //update the accessToken of the current session
            serviceLocator<Session>().accessToken = refreshedAccessToken;
            //retry the request with new accessToken
            //the new accessToken would be added in the Authorization interceptor.
            final response = await client.request(
              requestOptions.path,
              cancelToken: requestOptions.cancelToken,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
              onReceiveProgress: requestOptions.onReceiveProgress,
              onSendProgress: requestOptions.onSendProgress,
            );
            //return the response.
            handler.resolve(response);
          } else {
            //if we do not obtain the new access Token user session is terminated
            serviceLocator<SessionCubit>().terminateSession();
            await _generateSessionExpiredResponse(
              err,
              handler,
              message: "Cannot obtain access token",
            );
          }
        }
      } else {
        await _generateSessionExpiredResponse(
          err,
          handler,
          message: "Refresh Token Revoked",
        );
      }
    } else if (err.response?.statusCode == 409) {
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

Future<void> _generateSessionExpiredResponse(
  DioException err,
  ErrorInterceptorHandler handler, {
  required String message,
}) async {
  await serviceLocator<SessionCubit>().terminateSession();
  handler.reject(
    DioException(
      requestOptions: err.requestOptions,
      response: Response(
        requestOptions: err.requestOptions,
        statusCode: 403,
        statusMessage: message,
      ),
    ),
  );
}
