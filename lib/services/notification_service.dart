import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

class NotificationService {
  static final FlutterLocalNotificationsPlugin _notifications =
      FlutterLocalNotificationsPlugin();
  
  static String? _lastNotifiedId;

  static Future<void> init() async {
    const androidSettings = AndroidInitializationSettings('@mipmap/ic_launcher');
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
    _lastNotifiedId = id;

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
