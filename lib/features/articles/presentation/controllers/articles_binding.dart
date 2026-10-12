import 'package:get/get.dart';
import 'package:gymnestic/features/articles/presentation/controllers/articles_controller.dart';

class ArticlesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticlesController>(ArticlesController.new);
  }
}
