import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:frontend/core/common/app_enums.dart' show HealthParameter;
import 'package:frontend/features/analysis/domain/analysis_repository.dart';
import 'package:frontend/features/analysis/domain/entities/chart_point.dart';
import 'package:frontend/features/analysis/domain/entities/health_reading.dart';
import 'package:frontend/service_locator.dart';

class GetHealthReadingsUseCase {
  Future<Either<String, List<ChartPoint>>> call({
    required HealthParameter parameter,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final response =
        await serviceLocator<AnalysisRepository>().getHealthReadings(
      parameter: parameter,
      fromDate: fromDate,
      toDate: toDate,
    );
    return response.fold(
      (error) => Left(error.message),
      (chartPoints) => Right(chartPoints),
    );
  }
}
