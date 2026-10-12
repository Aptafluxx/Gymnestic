class DailyRecordModel {
  const DailyRecordModel({
    required this.dateKey,
    required this.bpm,
    required this.weight,
    required this.kcalBurned,
    required this.completedGoalIds,
  });

  final String dateKey;
  final int bpm;
  final int weight;
  final int kcalBurned;
  final List<String> completedGoalIds;

  factory DailyRecordModel.empty(String dateKey) {
    return DailyRecordModel(
      dateKey: dateKey,
      bpm: 72,
      weight: 120,
      kcalBurned: 0,
      completedGoalIds: const [],
    );
  }

  factory DailyRecordModel.fromMap(String dateKey, Map<String, dynamic> map) {
    return DailyRecordModel(
      dateKey: dateKey,
      bpm: (map['bpm'] as num?)?.toInt() ?? 72,
      weight: (map['weight'] as num?)?.toInt() ?? 120,
      kcalBurned: (map['kcalBurned'] as num?)?.toInt() ?? 0,
      completedGoalIds: List<String>.from(map['completedGoalIds'] ?? const []),
    );
  }

  Map<String, dynamic> toMap() => {
    'dateKey': dateKey,
    'bpm': bpm,
    'weight': weight,
    'kcalBurned': kcalBurned,
    'completedGoalIds': completedGoalIds,
  };
}
