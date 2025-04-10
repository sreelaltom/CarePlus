import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/features/home/domain/use_cases/predict_cancer_use_case.dart';
import 'package:frontend/features/home/domain/use_cases/classify_food_use_case.dart';
import 'package:frontend/features/home/presentation/bloc/analysis_result/analysis_result_state.dart';
import 'package:frontend/service_locator.dart';

class AnalysisResultCubit extends Cubit<AnalysisResultState> {
  AnalysisResultCubit() : super(AnalysisResultInitial());

  void reset() => emit(AnalysisResultInitial());      

  void analyzeImage({
    required CtScanCategory category,
    required String filePath,
  }) async {
    emit(AnalysisResultLoading(message: "Processing image..."));
    final response = await serviceLocator<PredictCancerUseCase>()
        .call(filePath: filePath, category: category);
    response.fold(
      (error) => emit(AnalysisResultError(error: error)),
      (cancerAnalysis) => emit(AnalysisResultLoaded(analysis: cancerAnalysis)),
    );
  }

  void classifyFood({required String filePath}) async {
    emit(AnalysisResultLoading(message: "Processing image..."));
    final response = await serviceLocator<ClassifyFoodUseCase>()
        .call(filePath: filePath);
    response.fold(
      (error) => emit(AnalysisResultError(error: error)),
      (foodComposition) => emit(AnalysisResultLoaded(foodComposition: foodComposition)),
    );
  }
}
