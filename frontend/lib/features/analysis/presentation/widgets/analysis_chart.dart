import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/config/responsive.dart';
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/analysis/presentation/bloc/chart_bloc.dart';

class AnalysisChart extends StatelessWidget {
  const AnalysisChart({super.key});

  @override
  Widget build(BuildContext context) {
    final sWidth = Responsive.screenWidth(context);
    return BlocBuilder<ChartBloc, ChartState>(
      buildWhen: (previous, current) => previous != current,
      builder: (context, state) {
        return Stack(
          alignment: AlignmentDirectional.center,
          children: [
            if (state is ChartLoading || state is ChartError)
              Text(
                state is ChartLoading
                    ? "Loading..."
                    : (state as ChartError).error ?? "Something went wrong!",
                style: Theme.of(context)
                    .textTheme
                    .bodyMedium!
                    .copyWith(color: AppColors.teal),
              ),
            Container(
              height: 400,
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: AppColors.teal, width: 2),
              ),
              child: BlocBuilder<ChartBloc, ChartState>(
                builder: (context, state) {
                  if (state is ChartInitial) {
                    return Center(
                      child: Text(
                        "Select a time range!",
                        style: Theme.of(context)
                            .textTheme
                            .bodyMedium!
                            .copyWith(color: AppColors.white),
                      ),
                    );
                  }
                  if (state is ChartLoaded && state.chartData.isEmpty) {
                    return Center(
                      child: SizedBox(
                        width: sWidth*0.6,
                        child: Text(
                          "No data found for ${state.healthParameter.dropdownValue} from ${state.fromDate.day} ${_getMonth(state.fromDate.month)}, ${state.fromDate.year} - ${state.toDate.day}/${_getMonth(state.toDate.month)}, ${state.toDate.year}",
                          textAlign: TextAlign.center,             
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.white),
                        ),
                      ),
                    );
                  }
                  return LineChart(
                    LineChartData(
                      // minX: state is ChartLoaded ? state.fromDat : null,
                      minY: 0,
                      // maxX: 10,
                      // maxY: 10,
                      borderData: FlBorderData(
                        show: true,
                        border: Border(
                          bottom: BorderSide(color: AppColors.white, width: 2),
                          left: BorderSide(color: AppColors.white, width: 2),
                        ),
                      ),
                      lineBarsData: [
                        LineChartBarData(
                          // show: false,
                          spots: state is ChartLoaded
                              ? state.chartData
                                  .map((point) => FlSpot(point.x, point.y))
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
                        drawHorizontalLine: false,
                        verticalInterval: 2,
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
                              interval: 10,
                              showTitles: true,
                              getTitlesWidget: (currentDateDifference, meta) {
                                if (state is ChartLoaded) {
                                  final currentDate = state.fromDate.add(
                                      Duration(
                                          days: currentDateDifference.toInt()));
                                  if (state.daySpan <= 31) {
                                    return Text(
                                      "${currentDate.day} ${_getMonth(currentDate.month)}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: AppColors.white),
                                    );
                                  } else if (state.daySpan <= 365) {
                                    return Text(
                                      _getMonth(currentDate.month),
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: AppColors.white),
                                    );
                                  } else {
                                    return Text(
                                      "${currentDate.year}",
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodySmall!
                                          .copyWith(color: AppColors.white),
                                    );
                                  }
                                }
                                return const SizedBox();
                              }),
                          // axisNameWidget:
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
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
