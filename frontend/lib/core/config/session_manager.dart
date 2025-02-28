import 'package:flutter/foundation.dart';
import 'package:frontend/core/config/storage_manager.dart';
import 'dart:developer' as developer;

class Session {
  final String userID;
  final String refreshToken;
  final String accessToken;

  Session._internal({
    required this.userID,
    required this.refreshToken,
    required this.accessToken,
  });

  factory Session({
    required String userID,
    required String accessToken,
    required String refreshToken,
  }) =>
      Session._internal(
        userID: userID,
        accessToken: accessToken,
        refreshToken: refreshToken,
      );
}

class SessionManager {
  String? userID;
  String? refreshToken;
  String? accessToken;
  void Function()? _sessionListener;
  final ValueNotifier<bool> _hasSession = ValueNotifier(false);

  ValueNotifier<bool> get hasSession => _hasSession;

  Future<Session?> hadActiveSession() async => await Future.wait(
        [
          // SecureStorageManager().delete(key: StorageKeys.userID),
          // SecureStorageManager().delete(key: StorageKeys.accessToken),
          // SecureStorageManager().delete(key: StorageKeys.refreshToken),
        ],
      ).then((_) => Future.wait(
            [
              SecureStorageManager().retrieve(key: StorageKeys.userID),
              SecureStorageManager().retrieve(key: StorageKeys.accessToken),
              SecureStorageManager().retrieve(key: StorageKeys.refreshToken),
            ],
          ).then(
            (response) {
              developer.log(
                '''

          LAST SESSION.
          session_status: { 
            user_id : ${response[0]},
            access_token : ${response[1]},
            refresh_token : ${response[2]},
            has_session: ${hasSession.value},
            listener: ${_sessionListener == null ? "not_active" : "active"}
          }

          ''',
                time: DateTime.now(),
              );
              return response.contains(null)
                  ? null
                  : Session(
                      userID: response[0]!,
                      accessToken: response[1]!,
                      refreshToken: response[2]!,
                    );
            },
          ));

  SessionManager._internal();
  static final SessionManager _sessionManager = SessionManager._internal();
  final _storage = SecureStorageManager();
  factory SessionManager() => _sessionManager;

  Future<void> createSession({
    required String userID,
    required String refreshToken,
    required String accessToken,
    void Function()? listener,
  }) async {
    this.userID = userID;
    this.refreshToken = refreshToken;
    this.accessToken = accessToken;
    _hasSession.value = true;
    // await _storage.store(key: StorageKeys.userID, value: userId);
    await Future.wait([
      _storage.store(key: StorageKeys.userID, value: userID.toString()),
      _storage.store(key: StorageKeys.refreshToken, value: refreshToken),
      _storage.store(key: StorageKeys.accessToken, value: accessToken),
    ]);

    if (_sessionListener == null && listener != null) {
      _sessionListener = listener;
      _hasSession.addListener(listener);
    }

    developer.log(
      '''

          SESSION CREATED.
          session_status: { 
            user_id : $userID,
            access_token : $accessToken,
            refresh_token : $refreshToken,
            has_session: ${hasSession.value},
            listener: ${listener == null ? "not_active" : "active"}
          }

        ''',
      time: DateTime.now(),
    );
  }

  // bool get hasSession => refreshToken != null && accessToken != null;

  Future<void> loadSession({
    required Session session,
    void Function()? listener,
  }) async {
    userID = session.userID;
    refreshToken = session.refreshToken;
    accessToken = session.accessToken;
    _hasSession.value = true;
    if (listener != null) {
      _sessionListener = listener;
      _hasSession.addListener(_sessionListener!);
    }

    developer.log(
      '''

          SESSION LOADED.
          session_status: { 
            user_id : ${session.userID},
            access_token : ${session.accessToken},
            refresh_token : ${session.refreshToken},
            has_session: ${hasSession.value},
            listener: ${listener == null ? "not_active" : "active"}
          }

        ''',
      time: DateTime.now(),
    );

    //todo: _sessionListener should be loaded when the user
    //todo: restarts the app after login. This should be
    //todo: done inside the homeBloc/dashboardBloc
  }

  Future<void> clearSession({bool isLogout = false}) async {
    // await _storage.delete(key: StorageKeys.userID);
    await Future.wait([
      _storage.delete(key: StorageKeys.userID),
      _storage.delete(key: StorageKeys.refreshToken),
      _storage.delete(key: StorageKeys.accessToken),
    ]);

    userID = null;
    refreshToken = null;
    accessToken = null;
    if (isLogout && _sessionListener != null) {
      _hasSession.removeListener(_sessionListener!);
      _sessionListener = null;
    }
    _hasSession.value = false;

    if (!isLogout && _sessionListener != null) {
      _hasSession.removeListener(_sessionListener!);
      _sessionListener = null;
    }

    developer.log(
      '''
          SESSION CLEARED.
          session_status: { 
            user_id : $userID,
            access_token : $accessToken,
            refresh_token : $refreshToken,
            has_session: ${hasSession.value},
            listener: ${_sessionListener == null ? "not_active" : "active"}
          }

        ''',
      time: DateTime.now(),
    );
  }

  void addSessionListener(void Function() listener) {
    _sessionListener = listener;
    _hasSession.addListener(listener);
    developer.log(
      '''
          ADDED SESSION LISTENER.
          session_status: { 
            user_id : $userID,
            access_token : $accessToken,
            refresh_token : $refreshToken,
            has_session: ${hasSession.value},
            listener: ${_sessionListener == null ? "not_active" : "active"}
          }

        ''',
      time: DateTime.now(),
    );
  }
}
