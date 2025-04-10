import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/analysis/presentation/bloc/chart_bloc.dart';
import 'dart:developer' as developer show log;

typedef RefreshAction = void Function();

class AnalysisChart extends StatelessWidget {
  final RefreshAction? refreshAction;
  const AnalysisChart({super.key, this.refreshAction});

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    return BlocBuilder<ChartBloc, ChartState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            if (state is ChartLoading)
              Text(
                "Loading...",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.teal),
              ),
            Container(
              height: 500,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.teal, width: 2),
              ),
              child: BlocBuilder<ChartBloc, ChartState>(
                builder: (context, state) {
                  if (state is ChartInitial ||
                      (state is ChartLoaded && state.chartData.isEmpty) ||
                      state is ChartError) {
                    return Center(
                      child: SizedBox(
                        width: sWidth * 0.6,
                        child: Text(
                          textAlign: TextAlign.center,
                          state is ChartInitial
                              ? "Select a time range!"
                              : (state is ChartLoaded
                                  ? 'No data found for ${(state).healthParameter.dropdownValue} from ${state.fromDate.day} ${_getMonth(state.fromDate.month)}, ${state.fromDate.year} - ${state.toDate.day} ${_getMonth(state.toDate.month)}, ${state.toDate.year}'
                                  : (state as ChartError).error ??
                                      "Something went wrong!"),
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(
                                  color: state is ChartError
                                      ? AppColors.error
                                      : AppColors.white),
                        ),
                      ),
                    );
                  }
                  return Column(
                    children: [
                      if(state is ChartLoaded)
                      Align(
                        alignment: Alignment.topRight,
                        child: IconButton(
                          onPressed: refreshAction,
                          icon: const Icon(
                            Icons.refresh_outlined,
                            color: AppColors.teal,
                          ),
                        ),
                      ),
                      Expanded(
                        child: LineChart(
                          duration: const Duration(milliseconds: 100),
                          
                          LineChartData(
                            minY: 0,
                            
                            borderData: FlBorderData(
                              show: true,
                              border: Border(
                                bottom: BorderSide(
                                    color: AppColors.white, width: 2),
                                left: BorderSide(
                                    color: AppColors.white, width: 2),
                              ),
                            ),
                            lineTouchData: State is ChartLoaded
                                ? LineTouchData(
                                    
                                    enabled: true,
                                    touchTooltipData: LineTouchTooltipData(
                                      getTooltipItems: (touchedSpots) {
                                        final date = (state as ChartLoaded)
                                            .fromDate
                                            .add(Duration(
                                                days: touchedSpots.first.x
                                                    .toInt()))
                                            .toString()
                                            .split(' ')[0];
                                        return touchedSpots.map(
                                          (spot) {
                                            return LineTooltipItem(
                                              " $date \n${spot.y.toStringAsFixed(1)} ",
                                              const TextStyle(
                                                color: AppColors.white,
                                              ),
                                            );
                                          },
                                        ).toList();
                                      },
                                    ),
                                    // handleBuiltInTouches: true,
                                    touchCallback: (event, response) {
                                      developer.log("Touched spot: $response");
                                    },
                                  )
                                : const LineTouchData(enabled: false),
                            lineBarsData: [
                              LineChartBarData(
                                // show: false,
                                spots: state is ChartLoaded
                                    ? state.chartData
                                        .map(
                                            (point) => FlSpot(point.x, point.y))
                                        .toList()
                                    : [],
                                isCurved: true,
                                color: AppColors.error,
                                barWidth: 2,
                                belowBarData: BarAreaData(
                                  show: true,
                                  color: AppColors.transparent,
                                ),
                              ),
                            ],
                            betweenBarsData: [],
                            gridData: FlGridData(
                              drawVerticalLine: true,
                              drawHorizontalLine: true,
                              verticalInterval: 5,
                            ),
                            titlesData: FlTitlesData(
                              show: true,
                              rightTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              topTitles: AxisTitles(
                                sideTitles: SideTitles(showTitles: false),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                    interval: state is ChartLoaded
                                        ? _getInterval(
                                            totalDays:
                                                state.chartData.first.x.toInt())
                                        : null,
                                    showTitles: true,
                                    getTitlesWidget:
                                        (currentDateDifference, meta) {
                                      if (state is ChartLoaded) {
                                        final currentDate = state.fromDate.add(
                                            Duration(
                                                days: currentDateDifference
                                                    .toInt()));
                                        if (state.daySpan <= 31) {
                                          return Padding(
                                            padding:
                                                const EdgeInsets.only(top: 8.0),
                                            child: Text(
                                              "${currentDate.day} ${_getMonth(currentDate.month)}",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall!
                                                  .copyWith(
                                                      color: AppColors.white),
                                            ),
                                          );
                                        } else if (state.daySpan <= 365) {
                                          return Text(
                                            _getMonth(currentDate.month),
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: AppColors.white),
                                          );
                                        } else {
                                          return Text(
                                            "${currentDate.year}",
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall!
                                                .copyWith(
                                                    color: AppColors.white),
                                          );
                                        }
                                      }
                                      return const SizedBox();
                                    }),
                                // axisNameWidget:
                              ),
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  interval: 6,
                                  showTitles: true,
                                  getTitlesWidget: (value, meta) => Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text(
                                      value.toStringAsFixed(0),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: AppColors.white),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

const months = [
  "Jan",
  "Feb",
  "Mar",
  "Apr",
  "May",
  "Jun",
  "Jul",
  "Aug",
  "Sep",
  "Oct",
  "Nov",
  "Dec"
];

String _getMonth(int num) => months[num - 1];

double _getInterval({required int totalDays}) {
  if (totalDays <= 31) {
    return (totalDays / 4).ceilToDouble();
  } else if (totalDays <= 365) {
    return (totalDays / 2).ceilToDouble();
  } else {
    return 30;
  }
}
