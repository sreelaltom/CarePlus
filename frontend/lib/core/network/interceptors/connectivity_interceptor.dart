import 'package:dio/dio.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/network/cubit/connectivity_cubit.dart';
import 'package:frontend/service_locator.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class ConnectivityInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    try {
      final internetConnectionStatus =
          serviceLocator<ConnectivityCubit>().state.internetStatus;
      if (internetConnectionStatus == InternetStatus.connected) {
        handler.next(options);
      } else {
        handler.reject(
          DioException(
            requestOptions: options,
            type: DioExceptionType.connectionError,
            response: Response(
              requestOptions: options,
              statusCode : Network.noInternet.errorCode,
              statusMessage: "No Internet connection!",
            ),
          ),
        );
      }
    } catch (e) {
      handler.reject(
        DioException(
          requestOptions: options,
          response: Response(
            requestOptions: options,
            statusCode : Internal.interceptorError.errorCode,
            statusMessage: "Error in connectivity interceptor",
          ),
        ),
      );
    }
    // super.onRequest(options, handler);
  }
}
