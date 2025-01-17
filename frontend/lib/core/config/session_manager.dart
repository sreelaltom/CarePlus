import 'package:frontend/core/config/storage_manager.dart';
import 'dart:developer' as developer;

class SessionManager {
  String? userId;
  String? token;
  DateTime? expiryDate;

  static final SessionManager _sessionManager = SessionManager._internal();
  SessionManager._internal() {
    userId = null;
    token = null;
    expiryDate = null;
  }

  factory SessionManager() => _sessionManager;

  Future<void> createSession({
    required String userId,
    required String token,
    required DateTime expiryDate,
  }) async {
    this.userId = userId;
    this.token = token;
    this.expiryDate = expiryDate;

    await SecureStorageManager().store(key: 'user_Id', value: userId);
    await SecureStorageManager().store(key: 'token', value: token);
    await SecureStorageManager()
        .store(key: 'expiry_date', value: expiryDate.toString());

    developer.log(
      'SESSION CREATED SUCCESSFULLY...',
      time: DateTime.now(),
    );
  }

  bool get hasSession =>
      userId != null &&
      token != null &&
      expiryDate != null;

  bool get validate =>
      expiryDate != null && expiryDate!.isBefore(DateTime.now());

  Future<void> clearSession() async {
    userId = null;
    token = null;
    expiryDate = null;

    await SecureStorageManager().delete(key: 'user_Id');
    await SecureStorageManager().delete(key: 'token');
    await SecureStorageManager().delete(key: 'expiry_date');

    developer.log(
      'SESSION CLEARED SUCCESSFULLY...',
      time: DateTime.now(),
    );
  }
}
