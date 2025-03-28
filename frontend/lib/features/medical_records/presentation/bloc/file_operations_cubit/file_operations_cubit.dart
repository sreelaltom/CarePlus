import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';
import 'package:frontend/features/medical_records/domain/use_case/delete_medical_record_use_case.dart';
import 'package:frontend/features/medical_records/domain/use_case/upload_medical_record_use_case.dart';
import 'package:frontend/service_locator.dart';
import 'package:image_picker/image_picker.dart';

part 'file_operations_state.dart';

class FileOperationsCubit extends Cubit<FileOperationState> {
  FileOperationsCubit() : super(FileOperationInitial());

  void reset() => emit(FileOperationInitial());

  void captureImage() async {
    emit(UploadRequested());
    final xFile = await ImagePicker().pickImage(source: ImageSource.camera);
    if (xFile == null) {
      emit(FileOperationInitial());
      return;
    }
    final filePath = xFile.path;
    final fileName = xFile.name;
    OpenFile(filePath, true);
    emit(
      UploadConfirmation(
        fileName: fileName,
        filePath: filePath,
      ),
    );
  }

  void selectFile() async {
    emit(UploadRequested());
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'jpg'],
      type: FileType.custom,
    );
    if (result == null) {
      emit(FileOperationInitial());
      return;
    }
    final filePath = result.files.single.path;
    final fileName = result.files.single.name;

    OpenFile(result.files.single.path!, true);
    emit(
      UploadConfirmation(
        fileName: fileName,
        filePath: filePath!,
      ),
    );
  }

  void uploadFile({
    required String filePath,
    required String fileName,
    required MedicalRecordType type,
  }) async {
    final response = await serviceLocator<UploadMedicalRecordUseCase>()
        .call(filePath: filePath, type: type);

    response.fold(
      (error) => emit(UploadFailure(error: error)),
      (medicalRecord) => emit(UploadSuccess(medicalRecord: medicalRecord)),
    );
  }

  void requestDeleteFile({required MedicalRecord record}) =>
      emit(DeleteRequested(record: record));

  void deleteFile({required MedicalRecord record}) async {
    final response =
        await serviceLocator<DeleteMedicalRecordUseCase>().call(id: record.id);
    response.fold(
      (error) => emit(DeleteFailure(error: error)),
      (message) => emit(
          DeleteSuccess(fileName: record.id.toString(), fileId: record.id)),
    );
  }
}
