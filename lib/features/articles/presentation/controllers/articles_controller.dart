import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/features/articles/data/models/article_model.dart';

class ArticlesController extends GetxController {
  final RxInt heroCarouselIndex = 0.obs;
  final RxList<ArticleModel> heroArticles = <ArticleModel>[
    const ArticleModel(
      id: 'hero-muscle',
      title: 'Get Ready for New Era',
      author: 'authorname',
      readTime: '5 min read',
      views: '544',
      date: '06 August 2020',
      content: 'That strategy doesn’t need to be so rigid that it leaves no room for fun.',
      imageUrl:
          'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=900',
    ),
    const ArticleModel(
      id: 'hero-training',
      title: 'The Way to Make Your Dream',
      author: 'authorname',
      readTime: '4 min read',
      views: '328',
      date: '12 August 2020',
      content: 'Build a routine that works for you and make every day count.',
      imageUrl:
          'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=900',
    ),
    const ArticleModel(
      id: 'hero-nutrition',
      title: 'Build Strength Every Day',
      author: 'authorname',
      readTime: '6 min read',
      views: '291',
      date: '18 August 2020',
      content: 'Fuel your training with healthy habits and nourishing meals.',
      imageUrl:
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=900',
    ),
  ].obs;
  final RxList<ArticleModel> recommendedArticles = <ArticleModel>[
    const ArticleModel(
      id: 'muscle-principles',
      title: '10 Principals to Pack on Muscle',
      author: 'authorname',
      readTime: '5 min read',
      views: '544',
      date: '06 August 2020',
      content: 'A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I am alone, and feel the charm of existence in this spot, which was created for the bliss of souls like mine. I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents.',
      imageUrl:
          'https://images.unsplash.com/photo-1581009146145-b5ef050c2e1e?w=600',
    ),
    const ArticleModel(
      id: 'make-your-dream',
      title: 'The Way to Make Your Dream',
      author: 'authorname',
      readTime: '4 min read',
      views: '328',
      date: '12 August 2020',
      content: 'Build a routine that works for you, stay consistent, and give your body the time it needs to grow stronger. Small steps repeated every day create lasting progress.',
      imageUrl:
          'https://images.unsplash.com/photo-1599058945522-28d584b6f0ff?w=600',
    ),
    const ArticleModel(
      id: 'body-breakfast',
      title: 'Best Breakfast to Build Body',
      author: 'authorname',
      readTime: '6 min read',
      views: '291',
      date: '18 August 2020',
      content: 'A balanced breakfast fuels your training and supports recovery. Choose nourishing foods that help you feel energized throughout the day.',
      imageUrl:
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=600',
    ),
  ].obs;
  final Rx<ArticleModel?> selectedArticle = Rx<ArticleModel?>(null);
  final RxBool isExpanded = false.obs;

  @override
  void onInit() {
    super.onInit();
    selectedArticle.value = recommendedArticles.first;
  }

  void toggleLike(String articleId) {
    ArticleModel toggle(ArticleModel article) {
      final liked = !article.isLiked;
      return article.copyWith(
        isLiked: liked,
        likesCount: article.likesCount + (liked ? 1 : -1),
      );
    }

    final recommendationIndex = recommendedArticles.indexWhere(
      (article) => article.id == articleId,
    );
    if (recommendationIndex != -1) {
      recommendedArticles[recommendationIndex] = toggle(
        recommendedArticles[recommendationIndex],
      );
    }

    final heroIndex = heroArticles.indexWhere(
      (article) => article.id == articleId,
    );
    if (heroIndex != -1) {
      heroArticles[heroIndex] = toggle(heroArticles[heroIndex]);
    }

    final selected = selectedArticle.value;
    if (selected?.id == articleId) {
      selectedArticle.value = toggle(selected!);
    }
  }

  void toggleReadMore() => isExpanded.toggle();

  void selectArticle(ArticleModel article) {
    selectedArticle.value = article;
    isExpanded.value = false;
    Get.toNamed(AppRoutes.articleDetails);
  }
}
