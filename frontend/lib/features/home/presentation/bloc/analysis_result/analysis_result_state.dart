import 'package:equatable/equatable.dart';
import 'package:frontend/features/home/domain/entities/cancer_analysis.dart';
import 'package:frontend/features/home/domain/entities/food_composition.dart';

abstract class AnalysisResultState extends Equatable {}

class AnalysisResultInitial extends AnalysisResultState {
  @override
  List<Object?> get props => [];
}

class AnalysisResultLoading extends AnalysisResultState {
  final String message;

  AnalysisResultLoading({required this.message});
  @override
  List<Object?> get props => [message];
}

class AnalysisResultLoaded extends AnalysisResultState {
  final CancerAnalysis? analysis;
  final FoodComposition? foodComposition;

  AnalysisResultLoaded({this.analysis, this.foodComposition});
  
  @override
  List<Object?> get props => [analysis, foodComposition];
}

class AnalysisResultError extends AnalysisResultState {
  final String error;
  AnalysisResultError({required this.error});
  @override
  List<Object?> get props => [error];
}
