import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/core/widgets/gym_image.dart';
import 'package:gymnestic/core/widgets/section_heading.dart';
import 'package:gymnestic/features/articles/data/models/article_model.dart';
import 'package:gymnestic/features/articles/presentation/controllers/articles_controller.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/dashboard_controller.dart';

class ArticlesScreen extends GetView<ArticlesController> {
  const ArticlesScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      leading: IconButton(
        onPressed: () {
          if (Get.currentRoute == AppRoutes.home &&
              Get.isRegistered<DashboardController>()) {
            Get.find<DashboardController>().selectTab(0);
          } else {
            Get.back();
          }
        },
        icon: const Icon(Icons.arrow_back_ios_new, size: 19),
      ),
      title: const SizedBox.shrink(),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.search_rounded)),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.only(bottom: 20),
        children: [
          Obx(
            () => SizedBox(
              height: 245,
              child: PageView.builder(
                itemCount: controller.heroArticles.length,
                onPageChanged: (index) =>
                    controller.heroCarouselIndex.value = index,
                itemBuilder: (context, index) =>
                    _HeroBanner(article: controller.heroArticles[index]),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                controller.heroArticles.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: controller.heroCarouselIndex.value == index ? 8 : 6,
                  height: controller.heroCarouselIndex.value == index ? 8 : 6,
                  decoration: BoxDecoration(
                    color: controller.heroCarouselIndex.value == index
                        ? AppColors.primaryRed
                        : AppColors.grayMedium,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 24, 18, 14),
            child: const SectionHeading(
              title: 'Rekomendation',
              subtitle: 'Latest article this month',
            ),
          ),
          Obx(
            () => Column(
              children: controller.recommendedArticles
                  .map(
                    (article) => Padding(
                      padding: const EdgeInsets.fromLTRB(18, 0, 18, 11),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => controller.selectArticle(article),
                        child: Container(
                          height: 108,
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: AppColors.cardDark,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              Expanded(
                                child: Text(
                                  article.title,
                                  style: const TextStyle(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                  maxLines: 3,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 10),
                              GymImage(
                                url: article.imageUrl,
                                width: 116,
                                height: 84,
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  )
                  .toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner({required this.article});

  final ArticleModel article;

  @override
  Widget build(BuildContext context) => Stack(
    fit: StackFit.expand,
    children: [
      Container(color: AppColors.primaryRed),
      Positioned(
        right: -12,
        bottom: 0,
        top: 0,
        width: MediaQuery.sizeOf(context).width * .58,
        child: GymImage(url: article.imageUrl, fit: BoxFit.cover),
      ),
      Positioned.fill(
        child: DecoratedBox(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                AppColors.primaryRed,
                AppColors.primaryRed.withValues(alpha: .96),
                AppColors.primaryRed.withValues(alpha: .02),
              ],
              stops: const [0, .43, 1],
            ),
          ),
        ),
      ),
      Positioned(
        left: 18,
        top: 42,
        width: MediaQuery.sizeOf(context).width * .47,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              article.title,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 9),
            Text(
              article.content,
              style: const TextStyle(fontSize: 10, height: 1.5),
            ),
          ],
        ),
      ),
    ],
  );
}
