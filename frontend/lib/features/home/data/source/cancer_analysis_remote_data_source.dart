import 'package:dio/dio.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/errors/error_handler.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/network/api_urls.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/features/home/data/models/cancer_analysis_model.dart';

abstract interface class CancerAnalysisRemoteDataSource {
  Future<CancerAnalysisModel> predictCancer({
    required String filePath,
    required CtScanCategory category,
  });
}

class CancerAnalysisRemoteDataSourceImplementation
    implements CancerAnalysisRemoteDataSource {
  @override
  Future<CancerAnalysisModel> predictCancer({
    required String filePath,
    required CtScanCategory category,
  }) async {
    try {
      final client = DioClient();
      final data = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'model_type': category.apiValue,
      });
      final response = await client.post(ApiUrls.predictCancer, data: data);
      final body = response.data as Map<String, dynamic>;
      switch (response.statusCode) {
        case 200:
          return CancerAnalysisModel.fromMap(body);
        default:
          throw AppException(type: Internal.unknown);
      }
    } on Exception catch (e) {
      throw ErrorHandler.serverOrNetworkException(e);
    } catch (e) {
      throw AppException(type: Internal.unknown);
    }
  }
}
