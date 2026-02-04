import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import '../models/pomodoro_session.dart';

class NotificationService {
  static final NotificationService _instance = NotificationService._internal();
  factory NotificationService() => _instance;
  NotificationService._internal();

  final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();

  bool _initialized = false;

  Future<void> initialize() async {
    if (_initialized) return;

    const initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    
    final initializationSettingsDarwin = DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
      onDidReceiveLocalNotification: (id, title, body, payload) async {},
    );

    final initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin,
    );

    await _notifications.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: (details) async {},
    );

    _initialized = true;
  }

  Future<void> showTimerCompleteNotification(SessionType sessionType) async {
    String title;
    String body;

    switch (sessionType) {
      case SessionType.work:
        title = '工作時間結束！';
        body = '做得好！該休息一下了 😊';
        break;
      case SessionType.shortBreak:
        title = '短休息結束！';
        body = '準備好開始下一個番茄鐘了嗎？';
        break;
      case SessionType.longBreak:
        title = '長休息結束！';
        body = '休息充足了，讓我們繼續努力！';
        break;
    }

    const androidDetails = AndroidNotificationDetails(
      'pomodoro_timer',
      '番茄鐘計時器',
      channelDescription: '番茄鐘計時完成通知',
      importance: Importance.high,
      priority: Priority.high,
      showWhen: false,
    );

    const darwinDetails = DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );

    const notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails,
    );

    await _notifications.show(
      sessionType.index,
      title,
      body,
      notificationDetails,
    );
  }

  Future<void> cancelAllNotifications() async {
    await _notifications.cancelAll();
  }
}
