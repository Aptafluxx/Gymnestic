import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/widgets/app_text_field.dart';

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
              AppTextField(
                controller: bpmController,
                hintText: "Resting BPM e.g. 72",
                prefixIcon: Icons.favorite_outline_rounded,
                keyboardType: .number,
              ),
              const SizedBox(height: 14),
              AppTextField(
                controller: weightController,
                hintText: "Current Weight (kg/lbs) e.g. 120",
                prefixIcon: Icons.favorite_outline_rounded,
                keyboardType: .number,
              ),
              const SizedBox(height: 24),
              ElevatedButton(
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
                child: const Text('Save Record'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
