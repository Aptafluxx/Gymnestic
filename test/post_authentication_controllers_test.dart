import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gymnestic/features/articles/presentation/controllers/articles_controller.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/home_controller.dart';
import 'package:gymnestic/features/profile/presentation/controllers/profile_controller.dart';
import 'package:gymnestic/features/statistics/presentation/controllers/statistics_controller.dart';
import 'package:gymnestic/features/workouts/presentation/controllers/workout_details_controller.dart';

void main() {
  tearDown(Get.reset);

  test('home refresh reloads mock metrics, date, and chart data', () {
    final controller = HomeController();

    controller.bpm.value = 91;
    controller.statusChartSpots.clear();
    controller.refreshDashboardData();

    expect(controller.bpm.value, 78);
    expect(controller.kcalBurned.value, 340);
    expect(controller.currentWeight.value, 120);
    expect(controller.currentDate.value, isNotEmpty);
    expect(controller.statusChartSpots, hasLength(5));
  });

  test('workout gender and goal state update by goal id', () {
    final controller = WorkoutDetailsController();

    expect(controller.selectedGender.value, 'Male');
    expect(controller.completedGoalsCount, 3);
    controller.setGender('Female');
    controller.toggleGoalStatus('push-ups-50');

    expect(controller.selectedGender.value, 'Female');
    expect(controller.completedGoalsCount, 4);
    expect(controller.totalGoalsCount, 5);
  });

  test('article likes and read-more state remain attached to selection', () {
    final controller = Get.put(ArticlesController());
    final article = controller.recommendedArticles.first;
    final initialLikes = article.likesCount;

    controller.toggleLike(article.id);
    controller.toggleReadMore();

    expect(controller.selectedArticle.value?.isLiked, isTrue);
    expect(controller.selectedArticle.value?.likesCount, initialLikes + 1);
    expect(controller.recommendedArticles.first.likesCount, initialLikes + 1);
    expect(controller.isExpanded.value, isTrue);
  });

  test('profile edits update the reactive model and skill selection', () {
    final controller = ProfileController();

    controller.updateBio('Updated bio');
    controller.selectSkill('Barbell');

    expect(controller.userProfile.value.bio, 'Updated bio');
    expect(controller.selectedSkill.value, 'Barbell');
  });

  test('statistics progress and selected chart day are derived from state', () {
    final controller = StatisticsController();

    expect(controller.overallProgressPercentage, 75);
    controller.selectDay(3);

    expect(controller.weeklyData[3].isSelected, isTrue);
    expect(controller.weeklyData.where((day) => day.isSelected), hasLength(1));
  });
}
