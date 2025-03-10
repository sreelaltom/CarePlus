import 'dart:developer' as developer;

abstract interface class ExceptionType {
  final int errorCode = 520;
  final String name = "EXCEPTION_name";
}

mixin ExceptionMixin<T extends ExceptionType> on ExceptionType {
  T? hasError(List<T> values, int code) {
    if (values.map((e) => e.errorCode).contains(code)) {
      return values.firstWhere((e) => e.errorCode == code);
    }
    return null;
  }
}

enum Internal implements ExceptionType {
  //600 - 610
  formatError(600),
  rangeError(601),
  stateError(602),
  unknown(520),
  interceptorError(603);

  const Internal(this.errorCode);

  @override
  final int errorCode;

  @override
  final String name = "INTERNAL_EXCEPTION";
  static List<int> errorCodes =
      Internal.values.map((e) => e.errorCode).toList();

  static Internal hasError(int code) {
    if (errorCodes.contains(code)) {
      return Internal.values.firstWhere((e) => e.errorCode == code);
    }
    return Internal.unknown;
  }
}

enum Server implements ExceptionType {
  badRequest(400),
  unauthorized(401),
  forbidden(403),
  invalidCredentials(404),
  serverError(500),
  serviceUnavailable(503),
  unknown(520),
  accountLocked(423);

  const Server(this.errorCode);

  @override
  final String name = "SERVER_EXCEPTION";
  @override
  final int errorCode;

  static List<int> errorCodes = Server.values.map((e) => e.errorCode).toList();

  static Server? hasError(int? code) {
    if (errorCodes.contains(code)) {
      return Server.values.firstWhere((e) => e.errorCode == code);
    }
    return null;
  }
}

enum Network implements ExceptionType {
  //611 - 620
  noInternet(611),
  connectionTimeout(408),
  unknown(520);

  const Network(this.errorCode);

  @override
  final int errorCode;
  @override
  final String name = "NETWORK_EXCEPTION";
  static List<int> errorCodes = Network.values.map((e) => e.errorCode).toList();
  static Network? hasError(int? code) {
    if (code != null && errorCodes.contains(code)) {
      return Network.values.firstWhere((e) => e.errorCode == code);
    }
    return null;
  }
}

enum Storage implements ExceptionType {
  //621 - 630
  hiveInitialization(621),
  hiveNotFound(622),
  hiveAlreadyOpen(623),
  hiveCorrupt(624),
  hiveLockError(625),
  hiveAdapterError(626),

  secureStorage(627),
  fileSystem(628),
  permissionDenied(629),
  unknown(520);

  const Storage(this.errorCode);

  @override
  final int errorCode;
  @override
  final String name = "STORAGE_EXCEPTION";
  static List<int> errorCodes = Storage.values.map((e) => e.errorCode).toList();
  static Storage hasError(int code) {
    if (errorCodes.contains(code)) {
      return Storage.values.firstWhere((e) => e.errorCode == code);
    }
    return Storage.unknown;
  }
}

class AppException<T extends ExceptionType> implements Exception {
  final T type;

  const AppException({required this.type});

  @override
  String toString() {
    developer.log("APP EXCEPTION : ${type.name}_${type.errorCode}");
    return "APP EXCEPTION OCCURRED";
  }
}

// class InternalException extends AppException {
//   final InternalExceptionType type;

//   InternalException({this.type = InternalExceptionType.unknown});

//   @override
//   String toString() {
//     developer.log("INTERNAL EXCEPTION : $type");
//     return "INTERNAL EXCEPTION: $type";
//   }
// }

// class ServerException extends AppException {
//   final ServerExceptionType type;

//   ServerException({this.type = ServerExceptionType.unknown});
//   @override
//   String toString() {
//     developer.log("SERVER EXCEPTION : $type");
//     return "SERVER EXCEPTION: $type";
//   }
// }

// class NetworkException extends AppException {
//   final NetworkExceptionType type;

//   NetworkException({this.type = NetworkExceptionType.unknown});
//   @override
//   String toString() {
//     developer.log("NETWORK EXCEPTION : $type");
//     return "NETWORK EXCEPTION: $type";
//   }
// }

// class StorageException extends AppException {
//   final StorageExceptionType type;

//   StorageException({this.type = StorageExceptionType.unknown});
//   @override
//   String toString() {
//     developer.log("STORAGE EXCEPTION : $type");
//     return "STORAGE EXCEPTION: $type";
//   }
// }

// class UnknownException extends AppException {
//   @override
//   String toString() {
//     developer.log("UNKNOWN EXCEPTION OCCURRED");
//     return "UNKNOWN EXCEPTION OCCURRED";
//   }
// }

