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

  // Master list of raw goal templates
  final RxList<DailyGoalModel> rawGoals = <DailyGoalModel>[].obs;

  // Today's completed goal IDs (e.g. ['beg-push-ups'])
  final RxList<String> todayCompletedIds = <String>[].obs;

  StreamSubscription? _goalsSubscription;
  StreamSubscription? _todaySubscription;

  @override
  void onInit() {
    super.onInit();
    _extractProgramArguments();
    _loadGender();
    _bindStreams();
  }

  void _extractProgramArguments() {
    if (Get.arguments is ActivityProgramModel) {
      activeProgram.value = Get.arguments as ActivityProgramModel;
    }
  }

  Future<void> _loadGender() async {
    selectedGender.value = await _dataSource.getGenderPreference();
  }

  void _bindStreams() {
    // 1. Listen to today's daily record to see what is completed TODAY
    _todaySubscription?.cancel();
    _todaySubscription = _dataSource.streamTodayRecord().listen((record) {
      todayCompletedIds.assignAll(record.completedGoalIds);
    });

    // 2. Stream goal templates for the active program
    _goalsSubscription?.cancel();
    _goalsSubscription = _dataSource
        .streamDailyGoals(programId: activeProgram.value.id)
        .listen((goals) {
          rawGoals.assignAll(goals);
        });
  }

  /// Evaluates each goal against TODAY'S completed IDs
  List<DailyGoalModel> get dailyGoals {
    return rawGoals
        .where(
          (goal) => goal.gender == 'All' || goal.gender == selectedGender.value,
        )
        .map((goal) {
          // A goal is completed IF AND ONLY IF today's record contains its ID
          final isDoneToday = todayCompletedIds.contains(goal.id);
          return goal.copyWith(isCompleted: isDoneToday);
        })
        .toList();
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

  /// Toggles completion status for today
  Future<void> toggleGoalStatus(String id) async {
    final goal = rawGoals.firstWhereOrNull((g) => g.id == id);
    if (goal == null) return;

    final isCurrentlyCompleted = todayCompletedIds.contains(id);
    final newStatus = !isCurrentlyCompleted;

    // Optimistic UI update for instantaneous visual feedback
    if (newStatus) {
      todayCompletedIds.add(id);
    } else {
      todayCompletedIds.remove(id);
    }

    // Persist change to today's record in Firestore
    await _dataSource.toggleGoalCompletion(goal: goal, isCompleted: newStatus);
  }

  @override
  void onClose() {
    _goalsSubscription?.cancel();
    _todaySubscription?.cancel();
    super.onClose();
  }
}
