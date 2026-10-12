class DailyGoalModel {
  const DailyGoalModel({
    required this.time,
    required this.title,
    this.isComplete = false,
  });

  final String time;
  final String title;
  final bool isComplete;

  DailyGoalModel copyWith({bool? isComplete}) => DailyGoalModel(
    time: time,
    title: title,
    isComplete: isComplete ?? this.isComplete,
  );
}
