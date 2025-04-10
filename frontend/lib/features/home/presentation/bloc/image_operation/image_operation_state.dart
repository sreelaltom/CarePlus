import 'package:equatable/equatable.dart';
import 'package:image_picker/image_picker.dart';
import 'package:frontend/core/common/app_enums.dart' show AnalysisType;


abstract class ImageOperationState extends Equatable {}

class ImageOperationInitial extends ImageOperationState {

  @override
  List<Object?> get props => [];
}

class ImageSelectionRequested extends ImageOperationState {
  @override
  List<Object?> get props => [];
}

class ImageSelected extends ImageOperationState {
  final XFile file;
  final AnalysisType analysisRequested;

  ImageSelected({required this.file, required this.analysisRequested,});

  @override
  List<Object?> get props => [file, analysisRequested];
}