import 'package:get/get.dart';
import 'package:gymnestic/features/profile/data/models/profile_model.dart';
import 'package:gymnestic/features/profile/data/models/social_link_model.dart';

class ProfileController extends GetxController {
  final profile = const ProfileModel(
    name: 'Roberto Luigie',
    occupation: 'UI/UX Designer',
    phone: '+62 083 098 267 980',
    level: 'BEGINNER',
    biography: 'A wonderful serenity has taken possession of my entire soul, like these sweet mornings of spring which I enjoy with my whole heart. I enjoy the simple things that help me grow stronger every day.',
    photoUrl:
        'https://images.unsplash.com/photo-1506794778202-cad84cf45f1d?w=300',
  );
  final skills = const ['Sprint', 'Weightlifting', 'Barbell', 'Cardio'];
  final RxInt selectedSkill = 0.obs;
  final socialLinks = const <SocialLinkModel>[
    SocialLinkModel(platform: 'Facebook', username: '@RobertoLuigi'),
    SocialLinkModel(platform: 'Twitter', username: '@Roberto123'),
    SocialLinkModel(platform: 'YouTube', username: 'Gymwithme'),
  ];
}
