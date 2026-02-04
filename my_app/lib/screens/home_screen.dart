import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/timer_provider.dart';
import '../providers/task_provider.dart';
import '../widgets/circular_timer.dart';
import '../models/pomodoro_session.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final timerProvider = context.watch<TimerProvider>();
    final taskProvider = context.watch<TaskProvider>();
    final theme = Theme.of(context);
    
    Color getPhaseColor() {
      switch (timerProvider.currentPhase) {
        case SessionType.work:
          return theme.colorScheme.primary;
        case SessionType.shortBreak:
          return Colors.green;
        case SessionType.longBreak:
          return Colors.blue;
      }
    }

    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 圓形計時器
                CircularTimer(
                  progress: timerProvider.progress,
                  timeText: timerProvider.formattedTime,
                  phaseLabel: timerProvider.phaseLabel,
                  color: getPhaseColor(),
                ),

                const SizedBox(height: 48),

                // 控制按鈕
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // 開始/暫停按鈕
                    FilledButton.icon(
                      onPressed: () {
                        if (timerProvider.isRunning) {
                          timerProvider.pauseTimer();
                        } else {
                          timerProvider.startTimer();
                        }
                      },
                      icon: Icon(
                        timerProvider.isRunning ? Icons.pause : Icons.play_arrow,
                        size: 28,
                      ),
                      label: Text(
                        timerProvider.isRunning ? '暫停' : '開始',
                        style: const TextStyle(fontSize: 18),
                      ),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        backgroundColor: getPhaseColor(),
                      ),
                    ),

                    const SizedBox(width: 16),

                    // 重置按鈕
                    FilledButton.tonalIcon(
                      onPressed: timerProvider.resetTimer,
                      icon: const Icon(Icons.refresh),
                      label: const Text('重置'),
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 24,
                          vertical: 16,
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 24),

                // 跳過按鈕
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (timerProvider.currentPhase == SessionType.work)
                      TextButton.icon(
                        onPressed: timerProvider.skipToBreak,
                        icon: const Icon(Icons.skip_next),
                        label: const Text('跳到休息'),
                      ),
                    if (timerProvider.currentPhase != SessionType.work)
                      TextButton.icon(
                        onPressed: timerProvider.skipToWork,
                        icon: const Icon(Icons.skip_next),
                        label: const Text('跳到工作'),
                      ),
                  ],
                ),

                const SizedBox(height: 32),

                // 任務選擇器
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.task_alt,
                              color: theme.colorScheme.primary,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              '當前任務',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 12),
                        if (timerProvider.currentTaskId != null)
                          Builder(
                            builder: (context) {
                              final task = taskProvider.getTask(timerProvider.currentTaskId!);
                              if (task == null) {
                                return const Text('任務已刪除');
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    task.title,
                                    style: theme.textTheme.bodyLarge?.copyWith(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  LinearProgressIndicator(
                                    value: task.progress,
                                    backgroundColor: theme.colorScheme.surfaceContainerHighest,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '${task.completedPomodoros} / ${task.estimatedPomodoros} 番茄鐘',
                                    style: theme.textTheme.bodySmall,
                                  ),
                                ],
                              );
                            },
                          ),
                        if (timerProvider.currentTaskId == null)
                          TextButton.icon(
                            onPressed: () {
                              _showTaskSelector(context);
                            },
                            icon: const Icon(Icons.add),
                            label: const Text('選擇任務'),
                          ),
                        if (timerProvider.currentTaskId != null)
                          TextButton.icon(
                            onPressed: () {
                              timerProvider.setTaskId(null);
                            },
                            icon: const Icon(Icons.clear),
                            label: const Text('取消選擇'),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 24),

                // 番茄鐘計數
                Card(
                  color: theme.colorScheme.primaryContainer,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.local_fire_department, size: 32),
                        const SizedBox(width: 12),
                        Text(
                          '今日完成 ${timerProvider.completedPomodoros} 個番茄鐘',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showTaskSelector(BuildContext context) {
    final taskProvider = context.read<TaskProvider>();
    final timerProvider = context.read<TimerProvider>();

    showModalBottomSheet(
      context: context,
      builder: (context) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                '選擇任務',
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ),
            if (taskProvider.activeTasks.isEmpty)
              const Padding(
                padding: EdgeInsets.all(32),
                child: Text('沒有活動任務，請先創建任務'),
              ),
            ...taskProvider.activeTasks.map((task) {
              return ListTile(
                leading: const Icon(Icons.task),
                title: Text(task.title),
                subtitle: Text('${task.completedPomodoros} / ${task.estimatedPomodoros} 番茄鐘'),
                onTap: () {
                  timerProvider.setTaskId(task.id);
                  Navigator.pop(context);
                },
              );
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}
