import 'package:dartz/dartz.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/features/home/domain/entities/cancer_analysis.dart';
import 'package:frontend/features/home/domain/repository/cancer_analysis_repository.dart';
import 'package:frontend/service_locator.dart';

class PredictCancerUseCase {
  Future<Either<String, CancerAnalysis>> call({
    required String filePath,
    required CtScanCategory category,
  }) async {
    final response = await serviceLocator<CancerAnalysisRepository>()
        .predict(filePath: filePath, category: category);
    return response.fold(
      (error) => Left(error.message),
      (cancerAnalysis) => Right(cancerAnalysis),
    );
  }
}
