import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_pages.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_theme.dart';
import 'package:gymnestic/features/workouts/presentation/controllers/workout_details_controller.dart';

void main() {
  testWidgets('dashboard retains four post-authentication tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        initialRoute: AppRoutes.home,
        getPages: AppPages.pages,
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Roberto !'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    await tester.ensureVisible(find.text('Training for Beginner'));
    await tester.tap(find.text('Training for Beginner'));
    await tester.pumpAndSettle();
    expect(find.text('Build your Body'), findsOneWidget);
    await tester.tap(find.text('Female'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Push up 20 times'));
    await tester.pumpAndSettle();
    expect(
      Get.find<WorkoutDetailsController>().dailyGoals.first.isCompleted,
      isFalse,
    );
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('My Profile'), findsOneWidget);

    await tester.tap(find.text('Articles'));
    await tester.pumpAndSettle();
    expect(find.text('Rekomendation'), findsOneWidget);
    await tester.tap(find.text('10 Principals to Pack on Muscle'));
    await tester.pumpAndSettle();
    expect(find.text('By @authorname'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.favorite_border));
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.favorite), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_back_ios_new));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Statistics'));
    await tester.pumpAndSettle();
    expect(find.text('Building Progress'), findsOneWidget);
  });
}
