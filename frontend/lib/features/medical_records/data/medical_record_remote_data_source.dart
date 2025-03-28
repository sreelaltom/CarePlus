import 'dart:isolate';

import 'package:dio/dio.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'package:frontend/core/errors/error_handler.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/network/api_urls.dart';
import 'package:frontend/core/network/dio_client.dart';
import 'package:frontend/features/medical_records/data/medical_record_model.dart';
import 'dart:developer' as developer;

abstract interface class MedicalRecordRemoteDataSource {
  Future<MedicalRecordModel> upload({
    required String filePath,
    required MedicalRecordType type,
  });

  Future<List<MedicalRecordModel>> getAll();

  Future<String> delete({required int id});
}

class MedicalRecordRemoteDataSourceImplementation
    implements MedicalRecordRemoteDataSource {
  @override
  Future<MedicalRecordModel> upload({
    required String filePath,
    required MedicalRecordType type,
  }) async {
    try {
      final FormData data = FormData.fromMap({
        'file': await MultipartFile.fromFile(filePath),
        'file_type': type.apiValue,
      });

      final client = DioClient();
      final response = await client.post(
        ApiUrls.uploadMedicalRecord,
        data: data,
        options: Options(headers: {'Content-Type': 'multipart/form-data'}),
      );
      final body = response.data as Map<String, dynamic>;
      switch (response.statusCode) {
        case 201:
          return MedicalRecordModel.fromMap(body);
        default:
          throw AppException(type: Internal.unknown);
      }
    } on Exception catch (e) {
      throw ErrorHandler.serverOrNetworkException(e);
    } catch (e) {
      throw AppException<Internal>(type: Internal.unknown);
    }
  }

  @override
  Future<List<MedicalRecordModel>> getAll() async {
    final client = DioClient();
    try {
      final response = await client.get(ApiUrls.getMedicalRecords);
      final body = response.data as List<dynamic>;
      final medicalRecords = await Isolate.run(
        () {
          final result = body
              .map((medicalRecordMap) =>
                  MedicalRecordModel.fromMap(medicalRecordMap))
              .toList();
          result.sort((rec1, rec2) => rec2.createdAt.compareTo(rec1.createdAt));
          return result;
        },
        debugName: "Medical Records Model Mapping Isolate",
      );
      return medicalRecords;
    } on Exception catch (e) {
      throw ErrorHandler.serverOrNetworkException(e);
    } catch (e) {
      developer.log(e.toString());
      throw AppException<Internal>(type: Internal.unknown);
    }
  }

  @override
  Future<String> delete({required int id}) async {
    final client = DioClient();
    try {
      final response = await client.delete(ApiUrls.deleteMedicalRecord(id));
      // final body = response.data as Map<String, String>;
      switch (response.statusCode) {
        case 204:
          return "File Deleted Successfully";
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
