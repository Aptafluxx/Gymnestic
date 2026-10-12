import 'package:get/get.dart';
import 'package:gymnestic/features/workouts/data/models/daily_goal_model.dart';

class WorkoutDetailsController extends GetxController {
  final RxString selectedGender = 'Male'.obs;
  final RxList<DailyGoalModel> dailyGoals = <DailyGoalModel>[
    const DailyGoalModel(
      id: 'push-ups-20',
      time: '07:10',
      title: 'Push up 20 times',
      isCompleted: true,
    ),
    const DailyGoalModel(
      id: 'breakfast',
      time: '08:10',
      title: 'Breakfast cereal with milk',
      isCompleted: true,
    ),
    const DailyGoalModel(
      id: 'ice-cream',
      time: '09:20',
      title: 'Have a bowl of ice cream',
      isCompleted: true,
    ),
    const DailyGoalModel(
      id: 'push-ups-50',
      time: '11:45',
      title: 'Push up 50 times',
    ),
    const DailyGoalModel(
      id: 'nap',
      time: '12:55',
      title: 'Have milk before taking a nap',
    ),
  ].obs;

  int get completedGoalsCount =>
      dailyGoals.where((goal) => goal.isCompleted).length;

  int get totalGoalsCount => dailyGoals.length;

  void setGender(String gender) {
    if (gender == 'Male' || gender == 'Female') {
      selectedGender.value = gender;
    }
  }

  void toggleGoalStatus(String id) {
    final index = dailyGoals.indexWhere((goal) => goal.id == id);
    if (index == -1) return;
    final goal = dailyGoals[index];
    dailyGoals[index] = goal.copyWith(isCompleted: !goal.isCompleted);
  }
}
