import 'package:dartz/dartz.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';
import 'package:frontend/features/medical_records/domain/use_case/get_medical_records_use_case.dart';
import 'package:frontend/features/medical_records/domain/use_case/upload_medical_record_use_case.dart';
import 'package:frontend/service_locator.dart';

part 'medical_records_event.dart';
part 'medical_records_state.dart';

class MedicalRecordsBloc
    extends Bloc<MedicalRecordsEvent, MedicalRecordsState> {
  MedicalRecordsBloc() : super(MedicalRecordsInitial()) {
    on<SelectMedicalRecordEvent>(_selectMedicalRecord);
    on<UploadMedicalRecordEvent>(_uploadMedicalRecord);
    on<GetAllMedicalRecordsEvent>(_getAllMedicalRecords);
  }

  void _selectMedicalRecord(
    SelectMedicalRecordEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    final result = await FilePicker.platform.pickFiles(
      allowedExtensions: ['pdf', 'jpg'],
      type: FileType.custom,
    );
    if (result == null) return;
    final filePath = result.files.single.path;
    final fileName = result.files.single.name;

    OpenFile(result.files.single.path!, true);
    emit(
      UploadMedicalRecordConfirmation(
        filePath: filePath!,
        fileName: fileName,
        loadedMedicalRecords: event.loadedMedicalRecords,
      ),
    );
  }

  void _uploadMedicalRecord(
    UploadMedicalRecordEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    final response = await serviceLocator<UploadMedicalRecordUseCase>()
        .call(filePath: event.filePath, type: event.type);

    response.fold(
      (error) => emit(
        UploadMedicalRecordFailed(
          error: error,
          previouslyLoadedRecords: event.loadedMedicalRecords,
        ),
      ),
      (medicalRecord) => emit(
        UploadMedicalRecordSuccess(
          medicalRecord: medicalRecord,
        ),
      ),
    );
  }

  void _getAllMedicalRecords(
    GetAllMedicalRecordsEvent event,
    Emitter<MedicalRecordsState> emit,
  ) async {
    if (event.previousMedicalRecords != null) {
      emit(MedicalRecordsLoaded(medicalRecords: event.previousMedicalRecords!));
      return;
    }
    emit(MedicalRecordsLoading());
    final response = await serviceLocator<GetMedicalRecordsUseCase>().call();
    return response.fold(
      (error) => emit(MedicalRecordsFailed(error: error)),
      (medicalRecords) => emit(
        MedicalRecordsLoaded(medicalRecords: medicalRecords),
      ),
    );
  }
}
