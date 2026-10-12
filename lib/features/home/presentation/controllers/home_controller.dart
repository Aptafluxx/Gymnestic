import 'package:get/get.dart';
import 'package:gymnestic/features/home/data/models/activity_model.dart';

class HomeController extends GetxController {
  final activities = const <ActivityModel>[
    ActivityModel(
      title: 'Training for Beginner',
      level: 'Build Your Body',
      imageUrl:
          'https://images.unsplash.com/photo-1583454110551-21f2fa2afe61?w=1000',
      difficulty: 2,
    ),
    ActivityModel(
      title: 'Strength Training',
      level: 'Build Your Body',
      imageUrl:
          'https://images.unsplash.com/photo-1534438327276-14e5300c3a48?w=1000',
      difficulty: 3,
    ),
    ActivityModel(
      title: 'Daily Stretch',
      level: 'Find More Energy',
      imageUrl:
          'https://images.unsplash.com/photo-1518611012118-696072aa579a?w=1000',
      difficulty: 1,
    ),
  ];
}
