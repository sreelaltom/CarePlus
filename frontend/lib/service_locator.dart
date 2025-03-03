import 'package:frontend/core/network/cubit/connectivity_cubit.dart';
import 'package:frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:frontend/features/auth/data/auth_repository_implementation.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:frontend/features/auth/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/auth/domain/use_cases/register_use_case.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer' as developer;

final serviceLocator = GetIt.instance;

abstract class Dependencies {
  static Future<void> initialize() async {
    serviceLocator
      ..registerSingleton<SessionCubit>(SessionCubit())
      ..registerSingleton<ConnectivityCubit>(ConnectivityCubit())
      ..registerSingleton<RegisterUseCase>(RegisterUseCase())
      ..registerSingleton<LoginUseCase>(LoginUseCase())
      ..registerSingleton<AuthRepository>(AuthRepositoryImplementation())
      ..registerSingleton<AuthRemoteDataSource>(
        AuthRemoteDataSourceImplementation(),
      );

    developer.log('SERVICE LOCATOR: Dependencies initialized');
  }

  static Future<void> disposeAuth() async {
    developer.log("SERVICE LOCATOR:");
    if (serviceLocator.isRegistered<AuthRepository>()) {
      serviceLocator.unregister<AuthRepository>();
      developer.log('\tUnregistered AuthRepository');
    }
    if (serviceLocator.isRegistered<AuthRemoteDataSource>()) {
      serviceLocator.unregister<AuthRemoteDataSource>();
      developer.log('\tUnregistered AuthRemoteDataSource');
    }
    if (serviceLocator.isRegistered<LoginUseCase>()) {
      serviceLocator.unregister<LoginUseCase>();
      developer.log('\tUnregistered LoginUseCase');
    }
    if (serviceLocator.isRegistered<RegisterUseCase>()) {
      serviceLocator.unregister<RegisterUseCase>();
      developer.log('\tUnregistered RegisterUseCase');
    }
  }

  static Future<void> initAuth() async {
    developer.log("SERVICE LOCATOR:");
    if (!serviceLocator.isRegistered<AuthRepository>()) {
      serviceLocator.registerSingleton<AuthRepository>(
        AuthRepositoryImplementation(),
      );
      developer.log('\tRegistered AuthRepository');
    }
    if (!serviceLocator.isRegistered<AuthRemoteDataSource>()) {
      serviceLocator.registerSingleton<AuthRemoteDataSource>(
        AuthRemoteDataSourceImplementation(),
      );
      developer.log('\tRegistered AuthRemoteDataSource');
    }
    if (!serviceLocator.isRegistered<LoginUseCase>()) {
      serviceLocator.registerSingleton<LoginUseCase>(LoginUseCase());
      developer.log('\tRegistered LoginUseCase');
    }
    if (!serviceLocator.isRegistered<RegisterUseCase>()) {
      serviceLocator.registerSingleton<RegisterUseCase>(RegisterUseCase());
      developer.log('\tRegistered RegisterUseCase');
    }
  }
}
