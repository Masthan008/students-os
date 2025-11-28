import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:intl/intl.dart';
import 'package:geolocator/geolocator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/glass_container.dart';
import '../services/timetable_service.dart';
import '../models/class_session.dart';

class TeacherDashboardScreen extends StatefulWidget {
  const TeacherDashboardScreen({super.key});

  @override
  State<TeacherDashboardScreen> createState() => _TeacherDashboardScreenState();
}

class _TeacherDashboardScreenState extends State<TeacherDashboardScreen> {
  bool _isSettingLocation = false;
  ClassSession? _currentClass;
  List<Map<String, dynamic>> _attendanceRecords = [];
  bool _isLoadingRecords = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentClass();
    _loadAttendanceRecords();
  }

  Future<void> _loadCurrentClass() async {
    try {
      final now = DateTime.now();
      final classes = await TimetableService.getTodayClasses();

      for (var session in classes) {
        if (now.isAfter(session.startTime) && now.isBefore(session.endTime)) {
          setState(() => _currentClass = session);
          return;
        }
      }
      setState(() => _currentClass = null);
    } catch (e) {
      debugPrint("Error loading current class: $e");
    }
  }

  Future<void> _loadAttendanceRecords() async {
    setState(() => _isLoadingRecords = true);
    try {
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);

      final response = await Supabase.instance.client
          .from('attendance_logs')
          .select()
          .gte('timestamp', startOfDay.toIso8601String())
          .order('timestamp', ascending: false);

      setState(() {
        _attendanceRecords = List<Map<String, dynamic>>.from(response);
      });
    } catch (e) {
      debugPrint("Error loading attendance: $e");
    } finally {
      setState(() => _isLoadingRecords = false);
    }
  }

  Future<void> _setClassLocation() async {
    if (_currentClass == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("No class in session right now!"),
        ),
      );
      return;
    }

    setState(() => _isSettingLocation = true);

    try {
      // Get current position
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      // Upsert to Supabase
      await Supabase.instance.client.from('class_coordinates').upsert({
        'subject': _currentClass!.subjectName,
        'day_of_week': DateTime.now().weekday,
        'latitude': position.latitude,
        'longitude': position.longitude,
        'set_by': 'Teacher',
      }, onConflict: 'subject,day_of_week');

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.green,
          content: Text(
            "✅ Location locked for ${_currentClass!.subjectName}",
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          backgroundColor: Colors.red,
          content: Text("Error: $e"),
        ),
      );
    } finally {
      setState(() => _isSettingLocation = false);
    }
  }

  Future<void> _viewProof(String? proofUrl) async {
    if (proofUrl == null || proofUrl.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.orange,
          content: Text("No proof image available"),
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.black,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppBar(
              backgroundColor: Colors.grey.shade900,
              title: const Text("Attendance Proof"),
              automaticallyImplyLeading: false,
              actions: [
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Image.network(
                proofUrl,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(
                    child: CircularProgressIndicator(color: Colors.cyanAccent),
                  );
                },
                errorBuilder: (context, error, stackTrace) {
                  return const Padding(
                    padding: EdgeInsets.all(20),
                    child: Text(
                      "Failed to load image",
                      style: TextStyle(color: Colors.red),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'Teacher Dashboard',
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _loadCurrentClass();
              _loadAttendanceRecords();
            },
          ),
        ],
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
          child: Column(
            children: [
              // Current Class Card
              Padding(
                padding: const EdgeInsets.all(16),
                child: GlassContainer(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Icon(
                        _currentClass != null ? Icons.class_ : Icons.schedule,
                        size: 50,
                        color: _currentClass != null
                            ? Colors.cyanAccent
                            : Colors.grey,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        _currentClass != null
                            ? "Current Class"
                            : "No Class in Session",
                        style: TextStyle(
                          color: Colors.grey.shade400,
                          fontSize: 14,
                        ),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        _currentClass?.subjectName ?? "---",
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      if (_currentClass != null) ...[
                        const SizedBox(height: 5),
                        Text(
                          TimetableService.subjectNames[
                                  _currentClass!.subjectName] ??
                              _currentClass!.subjectName,
                          style: TextStyle(
                            color: Colors.grey.shade500,
                            fontSize: 12,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _currentClass != null
                                ? Colors.green
                                : Colors.grey[800],
                            padding: const EdgeInsets.symmetric(vertical: 15),
                          ),
                          onPressed: _currentClass != null && !_isSettingLocation
                              ? _setClassLocation
                              : null,
                          icon: _isSettingLocation
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.location_on, color: Colors.white),
                          label: Text(
                            _isSettingLocation
                                ? "Setting Location..."
                                : "📍 Set Location for This Class",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              // Attendance Records Header
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Today's Attendance",
                      style: GoogleFonts.orbitron(
                        color: Colors.cyanAccent,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "${_attendanceRecords.length} records",
                      style: TextStyle(
                        color: Colors.grey.shade500,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),

              // Attendance Records List
              Expanded(
                child: _isLoadingRecords
                    ? const Center(
                        child: CircularProgressIndicator(color: Colors.cyanAccent),
                      )
                    : _attendanceRecords.isEmpty
                        ? Center(
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
                          )
                        : ListView.builder(
                            padding: const EdgeInsets.all(16),
                            itemCount: _attendanceRecords.length,
                            itemBuilder: (context, index) {
                              final record = _attendanceRecords[index];
                              return _buildAttendanceCard(record);
                            },
                          ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildAttendanceCard(Map<String, dynamic> record) {
    final studentId = record['student_id'] ?? 'Unknown';
    final studentName = record['student_name'] ?? 'Unknown';
    final subject = record['subject'] ?? 'Unknown';
    final timestamp = DateTime.parse(record['timestamp']);
    final proofUrl = record['proof_url'] as String?;
    final hasProof = proofUrl != null && proofUrl.isNotEmpty;

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlassContainer(
        width: double.infinity,
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Status Icon
            Container(
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: hasProof
                    ? Colors.green.withOpacity(0.3)
                    : Colors.orange.withOpacity(0.3),
              ),
              child: Icon(
                hasProof ? Icons.verified : Icons.warning,
                color: hasProof ? Colors.greenAccent : Colors.orangeAccent,
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
                    studentName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'ID: $studentId',
                    style: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Subject: $subject',
                    style: const TextStyle(
                      color: Colors.cyanAccent,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    DateFormat('hh:mm a').format(timestamp),
                    style: const TextStyle(
                      color: Colors.white70,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),

            // View Proof Button
            if (hasProof)
              IconButton(
                icon: const Icon(Icons.photo, color: Colors.cyanAccent),
                onPressed: () => _viewProof(proofUrl),
                tooltip: "View Proof",
              ),
          ],
        ),
      ),
    );
  }
}
