import 'package:get/get.dart';
import 'package:gymnestic/features/articles/data/models/article_model.dart';

class ArticleDetailsController extends GetxController {
  late final ArticleModel article;
  final RxBool isFavorite = false.obs;
  final RxBool isExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    final selectedArticle = Get.arguments;
    article = selectedArticle is ArticleModel
        ? selectedArticle
        : const ArticleModel(
            title: '10 Principals to Pack on Muscle',
            imageUrl: 'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=1000',
            views: '544',
            publishedAt: '06 August 2020',
            body: 'A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents.',
          );
  }

  void toggleFavorite() => isFavorite.toggle();
  void toggleExpanded() => isExpanded.toggle();
}
