import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/routes/app_routes.dart';
import 'package:gymnestic/core/theme/app_colors.dart';
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
    ),
    body: SafeArea(
      top: false,
      child: ListView(
        padding: const EdgeInsets.fromLTRB(18, 25, 18, 24),
        children: [
          // 1. User Info Section
          Row(
            children: [
              ClipOval(child: Icon(Icons.person, size: 80)),
              const SizedBox(width: 16),
              Expanded(
                child: Obx(
                  () => Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        controller.userProfile.value.fullName.isNotEmpty
                            ? controller.userProfile.value.fullName
                            : 'Add your name',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        controller.userProfile.value.role.isNotEmpty
                            ? controller.userProfile.value.role
                            : 'Add your role',
                        style: const TextStyle(
                          color: AppColors.grayLight,
                          fontSize: 10,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        controller.userProfile.value.phone.isNotEmpty
                            ? controller.userProfile.value.phone
                            : 'Add phone number',
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
              ),
              IconButton(
                onPressed: controller.editUserInfo,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryRed,
                  size: 22,
                ),
              ),
            ],
          ),
          const SizedBox(height: 25),

          // 2. About Me Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const SectionHeading(title: 'About Me', subtitle: ''),
              IconButton(
                onPressed: controller.editBio,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
              ),
            ],
          ),
          Obx(
            () => Text(
              controller.userProfile.value.bio.isNotEmpty
                  ? controller.userProfile.value.bio
                  : 'Tell us a little bit about yourself...',
              style: TextStyle(
                color: controller.userProfile.value.bio.isNotEmpty
                    ? AppColors.textMuted
                    : AppColors.grayDark,
                fontSize: 11,
                height: 1.65,
                fontStyle: controller.userProfile.value.bio.isEmpty
                    ? FontStyle.italic
                    : FontStyle.normal,
              ),
            ),
          ),
          const SizedBox(height: 25),

          // 3. Skills Section
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Obx(
                () => SectionHeading(
                  title: 'My Skill',
                  subtitle:
                      '${controller.userProfile.value.skills.length} total skill',
                ),
              ),
              IconButton(
                onPressed: controller.editSkills,
                icon: const Icon(
                  Icons.edit_outlined,
                  color: AppColors.primaryRed,
                  size: 20,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 37,
            child: Obx(() {
              if (controller.userProfile.value.skills.isEmpty) {
                return const Text(
                  'No skills added yet.',
                  style: TextStyle(
                    color: AppColors.grayDark,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                );
              }
              return ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: controller.userProfile.value.skills.length,
                separatorBuilder: (context, index) => const SizedBox(width: 8),
                itemBuilder: (context, index) {
                  final skill = controller.userProfile.value.skills[index];
                  return Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceDark,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: AppColors.grayDark),
                    ),
                    child: Text(
                      skill,
                      style: TextStyle(
                        color: AppColors.grayLighter,
                        fontSize: 10,
                      ),
                    ),
                  );
                },
              );
            }),
          ),
          const SizedBox(height: 32),

          // 4. NEW: Progress Card Component
          _buildProgressCard(),
          const SizedBox(height: 32),
        ],
      ),
    ),
  );

  Widget _buildProgressCard() {
    return Obx(() {
      final progress = controller.profileProgress;
      final count = controller.completedFieldsCount;

      return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.surfaceDark,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.grayDark),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Profile Completion',
                  style: TextStyle(
                    color: AppColors.textWhite,
                    fontWeight: FontWeight.w700,
                    fontSize: 14,
                  ),
                ),
                Text(
                  '$count/6',
                  style: const TextStyle(
                    color: AppColors.primaryRed,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              progress >= 1.0
                  ? 'Outstanding! Your profile is fully complete.'
                  : 'Complete your profile to unlock personalized routines.',
              style: const TextStyle(color: AppColors.grayLight, fontSize: 11),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 8,
                backgroundColor: AppColors.cardDark,
                color: AppColors.primaryRed,
              ),
            ),
          ],
        ),
      );
    });
  }
}
