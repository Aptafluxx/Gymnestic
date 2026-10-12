import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';

class LogMetricsBottomSheet extends StatefulWidget {
  final int currentBpm;
  final int currentWeight;
  final Function(int bpm, int weight) onSave;

  const LogMetricsBottomSheet({
    super.key,
    required this.currentBpm,
    required this.currentWeight,
    required this.onSave,
  });

  @override
  State<LogMetricsBottomSheet> createState() => _LogMetricsBottomSheetState();
}

class _LogMetricsBottomSheetState extends State<LogMetricsBottomSheet> {
  late final TextEditingController bpmController;
  late final TextEditingController weightController;

  @override
  void initState() {
    super.initState();
    bpmController = TextEditingController(
      text: widget.currentBpm > 0 ? widget.currentBpm.toString() : '',
    );
    weightController = TextEditingController(
      text: widget.currentWeight > 0 ? widget.currentWeight.toString() : '',
    );
  }

  @override
  void dispose() {
    bpmController.dispose();
    weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Read the soft keyboard height dynamically
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
              // Bottom sheet grab handle bar
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

              // Title
              const Text(
                'Log Health Metrics',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 6),

              // Subtitle
              const Text(
                'Update your resting heart rate and current weight',
                style: TextStyle(
                  fontSize: 12,
                  color: AppColors.grayLight,
                  fontFamily: 'Montserrat',
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 22),

              // Resting BPM Input Field
              TextField(
                controller: bpmController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Resting BPM',
                  hintText: 'e.g. 72',
                  prefixIcon: const Icon(
                    Icons.favorite_outline_rounded,
                    color: AppColors.primaryRed,
                    size: 20,
                  ),
                  labelStyle: const TextStyle(color: AppColors.grayLight),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primaryRed,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 14),

              // Weight Input Field
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                style: const TextStyle(
                  color: AppColors.textWhite,
                  fontWeight: FontWeight.w600,
                ),
                decoration: InputDecoration(
                  labelText: 'Current Weight (kg/lbs)',
                  hintText: 'e.g. 120',
                  prefixIcon: const Icon(
                    Icons.monitor_weight_outlined,
                    color: AppColors.primaryRed,
                    size: 20,
                  ),
                  labelStyle: const TextStyle(color: AppColors.grayLight),
                  filled: true,
                  fillColor: AppColors.surfaceDark,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide.none,
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(
                      color: AppColors.primaryRed,
                      width: 1.2,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              // Save Record Action Button
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primaryRed,
                  minimumSize: const Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  elevation: 0,
                ),
                onPressed: () {
                  final bpm =
                      int.tryParse(bpmController.text.trim()) ??
                      widget.currentBpm;
                  final weight =
                      int.tryParse(weightController.text.trim()) ??
                      widget.currentWeight;
                  widget.onSave(bpm, weight);
                  Get.back();
                },
                child: const Text(
                  'Save Record',
                  style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
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
