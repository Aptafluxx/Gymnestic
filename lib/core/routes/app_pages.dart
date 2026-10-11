import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/features/auth/presentation/controllers/login_binding.dart';
import 'package:gymnestic/features/auth/presentation/controllers/signup_binding.dart';
import 'package:gymnestic/features/auth/presentation/pages/login_screen.dart';
import 'package:gymnestic/features/auth/presentation/pages/signup_screen.dart';
import 'package:gymnestic/features/home/controller/home_binding.dart';
import 'package:gymnestic/features/home/presentation/home_screen.dart';
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
      page: () => const HomeScreen(),
      binding: HomeBinding(),
      transition: .rightToLeft,
    ),
  ];
}
