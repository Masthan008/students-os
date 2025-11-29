import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../modules/alarm/alarm_service.dart';
import '../widgets/glass_container.dart';

class CalendarReminder {
  final String id;
  final String title;
  final DateTime dateTime;
  final String category;
  final String? notes;
  final int alarmId;

  CalendarReminder({
    required this.id,
    required this.title,
    required this.dateTime,
    required this.category,
    this.notes,
    required this.alarmId,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'dateTime': dateTime.toIso8601String(),
        'category': category,
        'notes': notes,
        'alarmId': alarmId,
      };

  factory CalendarReminder.fromJson(Map<String, dynamic> json) => CalendarReminder(
        id: json['id'],
        title: json['title'],
        dateTime: DateTime.parse(json['dateTime']),
        category: json['category'],
        notes: json['notes'],
        alarmId: json['alarmId'],
      );
}

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  DateTime _focusedDay = DateTime.now();
  DateTime? _selectedDay;
  CalendarFormat _calendarFormat = CalendarFormat.month;
  late Box _remindersBox;
  Map<DateTime, List<CalendarReminder>> _reminders = {};

  final List<String> _categories = [
    '📚 Study',
    '📝 Assignment',
    '🎯 Exam',
    '💼 Meeting',
    '🎉 Event',
    '⚡ Important',
    '📌 Other',
  ];

  @override
  void initState() {
    super.initState();
    _initHive();
  }

  Future<void> _initHive() async {
    _remindersBox = await Hive.openBox('calendar_reminders');
    _loadReminders();
  }

  void _loadReminders() {
    final remindersData = _remindersBox.get('reminders', defaultValue: <String, dynamic>{});
    _reminders.clear();
    
    if (remindersData is Map) {
      remindersData.forEach((key, value) {
        if (value is List) {
          final date = DateTime.parse(key);
          _reminders[_normalizeDate(date)] = value
              .map((item) => CalendarReminder.fromJson(Map<String, dynamic>.from(item)))
              .toList();
        }
      });
    }
    
    setState(() {});
  }

  Future<void> _saveReminders() async {
    final remindersData = <String, dynamic>{};
    _reminders.forEach((date, reminders) {
      remindersData[date.toIso8601String()] = reminders.map((r) => r.toJson()).toList();
    });
    await _remindersBox.put('reminders', remindersData);
  }

  DateTime _normalizeDate(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  List<CalendarReminder> _getRemindersForDay(DateTime day) {
    return _reminders[_normalizeDate(day)] ?? [];
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Student Calendar',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.list, color: Colors.cyanAccent, size: 28),
                      onPressed: _showAllReminders,
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: GlassContainer(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          child: TableCalendar(
                            firstDay: DateTime.utc(2020, 1, 1),
                            lastDay: DateTime.utc(2030, 12, 31),
                            focusedDay: _focusedDay,
                            calendarFormat: _calendarFormat,
                            selectedDayPredicate: (day) {
                              return isSameDay(_selectedDay, day);
                            },
                            eventLoader: _getRemindersForDay,
                            onDaySelected: (selectedDay, focusedDay) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusedDay = focusedDay;
                              });
                              _showDayReminders(selectedDay);
                            },
                            onFormatChanged: (format) {
                              setState(() {
                                _calendarFormat = format;
                              });
                            },
                            onPageChanged: (focusedDay) {
                              _focusedDay = focusedDay;
                            },
                            calendarStyle: CalendarStyle(
                              todayDecoration: BoxDecoration(
                                color: Colors.cyanAccent.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              todayTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              selectedDecoration: const BoxDecoration(
                                color: Colors.purpleAccent,
                                shape: BoxShape.circle,
                              ),
                              selectedTextStyle: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                              markerDecoration: const BoxDecoration(
                                color: Colors.amber,
                                shape: BoxShape.circle,
                              ),
                              markersMaxCount: 3,
                              defaultTextStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              weekendTextStyle: const TextStyle(
                                color: Colors.white70,
                              ),
                              outsideTextStyle: const TextStyle(
                                color: Colors.white30,
                              ),
                            ),
                            headerStyle: HeaderStyle(
                              titleTextStyle: const TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                              formatButtonTextStyle: const TextStyle(
                                color: Colors.white,
                              ),
                              formatButtonDecoration: BoxDecoration(
                                border: Border.all(color: Colors.white30),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              leftChevronIcon: const Icon(
                                Icons.chevron_left,
                                color: Colors.white,
                              ),
                              rightChevronIcon: const Icon(
                                Icons.chevron_right,
                                color: Colors.white,
                              ),
                            ),
                            daysOfWeekStyle: const DaysOfWeekStyle(
                              weekdayStyle: TextStyle(
                                color: Colors.cyanAccent,
                                fontWeight: FontWeight.bold,
                              ),
                              weekendStyle: TextStyle(
                                color: Colors.purpleAccent,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                      if (_selectedDay != null) _buildSelectedDayReminders(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 80.0),
        child: FloatingActionButton.extended(
          onPressed: () => _showAddReminderDialog(_selectedDay ?? DateTime.now()),
          backgroundColor: Colors.cyanAccent,
          icon: const Icon(Icons.add, color: Colors.black),
          label: const Text('Add Reminder', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
        ),
      ),
    );
  }

  Widget _buildSelectedDayReminders() {
    final reminders = _getRemindersForDay(_selectedDay!);
    if (reminders.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Reminders for ${DateFormat('MMM dd, yyyy').format(_selectedDay!)}',
              style: const TextStyle(
                color: Colors.cyanAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            ...reminders.map((reminder) => _buildReminderCard(reminder)),
          ],
        ),
      ),
    );
  }

  Widget _buildReminderCard(CalendarReminder reminder) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      reminder.category,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        reminder.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '🕐 ${DateFormat('h:mm a').format(reminder.dateTime)}',
                  style: const TextStyle(color: Colors.white70, fontSize: 14),
                ),
                if (reminder.notes != null && reminder.notes!.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Text(
                      reminder.notes!,
                      style: const TextStyle(color: Colors.white60, fontSize: 12),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.redAccent),
            onPressed: () => _deleteReminder(reminder),
          ),
        ],
      ),
    );
  }

  void _showDayReminders(DateTime day) {
    final reminders = _getRemindersForDay(day);
    if (reminders.isEmpty) {
      _showAddReminderDialog(day);
    }
  }

  void _showAllReminders() {
    final allReminders = <CalendarReminder>[];
    _reminders.forEach((date, reminders) {
      allReminders.addAll(reminders);
    });
    allReminders.sort((a, b) => a.dateTime.compareTo(b.dateTime));

    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: BoxDecoration(
          color: const Color(0xFF1a1a2e),
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          border: Border.all(color: Colors.cyanAccent, width: 2),
        ),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'All Reminders',
                    style: TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            Expanded(
              child: allReminders.isEmpty
                  ? const Center(
                      child: Text(
                        'No reminders yet',
                        style: TextStyle(color: Colors.white70, fontSize: 16),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: allReminders.length,
                      itemBuilder: (context, index) {
                        final reminder = allReminders[index];
                        return _buildReminderCard(reminder);
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  void _showAddReminderDialog(DateTime selectedDate) {
    final titleController = TextEditingController();
    final notesController = TextEditingController();
    TimeOfDay selectedTime = TimeOfDay.now();
    String selectedCategory = _categories[0];

    showDialog(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1a1a2e),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
            side: const BorderSide(color: Colors.cyanAccent, width: 2),
          ),
          title: const Text(
            '📅 Add Reminder',
            style: TextStyle(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Date: ${DateFormat('MMM dd, yyyy').format(selectedDate)}',
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 20),
                DropdownButtonFormField<String>(
                  value: selectedCategory,
                  dropdownColor: const Color(0xFF1a1a2e),
                  decoration: InputDecoration(
                    labelText: 'Category',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  items: _categories.map((category) {
                    return DropdownMenuItem(
                      value: category,
                      child: Text(category, style: const TextStyle(color: Colors.white)),
                    );
                  }).toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setDialogState(() {
                        selectedCategory = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: titleController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'Title',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: notesController,
                  style: const TextStyle(color: Colors.white),
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'Notes (Optional)',
                    labelStyle: const TextStyle(color: Colors.white70),
                    enabledBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: const BorderSide(color: Colors.cyanAccent),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                GestureDetector(
                  onTap: () async {
                    final TimeOfDay? picked = await showTimePicker(
                      context: context,
                      initialTime: selectedTime,
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Colors.cyanAccent,
                              onPrimary: Colors.black,
                              surface: Color(0xFF1a1a2e),
                              onSurface: Colors.white,
                            ),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      setDialogState(() {
                        selectedTime = picked;
                      });
                    }
                  },
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.white30),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Time:',
                          style: TextStyle(color: Colors.white70),
                        ),
                        Text(
                          selectedTime.format(context),
                          style: const TextStyle(
                            color: Colors.cyanAccent,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text(
                'Cancel',
                style: TextStyle(color: Colors.white70),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                final title = titleController.text.trim();
                if (title.isEmpty) {
                  return;
                }

                final reminderDateTime = DateTime(
                  selectedDate.year,
                  selectedDate.month,
                  selectedDate.day,
                  selectedTime.hour,
                  selectedTime.minute,
                );

                if (reminderDateTime.isBefore(DateTime.now())) {
                  return;
                }

                final alarmId = reminderDateTime.millisecondsSinceEpoch ~/ 1000;
                final reminderId = DateTime.now().millisecondsSinceEpoch.toString();

                try {
                  await AlarmService.scheduleAlarm(
                    id: alarmId,
                    dateTime: reminderDateTime,
                    assetAudioPath: AlarmService.defaultAudioPath,
                    notificationTitle: '$selectedCategory Reminder',
                    notificationBody: title,
                    reminderNote: notesController.text.trim(),
                    loopAudio: true,
                    vibrate: true,
                    androidFullScreenIntent: true,
                  );

                  final reminder = CalendarReminder(
                    id: reminderId,
                    title: title,
                    dateTime: reminderDateTime,
                    category: selectedCategory,
                    notes: notesController.text.trim(),
                    alarmId: alarmId,
                  );

                  final normalizedDate = _normalizeDate(selectedDate);
                  if (_reminders[normalizedDate] == null) {
                    _reminders[normalizedDate] = [];
                  }
                  _reminders[normalizedDate]!.add(reminder);
                  await _saveReminders();

                  setState(() {});
                  Navigator.pop(context);
                } catch (e) {
                  // Silent error handling
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
              ),
              child: const Text('Set Reminder'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _deleteReminder(CalendarReminder reminder) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: const BorderSide(color: Colors.redAccent, width: 2),
        ),
        title: const Text(
          'Delete Reminder?',
          style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to delete "${reminder.title}"?',
          style: const TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      try {
        await AlarmService.stopAlarm(reminder.alarmId);
        
        final normalizedDate = _normalizeDate(reminder.dateTime);
        _reminders[normalizedDate]?.removeWhere((r) => r.id == reminder.id);
        if (_reminders[normalizedDate]?.isEmpty ?? false) {
          _reminders.remove(normalizedDate);
        }
        await _saveReminders();

        setState(() {});

        // Silent deletion
      } catch (e) {
        // Silent error handling
      }
    }
  }
}
