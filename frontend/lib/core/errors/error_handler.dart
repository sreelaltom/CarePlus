

import 'package:dio/dio.dart';
import 'package:frontend/core/errors/exceptions.dart';

abstract class ErrorHandler {

  static AppException serverOrNetworkException(Exception e) {
    
    if (e is DioException) {
      ExceptionType? error = Server.hasError(e.response?.statusCode);
      if (error != null) {
        return AppException<Server>(type: error as Server);
      }
      error = Network.hasError(e.response?.statusCode);
      if (error != null) {
        return AppException<Network>(type: error as Network);
      }
      return AppException<Network>(type: Network.unknown);
    }
    return AppException<Server>(type: Server.unknown);
  }

  static AppException<Storage> storageException(Exception e) {
    //TODO: after implementing hive
    return AppException(type: Storage.unknown);
  }
}
