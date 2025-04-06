import 'dart:convert';

import 'package:frontend/features/home/domain/entities/nutrition.dart';

class NutritionModel extends Nutrition {
  const NutritionModel(
      {required super.calories,
      required super.carbohydrates,
      required super.proteins,
      required super.fats,
      required super.vitamins});

  factory NutritionModel.fromMap(Map<String, dynamic> map) => NutritionModel(
        calories: (map['calories'] as int).toDouble(),
        carbohydrates: (map['carbohydrates']).toDouble(),
        proteins: (map['proteins']).toDouble(),
        fats: (map['fats']).toDouble(),
        vitamins:(map['vitamins'] as List<dynamic>).map((vitamin) => vitamin.toString()).toList(),
      );

  factory NutritionModel.fromJson(String source) =>
      NutritionModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  Map<String, dynamic> toMap() => <String, dynamic>{
        'calories': calories,
        'carbohydrates': carbohydrates,
        'proteins': proteins,
        'fats': fats,
        'vitamins': vitamins,
      };

  String toJson() => jsonEncode(toMap());
}
