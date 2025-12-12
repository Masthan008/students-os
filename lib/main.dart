import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart'; // Critical Import
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';

// Imports from your project structure
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/ring_screen.dart'; // Contains AlarmRingScreen
import 'modules/calculator/calculator_provider.dart';
import 'modules/alarm/alarm_provider.dart';
import 'modules/alarm/alarm_service.dart';
import 'providers/focus_provider.dart';
import 'providers/theme_provider.dart';
import 'providers/accessibility_provider.dart';
import 'providers/dashboard_provider.dart';
import 'providers/notification_provider.dart';
import 'models/class_session.dart';
import 'models/attendance_record.dart';
import 'services/timetable_service.dart';
import 'services/notification_service.dart';
import 'services/news_service.dart';

// ---------------------------------------------------------
// 🔐 SECURITY NOTE: In production, use environment variables
// ---------------------------------------------------------
const String mySupabaseUrl = 'https://gnlkgstnulfenqxvrsur.supabase.co';
const String mySupabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImdubGtnc3RudWxmZW5xeHZyc3VyIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NjQyMjg4NjYsImV4cCI6MjA3OTgwNDg2Nn0.aOqkffRPxI4GPM79ravi79gm8ecOG9XXjWCnao59RG0';

void main() async {
  // 1. Ensure Bindings FIRST
  WidgetsFlutterBinding.ensureInitialized();

  // 2. Fix White Bar UI Bug - Set System UI Overlay
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.black, // Fixes white bar
      systemNavigationBarIconBrightness: Brightness.light,
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  // 3. Wrap EVERYTHING in a safety block
  try {
    // --- Hive Init ---
    await Hive.initFlutter();
    
    // Safety check for Adapters (Fixes "Adapter already registered" crash)
    try {
      if (!Hive.isAdapterRegistered(ClassSessionAdapter().typeId)) {
        Hive.registerAdapter(ClassSessionAdapter());
      }
      if (!Hive.isAdapterRegistered(AttendanceRecordAdapter().typeId)) {
        Hive.registerAdapter(AttendanceRecordAdapter());
      }
    } catch (e) {
      print("⚠️ Adapter Warning: $e");
    }
    
    // Open Boxes
    await Hive.openBox('calculator_history');
    await Hive.openBox<ClassSession>('class_sessions');
    await Hive.openBox('user_prefs');
    await Hive.openBox('attendance_records');
    await Hive.openBox('books_notes');
    
    print("✅ Hive Initialized Successfully");

    // --- Supabase Init ---
    // Safety check for Placeholder URL (Fixes "Invalid Argument" crash)
    if (mySupabaseUrl.contains('YOUR_SUPABASE_URL')) {
      print("⚠️ WARNING: Supabase Keys not set! Skipping Cloud Connection.");
    } else {
      await Supabase.initialize(
        url: mySupabaseUrl,
        anonKey: mySupabaseKey,
      );
      print("✅ Supabase Initialized Successfully");
    }

    // --- Services Init ---
    await AlarmService.init();
    print("✅ Alarm Service Initialized");
    
    await TimetableService.initializeTimetable();
    print("✅ Timetable Service Initialized");

    // --- Notification Service Init ---
    await NotificationService.init();
    print("✅ Notification Service Initialized");
    
    // Start listening for news updates
    NewsService.listenForUpdates();
    print("✅ News Notification Listener Started");

    // --- Permissions ---
    // Using a separate try-catch because permissions can be finicky on some Android versions
    try {
      await _requestPermissions();
      print("✅ Permissions Requested");
    } catch (e) {
      print("⚠️ Permission Request Warning: $e");
    }

  } catch (e, stackTrace) {
    // 4. THE SAFETY NET
    // If anything above fails, print it, but DO NOT STOP the app.
    print("❌ CRITICAL ERROR during init: $e");
    print("Stack trace: $stackTrace");
  }

  // 5. Launch App (This runs even if Init failed)
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => AccessibilityProvider()),
        ChangeNotifierProvider(create: (_) => DashboardProvider()),
        ChangeNotifierProvider(create: (_) => NotificationProvider()),
        ChangeNotifierProvider(create: (_) => CalculatorProvider()),
        ChangeNotifierProvider(create: (_) => AlarmProvider()),
        ChangeNotifierProvider(create: (_) => FocusProvider()),
      ],
      child: const FluxFlowApp(),
    ),
  );
}

class FluxFlowApp extends StatefulWidget {
  const FluxFlowApp({super.key});

  @override
  State<FluxFlowApp> createState() => _FluxFlowAppState();
}

class _FluxFlowAppState extends State<FluxFlowApp> {
  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  void initState() {
    super.initState();
    // Listen for Alarm Ring
    AlarmService.ringStream.listen((alarmSettings) {
      debugPrint("⏰ ALARM RINGING! ID: ${alarmSettings.id}");
      // FIX 2 from Diagnostic Report: Use correct class 'AlarmRingScreen'
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'FluxFlow',
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          theme: themeProvider.getCurrentTheme(),
          home: const SplashScreen(),
        );
      },
    );
  }
}

Future<void> _requestPermissions() async {
  if (await Permission.notification.isDenied) {
    await Permission.notification.request();
  }
  if (await Permission.scheduleExactAlarm.isDenied) {
    await Permission.scheduleExactAlarm.request();
  }
  if (await Permission.systemAlertWindow.isDenied) {
    await Permission.systemAlertWindow.request();
  }
}
