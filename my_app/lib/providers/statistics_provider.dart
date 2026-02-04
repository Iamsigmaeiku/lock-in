import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../models/pomodoro_session.dart';
import '../models/statistics.dart';

class StatisticsProvider with ChangeNotifier {
  late Box<PomodoroSession> _sessionBox;
  late Box<DailyStatistics> _statsBox;
  Map<String, DailyStatistics> _dailyStats = {};

  Future<void> initialize() async {
    _sessionBox = await Hive.openBox<PomodoroSession>('sessions');
    _statsBox = await Hive.openBox<DailyStatistics>('daily_stats');
    _loadData();
  }

  void _loadData() {
    _dailyStats = {
      for (var stat in _statsBox.values)
        _getDateKey(stat.date): stat
    };
    notifyListeners();
  }

  String _getDateKey(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  Future<void> addSession(PomodoroSession session) async {
    await _sessionBox.add(session);
    
    // 只統計完成的工作會話
    if (session.completed && session.type == SessionType.work) {
      final dateKey = _getDateKey(session.startTime);
      DailyStatistics? stat = _dailyStats[dateKey];
      
      if (stat == null) {
        stat = DailyStatistics(
          date: DateTime(
            session.startTime.year,
            session.startTime.month,
            session.startTime.day,
          ),
        );
        await _statsBox.put(dateKey, stat);
      }
      
      stat.addSession(session);
      await stat.save();
      _dailyStats[dateKey] = stat;
    }
    
    _loadData();
  }

  StatisticsSummary getSummary() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final weekAgo = today.subtract(const Duration(days: 7));

    int todayPomodoros = 0;
    int weekPomodoros = 0;
    int totalPomodoros = 0;
    double todayFocusHours = 0;
    double weekFocusHours = 0;

    for (var entry in _dailyStats.entries) {
      final stat = entry.value;
      totalPomodoros += stat.completedPomodoros;

      if (stat.date.isAtSameMomentAs(today)) {
        todayPomodoros = stat.completedPomodoros;
        todayFocusHours = stat.focusTimeInHours;
      }

      if (stat.date.isAfter(weekAgo) || stat.date.isAtSameMomentAs(weekAgo)) {
        weekPomodoros += stat.completedPomodoros;
        weekFocusHours += stat.focusTimeInHours;
      }
    }

    // 獲取最近30天的數據
    final thirtyDaysAgo = today.subtract(const Duration(days: 30));
    final recentDays = _dailyStats.values
        .where((stat) => stat.date.isAfter(thirtyDaysAgo) || stat.date.isAtSameMomentAs(thirtyDaysAgo))
        .toList()
      ..sort((a, b) => b.date.compareTo(a.date));

    // 計算平均每日番茄鐘
    final daysWithData = recentDays.length;
    final averageDailyPomodoros = daysWithData > 0
        ? recentDays.fold(0, (sum, stat) => sum + stat.completedPomodoros) / daysWithData
        : 0.0;

    return StatisticsSummary(
      todayPomodoros: todayPomodoros,
      weekPomodoros: weekPomodoros,
      totalPomodoros: totalPomodoros,
      todayFocusHours: todayFocusHours,
      weekFocusHours: weekFocusHours,
      averageDailyPomodoros: averageDailyPomodoros,
      recentDays: recentDays,
    );
  }

  DailyStatistics? getStatsForDate(DateTime date) {
    final dateKey = _getDateKey(date);
    return _dailyStats[dateKey];
  }

  List<DailyStatistics> getStatsForDateRange(DateTime start, DateTime end) {
    return _dailyStats.values
        .where((stat) =>
            (stat.date.isAfter(start) || stat.date.isAtSameMomentAs(start)) &&
            (stat.date.isBefore(end) || stat.date.isAtSameMomentAs(end)))
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  // 獲取本週的統計（週一到週日）
  List<DailyStatistics> getWeekStats() {
    final now = DateTime.now();
    final weekday = now.weekday; // 1 = Monday, 7 = Sunday
    final monday = now.subtract(Duration(days: weekday - 1));
    final startOfWeek = DateTime(monday.year, monday.month, monday.day);
    final endOfWeek = startOfWeek.add(const Duration(days: 6));

    return getStatsForDateRange(startOfWeek, endOfWeek);
  }

  Future<void> clearAllData() async {
    await _sessionBox.clear();
    await _statsBox.clear();
    _loadData();
  }
}
