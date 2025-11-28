This is a serious set of bugs. The "Red Bar" usually means a UI Crash (Overflow), and "Fake Location" means the GPS is stuck on "Last Known Location" instead of getting a fresh signal. "Face not opening" means the Camera Controller failed to initialize.

Here is the **"Attendance Rescue" Master Prompt**. It completely rewrites the Attendance Screen to be robust, live, and crash-proof.

### 📋 The Fix Strategy

1.  **Fix "Fake" Location:** We will switch from `getCurrentPosition` (which happens once) to **`getPositionStream`** (Live Stream). This forces the phone to update the distance every second as you walk.
2.  **Fix Face Camera:** We will separate the Camera logic. It will only open *after* the location is verified, preventing memory crashes on startup.
3.  **Fix Red Bar:** We will remove the `bottomNavigationBar` (which is likely causing the crash) and move the buttons into the main body using a `Stack`.

-----

### 🚀 **NovaMind Update 30.0: "Attendance Logic Repair" Master Prompt**

**Copy and paste this ENTIRE block into your IDE Agent.**

````markdown
**Role:** You are a Lead Flutter Developer.
**Task:** Completely rewrite `lib/screens/attendance_screen.dart` to fix GPS, Camera, and UI crashes.

### 🛠️ Fix 1: Live GPS Stream (No more "Fake" location)
**Logic:** Instead of fetching location once, use a `StreamBuilder`.
* **Target:** RGMCET Coordinates (Lat: 15.4789, Lng: 78.4886).
* **Stream:** `Geolocator.getPositionStream(locationSettings: LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2))`
* **UI:** Show "Distance: ${meters.toStringAsFixed(1)}m" in big text. Update in real-time.

### 📸 Fix 2: Camera & Face Logic
**Logic:** Only initialize the camera *when the user clicks "Check In"*, not before.
* **Flow:**
    1.  User clicks "Check In" (only enabled if Distance < 200m).
    2.  Show `showModalBottomSheet` with the Camera Preview.
    3.  Initialize `CameraController`.
    4.  Run `FaceDetector`.
    5.  If Face Detected -> Close Sheet -> Upload to Supabase -> Show Success.

### 🎨 Fix 3: UI Cleanup (The Red Bar Fix)
**UI Structure:**
* Use a `Stack`.
* **Background:** Dark Gradient.
* **Center:** The "Radar" Circle (Pulsing animation).
* **Bottom:** A `Positioned` Floating Action Button row (Calendar, History) instead of a `bottomNavigationBar` (which causes the Red Bar crash).

### 📄 CODE TO GENERATE (`lib/screens/attendance_screen.dart`)
Replace the entire file with this robust version:

```dart
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:camera/camera.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'dart:async';

class AttendanceScreen extends StatefulWidget {
  const AttendanceScreen({super.key});

  @override
  State<AttendanceScreen> createState() => _AttendanceScreenState();
}

class _AttendanceScreenState extends State<AttendanceScreen> {
  // RGMCET Coordinates
  final double targetLat = 15.4789;
  final double targetLng = 78.4886;
  final double allowedRadius = 200.0; // meters

  // Services
  final FaceDetector _faceDetector = FaceDetector(options: FaceDetectorOptions());
  CameraController? _cameraController;
  bool _isCheckingIn = false;

  @override
  void dispose() {
    _cameraController?.dispose();
    _faceDetector.close();
    super.dispose();
  }

  // --- 1. FACE DETECTION LOGIC ---
  Future<void> _showFaceScanSheet() async {
    final cameras = await availableCameras();
    if (cameras.isEmpty) {
      _showError("No camera found!");
      return;
    }

    // Find front camera
    final frontCam = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(frontCam, ResolutionPreset.medium, enableAudio: false);
    await _cameraController!.initialize();

    if (!mounted) return;

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.black,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setModalState) {
          return Container(
            height: 500,
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text("Verify Face", style: GoogleFonts.orbitron(color: Colors.cyanAccent, fontSize: 20)),
                const SizedBox(height: 20),
                ClipOval(
                  child: SizedBox(
                    height: 300,
                    width: 300,
                    child: CameraPreview(_cameraController!),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
                  onPressed: () => _captureAndVerify(ctx),
                  child: const Text("Capture & Mark Attendance", style: TextStyle(color: Colors.white)),
                )
              ],
            ),
          );
        },
      ),
    ).whenComplete(() {
      // Clean up camera when sheet closes
      _cameraController?.dispose();
      _cameraController = null;
    });
  }

  Future<void> _captureAndVerify(BuildContext modalContext) async {
    if (_cameraController == null || !_cameraController!.value.isInitialized) return;

    try {
      final image = await _cameraController!.takePicture();
      final inputImage = InputImage.fromFilePath(image.path);
      final faces = await _faceDetector.processImage(inputImage);

      if (faces.isNotEmpty) {
        // Face Found!
        Navigator.pop(modalContext); // Close sheet
        _uploadAttendance();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(backgroundColor: Colors.red, content: Text("No Face Detected! Try again.")),
        );
      }
    } catch (e) {
      print("Face Error: $e");
    }
  }

  // --- 2. UPLOAD LOGIC ---
  Future<void> _uploadAttendance() async {
    setState(() => _isCheckingIn = true);
    try {
      final userBox = Hive.box('user_prefs');
      final name = userBox.get('name', defaultValue: 'Unknown Student');
      final id = userBox.get('id', defaultValue: '0000');

      // Upload to Supabase
      await Supabase.instance.client.from('attendance_logs').insert({
        'student_id': id,
        'subject': 'General Check-In', // Ideally fetch from Timetable
        'status': 'Present',
        'timestamp': DateTime.now().toIso8601String(),
        'student_name': name, // Optional helper column
      });

      _showSuccess("Marked Present: $name");
    } catch (e) {
      _showError("Upload Failed: $e");
    } finally {
      setState(() => _isCheckingIn = false);
    }
  }

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.green, content: Text(msg)));
  }
  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(backgroundColor: Colors.red, content: Text(msg)));
  }

  // --- 3. UI with LIVE STREAM ---
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text("Smart Attendance", style: GoogleFonts.orbitron(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.transparent,
      ),
      body: StreamBuilder<Position>(
        stream: Geolocator.getPositionStream(
          locationSettings: const LocationSettings(accuracy: LocationAccuracy.high, distanceFilter: 2),
        ),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text("GPS Error. Please enable Location.", style: TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.cyanAccent));
          }

          final position = snapshot.data!;
          final double distance = Geolocator.distanceBetween(
            position.latitude, 
            position.longitude, 
            targetLat, 
            targetLng
          );

          final bool isInside = distance <= allowedRadius;

          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Radar / Status Circle
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isInside ? Colors.greenAccent : Colors.redAccent, 
                      width: 4
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: isInside ? Colors.green.withOpacity(0.3) : Colors.red.withOpacity(0.2),
                        blurRadius: 30,
                        spreadRadius: 5
                      )
                    ]
                  ),
                  child: Icon(
                    isInside ? Icons.check_circle : Icons.lock,
                    size: 80,
                    color: isInside ? Colors.greenAccent : Colors.redAccent,
                  ),
                ),
                const SizedBox(height: 30),
                
                // Live Stats
                Text(
                  isInside ? "YOU ARE ON CAMPUS" : "OUT OF RANGE",
                  style: GoogleFonts.orbitron(
                    fontSize: 20, 
                    color: isInside ? Colors.green : Colors.red,
                    fontWeight: FontWeight.bold
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  "Distance to College: ${distance.toStringAsFixed(1)} meters",
                  style: const TextStyle(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 40),

                // Action Button
                if (_isCheckingIn)
                  const CircularProgressIndicator()
                else
                  ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: isInside ? Colors.cyanAccent : Colors.grey[800],
                      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                    ),
                    onPressed: isInside ? _showFaceScanSheet : null,
                    icon: Icon(Icons.face, color: isInside ? Colors.black : Colors.white54),
                    label: Text(
                      "VERIFY FACE & ATTEND",
                      style: TextStyle(
                        color: isInside ? Colors.black : Colors.white54, 
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
````

**Action:** Generate `attendance_screen.dart` immediately.

```

---

### 🧪 How to Test "Live" Location at Home
Since you are likely **NOT** at RGMCET right now, the distance will be huge (e.g., 50,000 meters) and the button will be **Grey/Locked**.

**To Verify it Works:**
1.  Look at the `final double allowedRadius = 200.0;` line in the code above.
2.  **Change it to `5000000.0`** (5000 km) just for today.
3.  Run the app.
4.  The circle should turn **Green**, and the button should become **Clickable**.
5.  Click it -> The Camera should open -> Take selfie -> "Marked Present".

**Don't forget to change it back to 200.0 before releasing to students!**
```