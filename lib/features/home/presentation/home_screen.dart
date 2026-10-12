import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/core/widgets/gym_image.dart';
import 'package:gymnestic/core/widgets/section_heading.dart';
import 'package:gymnestic/features/home/presentation/controllers/home_controller.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: CustomScrollView(
        slivers: [
          SliverPadding(
            padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
            sliver: SliverList.list(
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Welcome, Roberto !',
                            style: TextStyle(
                              fontSize: 19,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(height: 4),
                          Text(
                            'Monday, 24 August 2020',
                            style: TextStyle(
                              fontSize: 11,
                              color: AppColors.grayLight,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: const Icon(Icons.more_vert),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                const _StatusCard(),
                const SizedBox(height: 25),
                const SectionHeading(
                  title: 'Activity',
                  subtitle: 'Choose your program',
                ),
                const SizedBox(height: 14),
                ...controller.activities.map(
                  (activity) => Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(15),
                      onTap: () => Get.toNamed(AppRoutes.workoutDetails),
                      child: SizedBox(
                        height: 145,
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            GymImage(
                              url: activity.imageUrl,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            DecoratedBox(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: .8),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 14,
                              bottom: 14,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.black.withValues(
                                        alpha: .55,
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                    ),
                                    child: Text(
                                      activity.title,
                                      style: const TextStyle(fontSize: 10),
                                    ),
                                  ),
                                  const SizedBox(height: 6),
                                  Text(
                                    activity.level,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              right: 14,
                              bottom: 18,
                              child: Row(
                                children: List.generate(
                                  3,
                                  (index) => Padding(
                                    padding: const EdgeInsets.only(left: 4),
                                    child: Icon(
                                      Icons.star,
                                      size: 13,
                                      color: index < activity.difficulty
                                          ? AppColors.primaryRed
                                          : AppColors.grayMedium,
                                    ),
                                  ),
                                ),
                              ),
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
        ],
      ),
    ),
  );
}

class _StatusCard extends StatelessWidget {
  const _StatusCard();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
    decoration: BoxDecoration(
      color: AppColors.surfaceDark,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        const Text(
          'Current Status',
          style: TextStyle(color: AppColors.grayLight, fontSize: 11),
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 105,
          child: LineChart(
            LineChartData(
              minX: 0,
              maxX: 4,
              minY: 0,
              maxY: 6,
              gridData: const FlGridData(show: false),
              borderData: FlBorderData(show: false),
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
                    reservedSize: 18,
                    getTitlesWidget: (value, meta) => SideTitleWidget(
                      meta: meta,
                      child: Text(
                        'day ${value.toInt() + 1}',
                        style: const TextStyle(
                          color: AppColors.grayMedium,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              lineBarsData: [
                LineChartBarData(
                  spots: const [
                    FlSpot(0, 1.4),
                    FlSpot(1, 3.5),
                    FlSpot(2, 1.8),
                    FlSpot(3, 4.7),
                    FlSpot(4, 4.5),
                  ],
                  isCurved: true,
                  curveSmoothness: .3,
                  color: AppColors.primaryRed,
                  barWidth: 2,
                  dotData: const FlDotData(show: false),
                  belowBarData: BarAreaData(
                    show: true,
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.primaryRed.withValues(alpha: .35),
                        AppColors.primaryRed.withValues(alpha: .01),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 10),
        const Row(
          children: [
            _StatusMetric(value: '78', label: 'BPM'),
            _MetricDivider(),
            _StatusMetric(value: '340', label: 'KCAL'),
            _MetricDivider(),
            _StatusMetric(value: '120', label: 'Weight'),
          ],
        ),
      ],
    ),
  );
}

class _MetricDivider extends StatelessWidget {
  const _MetricDivider();

  @override
  Widget build(BuildContext context) =>
      Container(width: 1, height: 28, color: AppColors.grayDark);
}

class _StatusMetric extends StatelessWidget {
  const _StatusMetric({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Column(
      children: [
        Text(value, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 2),
        Text(
          label,
          style: const TextStyle(color: AppColors.grayLight, fontSize: 10),
        ),
      ],
    ),
  );
}
