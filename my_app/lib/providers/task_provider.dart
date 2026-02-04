import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/task.dart';

class TaskProvider with ChangeNotifier {
  late Box<Task> _taskBox;
  List<Task> _tasks = [];
  final _uuid = const Uuid();

  List<Task> get tasks => _tasks;
  List<Task> get activeTasks => _tasks.where((t) => !t.isCompleted).toList();
  List<Task> get completedTasks => _tasks.where((t) => t.isCompleted).toList();

  Future<void> initialize() async {
    _taskBox = await Hive.openBox<Task>('tasks');
    _loadTasks();
  }

  void _loadTasks() {
    _tasks = _taskBox.values.toList();
    // 按創建時間排序，最新的在前
    _tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    notifyListeners();
  }

  Future<void> addTask({
    required String title,
    int estimatedPomodoros = 1,
  }) async {
    final task = Task(
      id: _uuid.v4(),
      title: title,
      estimatedPomodoros: estimatedPomodoros,
      createdAt: DateTime.now(),
    );

    await _taskBox.put(task.id, task);
    _loadTasks();
  }

  Future<void> updateTask(Task task) async {
    await _taskBox.put(task.id, task);
    _loadTasks();
  }

  Future<void> deleteTask(String taskId) async {
    await _taskBox.delete(taskId);
    _loadTasks();
  }

  Future<void> toggleTaskCompletion(String taskId) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      task.isCompleted = !task.isCompleted;
      task.completedAt = task.isCompleted ? DateTime.now() : null;
      await task.save();
      _loadTasks();
    }
  }

  Future<void> incrementTaskPomodoro(String taskId) async {
    final task = _taskBox.get(taskId);
    if (task != null) {
      task.completedPomodoros++;
      await task.save();
      _loadTasks();
    }
  }

  Task? getTask(String taskId) {
    return _taskBox.get(taskId);
  }

  Future<void> reorderTasks(int oldIndex, int newIndex) async {
    if (newIndex > oldIndex) {
      newIndex -= 1;
    }
    
    final task = _tasks.removeAt(oldIndex);
    _tasks.insert(newIndex, task);
    
    // 更新所有任務的創建時間以保持順序
    for (int i = 0; i < _tasks.length; i++) {
      _tasks[i].createdAt = DateTime.now().subtract(Duration(seconds: _tasks.length - i));
      await _tasks[i].save();
    }
    
    notifyListeners();
  }

  int get totalActiveTasks => activeTasks.length;
  int get totalCompletedTasks => completedTasks.length;
  int get totalEstimatedPomodoros => activeTasks.fold(0, (sum, task) => sum + task.estimatedPomodoros);
  int get totalCompletedPomodoros => _tasks.fold(0, (sum, task) => sum + task.completedPomodoros);
}
