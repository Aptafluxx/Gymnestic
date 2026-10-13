import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../dashboard/data/datasources/fitness_remote_data_source.dart';
import '../../../dashboard/data/models/daily_record_model.dart';

class StatisticsController extends GetxController {
  StatisticsController({FitnessRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? FitnessRemoteDataSource();

  final FitnessRemoteDataSource _dataSource;

  // Overview Progress Metrics
  final RxInt totalActivity = 0.obs;
  final RxInt targetActivity = 20.obs;
  final RxInt weeklyCalories = 0.obs;

  // Sub-Metrics
  final RxDouble runningKm = 45.0.obs;
  final RxDouble targetRunningKm = 60.0.obs;
  final RxInt runningKcal = 25.obs;

  final RxInt sleepHours = 21.obs;
  final RxInt targetSleepHours = 28.obs;
  final RxInt sleepKcal = 25.obs;

  // Selected Day Index for Bar Chart (0: Mon, 6: Sun)
  final RxInt selectedDayIndex = (DateTime.now().weekday - 1).obs;

  // Weekly bar data values (Mon to Sun)
  final RxList<double> weeklyDailyKcal = <double>[0, 0, 0, 0, 0, 0, 0].obs;

  StreamSubscription<DailyRecordModel>? _todaySubscription;

  // Computed Progress Percentage for Circular Ring
  int get progressPercentage {
    if (targetActivity.value <= 0) return 0;
    final percentage = (totalActivity.value / targetActivity.value) * 100;
    return percentage.clamp(0, 100).toInt();
  }

  // DYNAMIC CHART CEILING: Computes dynamic maxY with 20% buffer to prevent overflow
  double get maxWeeklyKcal {
    double highest = 0.0;
    for (final kcal in weeklyDailyKcal) {
      if (kcal > highest) highest = kcal;
    }
    // Baseline minimum of 200, or highest value + 20% headroom
    return highest > 160 ? highest * 1.2 : 200.0;
  }

  @override
  void onInit() {
    super.onInit();
    _loadStatistics();
    _bindTodayStream();
  }

Future<void> _loadStatistics({bool forceRefresh = false}) async {
    final records = await _dataSource.fetchCurrentWeekRecords(
      forceRefresh: forceRefresh,
    );

    int totalTasks = 0;
    int caloriesSum = 0;
    final dayKcal = List<double>.filled(7, 0.0);

    for (final record in records) {
      try {
        final recordDate = DateFormat('yyyy-MM-dd').parse(record.dateKey);
        final dayIndex = recordDate.weekday - 1;
        if (dayIndex >= 0 && dayIndex < 7) {
          dayKcal[dayIndex] = record.kcalBurned.toDouble();
        }
      } catch (_) {}

      totalTasks += record.completedGoalIds.length;
      caloriesSum += record.kcalBurned;
    }

    totalActivity.value = totalTasks;
    weeklyCalories.value = caloriesSum;
    weeklyDailyKcal.assignAll(dayKcal);
  }

  /// Triggered by pull-to-refresh on StatisticsScreen
  Future<void> refreshStatistics() async {
    await _loadStatistics(forceRefresh: true);
  }

  void _bindTodayStream() {
    _todaySubscription?.cancel();
    _todaySubscription = _dataSource.streamTodayRecord().listen((todayRecord) {
      final currentWeekday = DateTime.now().weekday - 1;
      if (currentWeekday >= 0 && currentWeekday < 7) {
        weeklyDailyKcal[currentWeekday] = todayRecord.kcalBurned.toDouble();
      }
    });
  }

  void onSelectDay(int index) {
    selectedDayIndex.value = index;
  }

  @override
  void onClose() {
    _todaySubscription?.cancel();
    super.onClose();
  }
}
