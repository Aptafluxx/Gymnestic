import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/errors/auth_exceptions.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/widgets/app_snackbar.dart';
import 'package:gymnestic/features/auth/domain/usecases/signout_usecase.dart';
import 'package:gymnestic/features/dashboard/data/datasources/fitness_remote_data_source.dart';
import 'package:gymnestic/features/dashboard/data/models/activity_program_model.dart';
import 'package:gymnestic/features/dashboard/data/models/daily_record_model.dart';
import 'package:gymnestic/features/dashboard/presentation/widgets/log_metrics_bottom_sheet.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  HomeController({FitnessRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? FitnessRemoteDataSource();

  final FitnessRemoteDataSource _dataSource;

  final RxString userName = 'Athlete'.obs;
  final RxString currentDate = ''.obs;
  final RxBool isLoggingOut = false.obs;

  final RxInt bpm = 70.obs;
  final RxInt kcalBurned = 0.obs;
  final RxInt currentWeight = 0.obs;

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

  final RxList<FlSpot> statusChartSpots = <FlSpot>[
    const FlSpot(0, 0),
    const FlSpot(1, 0),
    const FlSpot(2, 0),
    const FlSpot(3, 0),
    const FlSpot(4, 0),
  ].obs;

  StreamSubscription<DailyRecordModel>? _todaySubscription;

  @override
  void onInit() {
    super.onInit();
    _loadUserInfo();
    _bindTodayStream();
    loadPastRecords();
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

  // Listen exclusively to today's document
  void _bindTodayStream() {
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
  }

  // OPTIMIZATION: Fetches historical chart spots once without lingering listeners
  /// One-time fetch for historical days with optional cache bypass
  Future<void> loadPastRecords({bool forceRefresh = false}) async {
    final records = await _dataSource.fetchPastRecords(
      days: 5,
      forceRefresh: forceRefresh,
    );

    if (records.isEmpty) {
      final todayScaledY = (kcalBurned.value / 100.0).clamp(0.0, 6.0);
      statusChartSpots.assignAll([
        const FlSpot(0, 0),
        const FlSpot(1, 0),
        const FlSpot(2, 0),
        const FlSpot(3, 0),
        FlSpot(4, todayScaledY),
      ]);
      return;
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < records.length; i++) {
      final scaledY = (records[i].kcalBurned / 100.0).clamp(0.0, 6.0);
      spots.add(FlSpot(i.toDouble(), scaledY));
    }

    while (spots.length < 5) {
      spots.add(FlSpot(spots.length.toDouble(), 0));
    }

    final todayScaledY = (kcalBurned.value / 100.0).clamp(0.0, 6.0);
    spots[spots.length - 1] = FlSpot(4, todayScaledY);

    statusChartSpots.assignAll(spots);
  }

  /// Triggered by pull-to-refresh gesture on HomeScreen
  Future<void> refreshData() async {
    _loadUserInfo();
    await loadPastRecords(forceRefresh: true);
  }

  Future<void> logOut() async {
    if (isLoggingOut.value) return;

    isLoggingOut.value = true;
    try {
      await Get.find<SignOutUseCase>()();
      Get.offAllNamed(AppRoutes.login);
      AppSnackbar.success(
        'Logged out',
        'You have been logged out successfully.',
      );
    } on AuthException catch (exception) {
      AppSnackbar.error('Logout failed', exception.message);
    } catch (_) {
      AppSnackbar.error(
        'Logout failed',
        'Something went wrong. Please try again.',
      );
    } finally {
      isLoggingOut.value = false;
    }
  }

  void openLogMetricsDialog() {
    Get.bottomSheet(
      LogMetricsBottomSheet(
        currentBpm: bpm.value,
        currentWeight: currentWeight.value,
        onSave: (bpmVal, weightVal, runningKmVal, sleepHoursVal) async {
          try {
            await _dataSource.logHealthMetrics(
              bpm: bpmVal,
              weight: weightVal,
              runningKm: runningKmVal,
              sleepHours: sleepHoursVal,
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
    super.onClose();
  }
}
