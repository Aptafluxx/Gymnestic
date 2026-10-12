import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/widgets/app_snackbar.dart';
import 'package:gymnestic/features/dashboard/data/datasources/fitness_remote_data_source.dart';
import 'package:gymnestic/features/workouts/data/models/daily_goal_model.dart';

class WorkoutDetailsController extends GetxController {
  WorkoutDetailsController({FitnessRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? FitnessRemoteDataSource();

  final FitnessRemoteDataSource _dataSource;
  final RxString selectedGender = 'Male'.obs;
  final RxList<DailyGoalModel> allGoals = <DailyGoalModel>[].obs;

  StreamSubscription<List<DailyGoalModel>>? _goalsSubscription;
  StreamSubscription<String>? _genderSubscription;

  @override
  void onInit() {
    super.onInit();
    _genderSubscription = _dataSource.streamGenderPreference().listen(
      (gender) => selectedGender.value = gender,
      onError: (Object error) {
        AppSnackbar.error(
          'Preference unavailable',
          'Your gender preference could not be loaded.',
        );
      },
    );
    _goalsSubscription = _dataSource.streamDailyGoals().listen(
      allGoals.assignAll,
      onError: (Object error) {
        AppSnackbar.error(
          'Daily goals unavailable',
          'Your training goals could not be loaded. Please try again.',
        );
      },
    );
  }

  List<DailyGoalModel> get dailyGoals => allGoals
      .where(
        (goal) => goal.gender == 'All' || goal.gender == selectedGender.value,
      )
      .toList();

  int get completedGoalsCount =>
      dailyGoals.where((goal) => goal.isCompleted).length;

  int get totalGoalsCount => dailyGoals.length;

  Future<void> setGender(String gender) async {
    if (gender != 'Male' && gender != 'Female') return;
    final previousGender = selectedGender.value;
    selectedGender.value = gender;
    try {
      await _dataSource.saveGenderPreference(gender);
    } on FirebaseException {
      selectedGender.value = previousGender;
      AppSnackbar.error(
        'Preference not saved',
        'Your gender preference could not be saved. Please try again.',
      );
    }
  }

  Future<void> toggleGoalStatus(String id) async {
    final index = allGoals.indexWhere((goal) => goal.id == id);
    if (index == -1) return;

    final goal = allGoals[index];
    final updatedGoal = goal.copyWith(isCompleted: !goal.isCompleted);
    allGoals[index] = updatedGoal;

    try {
      await _dataSource.toggleGoalCompletion(
        goal: goal,
        isCompleted: updatedGoal.isCompleted,
      );
    } on FirebaseException {
      final currentIndex = allGoals.indexWhere((item) => item.id == id);
      if (currentIndex != -1 && allGoals[currentIndex] == updatedGoal) {
        allGoals[currentIndex] = goal;
      }
      AppSnackbar.error(
        'Goal not saved',
        'Your training goal could not be updated. Please try again.',
      );
    }
  }

  @override
  void onClose() {
    _goalsSubscription?.cancel();
    _genderSubscription?.cancel();
    super.onClose();
  }
}
