import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/core/widgets/gym_image.dart';
import 'package:gymnestic/core/widgets/section_heading.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/home_controller.dart';
import 'package:gymnestic/features/dashboard/data/models/activity_program_model.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: RefreshIndicator(
        color: AppColors.primaryRed,
        backgroundColor: AppColors.cardDark,
        displacement: 30,
        onRefresh: controller.refreshData,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(
            parent: BouncingScrollPhysics(),
          ),
          slivers: [
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 14, 18, 20),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Welcome, ${controller.userName.value} !',
                                style: const TextStyle(
                                  fontSize: 19,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                controller.currentDate.value,
                                style: const TextStyle(
                                  fontSize: 11,
                                  color: AppColors.grayLight,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(Icons.more_vert),
                      ),
                    ],
                  ),
                  const SizedBox(height: 18),
                  _StatusCard(controller: controller),
                  const SizedBox(height: 25),
                  const SectionHeading(
                    title: 'Activity',
                    subtitle: 'Choose your program',
                  ),
                  const SizedBox(height: 14),
                  Obx(
                    () => Column(
                      children: controller.programs
                          .map(
                            (program) => Padding(
                              padding: const EdgeInsets.only(bottom: 12),
                              child: _ActivityCard(program: program),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.program});

  final ActivityProgramModel program;

  @override
  Widget build(BuildContext context) => InkWell(
    borderRadius: BorderRadius.circular(15),
    // Pass the tapped program model as an argument
    onTap: () => Get.toNamed(AppRoutes.workoutDetails, arguments: program),
    child: SizedBox(
      height: 145,
      child: Stack(
        fit: StackFit.expand,
        children: [
          GymImage(
            url: program.imageUrl,
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
                    color: Colors.black.withValues(alpha: .55),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    program.title,
                    style: const TextStyle(fontSize: 10),
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  program.level,
                  style: const TextStyle(fontWeight: FontWeight.w600),
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
                    color: index < program.difficultyRating
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
  );
}

class _StatusCard extends StatelessWidget {
  const _StatusCard({required this.controller});

  final HomeController controller;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 12, 14, 16),
    decoration: BoxDecoration(
      color: AppColors.surfaceDark,
      borderRadius: BorderRadius.circular(16),
    ),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Current Status',
              style: TextStyle(
                color: AppColors.grayLight,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
            InkWell(
              onTap: controller.openLogMetricsDialog,
              borderRadius: BorderRadius.circular(12),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.cardDark,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryRed.withValues(alpha: 0.35),
                    width: 1,
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.edit_note_rounded,
                      size: 15,
                      color: AppColors.primaryRed,
                    ),
                    SizedBox(width: 4),
                    Text(
                      'Log Metrics',
                      style: TextStyle(
                        color: AppColors.textWhite,
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Montserrat',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),

        // Line Chart
        SizedBox(
          height: 105,
          child: Obx(
            () => LineChart(
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
                    spots: controller.statusChartSpots.toList(),
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
        ),
        const SizedBox(height: 10),
        Obx(
          () => Row(
            children: [
              _StatusMetric(value: '${controller.bpm.value}', label: 'BPM'),
              const _MetricDivider(),
              _StatusMetric(
                value: '${controller.kcalBurned.value}',
                label: 'KCAL',
              ),
              const _MetricDivider(),
              _StatusMetric(
                value: '${controller.currentWeight.value}',
                label: 'Weight',
              ),
            ],
          ),
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
