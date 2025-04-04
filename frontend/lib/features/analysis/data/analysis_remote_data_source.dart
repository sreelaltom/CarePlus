import 'dart:isolate';

import 'package:frontend/core/common/app_enums.dart' show HealthParameter;
import 'package:frontend/core/errors/error_handler.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/network/api_urls.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/features/analysis/data/health_reading_model.dart';
import 'dart:developer' as developer show log;

abstract class AnalysisRemoteDataSource {
  Future<List<HealthReadingModel>> getHealthReadings({
    required HealthParameter parameter,
    required DateTime fromDate,
    required DateTime toDate,
  });
}

class AnalysisRemoteDataSourceImplementation
    implements AnalysisRemoteDataSource {
  @override
  Future<List<HealthReadingModel>> getHealthReadings({
    required HealthParameter parameter,
    required DateTime fromDate,
    required DateTime toDate,
  }) async {
    final client = DioClient();

    try {
      final response = await client.get(
        ApiUrls.analysis(
          healthParameter: parameter.dropdownValue,
          from: fromDate,
          to: toDate,
        ),
      );
      final body = response.data as List<dynamic>;
      // late final List<Map<String, dynamic>> body;
      // switch (parameter) {
      //   case HealthParameter.bp:
      //     body = [
      //       {"value": 120.0, "date": "2024-02-12"},
      //       {"value": 125.0, "date": "2024-02-14"},
      //       {"value": 130.0, "date": "2024-02-16"},
      //       {"value": 128.0, "date": "2024-02-18"},
      //       {"value": 135.0, "date": "2024-02-20"},
      //       {"value": 138.0, "date": "2024-02-22"},
      //       {"value": 140.0, "date": "2024-02-24"},
      //       {"value": 142.0, "date": "2024-02-26"},
      //       {"value": 137.0, "date": "2024-02-28"},
      //       {"value": 132.0, "date": "2024-03-01"},
      //       {"value": 129.0, "date": "2024-03-03"},
      //     ];
      //     break;
      //   case HealthParameter.cholesterol:
      //     body = [
      //       {"value": 180.0, "date": "2024-02-12"},
      //       {"value": 185.0, "date": "2024-02-14"},
      //       {"value": 190.0, "date": "2024-02-16"},
      //       {"value": 188.0, "date": "2024-02-18"},
      //       {"value": 192.0, "date": "2024-02-20"},
      //       {"value": 195.0, "date": "2024-02-22"},
      //       {"value": 198.0, "date": "2024-02-24"},
      //       {"value": 200.0, "date": "2024-02-26"},
      //       {"value": 197.0, "date": "2024-02-28"},
      //       {"value": 193.0, "date": "2024-03-01"},
      //       {"value": 189.0, "date": "2024-03-03"}
      //     ];
      //     break;
      //   case HealthParameter.sugar:
      //     body = [
      //       {"value": 90.0, "date": "2024-02-12"},
      //       {"value": 92.0, "date": "2024-02-14"},
      //       {"value": 95.0, "date": "2024-02-16"},
      //       {"value": 100.0, "date": "2024-02-18"},
      //       {"value": 98.0, "date": "2024-02-20"},
      //       {"value": 105.0, "date": "2024-02-22"},
      //       {"value": 102.0, "date": "2024-02-24"},
      //       {"value": 108.0, "date": "2024-02-26"},
      //       {"value": 110.0, "date": "2024-02-28"},
      //       {"value": 106.0, "date": "2024-03-01"},
      //       {"value": 103.0, "date": "2024-03-03"}
      //     ];
      // }

      Future.delayed(const Duration(seconds: 2));
      final healthReadings = body.isEmpty ? <HealthReadingModel>[] : await Isolate.run(
        () {
          final result = body
              .map((reading) => HealthReadingModel.fromMap(reading))
              .toList();
          result.sort(
            (reading1, reading2) => reading2.date.compareTo(reading1.date),
          );
          return result;
        },
        debugName: "Health Readings Model Mapping Isolate",
      );
      return healthReadings;
    } on Exception catch (e) {
      throw ErrorHandler.serverOrNetworkException(e);
    } catch (e) {
      developer.log(e.toString());
      throw AppException(type: Internal.unknown);
    }
  }
}
