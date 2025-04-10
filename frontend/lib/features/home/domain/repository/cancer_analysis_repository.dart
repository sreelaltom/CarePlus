import 'package:dartz/dartz.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/home/domain/entities/cancer_analysis.dart';

abstract interface class CancerAnalysisRepository {
  Future<Either<Failure, CancerAnalysis>> predict({
    required String filePath,
    required CtScanCategory category,
  });
}
