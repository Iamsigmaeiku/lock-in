import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/settings_provider.dart';
import '../providers/timer_provider.dart';
import '../providers/task_provider.dart';
import '../providers/statistics_provider.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settingsProvider = context.watch<SettingsProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('設定'),
      ),
      body: ListView(
        children: [
          // 計時器設定
          const _SectionHeader(title: '計時器設定'),
          _TimerSettingTile(
            title: '工作時長',
            value: settingsProvider.workDuration,
            onChanged: (value) async {
              await settingsProvider.setWorkDuration(value);
              if (context.mounted) {
                context.read<TimerProvider>().updateSettings(
                  workDuration: value,
                );
              }
            },
          ),
          _TimerSettingTile(
            title: '短休息時長',
            value: settingsProvider.shortBreakDuration,
            onChanged: (value) async {
              await settingsProvider.setShortBreakDuration(value);
              if (context.mounted) {
                context.read<TimerProvider>().updateSettings(
                  shortBreakDuration: value,
                );
              }
            },
          ),
          _TimerSettingTile(
            title: '長休息時長',
            value: settingsProvider.longBreakDuration,
            onChanged: (value) async {
              await settingsProvider.setLongBreakDuration(value);
              if (context.mounted) {
                context.read<TimerProvider>().updateSettings(
                  longBreakDuration: value,
                );
              }
            },
          ),
          _TimerSettingTile(
            title: '長休息間隔',
            value: settingsProvider.pomodorosBeforeLongBreak,
            suffix: '個番茄鐘',
            min: 2,
            max: 10,
            onChanged: (value) async {
              await settingsProvider.setPomodorosBeforeLongBreak(value);
              if (context.mounted) {
                context.read<TimerProvider>().updateSettings(
                  pomodorosBeforeLongBreak: value,
                );
              }
            },
          ),

          const Divider(),

          // 通知設定
          const _SectionHeader(title: '通知設定'),
          SwitchListTile(
            title: const Text('啟用通知'),
            subtitle: const Text('時間到時接收通知'),
            value: settingsProvider.notificationsEnabled,
            onChanged: settingsProvider.setNotificationsEnabled,
          ),
          SwitchListTile(
            title: const Text('啟用音效'),
            subtitle: const Text('時間到時播放提示音'),
            value: settingsProvider.soundEnabled,
            onChanged: settingsProvider.setSoundEnabled,
          ),

          const Divider(),

          // 外觀設定
          const _SectionHeader(title: '外觀設定'),
          SwitchListTile(
            title: const Text('深色模式'),
            value: settingsProvider.isDarkMode,
            onChanged: settingsProvider.setDarkMode,
          ),
          ListTile(
            title: const Text('主題色彩'),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                _ColorOption(
                  color: Colors.deepOrange,
                  isSelected: settingsProvider.seedColor == Colors.deepOrange,
                  onTap: () => settingsProvider.setSeedColor(Colors.deepOrange),
                ),
                const SizedBox(width: 8),
                _ColorOption(
                  color: Colors.blue,
                  isSelected: settingsProvider.seedColor == Colors.blue,
                  onTap: () => settingsProvider.setSeedColor(Colors.blue),
                ),
                const SizedBox(width: 8),
                _ColorOption(
                  color: Colors.green,
                  isSelected: settingsProvider.seedColor == Colors.green,
                  onTap: () => settingsProvider.setSeedColor(Colors.green),
                ),
                const SizedBox(width: 8),
                _ColorOption(
                  color: Colors.purple,
                  isSelected: settingsProvider.seedColor == Colors.purple,
                  onTap: () => settingsProvider.setSeedColor(Colors.purple),
                ),
                const SizedBox(width: 8),
                _ColorOption(
                  color: Colors.pink,
                  isSelected: settingsProvider.seedColor == Colors.pink,
                  onTap: () => settingsProvider.setSeedColor(Colors.pink),
                ),
              ],
            ),
          ),

          const Divider(),

          // 數據管理
          const _SectionHeader(title: '數據管理'),
          ListTile(
            leading: const Icon(Icons.delete_sweep),
            title: const Text('清除所有數據'),
            subtitle: const Text('刪除所有任務和統計記錄'),
            onTap: () => _showClearDataDialog(context),
          ),
          ListTile(
            leading: const Icon(Icons.restart_alt),
            title: const Text('重置為預設值'),
            subtitle: const Text('恢復所有設定到初始狀態'),
            onTap: () => _showResetDialog(context),
          ),

          const Divider(),

          // 關於
          const _SectionHeader(title: '關於'),
          const ListTile(
            leading: Icon(Icons.info_outline),
            title: Text('版本'),
            subtitle: Text('1.0.0'),
          ),

          const SizedBox(height: 32),
        ],
      ),
    );
  }

  void _showClearDataDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('清除所有數據'),
        content: const Text('這將刪除所有任務和統計記錄，且無法復原。確定要繼續嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final taskProvider = context.read<TaskProvider>();
              final statsProvider = context.read<StatisticsProvider>();
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              
              await taskProvider.initialize();
              await statsProvider.clearAllData();
              
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('數據已清除')),
              );
            },
            style: FilledButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
            child: const Text('確定刪除'),
          ),
        ],
      ),
    );
  }

  void _showResetDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('重置為預設值'),
        content: const Text('這將恢復所有設定到初始狀態。確定要繼續嗎？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final settingsProvider = context.read<SettingsProvider>();
              final timerProvider = context.read<TimerProvider>();
              final navigator = Navigator.of(context);
              final messenger = ScaffoldMessenger.of(context);
              
              await settingsProvider.resetToDefaults();
              
              timerProvider.updateSettings(
                workDuration: settingsProvider.workDuration,
                shortBreakDuration: settingsProvider.shortBreakDuration,
                longBreakDuration: settingsProvider.longBreakDuration,
                pomodorosBeforeLongBreak: settingsProvider.pomodorosBeforeLongBreak,
              );
              
              navigator.pop();
              messenger.showSnackBar(
                const SnackBar(content: Text('設定已重置')),
              );
            },
            child: const Text('確定重置'),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;

  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Text(
        title,
        style: Theme.of(context).textTheme.titleMedium?.copyWith(
          color: Theme.of(context).colorScheme.primary,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}

class _TimerSettingTile extends StatelessWidget {
  final String title;
  final int value;
  final String suffix;
  final int min;
  final int max;
  final Function(int) onChanged;

  const _TimerSettingTile({
    required this.title,
    required this.value,
    this.suffix = '分鐘',
    this.min = 1,
    this.max = 60,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            onPressed: value > min ? () => onChanged(value - 1) : null,
            icon: const Icon(Icons.remove_circle_outline),
          ),
          SizedBox(
            width: 60,
            child: Text(
              '$value $suffix',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
          IconButton(
            onPressed: value < max ? () => onChanged(value + 1) : null,
            icon: const Icon(Icons.add_circle_outline),
          ),
        ],
      ),
    );
  }
}

class _ColorOption extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  const _ColorOption({
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: Theme.of(context).colorScheme.onSurface,
                  width: 3,
                )
              : null,
        ),
        child: isSelected
            ? const Icon(Icons.check, color: Colors.white, size: 16)
            : null,
      ),
    );
  }
}
