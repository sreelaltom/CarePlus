import 'package:dartz/dartz.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/medical_records/data/medical_record_remote_data_source.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';
import 'package:frontend/features/medical_records/domain/medical_record_repository.dart';
import 'package:frontend/service_locator.dart';

class MedicalRecordRepositoryImplementation implements MedicalRecordRepository {
  @override
  Future<Either<Failure, MedicalRecord>> upload({
    required String filePath,
    required MedicalRecordType type,
  }) async {
    try {
      final medicalRecord =
          await serviceLocator<MedicalRecordRemoteDataSource>()
              .upload(filePath: filePath, type: type);
      return Right(medicalRecord);
    } on AppException catch (e) {
      return Left(Failure.from(e));
    }
  }

  @override
  Future<Either<Failure, List<MedicalRecord>>> getAll() async {
    try {
      final medicalRecords =
          await serviceLocator<MedicalRecordRemoteDataSource>().getAll();

      return Right(medicalRecords);
    } on AppException catch (e) {
      return Left(Failure.from(e));
    }
  }

  @override
  Future<Either<Failure, String>> delete({required int id}) async {
    try {
      final message =
          await serviceLocator<MedicalRecordRemoteDataSource>().delete(id: id);

      return Right(message);
    } on AppException catch (e) {
      return Left(Failure.from(e));
    }
  }
}
