import 'package:dartz/dartz.dart';
import 'package:frontend/features/medical_records/domain/medical_record_repository.dart';
import 'package:frontend/service_locator.dart';

class DeleteMedicalRecordUseCase {
  Future<Either<String, String>> call({required int id}) async {
    final response =
        await serviceLocator<MedicalRecordRepository>().delete(id: id);
    return response.fold(
      (error) => Left(error.message),
      (message) => Right(message),
    );
  }
}
