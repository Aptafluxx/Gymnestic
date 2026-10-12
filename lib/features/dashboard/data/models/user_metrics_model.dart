import 'package:fl_chart/fl_chart.dart';

class UserMetricsModel {
  const UserMetricsModel({
    required this.bpm,
    required this.kcalBurned,
    required this.currentWeight,
    required this.chartHistory,
  });

  final int bpm;
  final int kcalBurned;
  final int currentWeight;
  final List<double> chartHistory;

  factory UserMetricsModel.initial() => const UserMetricsModel(
    bpm: 78,
    kcalBurned: 340,
    currentWeight: 120,
    chartHistory: [1.4, 3.5, 1.8, 4.7, 4.5],
  );

  factory UserMetricsModel.fromMap(Map<String, dynamic> map) {
    final rawHistory = map['chartHistory'];
    final chartHistory = rawHistory is List
        ? rawHistory.whereType<num>().map((value) => value.toDouble()).toList()
        : UserMetricsModel.initial().chartHistory;
    final initial = UserMetricsModel.initial();

    return UserMetricsModel(
      bpm: (map['bpm'] as num?)?.toInt() ?? initial.bpm,
      kcalBurned: (map['kcalBurned'] as num?)?.toInt() ?? initial.kcalBurned,
      currentWeight:
          (map['currentWeight'] as num?)?.toInt() ?? initial.currentWeight,
      chartHistory: chartHistory.isEmpty ? initial.chartHistory : chartHistory,
    );
  }

  Map<String, dynamic> toMap() => {
    'bpm': bpm,
    'kcalBurned': kcalBurned,
    'currentWeight': currentWeight,
    'chartHistory': chartHistory,
  };

  List<FlSpot> toFlSpots() => chartHistory
      .asMap()
      .entries
      .map((entry) => FlSpot(entry.key.toDouble(), entry.value))
      .toList();
}
