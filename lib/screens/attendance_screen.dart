import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../services/auth_service.dart';
import '../services/timetable_service.dart';
import '../models/class_session.dart';
import 'qr_handshake_screen.dart';
import '../services/report_service.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  bool _isLoading = false;
  double? _locationAccuracy;
  String _statusMessage = "Ready to Check-In";
  ClassSession? _currentClass;
  bool _isTeacher = false;

  @override
  void initState() {
    super.initState();
    _isTeacher = AuthService.userRole == 'teacher';
    if (!_isTeacher) {
      _checkCurrentClass();
    }
  }

  Future<void> _checkCurrentClass() async {
    final classes = await TimetableService.getTodayClasses();
    final now = DateTime.now();
    
    // Find class that is currently active
    ClassSession? activeClass;
    for (var session in classes) {
      final start = DateTime(now.year, now.month, now.day, session.startTime.hour, session.startTime.minute);
      final end = DateTime(now.year, now.month, now.day, session.endTime.hour, session.endTime.minute);
      
      if (now.isAfter(start) && now.isBefore(end)) {
        activeClass = session;
        break;
      }
    }

    setState(() {
      _currentClass = activeClass;
      if (_currentClass == null) {
        _statusMessage = "No class currently in session.";
      } else {
        _statusMessage = "Class: ${_currentClass!.subjectName}";
      }
    });
  }

  Future<void> _handleCheckIn() async {
    if (_currentClass == null) {
      _showError("No class in session!");
      return;
    }

    setState(() {
      _isLoading = true;
      _statusMessage = "Triangulating Location...";
    });

    try {
      // GPS with 6-second timeout
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: const Duration(seconds: 6),
      );

      setState(() {
        _locationAccuracy = position.accuracy;
      });

      // TODO: Verify location is within campus bounds
      // For now, just mark attendance
      _markAttendance(position);
      
    } on TimeoutException {
      _showError("GPS Signal Weak. Move near a window or try again.");
    } catch (e) {
      _showError("Location Error: ${e.toString()}");
    } finally {
      setState(() {
        _isLoading = false;
        _statusMessage = _currentClass != null 
          ? "Class: ${_currentClass!.subjectName}" 
          : "Ready to Check-In";
      });
    }
  }

  void _markAttendance(Position position) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          "Attendance Marked! Accuracy: ${position.accuracy.toStringAsFixed(1)}m"
        ),
        backgroundColor: Colors.green,
      ),
    );
    
    // TODO: Save to Hive/backend
    setState(() {
      _statusMessage = "Attendance Recorded ✓";
    });
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Attendance"),
        actions: [
          if (!_isTeacher)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _checkCurrentClass,
            ),
        ],
      ),
      body: _isLoading
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const CircularProgressIndicator(),
                  const SizedBox(height: 20),
                  Text(
                    _statusMessage,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                  ),
                ],
              ),
            )
          : Center(
              child: Padding(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (!_isTeacher) ...[
                      // Student UI
                      const Icon(Icons.fingerprint, size: 80, color: Colors.blue),
                      const SizedBox(height: 20),
                      Text(
                        _statusMessage,
                        style: Theme.of(context).textTheme.headlineSmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      
                      // Check-In Button with Shimmer Animation
                      GestureDetector(
                        onTap: _currentClass != null ? _handleCheckIn : null,
                        child: Container(
                          width: 200,
                          height: 200,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: LinearGradient(
                              colors: _currentClass != null
                                  ? [Colors.blue.shade400, Colors.blue.shade700]
                                  : [Colors.grey.shade400, Colors.grey.shade600],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.blue.withOpacity(0.5),
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ],
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.touch_app,
                              size: 60,
                              color: Colors.white,
                            ),
                          ),
                        ).animate(
                          onPlay: (controller) => controller.repeat(),
                        ).shimmer(
                          duration: 2.seconds,
                          color: Colors.white.withOpacity(0.3),
                        ),
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Location Accuracy Display
                      if (_locationAccuracy != null)
                        Text(
                          "Current Location Accuracy: ${_locationAccuracy!.toStringAsFixed(1)} meters",
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey.shade600,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      
                      const SizedBox(height: 20),
                      
                      // Late Override Button
                      TextButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QrHandshakeScreen(isTeacher: false),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code),
                        label: const Text("Request Late Override"),
                      ),
                    ] else ...[
                      // Teacher UI
                      const Icon(Icons.admin_panel_settings, size: 80, color: Colors.amber),
                      const SizedBox(height: 20),
                      Text(
                        "Teacher Dashboard",
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 40),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => const QrHandshakeScreen(isTeacher: true),
                            ),
                          );
                        },
                        icon: const Icon(Icons.qr_code_scanner),
                        label: const Text("Scan Student QR"),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                          textStyle: const TextStyle(fontSize: 18),
                        ),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton.icon(
                        onPressed: () async {
                          await ReportService.generateMonthlyReport();
                        },
                        icon: const Icon(Icons.picture_as_pdf),
                        label: const Text("Generate Monthly Report"),
                      ),
                    ],
                  ],
                ),
              ),
            ),
    );
  }
}
