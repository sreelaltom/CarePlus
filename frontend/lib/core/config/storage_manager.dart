import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class SecureStorageManager {
  static final SecureStorageManager _storageManager =
      SecureStorageManager._internal();

  SecureStorageManager._internal();

  factory SecureStorageManager() => _storageManager;

  final _storage = const FlutterSecureStorage();

  Future<void> store({
    required String key,
    required String value,
  }) async =>
      await _storage.write(key: key, value: value);

  Future<String?> retrieve({required String key}) async =>
      await _storage.read(key: key);

  Future<void> delete({required String key}) async =>
      await _storage.delete(key: key);
}
