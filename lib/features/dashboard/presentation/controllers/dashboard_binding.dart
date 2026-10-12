import 'package:get/get.dart';
import 'package:gymnestic/features/articles/presentation/controllers/articles_controller.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/home_controller.dart';
import 'package:gymnestic/features/profile/presentation/controllers/profile_controller.dart';
import 'package:gymnestic/features/statistics/presentation/controllers/statistics_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(DashboardController.new);
    Get.lazyPut<HomeController>(HomeController.new);
    Get.lazyPut<ArticlesController>(ArticlesController.new);
    Get.lazyPut<ProfileController>(ProfileController.new);
    Get.lazyPut<StatisticsController>(StatisticsController.new);
  }
}
