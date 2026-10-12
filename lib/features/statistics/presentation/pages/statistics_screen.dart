import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/core/widgets/section_heading.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gymnestic/features/statistics/presentation/controllers/statistics_controller.dart';

class StatisticsScreen extends GetView<StatisticsController> {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          if (Get.currentRoute == AppRoutes.home &&
              Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().selectTab(0);
          } else {
            Get.back();
          }
        },
        icon: const Icon(Icons.arrow_back_ios_new, size: 19),
      ),
      title: const Text('Building Progress'),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 22),
        children: [
          Obx(
            () => Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  SizedBox(
                    width: 105,
                    height: 105,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 92,
                          height: 92,
                          child: CircularProgressIndicator(
                            value: (controller.overallProgressPercentage / 100)
                                .clamp(0.0, 1.0),
                            strokeWidth: 8,
                            strokeCap: StrokeCap.round,
                            backgroundColor: AppColors.grayDark,
                            valueColor: const AlwaysStoppedAnimation(
                              AppColors.primaryRed,
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              '${controller.overallProgressPercentage.round()}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const Text(
                              'percent',
                              style: TextStyle(
                                fontSize: 9,
                                color: AppColors.grayLight,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Total Activity',
                          style: TextStyle(
                            color: AppColors.grayLighter,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${controller.completedActivity.value} / ${controller.totalActivity.value}',
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 12),
                        const Text(
                          'Calories Burned',
                          style: TextStyle(
                            color: AppColors.grayLighter,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          '${controller.caloriesBurned.value} KCAL',
                          style: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 11),
          Obx(
            () => Row(
              children: [
                Expanded(
                  child: _MetricCard(
                    icon: Icons.directions_run_rounded,
                    value:
                        '${controller.runningDistanceKm.value.toStringAsFixed(0)} / ${controller.targetDistanceKm.value.toStringAsFixed(0)} Km',
                    calories: '${controller.runningCaloriesBurned.value} KCAL',
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _MetricCard(
                    icon: Icons.nightlight_round,
                    value:
                        '${controller.sleepHours.value} / ${controller.targetSleepHours.value} hrs',
                    calories: '${controller.sleepCaloriesBurned.value} KCAL',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const SectionHeading(title: 'Monitoring', subtitle: 'Daily progress'),
          const SizedBox(height: 13),
          SizedBox(
            height: 185,
            child: Obx(
              () => Container(
                padding: const EdgeInsets.fromLTRB(14, 17, 14, 12),
                decoration: BoxDecoration(
                  color: AppColors.surfaceDark,
                  borderRadius: BorderRadius.circular(15),
                ),
                child: BarChart(
                  BarChartData(
                    maxY: 12,
                    minY: 0,
                    gridData: const FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                    barTouchData: BarTouchData(
                      touchCallback: (event, response) {
                        final index = response?.spot?.touchedBarGroupIndex;
                        if (index != null) controller.selectDay(index);
                      },
                      touchTooltipData: BarTouchTooltipData(
                        getTooltipItem: (group, groupIndex, rod, rodIndex) =>
                            null,
                      ),
                    ),
                    titlesData: FlTitlesData(
                      leftTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: 22,
                          getTitlesWidget: (value, meta) {
                            final index = value.toInt();
                            if (index < 0 ||
                                index >= controller.weeklyData.length) {
                              return const SizedBox.shrink();
                            }
                            return SideTitleWidget(
                              meta: meta,
                              child: Text(
                                controller.weeklyData[index].dayName,
                                style: TextStyle(
                                  color: controller.weeklyData[index].isSelected
                                      ? AppColors.primaryRed
                                      : AppColors.grayLighter,
                                  fontSize: 9,
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                    barGroups: List.generate(controller.weeklyData.length, (
                      index,
                    ) {
                      final stat = controller.weeklyData[index];
                      return BarChartGroupData(
                        x: index,
                        barRods: [
                          BarChartRodData(
                            toY: stat.value,
                            width: 9,
                            color: stat.isSelected
                                ? AppColors.primaryRed
                                : AppColors.grayDark,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                      );
                    }),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({
    required this.icon,
    required this.value,
    required this.calories,
  });

  final IconData icon;
  final String value;
  final String calories;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(12, 13, 10, 12),
    decoration: BoxDecoration(
      color: AppColors.surfaceDark,
      borderRadius: BorderRadius.circular(15),
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.center,
              decoration: const BoxDecoration(
                color: Color(0xFF241A19),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 17, color: AppColors.primaryRed),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                value,
                style: const TextStyle(
                  color: AppColors.primaryRed,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const Text(
          'Calories Burned',
          style: TextStyle(color: AppColors.grayLighter, fontSize: 9),
        ),
        const SizedBox(height: 3),
        Text(
          calories,
          style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
        ),
      ],
    ),
  );
}
