import 'package:get/get.dart';
import 'package:gymnestic/features/articles/presentation/controllers/article_details_controller.dart';

class ArticleDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ArticleDetailsController>(ArticleDetailsController.new);
  }
}
