import 'package:hive/hive.dart';
import 'pomodoro_session.dart';

part 'statistics.g.dart';

@HiveType(typeId: 3)
class DailyStatistics extends HiveObject {
  @HiveField(0)
  late DateTime date;

  @HiveField(1)
  late int completedPomodoros;

  @HiveField(2)
  late int totalFocusTimeInSeconds;

  @HiveField(3)
  late int completedTasks;

  DailyStatistics({
    required this.date,
    this.completedPomodoros = 0,
    this.totalFocusTimeInSeconds = 0,
    this.completedTasks = 0,
  });

  double get focusTimeInHours => totalFocusTimeInSeconds / 3600;

  void addSession(PomodoroSession session) {
    if (session.type == SessionType.work && session.completed) {
      completedPomodoros++;
      totalFocusTimeInSeconds += session.actualDurationInSeconds;
    }
  }
}

class StatisticsSummary {
  final int todayPomodoros;
  final int weekPomodoros;
  final int totalPomodoros;
  final double todayFocusHours;
  final double weekFocusHours;
  final double averageDailyPomodoros;
  final List<DailyStatistics> recentDays;

  StatisticsSummary({
    required this.todayPomodoros,
    required this.weekPomodoros,
    required this.totalPomodoros,
    required this.todayFocusHours,
    required this.weekFocusHours,
    required this.averageDailyPomodoros,
    required this.recentDays,
  });
}
