import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
import 'package:gymnestic/core/widgets/gym_image.dart';
import 'package:gymnestic/core/widgets/section_heading.dart';
import 'package:gymnestic/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'package:gymnestic/features/profile/presentation/controllers/profile_controller.dart';

class ProfileScreen extends GetView<ProfileController> {
  const ProfileScreen({super.key});

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
      title: const Text('My Profile'),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.edit_outlined, color: AppColors.primaryRed),
        ),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 11, 18, 24),
        children: [
          Row(
            children: [
              ClipOval(
                child: GymImage(
                  url: controller.profile.photoUrl,
                  width: 82,
                  height: 82,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.profile.name,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      controller.profile.occupation,
                      style: const TextStyle(
                        color: AppColors.grayLight,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      controller.profile.phone,
                      style: const TextStyle(
                        color: AppColors.grayLight,
                        fontSize: 10,
                      ),
                    ),
                    const SizedBox(height: 7),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceDark,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.grayDark),
                      ),
                      child: Text(
                        controller.profile.level,
                        style: const TextStyle(
                          color: AppColors.primaryRed,
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 23),
          const SectionHeading(title: 'About Me', subtitle: ''),
          const SizedBox(height: 8),
          Text(
            controller.profile.biography,
            style: const TextStyle(
              color: AppColors.textMuted,
              fontSize: 11,
              height: 1.65,
            ),
          ),
          const SizedBox(height: 23),
          const SectionHeading(title: 'My Skill', subtitle: '10 total skill'),
          const SizedBox(height: 12),
          SizedBox(
            height: 37,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: controller.skills.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) => Obx(() {
                final selected = controller.selectedSkill.value == index;
                return InkWell(
                  onTap: () => controller.selectedSkill.value = index,
                  borderRadius: BorderRadius.circular(20),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: selected
                          ? AppColors.primaryRed.withValues(alpha: .13)
                          : AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: selected
                            ? AppColors.primaryRed
                            : AppColors.grayDark,
                      ),
                    ),
                    child: Text(
                      controller.skills[index],
                      style: TextStyle(
                        color: selected
                            ? AppColors.primaryRed
                            : AppColors.grayLighter,
                        fontSize: 10,
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 23),
          const SectionHeading(title: 'Social Media', subtitle: 'Follow me at'),
          const SizedBox(height: 11),
          ...controller.socialLinks.map((link) {
            final icon = switch (link.platform) {
              'Facebook' => Icons.facebook,
              'Twitter' => Icons.alternate_email,
              _ => Icons.smart_display_outlined,
            };
            return Container(
              margin: const EdgeInsets.only(bottom: 9),
              padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceDark,
                border: Border.all(color: const Color(0xFF1E1E1E)),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(icon, size: 20, color: AppColors.grayLighter),
                  const SizedBox(width: 10),
                  Text(
                    link.platform,
                    style: const TextStyle(
                      fontSize: 11,
                      color: AppColors.grayLighter,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    link.username,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textMuted,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    ),
  );
}
