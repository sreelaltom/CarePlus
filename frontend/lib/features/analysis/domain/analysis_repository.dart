import 'package:dartz/dartz.dart' show Either;
import 'package:frontend/core/common/app_enums.dart' show HealthParameter;
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/analysis/domain/entities/chart_point.dart';


abstract interface class AnalysisRepository {
  Future<Either<Failure, List<ChartPoint>>> getHealthReadings({
    required HealthParameter parameter,
    required DateTime fromDate, 
    required DateTime toDate,
  });
}
