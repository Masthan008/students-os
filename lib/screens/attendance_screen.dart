import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:io';
import 'dart:async';
import 'package:image/image.dart' as img;
import '../services/timetable_service.dart';
import '../models/class_session.dart';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  final FaceDetector _faceDetector = FaceDetector(options: FaceDetectorOptions());
  CameraController? _cameraController;
  bool _isCheckingIn = false;
  bool _alreadyMarked = false;
  String? _currentSubject;
  Map<String, dynamic>? _classLocation;
  String _statusMessage = "Checking...";

  @override
  void initState() {
    super.initState();
    _checkAttendanceStatus();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // --- 1. CHECK IF ALREADY MARKED ---
  Future<void> _checkAttendanceStatus() async {
    try {
      final userBox = Hive.box('user_prefs');
      final studentId = userBox.get('id', defaultValue: '0000');
      
      // Get current class
      final currentClass = await _getCurrentClass();
      if (currentClass == null) {
        setState(() {
          _statusMessage = "No class in session";
          _currentSubject = null;
        });
        return;
      }

      setState(() {
        _currentSubject = currentClass.subjectName;
      });

      // Check if already marked today
      final today = DateTime.now();
      final startOfDay = DateTime(today.year, today.month, today.day);
      final endOfDay = startOfDay.add(const Duration(days: 1));

      final response = await Supabase.instance.client
          .from('attendance_logs')
          .select()
          .eq('student_id', studentId)
          .eq('subject', currentClass.subjectName)
          .gte('timestamp', startOfDay.toIso8601String())
          .lt('timestamp', endOfDay.toIso8601String());

      if (response.isNotEmpty) {
        setState(() {
          _alreadyMarked = true;
          _statusMessage = "Already marked for ${currentClass.subjectName}";
        });
        return;
      }

      // Get class location from teacher
      final locationResponse = await Supabase.instance.client
          .from('class_coordinates')
          .select()
          .eq('subject', currentClass.subjectName)
          .eq('day_of_week', today.weekday)
          .maybeSingle();

      setState(() {
        _classLocation = locationResponse;
        _statusMessage = locationResponse == null
            ? "Waiting for teacher to set location..."
            : "Ready to check in";
      });
    } catch (e) {
      debugPrint("Error checking attendance: $e");
      setState(() {
        _statusMessage = "Error: $e";
      });
    }
  }

  // --- 2. GET CURRENT CLASS ---
  Future<ClassSession?> _getCurrentClass() async {
    try {
      final now = DateTime.now();
      final classes = await TimetableService.getTodayClasses();
      
      for (var session in classes) {
        final start = session.startTime;
        final end = session.endTime;
        
        if (now.isAfter(start) && now.isBefore(end)) {
          return session;
        }
      }
      return null;
    } catch (e) {
      debugPrint("Error getting current class: $e");
      return null;
    }
  }

  // --- 3. FACE CAPTURE WITH UPLOAD ---
  Future<void> _showFaceScanSheet(Position position) async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      _showError("No camera found!");
      return;
    }

    final frontCam = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCam,
      ResolutionPreset.medium,
      enableAudio: false,
    );
    await _cameraController!.initialize();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      isDismissible: false,
      builder: (ctx) => WillPopScope(
        onWillPop: () async => false,
        child: Container(
          height: 550,
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Text(
                "Face Verification",
                style: GoogleFonts.orbitron(
                  color: Colors.cyanAccent,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "This photo will be saved as proof",
                style: TextStyle(color: Colors.grey.shade400, fontSize: 12),
              ),
              const SizedBox(height: 20),
              ClipOval(
                child: SizedBox(
                  height: 300,
                  width: 300,
                  child: CameraPreview(_cameraController!),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                ),
                onPressed: () => _captureAndUpload(ctx, position),
                icon: const Icon(Icons.camera_alt, color: Colors.white),
                label: const Text(
                  "Capture & Submit",
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 10),
              TextButton(
                onPressed: () {
                  _cameraController?.dispose();
                  _cameraController = null;
                  Navigator.pop(ctx);
                },
                child: const Text("Cancel", style: TextStyle(color: Colors.grey)),
              ),
            ],
          ),
        ),
      ),
    ).whenComplete(() {
      _cameraController?.dispose();
      _cameraController = null;
    });
  }

  // --- 4. CAPTURE, VERIFY FACE, RESIZE & UPLOAD ---
  Future<void> _captureAndUpload(BuildContext modalContext, Position position) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    setState(() => _isCheckingIn = true);

    try {
      // Capture image
      final xFile = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(xFile.path);
      
      // Verify face
      final faces = await _faceDetector.processImage(inputImage);
      if (faces.isEmpty) {
        setState(() => _isCheckingIn = false);
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: Colors.red,
            content: Text("No face detected! Please try again."),
          ),
        );
        return;
      }

      // Resize image to reduce size
      final bytes = await File(xFile.path).readAsBytes();
      final image = img.decodeImage(bytes);
      if (image == null) throw Exception("Failed to decode image");

      final resized = img.copyResize(image, width: 800);
      final resizedBytes = img.encodeJpg(resized, quality: 85);

      // Upload to Supabase Storage
      final userBox = Hive.box('user_prefs');
      final studentId = userBox.get('id', defaultValue: '0000');
      final timestamp = DateTime.now().millisecondsSinceEpoch;
      final fileName = '${studentId}_${timestamp}.jpg';

      final uploadResponse = await Supabase.instance.client.storage
          .from('attendance_proofs')
          .uploadBinary(
            fileName,
            resizedBytes,
            fileOptions: const FileOptions(contentType: 'image/jpeg'),
          );

      // Get public URL
      final publicUrl = Supabase.instance.client.storage
          .from('attendance_proofs')
          .getPublicUrl(fileName);

      // Close modal
      Navigator.pop(modalContext);

      // Upload attendance record
      await _uploadAttendance(publicUrl, position);
    } catch (e) {
      setState(() => _isCheckingIn = false);
      debugPrint("Capture error: $e");
      _showError("Upload failed: $e");
    }
  }

  // --- 5. UPLOAD ATTENDANCE ---
  Future<void> _uploadAttendance(String proofUrl, Position position) async {
    try {
      final userBox = Hive.box('user_prefs');
      final name = userBox.get('name', defaultValue: 'Unknown Student');
      final studentId = userBox.get('id', defaultValue: '0000');

      await Supabase.instance.client.from('attendance_logs').insert({
        'student_id': studentId,
        'student_name': name,
        'subject': _currentSubject,
        'status': 'Present',
        'timestamp': DateTime.now().toIso8601String(),
        'proof_url': proofUrl,
        'latitude': position.latitude,
        'longitude': position.longitude,
      });

      setState(() {
        _alreadyMarked = true;
        _statusMessage = "Attendance marked successfully!";
      });

      _showSuccess("✅ Attendance marked for $_currentSubject");
    } catch (e) {
      _showError("Failed to save attendance: $e");
    } finally {
      setState(() => _isCheckingIn = false);
    }
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.green, content: Text(msg)),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(backgroundColor: Colors.red, content: Text(msg)),
    );
  }

  // --- 6. UI ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          "Smart Attendance",
          style: GoogleFonts.orbitron(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _checkAttendanceStatus,
          ),
        ],
      ),
      body: _alreadyMarked
          ? _buildAlreadyMarkedUI()
          : _currentSubject == null
              ? _buildNoClassUI()
              : _classLocation == null
                  ? _buildWaitingForTeacherUI()
                  : _buildLocationCheckUI(),
    );
  }

  // Already Marked UI
  Widget _buildAlreadyMarkedUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.green.withOpacity(0.2),
              border: Border.all(color: Colors.greenAccent, width: 4),
            ),
            child: const Icon(
              Icons.check_circle,
              size: 100,
              color: Colors.greenAccent,
            ),
          ),
          const SizedBox(height: 30),
          Text(
            "ATTENDANCE MARKED",
            style: GoogleFonts.orbitron(
              fontSize: 20,
              color: Colors.green,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            _currentSubject ?? "Class",
            style: const TextStyle(color: Colors.white70, fontSize: 16),
          ),
          const SizedBox(height: 5),
          Text(
            "You cannot mark again today",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // No Class UI
  Widget _buildNoClassUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.schedule, size: 80, color: Colors.grey.shade700),
          const SizedBox(height: 20),
          Text(
            "No Class in Session",
            style: GoogleFonts.orbitron(
              fontSize: 20,
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Check back during class time",
            style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
          ),
        ],
      ),
    );
  }

  // Waiting for Teacher UI
  Widget _buildWaitingForTeacherUI() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const CircularProgressIndicator(color: Colors.amber),
          const SizedBox(height: 30),
          Text(
            "Waiting for Teacher",
            style: GoogleFonts.orbitron(
              fontSize: 20,
              color: Colors.amber,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            "Teacher needs to set location for $_currentSubject",
            style: const TextStyle(color: Colors.white70, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  // Location Check UI
  Widget _buildLocationCheckUI() {
    return StreamBuilder<Position>(
      stream: Geolocator.getPositionStream(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          distanceFilter: 2,
        ),
      ),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "GPS Error. Please enable Location.",
              style: TextStyle(color: Colors.red.shade400, fontSize: 16),
            ),
          );
        }

        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.cyanAccent),
          );
        }

        final position = snapshot.data!;
        final targetLat = _classLocation!['latitude'] as double;
        final targetLng = _classLocation!['longitude'] as double;

        final distance = Geolocator.distanceBetween(
          position.latitude,
          position.longitude,
          targetLat,
          targetLng,
        );

        final isInRange = distance <= 50.0; // 50 meters

        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Status Circle
              Container(
                width: 200,
                height: 200,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isInRange ? Colors.greenAccent : Colors.redAccent,
                    width: 4,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: isInRange
                          ? Colors.green.withOpacity(0.3)
                          : Colors.red.withOpacity(0.2),
                      blurRadius: 30,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Icon(
                  isInRange ? Icons.check_circle : Icons.lock,
                  size: 80,
                  color: isInRange ? Colors.greenAccent : Colors.redAccent,
                ),
              ),
              const SizedBox(height: 30),

              // Status Text
              Text(
                isInRange ? "IN CLASSROOM" : "NOT IN CLASSROOM",
                style: GoogleFonts.orbitron(
                  fontSize: 20,
                  color: isInRange ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                _currentSubject ?? "Class",
                style: const TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                "Distance: ${distance.toStringAsFixed(1)}m",
                style: TextStyle(
                  color: isInRange ? Colors.green.shade300 : Colors.red.shade300,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 40),

              // Action Button
              if (_isCheckingIn)
                const CircularProgressIndicator(color: Colors.cyanAccent)
              else
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        isInRange ? Colors.cyanAccent : Colors.grey[800],
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  onPressed: isInRange ? () => _showFaceScanSheet(position) : null,
                  icon: Icon(
                    Icons.face,
                    color: isInRange ? Colors.black : Colors.white54,
                  ),
                  label: Text(
                    "VERIFY FACE & ATTEND",
                    style: TextStyle(
                      color: isInRange ? Colors.black : Colors.white54,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
