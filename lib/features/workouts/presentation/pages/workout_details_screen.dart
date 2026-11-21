import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/core/widgets/section_heading.dart';
import 'package:gymnestic/features/workouts/presentation/controllers/workout_details_controller.dart';

class WorkoutDetailsScreen extends GetView<WorkoutDetailsController> {
  const WorkoutDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: Get.back,
        icon: const Icon(Icons.arrow_back_ios_new, size: 19),
      ),
      // Dynamically displays the tapped program title in the AppBar
      title: Obx(() => Text(controller.activeProgram.value.title)),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 14, 18, 24),
        children: [
          // Gender Toggle
          Obx(
            () => Container(
              height: 58,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                children: [
                  _GenderButton(
                    label: 'Male',
                    icon: Icons.male,
                    selected: controller.selectedGender.value == 'Male',
                    onTap: () => controller.setGender('Male'),
                  ),
                  const SizedBox(width: 5),
                  _GenderButton(
                    label: 'Female',
                    icon: Icons.female,
                    selected: controller.selectedGender.value == 'Female',
                    onTap: () => controller.setGender('Female'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Dynamic Section Heading
          Obx(
            () => SectionHeading(
              title: 'Daily Goals',
              subtitle:
                  '${controller.activeProgram.value.level} • ${controller.completedGoalsCount}/${controller.totalGoalsCount} completed',
            ),
          ),
          const SizedBox(height: 17),

          // Dynamic Goals Checklist
          Obx(
            () => Column(
              children: controller.dailyGoals
                  .map(
                    (goal) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => controller.toggleGoalStatus(goal.id),
                        child: Container(
                          height: 58,
                          padding: const EdgeInsets.symmetric(horizontal: 13),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceDark,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Text(
                                goal.time,
                                style: const TextStyle(
                                  color: AppColors.grayLighter,
                                  fontSize: 11,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                height: 25,
                                width: 1,
                                color: AppColors.grayDark,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      goal.title,
                                      style: const TextStyle(fontSize: 12),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '+${goal.calorieReward} KCAL',
                                      style: const TextStyle(
                                        fontSize: 10,
                                        color: AppColors.primaryRed,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Icon(
                                goal.isCompleted
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: goal.isCompleted
                                    ? AppColors.primaryRed
                                    : AppColors.grayLight,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

class _GenderButton extends StatelessWidget {
  const _GenderButton({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Expanded(
    child: InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        decoration: BoxDecoration(
          color: selected ? Colors.black : Colors.transparent,
          border: Border.all(
            color: selected ? AppColors.primaryRed : Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: selected ? AppColors.primaryRed : AppColors.grayLight,
            ),
            const SizedBox(width: 7),
            Text(
              label,
              style: TextStyle(
                fontSize: 10,
                color: selected ? AppColors.primaryRed : AppColors.grayLight,
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
