import 'package:frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:frontend/features/auth/data/auth_repository_implementation.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/auth/domain/use_cases/register_use_case.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer' as developer;

final serviceLocator = GetIt.instance;

abstract class Dependencies {
  static Future<void> initialize() async {
    serviceLocator
      ..registerSingleton<AuthRemoteDataSource>(
        AuthRemoteDataSourceImplementation(),
      )
      ..registerSingleton<AuthRepository>(AuthRepositoryImplementation())
      ..registerSingleton<RegisterUseCase>(RegisterUseCase())
      ..registerSingleton<LoginUseCase>(LoginUseCase());

    developer.log('APP DEPENDENCIES INITIALIZED SUCCESSFULLY');
  }

  static Future<void> disposeAuth() async {
    if (serviceLocator.isRegistered<AuthRepository>()) {
      serviceLocator.unregister<AuthRepository>();
      developer.log('UNREGISTERED AuthRepository');
    }
    if (serviceLocator.isRegistered<AuthRemoteDataSource>()) {
      serviceLocator.unregister<AuthRemoteDataSource>();
      developer.log('UNREGISTERED AuthRemoteDataSource');
    }
    if (serviceLocator.isRegistered<LoginUseCase>()) {
      serviceLocator.unregister<LoginUseCase>();
      developer.log('UNREGISTERED LoginUseCase');
    }
    if (serviceLocator.isRegistered<RegisterUseCase>()) {
      serviceLocator.unregister<RegisterUseCase>();
      developer.log('UNREGISTERED RegisterUseCase');
    }
  }

  static Future<void> initAuth() async {
    if (!serviceLocator.isRegistered<AuthRepository>()) {
      serviceLocator.registerSingleton<AuthRepository>(
        AuthRepositoryImplementation(),
      );
      developer.log('RE-REGISTERED AuthRepository');
    }
    if (!serviceLocator.isRegistered<AuthRemoteDataSource>()) {
      serviceLocator.registerSingleton<AuthRemoteDataSource>(
        AuthRemoteDataSourceImplementation(),
      );
      developer.log('RE-REGISTERED AuthRemoteDataSource');
    }
    if (!serviceLocator.isRegistered<LoginUseCase>()) {
      serviceLocator.registerSingleton<LoginUseCase>(LoginUseCase());
      developer.log('RE-REGISTERED LoginUseCase');
    }
    if (!serviceLocator.isRegistered<RegisterUseCase>()) {
      serviceLocator.registerSingleton<RegisterUseCase>(RegisterUseCase());
      developer.log('RE-REGISTERED RegisterUseCase');
    }
  }
}
