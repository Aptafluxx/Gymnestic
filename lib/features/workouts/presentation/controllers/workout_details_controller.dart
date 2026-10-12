import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/daily_goal_model.dart';
import '../../../dashboard/data/datasources/fitness_remote_data_source.dart';
import '../../../dashboard/data/models/activity_program_model.dart';

class WorkoutDetailsController extends GetxController {
  final FitnessRemoteDataSource _dataSource = FitnessRemoteDataSource();

  // Active Program Details
  final Rx<ActivityProgramModel> activeProgram = const ActivityProgramModel(
    id: 'beginner',
    title: 'Training for Beginner',
    level: 'Build Your Body',
    imageUrl: '',
    difficultyRating: 2,
  ).obs;

  final RxString selectedGender = 'Male'.obs;
  final RxList<DailyGoalModel> allGoals = <DailyGoalModel>[].obs;

  StreamSubscription? _goalsSubscription;
  StreamSubscription? _genderSubscription;

  @override
  void onInit() {
    super.onInit();
    _extractProgramArguments();
    _bindStreams();
  }

  void _extractProgramArguments() {
    if (Get.arguments is ActivityProgramModel) {
      activeProgram.value = Get.arguments as ActivityProgramModel;
    }
  }

  void _bindStreams() {
    // 1. Listen to user gender preference
    _genderSubscription?.cancel();
    _genderSubscription = _dataSource.streamGenderPreference().listen((gender) {
      selectedGender.value = gender;
    });

    // 2. Stream goals filtered by this specific program ID
    _goalsSubscription?.cancel();
    _goalsSubscription = _dataSource
        .streamDailyGoals(programId: activeProgram.value.id)
        .listen((goals) {
          allGoals.assignAll(goals);
        });
  }

  List<DailyGoalModel> get dailyGoals {
    return allGoals.where((goal) {
      return goal.gender == 'All' || goal.gender == selectedGender.value;
    }).toList();
  }

  int get completedGoalsCount =>
      dailyGoals.where((goal) => goal.isCompleted).length;
  int get totalGoalsCount => dailyGoals.length;

  Future<void> setGender(String gender) async {
    if (gender == 'Male' || gender == 'Female') {
      selectedGender.value = gender;
      await _dataSource.saveGenderPreference(gender);
    }
  }

  Future<void> toggleGoalStatus(String id) async {
    final goal = allGoals.firstWhereOrNull((g) => g.id == id);
    if (goal == null) return;

    final newStatus = !goal.isCompleted;

    // Optimistic UI update
    final index = allGoals.indexWhere((g) => g.id == id);
    if (index != -1) {
      allGoals[index] = goal.copyWith(isCompleted: newStatus);
    }

    // Persist to Cloud Firestore and update today's calorie totals
    await _dataSource.toggleGoalCompletion(goal: goal, isCompleted: newStatus);
  }

  @override
  void onClose() {
    _goalsSubscription?.cancel();
    _genderSubscription?.cancel();
    super.onClose();
  }
}
