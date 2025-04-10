import 'dart:isolate';

import 'package:dartz/dartz.dart' show Either, Left, Right;
import 'package:frontend/core/common/app_enums.dart' show HealthParameter;
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/analysis/data/analysis_remote_data_source.dart';
import 'package:frontend/features/analysis/domain/analysis_repository.dart';
import 'package:frontend/features/analysis/domain/entities/chart_point.dart';
import 'package:frontend/service_locator.dart';

class AnalysisRepositoryImplementation implements AnalysisRepository {
  @override
  Future<Either<Failure, List<ChartPoint>>> getHealthReadings({
    required HealthParameter parameter,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    try {
      final healthReadings =
          await serviceLocator<AnalysisRemoteDataSource>().getHealthReadings(
        parameter: parameter,
        fromDate: fromDate,
        toDate: toDate,
      );

      final chartPoints = healthReadings.isEmpty ? <ChartPoint>[] : await Isolate.run(
        () => healthReadings
            .map(
              (reading) => ChartPoint(
                x: fromDate.difference(reading.date).inDays.toDouble().abs(),
                y: reading.value,
              ),
            )
            .toList(),
      );
      return Right(chartPoints);
    } on AppException catch (e) {
      return Left(Failure.from(e));
    }
  }
}
