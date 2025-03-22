part of 'medical_records_bloc.dart';

abstract class MedicalRecordsEvent extends Equatable {}

class SelectMedicalRecordEvent extends MedicalRecordsEvent {
  final List<MedicalRecord>? loadedMedicalRecords;

  SelectMedicalRecordEvent({this.loadedMedicalRecords});

  @override
  List<Object?> get props => [loadedMedicalRecords];
}

class AddMedicalRecordEvent extends MedicalRecordsEvent {
  final MedicalRecord newRecord;

  AddMedicalRecordEvent({required this.newRecord});

  @override
  List<Object?> get props => [newRecord];
}

class GetAllMedicalRecordsEvent extends MedicalRecordsEvent {
  final List<MedicalRecord>? previousMedicalRecords;

  GetAllMedicalRecordsEvent({this.previousMedicalRecords});

  @override
  List<Object?> get props => [previousMedicalRecords];
}

class RemoveMedicalRecordEvent extends MedicalRecordsEvent {
  final int fileId;

  RemoveMedicalRecordEvent({required this.fileId});
  
  @override
  List<Object?> get props => [fileId];
}


