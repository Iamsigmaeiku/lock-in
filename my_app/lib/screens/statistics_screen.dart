import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';
import '../providers/statistics_provider.dart';
import '../providers/task_provider.dart';
import '../models/statistics.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatisticsProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final summary = statsProvider.getSummary();
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('統計'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 今日快速數據
            Text(
              '今日概覽',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.local_fire_department,
                    label: '番茄鐘',
                    value: summary.todayPomodoros.toString(),
                    color: theme.colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.schedule,
                    label: '專注時長',
                    value: '${summary.todayFocusHours.toStringAsFixed(1)}h',
                    color: Colors.green,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatCard(
                    icon: Icons.task,
                    label: '活動任務',
                    value: taskProvider.totalActiveTasks.toString(),
                    color: Colors.orange,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatCard(
                    icon: Icons.done_all,
                    label: '完成任務',
                    value: taskProvider.totalCompletedTasks.toString(),
                    color: Colors.blue,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            // 本週統計
            Text(
              '本週統計',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            Text(
                              summary.weekPomodoros.toString(),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: theme.colorScheme.primary,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '番茄鐘',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              '${summary.weekFocusHours.toStringAsFixed(1)}h',
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.green,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '專注時長',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            Text(
                              summary.averageDailyPomodoros.toStringAsFixed(1),
                              style: theme.textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Colors.orange,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '日均',
                              style: theme.textTheme.bodySmall,
                            ),
                          ],
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      height: 200,
                      child: _buildWeeklyChart(context, statsProvider),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),

            // 歷史趨勢
            Text(
              '歷史趨勢',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '總計',
                          style: theme.textTheme.titleMedium,
                        ),
                        Text(
                          '${summary.totalPomodoros} 個番茄鐘',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    _buildHeatmap(context, summary.recentDays),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(BuildContext context, StatisticsProvider provider) {
    final weekStats = provider.getWeekStats();
    final theme = Theme.of(context);
    
    // 確保有7天數據（週一到週日）
    final now = DateTime.now();
    final weekday = now.weekday;
    final monday = now.subtract(Duration(days: weekday - 1));
    
    final List<BarChartGroupData> barGroups = [];
    
    for (int i = 0; i < 7; i++) {
      final date = monday.add(Duration(days: i));
      final stat = weekStats.firstWhere(
        (s) => s.date.day == date.day && s.date.month == date.month,
        orElse: () => DailyStatistics(date: date),
      );
      
      barGroups.add(
        BarChartGroupData(
          x: i,
          barRods: [
            BarChartRodData(
              toY: stat.completedPomodoros.toDouble(),
              color: theme.colorScheme.primary,
              width: 20,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
            ),
          ],
        ),
      );
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: barGroups.map((g) => g.barRods[0].toY).fold(0.0, (a, b) => a > b ? a : b) + 2,
        barGroups: barGroups,
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                const weekdays = ['一', '二', '三', '四', '五', '六', '日'];
                return Text(
                  weekdays[value.toInt()],
                  style: const TextStyle(fontSize: 12),
                );
              },
            ),
          ),
          leftTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        borderData: FlBorderData(show: false),
        gridData: const FlGridData(show: false),
      ),
    );
  }

  Widget _buildHeatmap(BuildContext context, List recentDays) {
    final theme = Theme.of(context);
    
    // 取最近30天
    final days = recentDays.take(30).toList().reversed.toList();
    
    return Wrap(
      spacing: 4,
      runSpacing: 4,
      children: days.map((stat) {
        final intensity = stat.completedPomodoros == 0 ? 0.0 : 
            (stat.completedPomodoros / 8).clamp(0.2, 1.0);
        
        return Tooltip(
          message: '${DateFormat('M/d').format(stat.date)}: ${stat.completedPomodoros} 個',
          child: Container(
            width: 24,
            height: 24,
            decoration: BoxDecoration(
              color: stat.completedPomodoros == 0
                  ? theme.colorScheme.surfaceContainerHighest
                  : theme.colorScheme.primary.withOpacity(intensity),
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }
}
