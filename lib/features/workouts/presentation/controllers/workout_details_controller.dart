import 'dart:async';

import 'package:get/get.dart';

import '../../data/models/daily_goal_model.dart';
import '../../../dashboard/data/datasources/fitness_remote_data_source.dart';
import '../../../dashboard/data/models/activity_program_model.dart';

class WorkoutDetailsController extends GetxController {
  final FitnessRemoteDataSource _dataSource = FitnessRemoteDataSource();

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

  @override
  void onInit() {
    super.onInit();
    _extractProgramArguments();
    _loadGender();
    _bindGoalsStream();
  }

  void _extractProgramArguments() {
    if (Get.arguments is ActivityProgramModel) {
      activeProgram.value = Get.arguments as ActivityProgramModel;
    }
  }

  // OPTIMIZATION: One-time gender fetch instead of an open snapshot listener
  Future<void> _loadGender() async {
    selectedGender.value = await _dataSource.getGenderPreference();
  }

  void _bindGoalsStream() {
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

    // Optimistic UI update for immediate screen response
    final index = allGoals.indexWhere((g) => g.id == id);
    if (index != -1) {
      allGoals[index] = goal.copyWith(isCompleted: newStatus);
    }

    // Atomic write in Firestore
    await _dataSource.toggleGoalCompletion(goal: goal, isCompleted: newStatus);
  }

  @override
  void onClose() {
    _goalsSubscription?.cancel();
    super.onClose();
  }
}
