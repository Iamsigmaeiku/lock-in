import 'package:hive/hive.dart';

part 'pomodoro_session.g.dart';

@HiveType(typeId: 1)
enum SessionType {
  @HiveField(0)
  work,
  @HiveField(1)
  shortBreak,
  @HiveField(2)
  longBreak,
}

@HiveType(typeId: 2)
class PomodoroSession extends HiveObject {
  @HiveField(0)
  late String id;

  @HiveField(1)
  late SessionType type;

  @HiveField(2)
  late DateTime startTime;

  @HiveField(3)
  DateTime? endTime;

  @HiveField(4)
  late int durationInSeconds;

  @HiveField(5)
  String? taskId;

  @HiveField(6)
  late bool completed;

  PomodoroSession({
    required this.id,
    required this.type,
    required this.startTime,
    this.endTime,
    required this.durationInSeconds,
    this.taskId,
    this.completed = false,
  });

  int get actualDurationInSeconds {
    if (endTime == null) return 0;
    return endTime!.difference(startTime).inSeconds;
  }

  bool get wasInterrupted => completed && actualDurationInSeconds < durationInSeconds;
}
