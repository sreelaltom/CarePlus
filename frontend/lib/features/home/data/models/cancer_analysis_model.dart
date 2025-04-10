import 'dart:convert';

import 'package:frontend/features/home/domain/entities/cancer_analysis.dart';

class CancerAnalysisModel extends CancerAnalysis {
  const CancerAnalysisModel({required super.prediction, required super.url});

  factory CancerAnalysisModel.fromMap(Map<String, dynamic> map) {
    return CancerAnalysisModel(
      prediction: map['prediction'] as String,
      url: map['image_url'] as String,
    );
  }

  factory CancerAnalysisModel.fromJson(String source) {
    return CancerAnalysisModel.fromMap(jsonDecode(source) as Map<String, dynamic>);
  }

  Map<String, dynamic> toMap() => {'prediction': prediction, 'image_url': url};

  String toJson() => jsonEncode(toMap());
}