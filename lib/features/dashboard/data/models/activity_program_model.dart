class ActivityProgramModel {
  const ActivityProgramModel({
    required this.id,
    required this.title,
    required this.level,
    required this.imageUrl,
    required this.difficultyRating,
  });

  final String id;
  final String title;
  final String level;
  final String imageUrl;
  final int difficultyRating;
}
