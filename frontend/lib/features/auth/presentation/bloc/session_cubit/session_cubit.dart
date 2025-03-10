import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_state.dart';
import 'package:frontend/core/config/storage_manager.dart';
import 'package:frontend/features/auth/domain/entities/session.dart';
import 'package:frontend/service_locator.dart';
import 'dart:developer' as developer;

class SessionCubit extends Cubit<SessionState> {
  SessionCubit() : super(SessionInitial());

  void createSession({required Session session}) async {
    final storage = SecureStorageManager();
    await Future.wait([
      storage.store(key: StorageKeys.userID, value: session.userID.toString()),
      storage.store(key: StorageKeys.accessToken, value: session.accessToken),
      storage.store(key: StorageKeys.refreshToken, value: session.refreshToken),
    ]);
    serviceLocator.registerLazySingleton<Session>(() => session);
    if (serviceLocator.isRegistered<Session>()) {
      emit(ActiveSession());
      developer.log("SESSION CUBIT: Session created");
    } else {
      emit(InactiveSession(message: 'Failed to create session'));
      developer.log("SESSION CUBIT: Failed to create session.");
    }
    _logSessionStatus();
  }

  Future<void> loadSession() async {
    developer.log("SESSION CUBIT: Session Loading initiated");
    final storage = SecureStorageManager();
    final [userID, accessToken, refreshToken] = await Future.wait([
      storage.retrieve(key: StorageKeys.userID),
      storage.retrieve(key: StorageKeys.accessToken),
      storage.retrieve(key: StorageKeys.refreshToken),
    ]);
    if (userID == null || accessToken == null || refreshToken == null) {
      developer.log("SESSION CUBIT: No Session to load");
      emit(InactiveSession());
    } else {
      serviceLocator.registerLazySingleton<Session>(
        () => Session(
          accessToken: accessToken,
          refreshToken: refreshToken,
          userID: int.tryParse(userID)!,
        ),
      );
      if (serviceLocator.isRegistered<Session>()) {
        emit(ActiveSession());
        developer.log("SESSION CUBIT: Session loaded");
      } else {
        developer.log("SESSION CUBIT: Failed to load Session");
        emit(InactiveSession());
      }
    }
    _logSessionStatus();
  }

  Future<void> terminateSession({bool isLogout = false}) async {
    final storage = SecureStorageManager();
    if (serviceLocator.isRegistered<Session>()) {
      await Future.wait([
        storage.delete(key: StorageKeys.userID),
        storage.delete(key: StorageKeys.accessToken),
        storage.delete(key: StorageKeys.refreshToken),
      ]);
      serviceLocator.unregister<Session>();
      developer.log("SESSION CUBIT: Session Terminated");
    }
    await Dependencies.initAuth();
    emit(InactiveSession(
      message: isLogout ? 'Successfully logged out' : 'Session Expired',
    ));
    _logSessionStatus();
  }
}

void _logSessionStatus() {
  try {
    final session = serviceLocator<Session>();
    final accessToken = session.accessToken.substring(0, 50);
    final refreshToken = session.refreshToken.substring(0, 50);
    final userID = session.userID.toString();
    developer.log(
      'session_status : {\n\tuser_id : $userID\n\taccess_token: $accessToken\n\trefresh_token: $refreshToken\n}',
    );
  } catch (e) {
    developer.log(
      'session_status : {\n\tuser_id : null\n\taccess_token: null\n\trefresh_token: null\n}',
    );
  }
}
