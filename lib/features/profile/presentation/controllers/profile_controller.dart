import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/features/profile/data/models/user_profile_model.dart';

class ProfileController extends GetxController {
  final Rx<UserProfileModel> userProfile = const UserProfileModel(
    fullName: 'Roberto Luigie',
    role: 'UI/UX Designer',
    phone: '+62 083 098 267 980',
    badgeLevel: 'BEGINNER',
    bio: 'A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I enjoy the simple things that help me grow stronger every day.',
    skills: [
      'Sprint',
      'Weightlifting',
      'Barbell',
      'Cardio',
      'Strength',
      'Endurance',
      'Yoga',
      'Cycling',
      'Core',
      'Flexibility',
    ],
    socialLinks: {
      'Facebook': '@RobertoLuigi',
      'Twitter': '@Roberto123',
      'YouTube': 'Gymwithme',
    },
  ).obs;
  final RxString selectedSkill = 'Sprint'.obs;

  void selectSkill(String skill) {
    if (userProfile.value.skills.contains(skill)) selectedSkill.value = skill;
  }

  void updateBio(String newBio) {
    userProfile.value = userProfile.value.copyWith(bio: newBio.trim());
  }

  void editBio() {
    final textController = TextEditingController(text: userProfile.value.bio);
    Get.dialog<void>(
      AlertDialog(
        title: const Text('Edit About Me'),
        content: TextField(
          controller: textController,
          maxLines: 5,
          decoration: const InputDecoration(hintText: 'Tell us about yourself'),
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          TextButton(
            onPressed: () {
              updateBio(textController.text);
              Get.back();
            },
            child: const Text('Save'),
          ),
        ],
      ),
    ).whenComplete(textController.dispose);
  }
}
