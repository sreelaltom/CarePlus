import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart' show HealthParameter;
import 'package:frontend/features/analysis/domain/get_health_readings_use_case.dart';
import 'package:frontend/features/analysis/domain/entities/chart_point.dart';
import 'package:frontend/service_locator.dart';

part 'chart_event.dart';
part 'chart_state.dart';

class ChartBloc extends Bloc<ChartEvent, ChartState> {
  ChartBloc() : super(ChartInitial()) {
    on<LoadChartData>(_loadChartData);
    // on<AddChartData>(_addChartData);
  }
  Future<void> _loadChartData(
    LoadChartData event,
    Emitter<ChartState> emit,
  ) async {
    emit(ChartLoading());
    final response = await serviceLocator<GetHealthReadingsUseCase>().call(
      parameter: event.healthParameter,
      fromDate: event.fromDate,
      toDate: event.toDate,
    );
    response.fold(
      (error) => emit(ChartError(error: error)),
      (chartPoints) => emit(
        ChartLoaded(
          healthParameter: event.healthParameter,
          chartData: chartPoints,
          fromDate: event.fromDate,
          toDate: event.toDate,
        ),
      ),
    );
  }

  // Future<void> _addChartData(
  //   AddChartData event,
  //   Emitter<ChartState> emit,
  // ) async {
  //   if (state is ChartLoaded) {
  //     final currentState = state as ChartLoaded;
  //     if (currentState.fromDate.isBefore(DateTime.now()) &&
  //         currentState.toDate.isAfter(DateTime.now())) {
  //       emit(
  //         ChartLoaded(
  //           healthParameter = event.healthParameter,
  //           chartData:
  //               List.from([...currentState.chartData, event.newChartPoint]),
  //           fromDate: currentState.fromDate,
  //           toDate: currentState.toDate,
  //         ),
  //       );
  //     }
  //   }
  // }
}
