import 'package:get/get.dart';
import 'package:gymnestic/features/articles/presentation/controllers/articles_controller.dart';

class ArticlesBinding extends Bindings {
  @override
  void dependencies() {
    if (!Get.isRegistered<ArticlesController>()) {
      Get.lazyPut<ArticlesController>(ArticlesController.new);
    }
  }
}
