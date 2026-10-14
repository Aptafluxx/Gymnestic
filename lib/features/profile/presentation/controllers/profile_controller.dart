import 'dart:async';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:gymnestic/core/widgets/app_text_field.dart';

import '../../data/models/user_profile_model.dart';
import '../../../dashboard/data/datasources/fitness_remote_data_source.dart';

class ProfileController extends GetxController {
  ProfileController({FitnessRemoteDataSource? dataSource})
    : _dataSource = dataSource ?? FitnessRemoteDataSource();

  final FitnessRemoteDataSource _dataSource;

  final Rx<UserProfileModel> userProfile = UserProfileModel.initial().obs;

  StreamSubscription<UserProfileModel>? _profileSubscription;

  @override
  void onInit() {
    super.onInit();
    _bindProfileStream();
  }

  void _bindProfileStream() {
    _profileSubscription?.cancel();
    _profileSubscription = _dataSource.streamUserProfile().listen((profile) {
      userProfile.value = profile;
    });
  }

  Future<void> saveProfileChanges({
    String? fullName,
    String? role,
    String? phone,
  }) async {
    final updates = <String, dynamic>{};

    if (fullName != null && fullName.trim().isNotEmpty) {
      updates['fullName'] = fullName.trim();
    }
    if (role != null && role.trim().isNotEmpty) updates['role'] = role.trim();
    if (phone != null && phone.trim().isNotEmpty) {
      updates['phone'] = phone.trim();
    }

    if (updates.isNotEmpty) {
      userProfile.value = userProfile.value.copyWith(
        fullName: fullName ?? userProfile.value.fullName,
        role: role ?? userProfile.value.role,
        phone: phone ?? userProfile.value.phone,
      );
      await _dataSource.updateUserProfile(updates);
    }
  }

  Future<void> updateBio(String newBio) async {
    final trimmedBio = newBio.trim();
    if (trimmedBio.isEmpty) return;
    userProfile.value = userProfile.value.copyWith(bio: trimmedBio);
    await _dataSource.updateUserProfile({'bio': trimmedBio});
  }

  Widget _buildDialogTextField(
    TextEditingController ctrl,
    String hintText,
    TextInputType textInputType,
    IconData prefixIcon,
  ) {
    return AppTextField(
      controller: ctrl,
      hintText: hintText,
      prefixIcon: prefixIcon,
      keyboardType: textInputType,
    );
  }

  void editUserInfo() {
    final nameCtrl = TextEditingController(text: userProfile.value.fullName);
    final roleCtrl = TextEditingController(text: userProfile.value.role);
    final phoneCtrl = TextEditingController(text: userProfile.value.phone);

    Get.dialog<void>(
      AlertDialog(
        backgroundColor: const Color(0xFF141516),
        title: const Text(
          'Edit Profile',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogTextField(nameCtrl, 'Full Name', .name, Icons.person),
            const SizedBox(height: 12),
            _buildDialogTextField(
              roleCtrl,
              'Role (e.g. Athlete)',
              .text,
              Icons.people,
            ),
            const SizedBox(height: 12),
            _buildDialogTextField(
              phoneCtrl,
              'Phone Number',
              .phone,
              Icons.phone,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              saveProfileChanges(
                fullName: nameCtrl.text,
                role: roleCtrl.text,
                phone: phoneCtrl.text,
              );
              Get.back();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFFF34E3A)),
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        nameCtrl.dispose();
        roleCtrl.dispose();
        phoneCtrl.dispose();
      });
    });
  }

  void editBio() {
    final textController = TextEditingController(text: userProfile.value.bio);
    Get.dialog<void>(
      AlertDialog(
        backgroundColor: const Color(0xFF141516),
        title: const Text(
          'Edit About Me',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: TextField(
          controller: textController,
          maxLines: 5,
          style: const TextStyle(color: Colors.white, fontSize: 13),
          decoration: InputDecoration(
            hintText: 'Tell us about yourself',
            hintStyle: const TextStyle(color: Colors.grey),
            filled: true,
            fillColor: const Color(0xFF1E1E1E),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () {
              updateBio(textController.text);
              Get.back();
            },
            child: const Text(
              'Save',
              style: TextStyle(color: Color(0xFFF34E3A)),
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      Future.delayed(const Duration(milliseconds: 300), () {
        textController.dispose();
      });
    });
  }

  // --- SKILL MANAGEMENT METHODS ---

  Future<void> addSkill(String newSkill) async {
    final trimmed = newSkill.trim();
    // Prevent empty strings or duplicates
    if (trimmed.isEmpty || userProfile.value.skills.contains(trimmed)) return;

    final updatedSkills = List<String>.from(userProfile.value.skills)
      ..add(trimmed);

    // Optimistic UI update
    userProfile.value = userProfile.value.copyWith(skills: updatedSkills);

    // Persist array to Firestore
    await _dataSource.updateUserProfile({'skills': updatedSkills});
  }

  Future<void> removeSkill(String skillToRemove) async {
    final updatedSkills = List<String>.from(userProfile.value.skills)
      ..remove(skillToRemove);

    // Optimistic UI update
    userProfile.value = userProfile.value.copyWith(skills: updatedSkills);

    final updates = <String, dynamic>{'skills': updatedSkills};

    await _dataSource.updateUserProfile(updates);
  }

  void editSkills() {
    final skillCtrl = TextEditingController();

    Get.dialog<void>(
      AlertDialog(
        backgroundColor: const Color(0xFF141516),
        title: const Text(
          'Manage Skills',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
        content: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Add New Skill Input
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: skillCtrl,
                      style: const TextStyle(color: Colors.white, fontSize: 13),
                      decoration: InputDecoration(
                        hintText: 'Add a skill (e.g. Yoga)',
                        hintStyle: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                        filled: true,
                        fillColor: const Color(0xFF1E1E1E),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onSubmitted: (val) {
                        addSkill(val);
                        skillCtrl.clear();
                      },
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      addSkill(skillCtrl.text);
                      skillCtrl.clear();
                    },
                    icon: const Icon(
                      Icons.add_circle,
                      color: Color(0xFFF34E3A),
                      size: 28,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Display Current Skills with Delete Options
              Obx(
                () => Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: userProfile.value.skills.map((skill) {
                    return Chip(
                      label: Text(
                        skill,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                        ),
                      ),
                      backgroundColor: const Color(0xFF1E1E1E),
                      deleteIconColor: Colors.grey,
                      onDeleted: () => removeSkill(skill),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                        side: const BorderSide(color: Color(0xFF2A2A2A)),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: Get.back,
            child: const Text(
              'Done',
              style: TextStyle(color: Color(0xFFF34E3A)),
            ),
          ),
        ],
      ),
    ).whenComplete(() {
      Future.delayed(
        const Duration(milliseconds: 300),
        () => skillCtrl.dispose(),
      );
    });
  }

  double get profileProgress {
    int score = 0;
    final p = userProfile.value;

    if (p.fullName.trim().isNotEmpty) score++;
    if (p.role.trim().isNotEmpty) score++;
    if (p.phone.trim().isNotEmpty) score++;
    if (p.bio.trim().isNotEmpty) score++;
    if (p.skills.isNotEmpty) score++;

    return score / 6.0;
  }

  int get completedFieldsCount {
    return (profileProgress * 6).round();
  }

  @override
  void onClose() {
    _profileSubscription?.cancel();
    super.onClose();
  }
}
