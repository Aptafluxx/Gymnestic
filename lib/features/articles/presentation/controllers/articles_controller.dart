import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/features/articles/data/models/article_model.dart';

class ArticlesController extends GetxController {
  final RxInt bannerIndex = 0.obs;
  final articles = const <ArticleModel>[
    ArticleModel(
      title: '10 Principals to Pack on Muscle',
      imageUrl:
          'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=600',
      views: '544',
      publishedAt: '06 August 2020',
      body: 'A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents.',
    ),
    ArticleModel(
      title: 'The Way to Make Your Dream',
      imageUrl:
          'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=600',
      views: '328',
      publishedAt: '12 August 2020',
      body: 'Build a routine that works for you, stay consistent, and give your body the time it needs to grow stronger. Small steps repeated every day create lasting progress.',
    ),
    ArticleModel(
      title: 'Best Breakfast to Build Body',
      imageUrl:
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600',
      views: '291',
      publishedAt: '18 August 2020',
      body: 'A balanced breakfast fuels your training and supports recovery. Choose nourishing foods that help you feel energized throughout the day.',
    ),
  ];

  void openArticle(ArticleModel article) =>
      Get.toNamed(AppRoutes.articleDetails, arguments: article);
}
