import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';

class AlarmService {
  static const String defaultAudioPath = 'assets/sounds/alarm_1.mp3';
  
  static Future<void> init() async {
    await Alarm.init();
  }

  static Future<void> scheduleAlarm({
    required int id,
    required DateTime dateTime,
    String? assetAudioPath,
    required String notificationTitle,
    required String notificationBody,
    String? reminderNote,
    bool loopAudio = true,
    bool vibrate = true,
    bool androidFullScreenIntent = true,
  }) async {
    // Validate and default audio path - CRITICAL: Always ensure a valid audio path
    final audioPath = (assetAudioPath == null || assetAudioPath.isEmpty || assetAudioPath.trim().isEmpty)
        ? defaultAudioPath
        : assetAudioPath;
    
    // Append reminder note to notification body if provided
    final fullBody = reminderNote != null && reminderNote.isNotEmpty
        ? '$notificationBody\n\n📝 $reminderNote'
        : notificationBody;
    
    final alarmSettings = AlarmSettings(
      id: id,
      dateTime: dateTime,
      assetAudioPath: audioPath,
      loopAudio: loopAudio,
      vibrate: vibrate,
      androidFullScreenIntent: androidFullScreenIntent,
      volumeSettings: VolumeSettings.fade(
        volume: 1.0,
        fadeDuration: const Duration(seconds: 5),
        volumeEnforced: true,
      ),
      notificationSettings: NotificationSettings(
        title: notificationTitle,
        body: fullBody,
        stopButton: 'Stop',
      ),
    );

    await Alarm.set(alarmSettings: alarmSettings);
  }

  static Future<void> stopAlarm(int id) async {
    await Alarm.stop(id);
  }

  static Future<void> snoozeAlarm(AlarmSettings settings, {Duration duration = const Duration(minutes: 5)}) async {
    // Stop current alarm
    await stopAlarm(settings.id);

    // Schedule new alarm
    final now = DateTime.now();
    final newDateTime = now.add(duration);
    
    await scheduleAlarm(
      id: settings.id,
      dateTime: newDateTime,
      assetAudioPath: settings.assetAudioPath,
      notificationTitle: "Snoozed: ${settings.notificationSettings.title}",
      notificationBody: "Snoozing for ${duration.inMinutes} minutes",
      loopAudio: true,
      vibrate: true,
      androidFullScreenIntent: true,
    );
  }

  static Future<bool> isRinging(int id) async {
    return Alarm.isRinging(id);
  }
  
  static Stream<AlarmSettings> get ringStream => Alarm.ringStream.stream;
}
