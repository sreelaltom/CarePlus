import 'dart:convert';

import 'package:frontend/core/common/app_extensions.dart';
import 'package:frontend/features/medical_records/domain/medical_record.dart';

class MedicalRecordModel extends MedicalRecord {
  const MedicalRecordModel({
    required super.type,
    required super.url,
    required super.createdAt,
    required super.id,
    // required super.fileName,
  });

  factory MedicalRecordModel.fromMap(Map<String, dynamic> map) =>
      MedicalRecordModel(
        id: map['id'],
        type: map['file_type'].toString().toMedicalRecordType!,
        url: map['cloudinary_url']!,
        createdAt: DateTime.parse(map['uploaded_at']) ,
        // fileName: map['file_name']!,
      );
  Map<String, dynamic> toMap() => {
        'id' : id,
        'type': type.apiValue,
        'cloudinary_url': url,
        'uploaded_at' : createdAt.toIso8601String(),
        // 'file_name': fileName,
      };

  factory MedicalRecordModel.fromJson(String source) =>
      MedicalRecordModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  String toJson() => jsonEncode(toMap());
}
