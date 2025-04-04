part of 'chart_bloc.dart';

abstract class ChartState extends Equatable {}

class ChartInitial extends ChartState {
  @override
  List<Object?> get props => [];
}

class ChartLoading extends ChartState {
  @override
  List<Object?> get props => [];
}

class ChartLoaded extends ChartState {
  final HealthParameter healthParameter;
  final List<ChartPoint> chartData;
  final DateTime fromDate;
  final DateTime toDate;
  late final int daySpan;

  ChartLoaded({
    required this.healthParameter,
    required this.chartData,
    required this.fromDate,
    required this.toDate,
  }) : daySpan = fromDate.difference(toDate).inDays;

  @override
  List<Object?> get props => [chartData];
}

class ChartError extends ChartState {
  final String? error;

  ChartError({this.error});
  @override
  List<Object?> get props => [error];
}
