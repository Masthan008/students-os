import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; // For rootBundle
import 'package:alarm/alarm.dart';
import 'alarm_service.dart';
import '../../main.dart'; // For navigatorKey

class AlarmProvider extends ChangeNotifier {
  List<AlarmSettings> _alarms = [];
  List<AlarmSettings> get alarms => _alarms;

  AlarmProvider() {
    _loadAlarms();
    // Delay slightly to allow context to be ready if needed, though AssetBundle might not need it immediately if we use rootBundle
    // But we used DefaultAssetBundle.of(context).
    // Let's use rootBundle instead to avoid context issues in constructor.
    loadSounds();
  }

  Future<void> _loadAlarms() async {
    // In newer versions of alarm package, getAlarms might be async or sync depending on version.
    // The error said it returns Future<List<AlarmSettings>>.
    // If the package version installed is indeed returning Future:
    _alarms = await Alarm.getAlarms(); 
    notifyListeners();
  }

  Future<void> scheduleAlarm(DateTime dateTime, String audioPath, {bool loopAudio = true}) async {
    final id = DateTime.now().millisecondsSinceEpoch % 10000;
    await AlarmService.scheduleAlarm(
      id: id,
      dateTime: dateTime,
      assetAudioPath: audioPath,
      loopAudio: loopAudio,
      notificationTitle: 'FluxFlow Alarm',
      notificationBody: 'Time to wake up!',
    );
    await _loadAlarms();
  }

  // v5.0: Schedule alarm with note support
  Future<void> scheduleAlarmWithNote(
    DateTime dateTime, 
    String audioPath, 
    String? reminderNote,
    {bool loopAudio = true, int? alarmId}
  ) async {
    final id = alarmId ?? (DateTime.now().millisecondsSinceEpoch % 10000);
    await AlarmService.scheduleAlarm(
      id: id,
      dateTime: dateTime,
      assetAudioPath: audioPath,
      loopAudio: loopAudio,
      notificationTitle: 'FluxFlow Alarm',
      notificationBody: 'Time to wake up!',
      reminderNote: reminderNote,
    );
    await _loadAlarms();
  }

  Future<void> stopAlarm(int id) async {
    await AlarmService.stopAlarm(id);
    await _loadAlarms();
  }

  List<String> _availableSounds = [
    'assets/sounds/alarm_1.mp3',
    'assets/sounds/alarm_2.mp3',
    'assets/sounds/alarm_3.mp3',
    'assets/sounds/alarm_4.mp3',
    'assets/sounds/alarm_5.mp3',
    'assets/sounds/alarm_6.mp3',
    'assets/sounds/alarm_7.mp3',
    'assets/sounds/alarm_8.mp3',
    'assets/sounds/alarm_9.mp3',
    'assets/sounds/alarm_10.mp3',
    'assets/sounds/alarm_11.mp3',
    'assets/sounds/alarm_12.mp3',
    'assets/sounds/alarm_13.mp3',
    'assets/sounds/alarm_14.mp3',
    'assets/sounds/alarm_15.mp3',
    'assets/sounds/alarm_16.mp3',
    'assets/sounds/alarm_17.mp3',
    'assets/sounds/alarm_18.mp3',
    'assets/sounds/alarm_19.mp3',
    'assets/sounds/alarm_20.mp3',
  ];

  List<String> get availableSounds => _availableSounds;

  Future<void> loadSounds() async {
    try {
      // Use rootBundle to avoid context requirement
      final manifestContent = await rootBundle.loadString('AssetManifest.json');
      final Map<String, dynamic> manifestMap = json.decode(manifestContent);
      
      _availableSounds = manifestMap.keys
          .where((key) => key.startsWith('assets/sounds/') && key.endsWith('.mp3'))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint("Error loading sounds: $e");
    }
  }
}
