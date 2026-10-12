class DailyGoalModel {
  final String id;
  final String programId;
  final String time;
  final String title;
  final bool isCompleted;
  final String gender;
  final int calorieReward;

  const DailyGoalModel({
    required this.id,
    required this.programId,
    required this.time,
    required this.title,
    this.isCompleted = false,
    this.gender = 'All',
    this.calorieReward = 20,
  });

  DailyGoalModel copyWith({
    String? id,
    String? programId,
    String? time,
    String? title,
    bool? isCompleted,
    String? gender,
    int? calorieReward,
  }) {
    return DailyGoalModel(
      id: id ?? this.id,
      programId: programId ?? this.programId,
      time: time ?? this.time,
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
      gender: gender ?? this.gender,
      calorieReward: calorieReward ?? this.calorieReward,
    );
  }

  factory DailyGoalModel.fromMap(String id, Map<String, dynamic> map) {
    return DailyGoalModel(
      id: id,
      programId: map['programId'] as String? ?? 'beginner',
      time: map['time'] as String? ?? '08:00',
      title: map['title'] as String? ?? '',
      isCompleted: map['isCompleted'] as bool? ?? false,
      gender: map['gender'] as String? ?? 'All',
      calorieReward: (map['calorieReward'] as num?)?.toInt() ?? 20,
    );
  }

  Map<String, dynamic> toMap() => {
    'programId': programId,
    'time': time,
    'title': title,
    'isCompleted': isCompleted,
    'gender': gender,
    'calorieReward': calorieReward,
  };
}
