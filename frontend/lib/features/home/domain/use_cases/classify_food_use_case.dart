import 'package:dartz/dartz.dart';
import 'package:frontend/features/home/domain/entities/food_composition.dart';
import 'package:frontend/features/home/domain/repository/food_classifier_repository.dart';
import 'package:frontend/service_locator.dart';

class ClassifyFoodUseCase {
  Future<Either<String, FoodComposition>> call({
    required String filePath,
  }) async {
    final response = await serviceLocator<FoodClassifierRepository>()
        .classifyFood(filePath: filePath);
    return response.fold(
      (error) => Left(error.message),
      (foodComposition) => Right(foodComposition),
    );
  }
}
