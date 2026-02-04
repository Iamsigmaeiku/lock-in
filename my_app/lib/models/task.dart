import 'package:hive/hive.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late String title;

  @HiveField(2)
  late int estimatedPomodoros;

  @HiveField(3)
  late int completedPomodoros;

  @HiveField(4)
  late DateTime createdAt;

  @HiveField(5)
  DateTime? completedAt;

  @HiveField(6)
  late bool isCompleted;

  Task({
    required this.id,
    required this.title,
    this.estimatedPomodoros = 1,
    this.completedPomodoros = 0,
    required this.createdAt,
    this.completedAt,
    this.isCompleted = false,
  });

  double get progress {
    if (estimatedPomodoros == 0) return 0;
    return completedPomodoros / estimatedPomodoros;
  }

  bool get isOverdue => completedPomodoros > estimatedPomodoros;
}
