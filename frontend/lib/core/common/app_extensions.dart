import 'package:flutter/material.dart';
import 'package:frontend/core/common/app_enums.dart';
import 'dart:developer' as developer;

extension StringExtension on String {
  String get capitalize =>
      isEmpty ? this : this[0].toUpperCase() + substring(1);

  MedicalRecordType? get toMedicalRecordType => MedicalRecordType.values
          .map((value) => value.apiValue)
          .toList()
          .contains(this)
      ? MedicalRecordType.values.firstWhere((value) => value.apiValue == this)
      : null;
}

extension MapExtension on Map {
  void log() {
    developer.log("{");
    forEach((key, value) => developer.log("\t$key: $value"));
    developer.log("}");
  }
}
