import 'package:equatable/equatable.dart';

class CancerAnalysis extends Equatable{
  final String prediction;
  final String url;

  const CancerAnalysis({required this.prediction, required this.url});
  
  @override
  List<Object?> get props => [prediction, url];
}
