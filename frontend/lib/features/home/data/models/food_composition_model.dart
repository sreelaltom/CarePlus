import 'dart:convert';

import 'package:frontend/features/home/data/models/nutrition_model.dart';
import 'package:frontend/features/home/domain/entities/food_composition.dart';

class FoodCompositionModel extends FoodComposition {
  FoodCompositionModel(
      {required super.imageUrl,
      required super.foodName,
      required super.nutrition});

  factory FoodCompositionModel.fromMap(Map<String, dynamic> map) {
    return FoodCompositionModel(
      imageUrl: map['image_url'],
      foodName: map['prediction'],
      nutrition: NutritionModel.fromMap(map['nutririons']),
    );
  }

  factory FoodCompositionModel.fromJson(String source) =>
      FoodCompositionModel.fromMap(jsonDecode(source) as Map<String, dynamic>);

  // Map<String, dynamic> toMap() => <String, dynamic>{
  //       'imageUrl': imageUrl,
  //       'foodName': foodName,
  //       'nutririons': nutrition.toMap(),
  //     };
}
