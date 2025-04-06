import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart' show AnalysisType;
import 'package:frontend/features/home/presentation/bloc/image_operation/image_operation_state.dart';
import 'package:image_picker/image_picker.dart';

class ImageOperationCubit extends Cubit<ImageOperationState> {
  ImageOperationCubit() : super(ImageOperationInitial());

  void reset() => emit(ImageOperationInitial());

  void selectImage({
    required ImageSource source,
    required AnalysisType analysisRequested,
  
  }) async {
    emit(ImageSelectionRequested());
    final xFile = await ImagePicker().pickImage(source: source);
    if (xFile == null) {
      emit(ImageOperationInitial());
      return;
    }
    emit(ImageSelected(file: xFile, analysisRequested: analysisRequested)); 
  }
}
