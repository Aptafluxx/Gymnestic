import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/theme/app_theme.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/dashboard_binding.dart';
import 'package:gymnestic/features/dashboard/presentation/pages/dashboard_shell_screen.dart';

void main() {
  testWidgets('dashboard retains four post-authentication tabs', (
    tester,
  ) async {
    await tester.pumpWidget(
      GetMaterialApp(
        theme: AppTheme.darkTheme,
        initialBinding: DashboardBinding(),
        home: const DashboardShellScreen(),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Welcome, Roberto !'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);

    await tester.tap(find.text('Profile'));
    await tester.pumpAndSettle();
    expect(find.text('My Profile'), findsOneWidget);

    await tester.tap(find.text('Articles'));
    await tester.pumpAndSettle();
    expect(find.text('Rekomendation'), findsOneWidget);

    await tester.tap(find.text('Statistics'));
    await tester.pumpAndSettle();
    expect(find.text('Building Progress'), findsOneWidget);
  });
}
