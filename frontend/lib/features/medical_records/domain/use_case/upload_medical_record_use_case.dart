import 'package:dartz/dartz.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';
import 'package:frontend/features/medical_records/domain/medical_record_repository.dart';
import 'package:frontend/service_locator.dart';

class UploadMedicalRecordUseCase {
  Future<Either<String, MedicalRecord>> call({
    required String filePath,
    required MedicalRecordType type,
  }) async {
    final response = await serviceLocator<MedicalRecordRepository>()
        .upload(filePath: filePath, type: type);
    return response.fold(
      (error) => Left(error.message),
      (medicalRecord) => Right(medicalRecord),
    );
  }
}
