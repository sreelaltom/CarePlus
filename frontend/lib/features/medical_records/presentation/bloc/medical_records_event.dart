part of 'medical_records_bloc.dart';

abstract class MedicalRecordsEvent {}

class SelectMedicalRecordEvent extends MedicalRecordsEvent {

  final List<MedicalRecord>? loadedMedicalRecords;

  SelectMedicalRecordEvent({this.loadedMedicalRecords});
}

class UploadMedicalRecordEvent extends MedicalRecordsEvent {
  final String filePath;
  final String fileName;
  final MedicalRecordType type;
  final List<MedicalRecord>? loadedMedicalRecords;

  UploadMedicalRecordEvent({
    required this.filePath,
    required this.fileName,
    required this.type,
    this.loadedMedicalRecords,
  });
}

class GetAllMedicalRecordsEvent extends MedicalRecordsEvent {
  final List<MedicalRecord>? previousMedicalRecords;

  GetAllMedicalRecordsEvent({this.previousMedicalRecords});
}

class RestorePreviousStateEvent extends MedicalRecordsEvent {}
