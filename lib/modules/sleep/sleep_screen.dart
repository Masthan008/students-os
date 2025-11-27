import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import '../../widgets/glass_container.dart';
import '../../widgets/glass_button.dart';
import '../alarm/alarm_provider.dart';

class SleepScreen extends StatefulWidget {
  const SleepScreen({super.key});

  @override
  State<SleepScreen> createState() => _SleepScreenState();
}

class _SleepScreenState extends State<SleepScreen> {
  TimeOfDay _wakeTime = const TimeOfDay(hour: 7, minute: 0);

  // Helper function to calculate bedtime based on cycles
  String _calculateBedtime(int cycles) {
    final now = DateTime.now();
    DateTime wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );

    // If wake time is earlier than now, assume it's for tomorrow
    if (wakeDateTime.isBefore(now)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    final sleepTime = wakeDateTime.subtract(Duration(minutes: cycles * 90));
    return DateFormat.jm().format(sleepTime);
  }

  // Helper to get actual DateTime for alarm setting
  DateTime _getSleepDateTime(int cycles) {
    final now = DateTime.now();
    DateTime wakeDateTime = DateTime(
      now.year,
      now.month,
      now.day,
      _wakeTime.hour,
      _wakeTime.minute,
    );

    if (wakeDateTime.isBefore(now)) {
      wakeDateTime = wakeDateTime.add(const Duration(days: 1));
    }

    return wakeDateTime.subtract(Duration(minutes: cycles * 90));
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _wakeTime,
    );
    if (picked != null && picked != _wakeTime) {
      setState(() {
        _wakeTime = picked;
      });
    }
  }

  void _setAlarm(int cycles) {
    final sleepTime = _getSleepDateTime(cycles);
    final alarmProvider = Provider.of<AlarmProvider>(context, listen: false);
    
    // Create a unique ID based on time
    int id = sleepTime.millisecondsSinceEpoch ~/ 1000;
    
    if (sleepTime.isBefore(DateTime.now())) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("This time has already passed!"),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    alarmProvider.scheduleAlarmWithNote(
      sleepTime,
      'assets/sounds/alarm_1.mp3', // Default sound
      'Bedtime! Time to sleep for optimal rest.',
      loopAudio: false,
      alarmId: id,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Bedtime Alarm set for ${DateFormat.jm().format(sleepTime)}",
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.cyanAccent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cyclesList = [6, 5, 4]; // 9h, 7.5h, 6h
    final hoursList = ["9 Hours", "7.5 Hours", "6 Hours"];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Sleep Architect", style: TextStyle(color: Colors.cyanAccent)),
        backgroundColor: Colors.transparent,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.black, Color(0xFF1A1A2E)],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const SizedBox(height: 20),
              const Text(
                "I want to wake up at",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 10),
              GestureDetector(
                onTap: () => _selectTime(context),
                child: Text(
                  _wakeTime.format(context),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 60,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              const Text(
                "You should fall asleep at:",
                style: TextStyle(color: Colors.white70, fontSize: 18),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: ListView.separated(
                  itemCount: cyclesList.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final cycles = cyclesList[index];
                    final bedtime = _calculateBedtime(cycles);
                    final isBest = index == 1; // 7.5 hours is usually recommended as balanced

                    return GlassContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.all(20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                bedtime,
                                style: TextStyle(
                                  color: isBest ? Colors.cyanAccent : Colors.white,
                                  fontSize: 32,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "$cycles Cycles (${hoursList[index]})",
                                style: const TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                          IconButton(
                            icon: const Icon(Icons.add_circle_outline, size: 32, color: Colors.white54),
                            onPressed: () => _setAlarm(cycles),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(delay: (index * 200).ms).slideX();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
