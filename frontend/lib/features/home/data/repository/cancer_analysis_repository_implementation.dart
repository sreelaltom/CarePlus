import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/home/data/source/cancer_analysis_remote_data_source.dart';
import 'package:frontend/features/home/domain/entities/cancer_analysis.dart';
import 'package:frontend/features/home/domain/repository/cancer_analysis_repository.dart';
import 'package:frontend/service_locator.dart';

class CancerAnalysisRepositoryImplementation
    implements CancerAnalysisRepository {
  @override
  Future<Either<Failure, CancerAnalysis>> predict({
    required String filePath,
    required category,
  }) async {
    try {
      final cancerAnalysis =
          await serviceLocator<CancerAnalysisRemoteDataSource>()
              .predictCancer(filePath: filePath, category: category);
      return Right(cancerAnalysis);
    } on AppException catch (e) {
      return Left(Failure.from(e));
    }
  }
}
