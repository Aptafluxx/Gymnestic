class DailyGoalModel {
  const DailyGoalModel({
    required this.id,
    required this.time,
    required this.title,
    this.isCompleted = false,
  });

  final String id;
  final String time;
  final String title;
  final bool isCompleted;

  DailyGoalModel copyWith({
    String? id,
    String? time,
    String? title,
    bool? isCompleted,
  }) => DailyGoalModel(
    id: id ?? this.id,
    time: time ?? this.time,
    title: title ?? this.title,
    isCompleted: isCompleted ?? this.isCompleted,
  );
}
