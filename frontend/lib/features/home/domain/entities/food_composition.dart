import 'package:frontend/features/home/domain/entities/nutrition.dart';

class FoodComposition {
  final String foodName;
  final Nutrition nutrition;
  final String imageUrl;

  const FoodComposition({required this.imageUrl, required this.foodName, required this.nutrition});
}

