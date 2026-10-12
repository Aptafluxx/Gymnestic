import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/features/auth/presentation/controllers/login_binding.dart';
import 'package:gymnestic/features/auth/presentation/controllers/signup_binding.dart';
import 'package:gymnestic/features/auth/presentation/pages/login_screen.dart';
import 'package:gymnestic/features/auth/presentation/pages/signup_screen.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/dashboard_binding.dart';
import 'package:gymnestic/features/dashboard/presentation/pages/dashboard_shell_screen.dart';
import 'package:gymnestic/features/workouts/presentation/controllers/workout_details_binding.dart';
import 'package:gymnestic/features/workouts/presentation/pages/workout_details_screen.dart';
import 'package:gymnestic/features/articles/presentation/controllers/articles_binding.dart';
import 'package:gymnestic/features/articles/presentation/pages/articles_screen.dart';
import 'package:gymnestic/features/articles/presentation/pages/article_details_screen.dart';
import 'package:gymnestic/features/profile/presentation/controllers/profile_binding.dart';
import 'package:gymnestic/features/profile/presentation/pages/profile_screen.dart';
import 'package:gymnestic/features/statistics/presentation/controllers/statistics_binding.dart';
import 'package:gymnestic/features/statistics/presentation/pages/statistics_screen.dart';
import 'package:gymnestic/features/onboarding/controllers/onboarding_binding.dart';
import 'package:gymnestic/features/onboarding/presentation/onboarding_screen.dart';
import 'package:gymnestic/features/splash/controller/splash_binding.dart';
import 'package:gymnestic/features/splash/presentation/splash_screen.dart';

class AppPages {
  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
      transition: .fadeIn,
    ),
    GetPage(
      name: AppRoutes.onboarding,
      page: () => const OnboardingScreen(),
      binding: OnboardingBinding(),
      transition: .leftToRight,
    ),
    GetPage(
      name: AppRoutes.login,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.signup,
      page: () => const SignupScreen(),
      binding: SignupBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.home,
      page: () => const DashboardShellScreen(),
      binding: DashboardBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.workoutDetails,
      page: () => const WorkoutDetailsScreen(),
      binding: WorkoutDetailsBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.articles,
      page: () => const ArticlesScreen(),
      binding: ArticlesBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.articleDetails,
      page: () => const ArticleDetailsScreen(),
      binding: ArticlesBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileScreen(),
      binding: ProfileBinding(),
      transition: .rightToLeft,
    ),
    GetPage(
      name: AppRoutes.statistics,
      page: () => const StatisticsScreen(),
      binding: StatisticsBinding(),
      transition: .rightToLeft,
    ),
  ];
}
