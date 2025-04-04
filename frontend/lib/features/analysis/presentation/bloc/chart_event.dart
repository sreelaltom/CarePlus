part of "chart_bloc.dart";

abstract class ChartEvent extends Equatable {}

class LoadChartData extends ChartEvent {
  final HealthParameter healthParameter;
  final DateTime fromDate;
  final DateTime toDate;

  LoadChartData({
    required this.healthParameter,
    required this.fromDate,
    required this.toDate,
  });

  @override
  List<Object?> get props => [healthParameter, fromDate, toDate];
}

class AddChartData extends ChartEvent {
  final ChartPoint newChartPoint;

  AddChartData({required this.newChartPoint});
  
  @override
  List<Object?> get props => [newChartPoint];
}
