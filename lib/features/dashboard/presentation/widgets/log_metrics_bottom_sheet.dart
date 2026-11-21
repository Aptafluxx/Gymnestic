import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';

class LogMetricsBottomSheet extends StatefulWidget {
  final int currentBpm;
  final int currentWeight;
  final double currentRunningKm;
  final int currentSleepHours;
  final Function(int bpm, int weight, double runningKm, int sleepHours) onSave;

  const LogMetricsBottomSheet({
    super.key,
    required this.currentBpm,
    required this.currentWeight,
    this.currentRunningKm = 0.0,
    this.currentSleepHours = 0,
    required this.onSave,
  });

  @override
  State<LogMetricsBottomSheet> createState() => _LogMetricsBottomSheetState();
}

class _LogMetricsBottomSheetState extends State<LogMetricsBottomSheet> {
  late final TextEditingController bpmController;
  late final TextEditingController weightController;
  late final TextEditingController runningKmController;
  late final TextEditingController sleepHoursController;

  @override
  void initState() {
    super.initState();
    bpmController = TextEditingController(
      text: widget.currentBpm > 0 ? widget.currentBpm.toString() : '',
    );
    weightController = TextEditingController(
      text: widget.currentWeight > 0 ? widget.currentWeight.toString() : '',
    );
    runningKmController = TextEditingController(
      text: widget.currentRunningKm > 0
          ? widget.currentRunningKm.toString()
          : '',
    );
    sleepHoursController = TextEditingController(
      text: widget.currentSleepHours > 0
          ? widget.currentSleepHours.toString()
          : '',
    );
  }

  @override
  void dispose() {
    bpmController.dispose();
    weightController.dispose();
    runningKmController.dispose();
    sleepHoursController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.cardDark,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const ClampingScrollPhysics(),
          padding: EdgeInsets.only(
            left: 24,
            right: 24,
            top: 14,
            bottom: bottomInset + 20,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 38,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    color: AppColors.grayMedium.withValues(alpha: 0.5),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Log Health & Activity',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),
              const Text(
                'Update your daily stats for today',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grayLight,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),

              // Row 1: BPM & Weight
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: bpmController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textWhite),
                      decoration: InputDecoration(
                        labelText: 'Resting BPM',
                        prefixIcon: const Icon(
                          Icons.favorite_outline_rounded,
                          color: AppColors.primaryRed,
                          size: 18,
                        ),
                        labelStyle: const TextStyle(
                          color: AppColors.grayLight,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: weightController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textWhite),
                      decoration: InputDecoration(
                        labelText: 'Weight (kg/lbs)',
                        prefixIcon: const Icon(
                          Icons.monitor_weight_outlined,
                          color: AppColors.primaryRed,
                          size: 18,
                        ),
                        labelStyle: const TextStyle(
                          color: AppColors.grayLight,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // Row 2: Running Km & Sleep Hours
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: runningKmController,
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      style: const TextStyle(color: AppColors.textWhite),
                      decoration: InputDecoration(
                        labelText: 'Running (Km)',
                        prefixIcon: const Icon(
                          Icons.directions_run_rounded,
                          color: AppColors.primaryRed,
                          size: 18,
                        ),
                        labelStyle: const TextStyle(
                          color: AppColors.grayLight,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: sleepHoursController,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(color: AppColors.textWhite),
                      decoration: InputDecoration(
                        labelText: 'Sleep (Hours)',
                        prefixIcon: const Icon(
                          Icons.nightlight_round,
                          color: AppColors.primaryRed,
                          size: 18,
                        ),
                        labelStyle: const TextStyle(
                          color: AppColors.grayLight,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: AppColors.surfaceDark,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 22),

              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  minimumSize: const Size(double.infinity, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  final bpm =
                      int.tryParse(bpmController.text.trim()) ??
                      widget.currentBpm;
                  final weight =
                      int.tryParse(weightController.text.trim()) ??
                      widget.currentWeight;
                  final runningKm =
                      double.tryParse(runningKmController.text.trim()) ??
                      widget.currentRunningKm;
                  final sleepHours =
                      int.tryParse(sleepHoursController.text.trim()) ??
                      widget.currentSleepHours;

                  widget.onSave(bpm, weight, runningKm, sleepHours);
                  Get.back();
                },
                child: const Text(
                  'Save Daily Stats',
                  style: TextStyle(
                    fontWeight: FontWeight.w700,
                    color: AppColors.textWhite,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
