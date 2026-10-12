import 'package:get/get.dart';
import 'package:gymnestic/features/statistics/presentation/controllers/statistics_controller.dart';

class StatisticsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StatisticsController>(StatisticsController.new);
  }
}
