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
          onPressed: controller.editBio,
          icon: const Icon(Icons.edit_outlined, color: AppColors.primaryRed),
        ),
      ],
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 11, 18, 24),
        children: [
          Obx(
            () => Row(
              children: [
                ClipOval(
                  child: GymImage(
                    url: 'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300',
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
                        controller.userProfile.value.fullName,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        controller.userProfile.value.role,
                        style: const TextStyle(
                          color: AppColors.grayLight,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.userProfile.value.phone,
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
                          controller.userProfile.value.badgeLevel,
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
          ),
          const SizedBox(height: 23),
          const SectionHeading(title: 'About Me', subtitle: ''),
          const SizedBox(height: 8),
          Obx(
            () => Text(
              controller.userProfile.value.bio,
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                height: 1.65,
              ),
            ),
          ),
          const SizedBox(height: 23),
          Obx(
            () => SectionHeading(
              title: 'My Skill',
              subtitle:
                  '${controller.userProfile.value.skills.length} total skill',
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 37,
            child: Obx(
              () => ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.userProfile.value.skills.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final skill = controller.userProfile.value.skills[index];
                  final selected = controller.selectedSkill.value == skill;
                  return InkWell(
                    onTap: () => controller.selectSkill(skill),
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
                        skill,
                        style: TextStyle(
                          color: selected
                              ? AppColors.primaryRed
                              : AppColors.grayLighter,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
          const SizedBox(height: 23),
          const SectionHeading(title: 'Social Media', subtitle: 'Follow me at'),
          const SizedBox(height: 11),
          Obx(
            () => Column(
              children: controller.userProfile.value.socialLinks.entries.map((
                link,
              ) {
                final icon = switch (link.key) {
                  'Facebook' => Icons.facebook,
                  'Twitter' => Icons.alternate_email,
                  _ => Icons.smart_display_outlined,
                };
                return Container(
                  margin: const EdgeInsets.only(bottom: 9),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 13,
                    vertical: 12,
                  ),
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
                        link.key,
                        style: const TextStyle(
                          fontSize: 11,
                          color: AppColors.grayLighter,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        link.value,
                        style: const TextStyle(
                          fontSize: 10,
                          color: AppColors.textMuted,
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}
