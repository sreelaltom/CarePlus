import 'package:dio/dio.dart';
import 'package:frontend/core/errors/error_handler.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/network/api_urls.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/features/home/data/models/food_composition_model.dart';
import 'dart:developer' as developer show log;

abstract interface class FoodRemoteDataSource {
  Future<FoodCompositionModel> classifyFood({required String filePath});
}

class FoodRemoteDataSourceImplementation implements FoodRemoteDataSource {
  @override
  Future<FoodCompositionModel> classifyFood({required String filePath}) async {
    try {
      final client = DioClient();
      final data = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
      });
      final response = await client.post(ApiUrls.classifyFood, data: data);
      final body = response.data as Map<String, dynamic>;
      switch (response.statusCode) {
        case 201:
          return FoodCompositionModel.fromMap(body);
        default:
          throw AppException(type: Internal.unknown);
      }
    } on AppException catch (e) {
      throw ErrorHandler.serverOrNetworkException(e);
    } catch (e) {
      developer.log(e.toString());
      throw AppException(type: Internal.unknown);
    }
  }
}
