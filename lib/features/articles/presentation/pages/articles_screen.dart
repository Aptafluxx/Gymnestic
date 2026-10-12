import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/core/widgets/gym_image.dart';
import 'package:gymnestic/core/widgets/section_heading.dart';
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
          SizedBox(
            height: 245,
            child: PageView.builder(
              itemCount: 3,
              onPageChanged: (index) => controller.bannerIndex.value = index,
              itemBuilder: (context, index) => const _HeroBanner(),
            ),
          ),
          const SizedBox(height: 16),
          Obx(
            () => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                3,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 180),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  width: controller.bannerIndex.value == index ? 8 : 6,
                  height: controller.bannerIndex.value == index ? 8 : 6,
                  decoration: BoxDecoration(
                    color: controller.bannerIndex.value == index
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
          ...controller.articles.map(
            (article) => Padding(
              padding: const EdgeInsets.fromLTRB(18, 0, 18, 11),
              child: InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => controller.openArticle(article),
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
          ),
        ],
      ),
    ),
  );
}

class _HeroBanner extends StatelessWidget {
  const _HeroBanner();

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
        child: GymImage(
          url: 'https://images.unsplash.com/photo-1538805060514-97d9cc17730c?w=900',
          fit: BoxFit.cover,
        ),
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
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Get Ready for\nNew Era',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            SizedBox(height: 9),
            Text(
              'That strategy doesn’t need to be so rigid that it leaves no room for fun.',
              style: TextStyle(fontSize: 10, height: 1.5),
            ),
          ],
        ),
      ),
    ],
  );
}
