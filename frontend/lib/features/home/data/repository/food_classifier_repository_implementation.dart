import 'package:dartz/dartz.dart';
import 'package:frontend/core/errors/exceptions.dart';
import 'package:frontend/core/errors/failures.dart';
import 'package:frontend/features/home/data/source/food_remote_data_source.dart';
import 'package:frontend/features/home/domain/entities/food_composition.dart';
import 'package:frontend/features/home/domain/repository/food_classifier_repository.dart';
import 'package:frontend/service_locator.dart';

class FoodClassifierRepositoryImplementation
    implements FoodClassifierRepository {
  @override
  Future<Either<Failure, FoodComposition>> classifyFood(
      {required String filePath}) async {
    try {
      final foodComposition = await serviceLocator<FoodRemoteDataSource>()
          .classifyFood(filePath: filePath);
      return Right(foodComposition);
    } on AppException catch (e) {
      return Left(Failure.from(e));
    }
  }
}
