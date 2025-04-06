import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/home/domain/entities/food_composition.dart';

abstract interface class FoodClassifierRepository {
  Future<Either<Failure, FoodComposition>> classifyFood({
    required String filePath,
  });
}
