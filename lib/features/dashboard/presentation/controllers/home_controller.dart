import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/widgets/app_snackbar.dart';
import 'package:gymnestic/features/dashboard/data/datasources/fitness_remote_data_source.dart';
import 'package:gymnestic/features/dashboard/data/models/activity_program_model.dart';
import 'package:gymnestic/features/dashboard/data/models/daily_record_model.dart';
import 'package:gymnestic/features/dashboard/presentation/widgets/log_metrics_bottom_sheet.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  HomeController({FitnessRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? FitnessRemoteDataSource();

  final FitnessRemoteDataSource _dataSource;

  // Header state
  final RxString userName = 'Athlete'.obs;
  final RxString currentDate = ''.obs;

  // Status card metrics (default to clean initial states)
  final RxInt bpm = 70.obs;
  final RxInt kcalBurned = 0.obs;
  final RxInt currentWeight = 0.obs;

  // Static program cards
  final RxList<ActivityProgramModel> programs = <ActivityProgramModel>[
    const ActivityProgramModel(
      id: 'beginner',
      title: 'Training for Beginner',
      level: 'Build Your Body',
      imageUrl:
          'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=1000',
      difficultyRating: 2,
    ),
    const ActivityProgramModel(
      id: 'strength',
      title: 'Strength Training',
      level: 'Build Your Body',
      imageUrl:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1000',
      difficultyRating: 3,
    ),
    const ActivityProgramModel(
      id: 'stretch',
      title: 'Daily Stretch',
      level: 'Find More Energy',
      imageUrl:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=1000',
      difficultyRating: 1,
    ),
  ].obs;

  // Line chart spots
  final RxList<FlSpot> statusChartSpots = <FlSpot>[
    const FlSpot(0, 0),
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
  ].obs;

  StreamSubscription<DailyRecordModel>? _todaySubscription;
  StreamSubscription<List<DailyRecordModel>>? _pastRecordsSubscription;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    _bindStreams();
  }

  void _loadUserInfo() {
    currentDate.value = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    if (Firebase.apps.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final displayName = user?.displayName?.trim();
      final emailPrefix = user?.email?.split('@').first.trim();
      userName.value = displayName?.isNotEmpty == true
          ? displayName!
          : emailPrefix?.isNotEmpty == true
          ? emailPrefix!
          : 'Athlete';
    }
  }

  void _bindStreams() {
    // 1. Listen to today's daily record (BPM, Weight, and Calorie Burn)
    _todaySubscription?.cancel();
    _todaySubscription = _dataSource.streamTodayRecord().listen(
      (record) {
        bpm.value = record.bpm;
        kcalBurned.value = record.kcalBurned;
        currentWeight.value = record.weight;
      },
      onError: (Object error) {
        AppSnackbar.error(
          'Fitness data unavailable',
          'Your latest metrics could not be loaded. Please try again.',
        );
      },
    );

    // 2. Listen to the past 5 days to plot actual calorie history on the line chart
    _pastRecordsSubscription?.cancel();
    _pastRecordsSubscription = _dataSource.streamPastRecords(days: 5).listen((
      records,
    ) {
      if (records.isEmpty) {
        statusChartSpots.assignAll(const [
          FlSpot(0, 0),
          FlSpot(1, 0),
          FlSpot(2, 0),
          FlSpot(3, 0),
          FlSpot(4, 0),
        ]);
        return;
      }

      final spots = <FlSpot>[];
      for (int i = 0; i < records.length; i++) {
        // Normalize calorie burn into a 0.0 - 6.0 scale for chart display
        final scaledY = (records[i].kcalBurned / 100.0).clamp(0.0, 6.0);
        spots.add(FlSpot(i.toDouble(), scaledY));
      }

      // Fill remaining days if user has fewer than 5 days of history
      while (spots.length < 5) {
        spots.add(FlSpot(spots.length.toDouble(), 0));
      }

      statusChartSpots.assignAll(spots);
    });
  }

  /// Opens the bottom sheet modal to log actual resting BPM and body weight
  void openLogMetricsDialog() {
    Get.bottomSheet(
      LogMetricsBottomSheet(
        currentBpm: bpm.value,
        currentWeight: currentWeight.value,
        onSave: (bpmValue, weightValue) async {
          try {
            await _dataSource.logHealthMetrics(
              bpm: bpmValue,
              weight: weightValue,
            );
          } catch (_) {
            AppSnackbar.error(
              'Health metrics not saved',
              'Your metrics could not be stored. Please try again.',
            );
          }
        },
      ),
      isScrollControlled: true,
    );
  }

  @override
  void onClose() {
    _todaySubscription?.cancel();
    _pastRecordsSubscription?.cancel();
    super.onClose();
  }
}
