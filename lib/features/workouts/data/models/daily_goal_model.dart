class DailyGoalModel {
  const DailyGoalModel({
    required this.id,
    required this.time,
    required this.title,
    this.isCompleted = false,
    this.gender = 'All',
    this.calorieReward = 20,
  });

  final String id;
  final String time;
  final String title;
  final bool isCompleted;
  final String gender;
  final int calorieReward;

  DailyGoalModel copyWith({
    String? id,
    String? time,
    String? title,
    bool? isCompleted,
    String? gender,
    int? calorieReward,
  }) => DailyGoalModel(
    id: id ?? this.id,
    time: time ?? this.time,
    title: title ?? this.title,
    isCompleted: isCompleted ?? this.isCompleted,
    gender: gender ?? this.gender,
    calorieReward: calorieReward ?? this.calorieReward,
  );

  factory DailyGoalModel.fromMap(String documentId, Map<String, dynamic> map) =>
      DailyGoalModel(
        id: documentId,
        time: map['time'] as String? ?? '08:00',
        title: map['title'] as String? ?? '',
        isCompleted: map['isCompleted'] as bool? ?? false,
        gender: map['gender'] as String? ?? 'All',
        calorieReward: (map['calorieReward'] as num?)?.toInt() ?? 20,
      );

  Map<String, dynamic> toMap() => {
    'time': time,
    'title': title,
    'isCompleted': isCompleted,
    'gender': gender,
    'calorieReward': calorieReward,
  };
}
