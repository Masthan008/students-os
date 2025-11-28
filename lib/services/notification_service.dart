import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:hive_flutter/hive_flutter.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static String? _lastNotifiedId;

  static Future<void> init() async {
    // Using the transparent notification icon for status bar
    const androidSettings = AndroidInitializationSettings('notification_icon');
    const settings = InitializationSettings(android: androidSettings);
    
    await _notifications.initialize(settings);

    // Request permission for Android 13+
    await _notifications
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.requestNotificationsPermission();
  }

  static Future<void> showNewsAlert(String id, String title, String body) async {
    // Prevent duplicate notifications for the same news item
    if (_lastNotifiedId == id) return;
    
    // 24-hour throttle: Check last notification time
    final box = Hive.box('user_prefs');
    final lastNotifyTime = box.get('last_news_notify_time');
    
    if (lastNotifyTime != null) {
      final lastTime = DateTime.parse(lastNotifyTime);
      final hoursSinceLastNotify = DateTime.now().difference(lastTime).inHours;
      
      // If less than 24 hours, don't show notification
      if (hoursSinceLastNotify < 24) {
        return;
      }
    }
    
    _lastNotifiedId = id;
    
    // Save current time as last notification time
    await box.put('last_news_notify_time', DateTime.now().toIso8601String());

    const androidDetails = AndroidNotificationDetails(
      'news_channel',
      'News Updates',
      channelDescription: 'Notifications for new news updates',
      importance: Importance.max,
      priority: Priority.high,
      color: Color(0xFF00FFFF), // Cyan color
      playSound: true,
      enableVibration: true,
    );
    
    const details = NotificationDetails(android: androidDetails);
    
    await _notifications.show(
      DateTime.now().millisecond, // Unique ID
      "📢 $title",
      body,
      details,
    );
  }
}
