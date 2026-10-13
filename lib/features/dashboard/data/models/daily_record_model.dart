class DailyRecordModel {
  final String dateKey;
  final int bpm;
  final int weight;
  final int kcalBurned;
  final List<String> completedGoalIds;
  final double runningKm;
  final int sleepHours;

  const DailyRecordModel({
    required this.dateKey,
    required this.bpm,
    required this.weight,
    required this.kcalBurned,
    required this.completedGoalIds,
    this.runningKm = 0.0,
    this.sleepHours = 0,
  });

  factory DailyRecordModel.empty(String dateKey) {
    return DailyRecordModel(
      dateKey: dateKey,
      bpm: 70,
      weight: 0,
      kcalBurned: 0,
      completedGoalIds: const [],
      runningKm: 0.0,
      sleepHours: 0,
    );
  }

  factory DailyRecordModel.fromMap(String dateKey, Map<String, dynamic> map) {
    return DailyRecordModel(
      dateKey: dateKey,
      bpm: (map['bpm'] as num?)?.toInt() ?? 70,
      weight: (map['weight'] as num?)?.toInt() ?? 0,
      kcalBurned: (map['kcalBurned'] as num?)?.toInt() ?? 0,
      completedGoalIds: List<String>.from(map['completedGoalIds'] ?? []),
      runningKm: (map['runningKm'] as num?)?.toDouble() ?? 0.0,
      sleepHours: (map['sleepHours'] as num?)?.toInt() ?? 0,
    );
  }

  Map<String, dynamic> toMap() => {
    'dateKey': dateKey,
    'bpm': bpm,
    'weight': weight,
    'kcalBurned': kcalBurned,
    'completedGoalIds': completedGoalIds,
    'runningKm': runningKm,
    'sleepHours': sleepHours,
  };
}
