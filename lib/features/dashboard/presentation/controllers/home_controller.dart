import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:get/get.dart';
import 'package:gymnestic/features/dashboard/data/models/activity_program_model.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  final RxString userName = 'Roberto'.obs;
  final RxString currentDate = ''.obs;
  final RxInt bpm = 78.obs;
  final RxInt kcalBurned = 340.obs;
  final RxInt currentWeight = 120.obs;
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
    const FlSpot(0, 1.4),
    const FlSpot(1, 3.5),
    const FlSpot(2, 1.8),
    const FlSpot(3, 4.7),
    const FlSpot(4, 4.5),
  ].obs;

  @override
  void onInit() {
    super.onInit();
    refreshDashboardData();
  }

  void refreshDashboardData() {
    currentDate.value = DateFormat('EEEE, d MMMM yyyy').format(DateTime.now());
    bpm.value = 78;
    kcalBurned.value = 340;
    currentWeight.value = 120;
    statusChartSpots.assignAll(const [
      FlSpot(0, 1.4),
      FlSpot(1, 3.5),
      FlSpot(2, 1.8),
      FlSpot(3, 4.7),
      FlSpot(4, 4.5),
    ]);

    if (Firebase.apps.isNotEmpty) {
      final user = FirebaseAuth.instance.currentUser;
      final displayName = user?.displayName?.trim();
      final emailPrefix = user?.email?.split('@').first.trim();
      userName.value = displayName?.isNotEmpty == true
          ? displayName!
          : emailPrefix?.isNotEmpty == true
          ? emailPrefix!
          : 'Roberto';
    }
  }
}
