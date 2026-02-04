import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsProvider with ChangeNotifier {
  // 時間設定（分鐘）
  int _workDuration = 25;
  int _shortBreakDuration = 5;
  int _longBreakDuration = 15;
  int _pomodorosBeforeLongBreak = 4;

  // 通知設定
  bool _notificationsEnabled = true;
  bool _soundEnabled = true;

  // 主題設定
  bool _isDarkMode = false;
  Color _seedColor = Colors.deepOrange;

  // Getters
  int get workDuration => _workDuration;
  int get shortBreakDuration => _shortBreakDuration;
  int get longBreakDuration => _longBreakDuration;
  int get pomodorosBeforeLongBreak => _pomodorosBeforeLongBreak;
  bool get notificationsEnabled => _notificationsEnabled;
  bool get soundEnabled => _soundEnabled;
  bool get isDarkMode => _isDarkMode;
  Color get seedColor => _seedColor;

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    
    _workDuration = prefs.getInt('workDuration') ?? 25;
    _shortBreakDuration = prefs.getInt('shortBreakDuration') ?? 5;
    _longBreakDuration = prefs.getInt('longBreakDuration') ?? 15;
    _pomodorosBeforeLongBreak = prefs.getInt('pomodorosBeforeLongBreak') ?? 4;
    
    _notificationsEnabled = prefs.getBool('notificationsEnabled') ?? true;
    _soundEnabled = prefs.getBool('soundEnabled') ?? true;
    
    _isDarkMode = prefs.getBool('isDarkMode') ?? false;
    final colorValue = prefs.getInt('seedColor') ?? Colors.deepOrange.value;
    _seedColor = Color(colorValue);
    
    notifyListeners();
  }

  Future<void> setWorkDuration(int minutes) async {
    _workDuration = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('workDuration', minutes);
    notifyListeners();
  }

  Future<void> setShortBreakDuration(int minutes) async {
    _shortBreakDuration = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('shortBreakDuration', minutes);
    notifyListeners();
  }

  Future<void> setLongBreakDuration(int minutes) async {
    _longBreakDuration = minutes;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('longBreakDuration', minutes);
    notifyListeners();
  }

  Future<void> setPomodorosBeforeLongBreak(int count) async {
    _pomodorosBeforeLongBreak = count;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('pomodorosBeforeLongBreak', count);
    notifyListeners();
  }

  Future<void> setNotificationsEnabled(bool enabled) async {
    _notificationsEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('notificationsEnabled', enabled);
    notifyListeners();
  }

  Future<void> setSoundEnabled(bool enabled) async {
    _soundEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', enabled);
    notifyListeners();
  }

  Future<void> setDarkMode(bool enabled) async {
    _isDarkMode = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isDarkMode', enabled);
    notifyListeners();
  }

  Future<void> setSeedColor(Color color) async {
    _seedColor = color;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('seedColor', color.value);
    notifyListeners();
  }

  Future<void> resetToDefaults() async {
    _workDuration = 25;
    _shortBreakDuration = 5;
    _longBreakDuration = 15;
    _pomodorosBeforeLongBreak = 4;
    _notificationsEnabled = true;
    _soundEnabled = true;
    _isDarkMode = false;
    _seedColor = Colors.deepOrange;

    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    
    notifyListeners();
  }
}
