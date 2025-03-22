import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';
import 'package:frontend/features/medical_records/domain/use_case/get_medical_records_use_case.dart';
import 'package:frontend/service_locator.dart';

part 'medical_records_event.dart';
part 'medical_records_state.dart';

class MedicalRecordsBloc
    extends Bloc<MedicalRecordsEvent, MedicalRecordsState> {
  MedicalRecordsBloc() : super(MedicalRecordsInitial()) {
    // on<SelectMedicalRecordEvent>(_selectMedicalRecord);
    // on<UploadMedicalRecordEvent>(_uploadMedicalRecord);
    on<GetAllMedicalRecordsEvent>(_getAllMedicalRecords);
    on<AddMedicalRecordEvent>(_addMedicalRecord);
    on<RemoveMedicalRecordEvent>(_deleteMedicalRecord);
    // on<DeleteMedicalRecordEvent>(_deleteMedicalRecord);
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

  void _addMedicalRecord(
    AddMedicalRecordEvent event,
    Emitter<MedicalRecordsState> emit,
  ) {
    if (state is MedicalRecordsLoaded) {
      {
        final currentState = state as MedicalRecordsLoaded;
        emit(
          MedicalRecordsLoaded(
            medicalRecords: List.from(
              [
                event.newRecord,
                ...currentState.medicalRecords,
              ],
            ),
          ),
        );
      }
    }
  }

  void _deleteMedicalRecord(
    RemoveMedicalRecordEvent event,
    Emitter<MedicalRecordsState> emit,
  ) {
    if (state is MedicalRecordsLoaded) {
      final currentState = state as MedicalRecordsLoaded;
      emit(MedicalRecordsLoaded(medicalRecords: List.from(currentState.medicalRecords)..removeWhere((record) => record.id == event.fileId)));
    }
  }
}
