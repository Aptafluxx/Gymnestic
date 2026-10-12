import 'package:get/get.dart';
import 'package:gymnestic/features/workout/data/models/daily_goal_model.dart';

class WorkoutDetailsController extends GetxController {
  final RxBool isMaleSelected = true.obs;
  final goals = <DailyGoalModel>[
    const DailyGoalModel(
      time: '07:10',
      title: 'Push up 20 times',
      isComplete: true,
    ),
    const DailyGoalModel(
      time: '08:10',
      title: 'Breakfast cereal with milk',
      isComplete: true,
    ),
    const DailyGoalModel(
      time: '09:20',
      title: 'Have a bowl of ice cream',
      isComplete: true,
    ),
    const DailyGoalModel(time: '11:45', title: 'Push up 50 times'),
    const DailyGoalModel(time: '12:55', title: 'Have milk before taking a nap'),
  ].obs;

  void selectGender(bool isMale) => isMaleSelected.value = isMale;

  void toggleGoal(int index) {
    goals[index] = goals[index].copyWith(isComplete: !goals[index].isComplete);
  }
}
