import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/core/common/app_enums.dart' show HealthParameter;
import 'package:frontend/core/theme/app_colors.dart';
import 'package:frontend/features/analysis/presentation/bloc/chart_bloc.dart';
import 'package:frontend/features/analysis/presentation/widgets/analysis_chart.dart';
import 'package:frontend/features/analysis/presentation/widgets/date_selector.dart';
import 'package:frontend/features/medical_records/presentation/widgets/app_dropdown.dart';

class AnalysisPage extends StatefulWidget {
  const AnalysisPage({super.key});

  @override
  State<AnalysisPage> createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  late final ValueNotifier<HealthParameter> _parameterSelectionNotifier;
  late final ValueNotifier<DateTime?> _fromDateNotifier;
  late final ValueNotifier<DateTime?> _toDateNotifier;
  late final TextEditingController _fromDateController;
  late final TextEditingController _toDateController;

  @override
  void initState() {
    _parameterSelectionNotifier = ValueNotifier(HealthParameter.calcium);
    _fromDateNotifier = ValueNotifier(null);
    _toDateNotifier = ValueNotifier(null);
    _fromDateController = TextEditingController();
    _toDateController = TextEditingController();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            spacing: 8,
            children: [
              AppDropdown(
                selectionNotifier: _parameterSelectionNotifier,
                borderRadius: 20,
                onChanged: (value) {
                  if (value != null) {
                    _parameterSelectionNotifier.value = value;
                    if (_fromDateController.text.isNotEmpty &&
                        _toDateController.text.isNotEmpty) {
                      context.read<ChartBloc>().add(
                            LoadChartData(
                              healthParameter: value,
                              fromDate:
                                  DateTime.tryParse(_fromDateController.text)!,
                              toDate:
                                  DateTime.tryParse(_toDateController.text)!,
                            ),
                          );
                    }
                  }
                },
                items: HealthParameter.values
                    .map(
                      (parameter) => DropdownMenuItem(
                        value: parameter,
                        child: Text(
                          parameter.dropdownValue,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(color: AppColors.white),
                        ),
                      ),
                    )
                    .toList(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                spacing: 8,
                children: [
                  ValueListenableBuilder(
                    valueListenable: _toDateNotifier,
                    builder: (_, toDate, __) {
                      return DateSelector(
                        label: "From",
                        controller: _fromDateController,
                        onTap: () => _pickDate(
                          context,
                          isFromDate: true,
                          parameterSelectionNotifier:
                              _parameterSelectionNotifier,
                          initialDateNotifier: _fromDateNotifier,
                          selfController: _fromDateController,
                          otherPickerController: _toDateController,
                          lastDate: toDate,
                        ),
                      );
                    },
                  ),
                  ValueListenableBuilder(
                    valueListenable: _fromDateNotifier,
                    builder: (_, fromDate, __) {
                      return DateSelector(
                        onTap: () => _pickDate(
                          context,
                          parameterSelectionNotifier:
                              _parameterSelectionNotifier,
                          initialDateNotifier: _toDateNotifier,
                          otherPickerController: _fromDateController,
                          selfController: _toDateController,
                          firstDate: fromDate,
                        ),
                        enabled: fromDate != null,
                        label: "To",
                        firstDate: fromDate,
                        controller: _toDateController,
                      );
                    },
                  ),
                ],
              ),
              AnalysisChart(
                refreshAction: () {
                  if (_fromDateNotifier.value != null &&
                      _toDateNotifier.value != null) {
                    context.read<ChartBloc>().add(
                          LoadChartData(
                            healthParameter: _parameterSelectionNotifier.value,
                            fromDate: _fromDateNotifier.value!,
                            toDate: _toDateNotifier.value!,
                          ),
                        );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _parameterSelectionNotifier.dispose();
    _fromDateNotifier.dispose();
    _toDateNotifier.dispose();
    _fromDateController.dispose();
    _toDateController.dispose();
    super.dispose();
  }
}

void _pickDate(
  BuildContext context, {
  required ValueNotifier<HealthParameter> parameterSelectionNotifier,
  required ValueNotifier<DateTime?> initialDateNotifier,
  required TextEditingController selfController,
  TextEditingController? otherPickerController,
  DateTime? firstDate,
  DateTime? lastDate,
  bool isFromDate = false,
}) async {
  final selectedDate = await showDatePicker(
    context: context,
    initialDate: initialDateNotifier.value ?? DateTime.now(),
    firstDate: firstDate ?? DateTime(2000),
    lastDate: lastDate ?? DateTime.now(),
  );
  if (selectedDate != null) {
    initialDateNotifier.value = selectedDate;
    if (isFromDate) {
      otherPickerController?.text = '';
    }
    selfController.text = selectedDate
        .toIso8601String()
        .split('T')[0]
        .split('-')
        .reversed
        .join('/');
    if (otherPickerController?.text.isNotEmpty ?? false) {
      if (context.mounted) {
        context.read<ChartBloc>().add(
              LoadChartData(
                healthParameter: parameterSelectionNotifier.value,
                fromDate:
                    isFromDate ? selectedDate : firstDate ?? DateTime.now(),
                toDate: isFromDate
                    ? DateTime.tryParse(otherPickerController!.text
                        .split('/')
                        .reversed
                        .join('-'))!
                    : selectedDate,
              ),
            );
      }
    }
  }
}
