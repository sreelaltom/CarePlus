part of 'medical_records_bloc.dart';

abstract class MedicalRecordsState {}

class MedicalRecordsInitial extends MedicalRecordsState {}

class MedicalRecordsLoading extends MedicalRecordsState {}

class MedicalRecordsLoaded extends MedicalRecordsState {
  final List<MedicalRecord> medicalRecords;

  MedicalRecordsLoaded({required this.medicalRecords});
}

class UploadMedicalRecordConfirmation extends MedicalRecordsState {
  final String filePath;
  final String fileName;
  final List<MedicalRecord>? loadedMedicalRecords;

  UploadMedicalRecordConfirmation({
    required this.filePath,
    required this.fileName,
    this.loadedMedicalRecords,
  });
}

class UploadMedicalRecordSuccess extends MedicalRecordsState {
  final MedicalRecord medicalRecord;

  UploadMedicalRecordSuccess({required this.medicalRecord});
}

class UploadMedicalRecordFailed extends MedicalRecordsState {
  final String? error;
  final List<MedicalRecord>? previouslyLoadedRecords;

  UploadMedicalRecordFailed({
    required this.error,
    this.previouslyLoadedRecords,
  });
}

class DeleteMedicalRecordStatus extends MedicalRecordsState {
  final String status;

  DeleteMedicalRecordStatus({required this.status});
}

class MedicalRecordsFailed extends MedicalRecordsState {
  final String? error;

  MedicalRecordsFailed({this.error});
}
