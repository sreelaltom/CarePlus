import 'package:equatable/equatable.dart';

class Nutrition extends Equatable{
  final double calories;
  final double carbohydrates;
  final double proteins;
  final double fats;
  final List<String> vitamins;

  const Nutrition({
    required this.calories,
    required this.carbohydrates,
    required this.proteins,
    required this.fats,
    required this.vitamins,
  });
  
  @override
  List<Object?> get props => [calories, carbohydrates, proteins, fats, vitamins];
}
