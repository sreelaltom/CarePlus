import 'package:equatable/equatable.dart';

class ChartPoint extends Equatable {
  final double x;
  final double y;

  const ChartPoint({required this.x, required this.y});
  
  @override
  List<Object?> get props => [x, y];
}
