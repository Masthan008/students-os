import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import '../widgets/glass_container.dart';

class TeacherDashboardScreen extends StatelessWidget {
  const TeacherDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Teacher Dashboard',
          style: TextStyle(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
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
          child: ValueListenableBuilder(
            valueListenable: Hive.box('attendance_records').listenable(),
            builder: (context, Box box, _) {
              if (box.isEmpty) {
                return Center(
                  child: GlassContainer(
                    width: 250,
                    padding: const EdgeInsets.all(20),
                    child: const Text(
                      'No attendance records yet',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }

              final records = box.values.toList().reversed.toList();

              return ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: records.length,
                itemBuilder: (context, index) {
                  final record = records[index] as Map;
                  final studentId = record['studentId'] ?? 'Unknown';
                  final timestamp = DateTime.parse(record['timestamp']);
                  final isVerified = record['isVerified'] ?? false;
                  final subjectName = record['subjectName'] ?? 'Unknown';
                  final latitude = record['latitude'] ?? 0.0;
                  final longitude = record['longitude'] ?? 0.0;

                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: GlassContainer(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          // Verified Icon
                          Container(
                            width: 50,
                            height: 50,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isVerified
                                  ? Colors.green.withOpacity(0.3)
                                  : Colors.red.withOpacity(0.3),
                            ),
                            child: Icon(
                              isVerified ? Icons.check_circle : Icons.cancel,
                              color: isVerified ? Colors.greenAccent : Colors.redAccent,
                              size: 30,
                            ),
                          ),
                          const SizedBox(width: 16),
                          // Details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Student ID: $studentId',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Subject: $subjectName',
                                  style: const TextStyle(
                                    color: Colors.cyanAccent,
                                    fontSize: 14,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Time: ${DateFormat('MMM dd, yyyy - hh:mm a').format(timestamp)}',
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontSize: 12,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Location: ${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}',
                                  style: const TextStyle(
                                    color: Colors.white60,
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }
}
