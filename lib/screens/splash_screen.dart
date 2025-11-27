import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../widgets/particle_background.dart';
import 'home_screen.dart';
import 'auth_screen.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Start animation and then check permissions
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        _checkPermissions();
      }
    });
  }

  Future<void> _checkPermissions() async {
    // Request all permissions at once
    Map<Permission, PermissionStatus> statuses = await [
      Permission.camera,
      Permission.location,
      Permission.notification,
      Permission.scheduleExactAlarm,
      Permission.ignoreBatteryOptimizations, // Critical for alarms
    ].request();

    // Log status for debugging
    debugPrint("Permissions: $statuses");

    // Check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Prompt user to enable location services
      await Geolocator.openLocationSettings();
    }

    if (mounted) {
      await _checkBiometricAndNavigate();
    }
  }

  Future<void> _checkBiometricAndNavigate() async {
    final box = await Hive.openBox('user_prefs');
    final isBiometricEnabled = box.get('biometric_enabled', defaultValue: false);
    
    if (isBiometricEnabled) {
      // Import AuthService
      final authenticated = await _authenticateUser();
      if (!authenticated && mounted) {
        // Show retry dialog
        _showAuthFailedDialog();
        return;
      }
    }
    
    if (mounted) {
      _navigateNext();
    }
  }

  Future<bool> _authenticateUser() async {
    try {
      // Use local_auth package
      final localAuth = await Permission.camera.isGranted; // Placeholder for actual auth
      // In real implementation, use: await LocalAuthentication().authenticate(...)
      return true; // For now, always return true
    } catch (e) {
      debugPrint('Biometric auth error: $e');
      return false;
    }
  }

  void _showAuthFailedDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text(
          'Authentication Failed',
          style: TextStyle(color: Colors.redAccent),
        ),
        content: const Text(
          'Please authenticate to continue',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _checkBiometricAndNavigate();
            },
            child: const Text('Retry', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  Future<void> _navigateNext() async {
    // Check if user is already registered
    final box = await Hive.openBox('user_prefs');
    final userRole = box.get('user_role');

    if (mounted) {
      if (userRole == null) {
        // Go to Registration
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
        );
      } else {
        // Go to Home
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParticleBackground(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background Image
            Image.asset('assets/images/splash_bg.jpg', fit: BoxFit.cover)
               .animate()
                .fadeIn(duration: 800.ms)
                .saturate(duration: 2.seconds),

            // Logo
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.cyanAccent.withOpacity(0.5),
                          blurRadius: 30,
                          spreadRadius: 10,
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image.asset('assets/images/app_logo.jpg', fit: BoxFit.cover),
                    ),
                  )
                      .animate(onPlay: (controller) => controller.repeat(reverse: true))
                      .scale(
                        begin: const Offset(0.9, 0.9),
                        end: const Offset(1.05, 1.05),
                        duration: 2000.ms,
                        curve: Curves.easeInOut,
                      ),
                ],
              ),
            ),

            // Signature
            Positioned(
              bottom: 40,
              left: 0,
              right: 0,
              child: Center(
                child: DefaultTextStyle(
                  style: GoogleFonts.greatVibes(
                    fontSize: 16.0, // Smaller & Elegant
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                  child: const Text("Developed by MASTHAN VALLI")
                    .animate()
                    .fadeIn(delay: 500.ms, duration: 1000.ms)
                    .then()
                    .shimmer(
                      duration: 2.seconds, // Slower shimmer
                      color: const Color(0xFFFFD700),
                      colors: [
                        const Color(0xFFFFD700),
                        const Color(0xFF00FFFF),
                      ],
                    ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
