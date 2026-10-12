import 'package:get/get.dart';
import 'package:gymnestic/features/statistics/data/models/weekly_activity_model.dart';

class StatisticsController extends GetxController {
  final weeklyActivity = const <WeeklyActivityModel>[
    WeeklyActivityModel(day: 'Mon', value: 8),
    WeeklyActivityModel(day: 'Tue', value: 10),
    WeeklyActivityModel(day: 'Wed', value: 4),
    WeeklyActivityModel(day: 'Thu', value: 10),
    WeeklyActivityModel(day: 'Fri', value: 5),
    WeeklyActivityModel(day: 'Sat', value: 10),
  ];
}
