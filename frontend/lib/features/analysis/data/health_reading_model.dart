import 'dart:convert';

import 'package:frontend/features/analysis/domain/entities/health_reading.dart';

class HealthReadingModel extends HealthReading {
  const HealthReadingModel({required super.value, required super.date});

  factory HealthReadingModel.fromMap(Map<String, dynamic> map) =>
      HealthReadingModel(
        value: map['value'] as double,
        date: DateTime.parse(map['date']),
      );

  factory HealthReadingModel.fromJson(String source) =>
      HealthReadingModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => {'value': value, 'date': date};
}
