import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/core/widgets/gym_image.dart';
import 'package:gymnestic/features/articles/presentation/controllers/articles_controller.dart';

class ArticleDetailsScreen extends GetView<ArticlesController> {
  const ArticleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      bottom: false,
      child: Obx(() {
        final article = controller.selectedArticle.value;
        if (article == null) {
          return const Center(child: CircularProgressIndicator());
        }
        return CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: SizedBox(
                height: 238,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    GymImage(url: article.imageUrl),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.black.withValues(alpha: .5),
                            Colors.transparent,
                            Colors.black.withValues(alpha: .5),
                          ],
                        ),
                      ),
                    ),
                    Positioned(
                      left: 14,
                      top: 5,
                      child: IconButton(
                        onPressed: Get.back,
                        icon: const Icon(Icons.arrow_back_ios_new, size: 19),
                      ),
                    ),
                    Positioned(
                      left: 16,
                      bottom: 16,
                      child: Row(
                        children: [
                          const Icon(Icons.visibility, size: 14),
                          const SizedBox(width: 5),
                          Text(
                            '${article.views} view',
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(width: 18),
                          const Icon(Icons.calendar_month, size: 13),
                          const SizedBox(width: 5),
                          Text(
                            article.date,
                            style: const TextStyle(fontSize: 10),
                          ),
                          const SizedBox(width: 14),
                          Text(
                            article.readTime,
                            style: const TextStyle(fontSize: 10),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(18, 17, 18, 24),
              sliver: SliverList.list(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          article.title,
                          style: const TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      IconButton(
                        onPressed: () => controller.toggleLike(article.id),
                        icon: Icon(
                          article.isLiked
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: AppColors.primaryRed,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'By @${article.author}',
                    style: const TextStyle(
                      color: AppColors.primaryRed,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 19),
                  Text(
                    '${article.content}\n\n$_additionalText',
                    maxLines: controller.isExpanded.value ? null : 7,
                    overflow: controller.isExpanded.value
                        ? TextOverflow.visible
                        : TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 12,
                      height: 1.75,
                      color: AppColors.textMuted,
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                      onPressed: controller.toggleReadMore,
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(0, 32),
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        controller.isExpanded.value ? 'Read less' : 'Read more',
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 11,
                        ),
                      ),
                    ),
                  ),
                  const Divider(color: AppColors.grayDark, height: 25),
                  Row(
                    children: [
                      const Expanded(
                        child: Text(
                          'People liked',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ..._likedAvatars.map(
                        (url) => Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: ClipOval(
                            child: GymImage(url: url, width: 31, height: 31),
                          ),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Container(
                        width: 40,
                        height: 34,
                        alignment: Alignment.center,
                        decoration: const BoxDecoration(
                          color: AppColors.primaryRed,
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          '+${article.likesCount}',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    ),
  );

  static const _additionalText =
      'When I hear the buzz of the little world among the stalks, and grow familiar with the countless indescribable forms of the insects and flies, then I feel the presence of the Almighty, who formed us in his own image.\n\n'
      'I am so happy, my dear friend, so absorbed in the exquisite sense of mere tranquil existence, that I neglect my talents.';

  static const _likedAvatars = [
    'https://images.unsplash.com/photo-1500648767791-00dcc994a43e?w=100',
    'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=100',
    'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=100',
  ];
}
