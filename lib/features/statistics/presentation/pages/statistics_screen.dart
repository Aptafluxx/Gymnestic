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
          Container(
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
                      const SizedBox(
                        width: 92,
                        height: 92,
                        child: CircularProgressIndicator(
                          value: .89,
                          strokeWidth: 8,
                          strokeCap: StrokeCap.round,
                          backgroundColor: AppColors.grayDark,
                          valueColor: AlwaysStoppedAnimation(
                            AppColors.primaryRed,
                          ),
                        ),
                      ),
                      const Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            '89',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          Text(
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
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Total Activity',
                        style: TextStyle(
                          color: AppColors.grayLighter,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '15 / 20',
                        style: TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        'Calories Burned',
                        style: TextStyle(
                          color: AppColors.grayLighter,
                          fontSize: 10,
                        ),
                      ),
                      SizedBox(height: 3),
                      Text(
                        '50 KCAL',
                        style: TextStyle(
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
          const SizedBox(height: 11),
          const Row(
            children: [
              Expanded(
                child: _MetricCard(
                  icon: Icons.directions_run_rounded,
                  value: '45 / 60 Km',
                  calories: '25 KCAL',
                ),
              ),
              SizedBox(width: 10),
              Expanded(
                child: _MetricCard(
                  icon: Icons.nightlight_round,
                  value: '21 / 28 hrs',
                  calories: '25 KCAL',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const SectionHeading(title: 'Monitoring', subtitle: 'Daily progress'),
          const SizedBox(height: 13),
          Container(
            height: 185,
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
                barTouchData: BarTouchData(enabled: false),
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
                            index >= controller.weeklyActivity.length) {
                          return const SizedBox.shrink();
                        }
                        return SideTitleWidget(
                          meta: meta,
                          child: Text(
                            controller.weeklyActivity[index].day,
                            style: const TextStyle(
                              color: AppColors.grayLighter,
                              fontSize: 9,
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
                barGroups: List.generate(
                  controller.weeklyActivity.length,
                  (index) => BarChartGroupData(
                    x: index,
                    barRods: [
                      BarChartRodData(
                        toY: controller.weeklyActivity[index].value,
                        width: 9,
                        color: index == 0
                            ? AppColors.primaryRed
                            : AppColors.grayDark,
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ],
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
