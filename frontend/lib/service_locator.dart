import 'package:frontend/core/network/cubit/connectivity_cubit.dart';
import 'package:frontend/features/analysis/data/analysis_remote_data_source.dart';
import 'package:frontend/features/analysis/data/analysis_repository_implementation.dart';
import 'package:frontend/features/analysis/domain/analysis_repository.dart';
import 'package:frontend/features/analysis/domain/get_health_readings_use_case.dart';
import 'package:frontend/features/auth/data/auth_remote_data_source.dart';
import 'package:frontend/features/auth/data/auth_repository_implementation.dart';
import 'package:frontend/features/auth/domain/auth_repository.dart';
import 'package:frontend/features/auth/presentation/bloc/session_cubit/session_cubit.dart';
import 'package:frontend/features/auth/domain/use_cases/login_use_case.dart';
import 'package:frontend/features/auth/domain/use_cases/register_use_case.dart';
import 'package:frontend/features/home/data/repository/food_classifier_repository_implementation.dart';
import 'package:frontend/features/home/data/source/cancer_analysis_remote_data_source.dart';
import 'package:frontend/features/home/data/source/food_remote_data_source.dart';
import 'package:frontend/features/home/domain/repository/cancer_analysis_repository.dart';
import 'package:frontend/features/home/data/repository/cancer_analysis_repository_implementation.dart';
import 'package:frontend/features/home/domain/repository/food_classifier_repository.dart';
import 'package:frontend/features/home/domain/use_cases/classify_food_use_case.dart';
import 'package:frontend/features/home/domain/use_cases/predict_cancer_use_case.dart';
import 'package:frontend/features/medical_records/data/medical_record_remote_data_source.dart';
import 'package:frontend/features/medical_records/data/medical_record_repository_implementation.dart';
import 'package:frontend/features/medical_records/domain/medical_record_repository.dart';
import 'package:frontend/features/medical_records/domain/use_case/delete_medical_record_use_case.dart';
import 'package:frontend/features/medical_records/domain/use_case/get_medical_records_use_case.dart';
import 'package:frontend/features/medical_records/domain/use_case/upload_medical_record_use_case.dart';
import 'package:get_it/get_it.dart';
import 'dart:developer' as developer show log;

import 'package:image_picker/image_picker.dart';

final serviceLocator = GetIt.instance;

abstract class Dependencies {
  static bool isAuthRegistered = false;
  static bool isMedicalRecordRegistered = false;
  static bool isAnalysisRegistered = false;
  static bool isCancerAnalysisRegistered = false;
  static bool isFoodClassifyRegistered = false;

  static Future<void> initialize() async {
    isAuthRegistered = true;
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
    isAuthRegistered = false;
    developer.log("SERVICE LOCATOR:");
    if (serviceLocator.isRegistered<AuthRepository>()) {
      serviceLocator.unregister<AuthRepository>();
      developer.log('\tUnregistered AuthRepository');
    }
    if (serviceLocator.isRegistered<AuthRemoteDataSource>()) {
      serviceLocator
        ..unregister<AuthRemoteDataSource>()
        ..registerLazySingleton<AuthRemoteDataSource>(
          () => AuthRemoteDataSourceImplementation(),
        );
      developer.log('\tRegistered AuthRemoteDataSource(Lazy Singleton)');
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
    if (!isAuthRegistered) {
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
      isAuthRegistered = true;
    }
  }

  static Future<void> initMedicalRecord() async {
    if (!isMedicalRecordRegistered) {
      serviceLocator
        ..registerLazySingleton<UploadMedicalRecordUseCase>(
          () => UploadMedicalRecordUseCase(),
        )
        ..registerLazySingleton<GetMedicalRecordsUseCase>(
          () => GetMedicalRecordsUseCase(),
        )
        ..registerLazySingleton<DeleteMedicalRecordUseCase>(
          () => DeleteMedicalRecordUseCase(),
        )
        ..registerLazySingleton<MedicalRecordRepository>(
          () => MedicalRecordRepositoryImplementation(),
        )
        ..registerLazySingleton<MedicalRecordRemoteDataSource>(
          () => MedicalRecordRemoteDataSourceImplementation(),
        )
        ..registerLazySingleton<ImagePicker>(() => ImagePicker());
      isMedicalRecordRegistered = true;
      developer.log('SERVICE LOCATOR: Medical Record Dependencies initialized');
    }
  }

  static Future<void> initAnalysis() async {
    if (!isAnalysisRegistered) {
      serviceLocator
        ..registerLazySingleton<AnalysisRemoteDataSource>(
          () => AnalysisRemoteDataSourceImplementation(),
        )
        ..registerLazySingleton<AnalysisRepository>(
          () => AnalysisRepositoryImplementation(),
        )
        ..registerLazySingleton<GetHealthReadingsUseCase>(
          () => GetHealthReadingsUseCase(),
        );
      isAnalysisRegistered = true;
      developer.log('SERVICE LOCATOR: Analysis Dependencies initialized');
    }
  }

  static Future<void> initCancerAnalysis() async {
    if (!isCancerAnalysisRegistered) {
      serviceLocator
        ..registerLazySingleton<CancerAnalysisRemoteDataSource>(
          () => CancerAnalysisRemoteDataSourceImplementation(),
        )
        ..registerLazySingleton<CancerAnalysisRepository>(
          () => CancerAnalysisRepositoryImplementation(),
        )
        ..registerLazySingleton<PredictCancerUseCase>(
          () => PredictCancerUseCase(),
        );
      isCancerAnalysisRegistered = true;
      developer.log('SERVICE LOCATOR: Cancer Analysis Dependencies initialized');
    }
  }

  static Future<void> initFoodClassifier() async {
    if(!isFoodClassifyRegistered) {
      serviceLocator
        ..registerLazySingleton<FoodRemoteDataSource>(
          () => FoodRemoteDataSourceImplementation(),
        )
        ..registerLazySingleton<FoodClassifierRepository>(
          () => FoodClassifierRepositoryImplementation(),
        )
        ..registerLazySingleton<ClassifyFoodUseCase>(
          () => ClassifyFoodUseCase(),
        );
      isFoodClassifyRegistered = true;
      developer.log('SERVICE LOCATOR: Food classifier Dependencies initialized');
    }
  }
}
