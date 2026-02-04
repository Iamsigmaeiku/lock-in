import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/task_provider.dart';
import '../widgets/task_card.dart';

class TasksScreen extends StatelessWidget {
  const TasksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final taskProvider = context.watch<TaskProvider>();

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('任務'),
          bottom: const TabBar(
            tabs: [
              Tab(text: '進行中'),
              Tab(text: '已完成'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // 進行中的任務
            _buildTaskList(
              context,
              taskProvider.activeTasks,
              emptyMessage: '還沒有任務，點擊右下角新增',
            ),
            // 已完成的任務
            _buildTaskList(
              context,
              taskProvider.completedTasks,
              emptyMessage: '還沒有完成的任務',
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _showAddTaskDialog(context),
          icon: const Icon(Icons.add),
          label: const Text('新增任務'),
        ),
      ),
    );
  }

  Widget _buildTaskList(
    BuildContext context,
    List tasks,
    {required String emptyMessage}
  ) {
    if (tasks.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.inbox,
              size: 64,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      );
    }

    return ReorderableListView.builder(
      padding: const EdgeInsets.only(top: 8, bottom: 80),
      itemCount: tasks.length,
      onReorder: (oldIndex, newIndex) {
        context.read<TaskProvider>().reorderTasks(oldIndex, newIndex);
      },
      itemBuilder: (context, index) {
        final task = tasks[index];
        return TaskCard(
          key: ValueKey(task.id),
          task: task,
          onTap: () => _showEditTaskDialog(context, task),
          onDelete: () {
            context.read<TaskProvider>().deleteTask(task.id);
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('任務已刪除'),
                action: SnackBarAction(
                  label: '復原',
                  onPressed: () {
                    // TODO: 實作復原功能
                  },
                ),
              ),
            );
          },
          onToggleComplete: () {
            context.read<TaskProvider>().toggleTaskCompletion(task.id);
          },
        );
      },
    );
  }

  void _showAddTaskDialog(BuildContext context) {
    final titleController = TextEditingController();
    final pomodorosController = TextEditingController(text: '1');

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('新增任務'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '任務名稱',
                border: OutlineInputBorder(),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pomodorosController,
              decoration: const InputDecoration(
                labelText: '預估番茄鐘數',
                border: OutlineInputBorder(),
                suffixText: '個',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                return;
              }
              
              final pomodoros = int.tryParse(pomodorosController.text) ?? 1;
              
              context.read<TaskProvider>().addTask(
                title: titleController.text.trim(),
                estimatedPomodoros: pomodoros,
              );
              
              Navigator.pop(context);
            },
            child: const Text('新增'),
          ),
        ],
      ),
    );
  }

  void _showEditTaskDialog(BuildContext context, task) {
    final titleController = TextEditingController(text: task.title);
    final pomodorosController = TextEditingController(
      text: task.estimatedPomodoros.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('編輯任務'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(
                labelText: '任務名稱',
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: pomodorosController,
              decoration: const InputDecoration(
                labelText: '預估番茄鐘數',
                border: OutlineInputBorder(),
                suffixText: '個',
              ),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                const Icon(Icons.info_outline, size: 16),
                const SizedBox(width: 8),
                Text(
                  '已完成: ${task.completedPomodoros} 個',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () {
              if (titleController.text.trim().isEmpty) {
                return;
              }
              
              task.title = titleController.text.trim();
              task.estimatedPomodoros = int.tryParse(pomodorosController.text) ?? 1;
              
              context.read<TaskProvider>().updateTask(task);
              Navigator.pop(context);
            },
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }
}
