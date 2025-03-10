import 'package:frontend/core/errors/exceptions.dart';

typedef _ErrorMessage = Map<int, String>;

class Failure {
  final String message;

  Failure({required this.message});  

  factory Failure.from(AppException e) => Failure(
        message: _messages[e.type.errorCode] ?? "An Unexpected error occurred",
      );
}

final _ErrorMessage _messages = {
  // Internal Errors (600 - 610)
  600: "Invalid format encountered.",
  601: "Value is out of the allowed range.",
  602: "Invalid application state.",
  603: "Request was intercepted due to an error.",
  520: "An unknown internal error occurred.",

  // Server Errors (400 - 500)
  400: "The request was invalid.",
  401: "Unauthorized access. Please log in.",
  403: "Access Denied",
  404: "Invalid credentials provided.",
  500: "An unexpected server error occurred.",
  503: "The service is temporarily unavailable. Please try again later.",
  423: "Your account has been locked due to security reasons.",

  // Network Errors (611 - 620)
  611: "No internet connection. Please check your network.",
  408: "Connection timed out. Please try again.",

  // Storage Errors (621 - 630)
  621: "Local storage initialization failed.",
  622: "Data not found",
  623: "Hive database is already open.",
  624: "Hive database is corrupted.",
  625: "Hive database lock error.",
  626: "Hive adapter error encountered.",
  627: "Secure storage operation failed.",
  628: "File system error occurred.",
  629: "Storage permission denied."
};
