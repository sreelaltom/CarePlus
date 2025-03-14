import 'package:dartz/dartz.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';
import 'package:frontend/features/medical_records/domain/medical_record_repository.dart';
import 'package:frontend/service_locator.dart';

class GetMedicalRecordsUseCase {
  Future<Either<String, List<MedicalRecord>>> call() async {
    final response = await serviceLocator<MedicalRecordRepository>().getAll();
    return response.fold(
      (error) => Left(error.message),
      (medicalRecords) => Right(medicalRecords),
    );
  }
}
