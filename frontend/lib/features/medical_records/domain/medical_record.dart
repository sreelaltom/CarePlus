import 'package:frontend/core/common/app_enums.dart';

class MedicalRecord {
  final int id;
  final MedicalRecordType type;
  final String url;
  final DateTime createdAt;
  // final String fileName;

  const MedicalRecord({
    required this.id,
    required this.type,
    required this.url,
    required this.createdAt,
    // required this.fileName,
  });
}
