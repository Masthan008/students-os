import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:alarm/alarm.dart';
import 'package:alarm/model/alarm_settings.dart';
import 'package:alarm/model/notification_settings.dart';
import 'package:alarm/model/volume_settings.dart';
import '../models/class_session.dart';
import '../widgets/glass_container.dart';
import 'package:intl/intl.dart';

class TimetableScreen extends StatefulWidget {
  const TimetableScreen({super.key});

  @override
  State<TimetableScreen> createState() => _TimetableScreenState();
}

class _TimetableScreenState extends State<TimetableScreen> {
  @override
  void initState() {
    super.initState();
    scheduleDailyNotifications();
  }

  Future<void> scheduleDailyNotifications() async {
    final box = Hive.box<ClassSession>('class_sessions');
    final sessions = box.values.toList();
    final now = DateTime.now();
    final today = now.weekday;

    // Get today's classes
    final todayClasses = sessions.where((s) => s.dayOfWeek == today).toList();

    for (var session in todayClasses) {
      // Calculate notification time (5 minutes before class)
      final classTime = session.startTime;
      final notificationTime = classTime.subtract(const Duration(minutes: 5));

      // Only schedule if the notification time is in the future
      if (notificationTime.isAfter(now)) {
        final alarmId = session.hashCode % 100000 + 50000; // Unique ID for timetable alarms
        
        try {
          await Alarm.set(
            alarmSettings: AlarmSettings(
              id: alarmId,
              dateTime: notificationTime,
              assetAudioPath: 'assets/sounds/alarm_1.mp3',
              loopAudio: false,
              vibrate: true,
              androidFullScreenIntent: false,
              volumeSettings: VolumeSettings.fade(
                volume: 0.5,
                fadeDuration: const Duration(seconds: 3),
                volumeEnforced: false,
              ),
              notificationSettings: NotificationSettings(
                title: 'Class Starting Soon',
                body: '${session.subjectName} starts in 5 minutes',
                stopButton: 'OK',
              ),
            ),
          );
        } catch (e) {
          debugPrint('Error scheduling notification for ${session.subjectName}: $e');
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF191970),
              Colors.black,
              Color(0xFF4B0082),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  'Class Timetable',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              Expanded(
                child: ValueListenableBuilder(
                  valueListenable:
                      Hive.box<ClassSession>('class_sessions').listenable(),
                  builder: (context, Box<ClassSession> box, _) {
                    final sessions = box.values.toList();

                    if (sessions.isEmpty) {
                      return Center(
                        child: GlassContainer(
                          width: 250,
                          padding: const EdgeInsets.all(20),
                          child: const Text(
                            'No classes scheduled',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      );
                    }

                    // Group sessions by day
                    final sessionsByDay = <int, List<ClassSession>>{};
                    for (var session in sessions) {
                      sessionsByDay.putIfAbsent(session.dayOfWeek, () => []);
                      sessionsByDay[session.dayOfWeek]!.add(session);
                    }

                    // Sort sessions within each day by start time
                    for (var daySessions in sessionsByDay.values) {
                      daySessions.sort(
                          (a, b) => a.startTime.compareTo(b.startTime));
                    }

                    final dayNames = [
                      '',
                      'Monday',
                      'Tuesday',
                      'Wednesday',
                      'Thursday',
                      'Friday',
                      'Saturday'
                    ];

                    return ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: sessionsByDay.length,
                      itemBuilder: (context, index) {
                        final dayOfWeek =
                            sessionsByDay.keys.toList()..sort();
                        final day = dayOfWeek[index];
                        final daySessions = sessionsByDay[day]!;

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 12, horizontal: 8),
                              child: Text(
                                dayNames[day],
                                style: const TextStyle(
                                  color: Colors.cyanAccent,
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            ...daySessions.map((session) =>
                                _buildClassCard(context, session)),
                            const SizedBox(height: 16),
                          ],
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildClassCard(BuildContext context, ClassSession session) {
    final timeFormat = DateFormat('HH:mm');
    final startTime = timeFormat.format(session.startTime);
    final endTime = timeFormat.format(session.endTime);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 4,
              height: 50,
              decoration: BoxDecoration(
                color: _getSubjectColor(session.subjectName),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    session.subjectName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$startTime - $endTime',
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getSubjectColor(String subjectName) {
    final colors = {
      'BCE': Colors.cyanAccent,
      'CE': Colors.greenAccent,
      'LAAC': Colors.yellowAccent,
      'CHE': Colors.orangeAccent,
      'EWS': Colors.purpleAccent,
      'IP LAB': Colors.pinkAccent,
      'SS': Colors.blueAccent,
      'EC LAB': Colors.tealAccent,
      'BME': Colors.limeAccent,
      'IP': Colors.indigoAccent,
      'CE LAB': Colors.lightGreenAccent,
      'EAA': Colors.amberAccent,
    };
    return colors[subjectName] ?? Colors.white;
  }
}
