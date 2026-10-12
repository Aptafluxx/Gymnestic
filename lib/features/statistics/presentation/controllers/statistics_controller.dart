import 'package:get/get.dart';
import 'package:gymnestic/features/statistics/data/models/weekly_stat_model.dart';

class StatisticsController extends GetxController {
  final RxInt completedActivity = 15.obs;
  final RxInt totalActivity = 20.obs;
  final RxDouble runningDistanceKm = 45.0.obs;
  final RxDouble targetDistanceKm = 60.0.obs;
  final RxInt sleepHours = 21.obs;
  final RxInt targetSleepHours = 28.obs;
  final RxInt caloriesBurned = 50.obs;
  final RxInt runningCaloriesBurned = 25.obs;
  final RxInt sleepCaloriesBurned = 25.obs;
  final RxList<WeeklyStatModel> weeklyData = <WeeklyStatModel>[
    const WeeklyStatModel(dayName: 'Mon', value: 8, isSelected: true),
    const WeeklyStatModel(dayName: 'Tue', value: 10),
    const WeeklyStatModel(dayName: 'Wed', value: 4),
    const WeeklyStatModel(dayName: 'Thu', value: 10),
    const WeeklyStatModel(dayName: 'Fri', value: 5),
    const WeeklyStatModel(dayName: 'Sat', value: 10),
  ].obs;

  double get overallProgressPercentage => totalActivity.value == 0
      ? 0
      : completedActivity.value / totalActivity.value * 100;

  void selectDay(int index) {
    if (index < 0 || index >= weeklyData.length) return;
    for (var i = 0; i < weeklyData.length; i++) {
      weeklyData[i] = weeklyData[i].copyWith(isSelected: i == index);
    }
  }
}
