import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../core/theme/app_colors.dart';
import '../controllers/statistics_controller.dart';

class StatisticsScreen extends GetView<StatisticsController> {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundBlack,
      appBar: AppBar(
        title: const Text('Building Progress'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 19),
          onPressed: () => Get.back(),
        ),
      ),
      body: RefreshIndicator(
        color: AppColors.primaryRed,
        backgroundColor: AppColors.cardDark,
        displacement: 20,
        onRefresh: controller.refreshStatistics,
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildOverallProgressCard(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: _buildSubMetricCard(
                      icon: Icons.directions_run_rounded,
                      title: Obx(
                        () => Text(
                          '${controller.runningKm.value.toInt()} / ${controller.targetRunningKm.value.toInt()} Km',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      subtitle: 'Calories Burned',
                      kcalText: Obx(
                        () => Text(
                          '${controller.runningKcal.value} KCAL',
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: _buildSubMetricCard(
                      icon: Icons.nightlight_round,
                      title: Obx(
                        () => Text(
                          '${controller.sleepHours.value} / ${controller.targetSleepHours.value} hrs',
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                      subtitle: 'Calories Burned',
                      kcalText: Obx(
                        () => Text(
                          '${controller.sleepKcal.value} KCAL',
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              const Text(
                'Monitoring',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textWhite,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Daily progress',
                style: TextStyle(fontSize: 12, color: AppColors.grayLight),
              ),
              const SizedBox(height: 20),
              _buildMonitoringBarChart(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverallProgressCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Obx(() {
            final percentage = controller.progressPercentage;
            return SizedBox(
              width: 86,
              height: 86,
              child: Stack(
                fit: StackFit.expand,
                children: [
                  CircularProgressIndicator(
                    value: percentage / 100.0,
                    strokeWidth: 8,
                    backgroundColor: AppColors.cardDark,
                    color: AppColors.primaryRed,
                    strokeCap: StrokeCap.round,
                  ),
                  Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '$percentage',
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: AppColors.textWhite,
                          ),
                        ),
                        const Text(
                          'Percent',
                          style: TextStyle(
                            fontSize: 9,
                            color: AppColors.grayLight,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
          const SizedBox(width: 24),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Total Activity',
                  style: TextStyle(color: AppColors.grayLight, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${controller.totalActivity.value} / ${controller.targetActivity.value}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: AppColors.primaryRed,
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Calories Burned',
                  style: TextStyle(color: AppColors.grayLight, fontSize: 11),
                ),
                const SizedBox(height: 4),
                Obx(
                  () => Text(
                    '${controller.weeklyCalories.value} KCAL',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textWhite,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubMetricCard({
    required IconData icon,
    required Widget title,
    required String subtitle,
    required Widget kcalText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: AppColors.primaryRed, size: 24),
          const SizedBox(height: 14),
          title,
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: const TextStyle(color: AppColors.grayLight, fontSize: 10),
          ),
          const SizedBox(height: 2),
          kcalText,
        ],
      ),
    );
  }

  Widget _buildMonitoringBarChart() {
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

    return Container(
      height: 190,
      padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceDark,
        borderRadius: BorderRadius.circular(20),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Obx(() {
          final chartMaxY = controller.maxWeeklyKcal;

          return BarChart(
            BarChartData(
              alignment: BarChartAlignment.spaceAround,
              maxY: chartMaxY,
              barTouchData: BarTouchData(
                enabled: true,
                handleBuiltInTouches: true,
                touchTooltipData: BarTouchTooltipData(
                  fitInsideHorizontally: true,
                  fitInsideVertically: true,
                  tooltipMargin: 8,
                  tooltipPadding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 6,
                  ),
                  getTooltipColor: (_) => AppColors.cardDark,
                  tooltipBorderRadius: .circular(8),
                  getTooltipItem: (group, groupIndex, rod, rodIndex) {
                    final dayIndex = group.x.toInt();
                    if (dayIndex < 0 || dayIndex >= days.length) return null;

                    final dayName = days[dayIndex];
                    final kcal = controller.weeklyDailyKcal[dayIndex].toInt();

                    return BarTooltipItem(
                      '$dayName\n',
                      const TextStyle(
                        color: AppColors.grayLight,
                        fontSize: 10,
                        fontWeight: FontWeight.w500,
                        fontFamily: 'Montserrat',
                      ),
                      children: [
                        TextSpan(
                          text: '$kcal KCAL',
                          style: const TextStyle(
                            color: AppColors.primaryRed,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            fontFamily: 'Montserrat',
                          ),
                        ),
                      ],
                    );
                  },
                ),
                touchCallback: (event, response) {
                  if (event.isInterestedForInteractions &&
                      response != null &&
                      response.spot != null) {
                    final touchedIndex = response.spot!.touchedBarGroupIndex;
                    if (controller.selectedDayIndex.value != touchedIndex) {
                      controller.onSelectDay(touchedIndex);
                    }
                  }
                },
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
                      if (index < 0 || index >= days.length) {
                        return const SizedBox.shrink();
                      }
                      final isSelected =
                          controller.selectedDayIndex.value == index;
                      return Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          days[index],
                          style: TextStyle(
                            color: isSelected
                                ? AppColors.textWhite
                                : AppColors.grayMedium,
                            fontSize: 10,
                            fontWeight: isSelected
                                ? FontWeight.w700
                                : FontWeight.normal,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
              barGroups: List.generate(7, (index) {
                final isSelected = controller.selectedDayIndex.value == index;
                final kcal = controller.weeklyDailyKcal[index];

                return BarChartGroupData(
                  x: index,
                  barRods: [
                    BarChartRodData(
                      toY: kcal > 0 ? kcal : (chartMaxY * 0.06),
                      color: isSelected
                          ? AppColors.primaryRed
                          : AppColors.grayDark,
                      width: 14,
                      borderRadius: BorderRadius.circular(6),
                    ),
                  ],
                );
              }),
            ),
          );
        }),
      ),
    );
  }
}
