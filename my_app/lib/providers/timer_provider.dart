import 'dart:async';
import 'package:flutter/material.dart';
import '../models/pomodoro_session.dart';
import '../services/notification_service.dart';

class TimerProvider with ChangeNotifier {
  Function(PomodoroSession)? onSessionComplete;
  Function(String)? onPomodoroComplete;
  SessionType _currentPhase = SessionType.work;
  int _remainingSeconds = 25 * 60; // 預設 25 分鐘
  bool _isRunning = false;
  int _completedPomodoros = 0;
  String? _currentTaskId;
  Timer? _timer;

  // 時間設定（秒）
  int workDuration = 25 * 60;
  int shortBreakDuration = 5 * 60;
  int longBreakDuration = 15 * 60;
  int pomodorosBeforeLongBreak = 4;

  // 當前會話
  PomodoroSession? _currentSession;

  // Getters
  SessionType get currentPhase => _currentPhase;
  int get remainingSeconds => _remainingSeconds;
  bool get isRunning => _isRunning;
  int get completedPomodoros => _completedPomodoros;
  String? get currentTaskId => _currentTaskId;
  PomodoroSession? get currentSession => _currentSession;

  String get formattedTime {
    final minutes = _remainingSeconds ~/ 60;
    final seconds = _remainingSeconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  double get progress {
    final totalDuration = _getTotalDuration();
    if (totalDuration == 0) return 0;
    return (_getTotalDuration() - _remainingSeconds) / totalDuration;
  }

  String get phaseLabel {
    switch (_currentPhase) {
      case SessionType.work:
        return '工作中';
      case SessionType.shortBreak:
        return '短休息';
      case SessionType.longBreak:
        return '長休息';
    }
  }

  int _getTotalDuration() {
    switch (_currentPhase) {
      case SessionType.work:
        return workDuration;
      case SessionType.shortBreak:
        return shortBreakDuration;
      case SessionType.longBreak:
        return longBreakDuration;
    }
  }

  void setTaskId(String? taskId) {
    _currentTaskId = taskId;
    notifyListeners();
  }

  void updateSettings({
    int? workDuration,
    int? shortBreakDuration,
    int? longBreakDuration,
    int? pomodorosBeforeLongBreak,
  }) {
    if (workDuration != null) this.workDuration = workDuration * 60;
    if (shortBreakDuration != null) this.shortBreakDuration = shortBreakDuration * 60;
    if (longBreakDuration != null) this.longBreakDuration = longBreakDuration * 60;
    if (pomodorosBeforeLongBreak != null) this.pomodorosBeforeLongBreak = pomodorosBeforeLongBreak;
    
    // 如果計時器沒在運行，更新當前剩餘時間
    if (!_isRunning) {
      _remainingSeconds = _getTotalDuration();
      notifyListeners();
    }
  }

  void startTimer() {
    if (_isRunning) return;

    _isRunning = true;
    
    // 創建新會話
    _currentSession = PomodoroSession(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      type: _currentPhase,
      startTime: DateTime.now(),
      durationInSeconds: _getTotalDuration(),
      taskId: _currentTaskId,
    );

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        _remainingSeconds--;
        notifyListeners();
      } else {
        _handleTimerComplete();
      }
    });

    notifyListeners();
  }

  void pauseTimer() {
    _isRunning = false;
    _timer?.cancel();
    notifyListeners();
  }

  void resetTimer() {
    _isRunning = false;
    _timer?.cancel();
    _remainingSeconds = _getTotalDuration();
    _currentSession = null;
    notifyListeners();
  }

  void skipToBreak() {
    if (_currentPhase == SessionType.work) {
      _isRunning = false;
      _timer?.cancel();
      _switchToBreak();
      _currentSession = null;
      notifyListeners();
    }
  }

  void skipToWork() {
    if (_currentPhase != SessionType.work) {
      _isRunning = false;
      _timer?.cancel();
      _currentPhase = SessionType.work;
      _remainingSeconds = workDuration;
      _currentSession = null;
      notifyListeners();
    }
  }

  void _handleTimerComplete() {
    _timer?.cancel();
    _isRunning = false;

    // 標記會話完成
    if (_currentSession != null) {
      _currentSession!.endTime = DateTime.now();
      _currentSession!.completed = true;
      
      // 保存會話到統計
      onSessionComplete?.call(_currentSession!);
      
      // 如果是工作會話且有關聯任務，更新任務進度
      if (_currentPhase == SessionType.work && _currentTaskId != null) {
        onPomodoroComplete?.call(_currentTaskId!);
      }
    }

    // 發送通知
    NotificationService().showTimerCompleteNotification(_currentPhase);

    if (_currentPhase == SessionType.work) {
      _completedPomodoros++;
      _switchToBreak();
    } else {
      // 休息結束，回到工作階段
      _currentPhase = SessionType.work;
      _remainingSeconds = workDuration;
    }

    _currentSession = null;
    notifyListeners();
  }

  void _switchToBreak() {
    if (_completedPomodoros % pomodorosBeforeLongBreak == 0 && _completedPomodoros > 0) {
      _currentPhase = SessionType.longBreak;
      _remainingSeconds = longBreakDuration;
    } else {
      _currentPhase = SessionType.shortBreak;
      _remainingSeconds = shortBreakDuration;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}
