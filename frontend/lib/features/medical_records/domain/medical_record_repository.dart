import 'package:dartz/dartz.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';

abstract interface class MedicalRecordRepository {
  Future<Either<Failure, MedicalRecord>> upload({
    required String filePath,
    required MedicalRecordType type,
  });

  Future<Either<Failure, List<MedicalRecord>>> getAll();

  Future<Either<Failure, String>> delete({required int id});
}
