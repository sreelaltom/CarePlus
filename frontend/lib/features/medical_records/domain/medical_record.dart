import 'package:equatable/equatable.dart';
import 'package:frontend/core/common/app_enums.dart';

class MedicalRecord extends Equatable{
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
  
  @override
  List<Object?> get props => [id, type, url, createdAt];
}
