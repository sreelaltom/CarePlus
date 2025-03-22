part of 'file_operations_cubit.dart';

abstract class FileOperationState extends Equatable{}

class FileOperationInitial extends FileOperationState {
  @override
  List<Object?> get props => [];
}

class UploadRequested extends FileOperationState {
  @override
  List<Object?> get props => [];
}

class UploadConfirmation extends FileOperationState {
  final String fileName;
  final String filePath;

  UploadConfirmation({required this.fileName, required this.filePath});
  
  @override
  List<Object?> get props => [fileName, filePath];
}

class UploadSuccess extends FileOperationState  {
  final MedicalRecord medicalRecord;
  UploadSuccess({required this.medicalRecord});
  
  @override
  List<Object?> get props => [medicalRecord];
}

class UploadFailure extends FileOperationState {
  final String error;

  UploadFailure({this.error = "File upload failed!"});
  
  @override
  List<Object?> get props => [error];
}

class DeleteRequested extends FileOperationState {
  final MedicalRecord record;
  DeleteRequested({required this.record});
  
  @override
  List<Object?> get props => [record];
}


class DeleteSuccess extends FileOperationState {
  final String fileName;
  final int fileId;
  DeleteSuccess({required this.fileName, required this.fileId});
  
  @override
  List<Object?> get props => [fileName, fileId];
}

class DeleteFailure extends FileOperationState {
  final String error;

  DeleteFailure({this.error = "File was not deleted!"});
  
  @override
  List<Object?> get props => [error];
}
