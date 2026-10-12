class WeeklyStatModel {
  const WeeklyStatModel({
    required this.dayName,
    required this.value,
    this.isSelected = false,
  });

  final String dayName;
  final double value;
  final bool isSelected;

  WeeklyStatModel copyWith({
    String? dayName,
    double? value,
    bool? isSelected,
  }) => WeeklyStatModel(
    dayName: dayName ?? this.dayName,
    value: value ?? this.value,
    isSelected: isSelected ?? this.isSelected,
  );
}
