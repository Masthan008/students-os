import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';
import 'package:alarm/alarm.dart';
import 'package:permission_handler/permission_handler.dart';
import 'theme/app_theme.dart';
import 'screens/splash_screen.dart';
import 'screens/ring_screen.dart';
import 'modules/calculator/calculator_provider.dart';
import 'modules/alarm/alarm_provider.dart';
import 'modules/alarm/alarm_service.dart';
import 'providers/focus_provider.dart';
import 'models/class_session.dart';
import 'models/attendance_record.dart';
import 'services/timetable_service.dart';
import 'services/news_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Hive
  await Hive.initFlutter();
  
  // Register Adapters
  Hive.registerAdapter(ClassSessionAdapter());
  Hive.registerAdapter(AttendanceRecordAdapter());
  
  // Open Boxes
  await Hive.openBox('calculator_history');
  await Hive.openBox<ClassSession>('class_sessions');
  await Hive.openBox('user_prefs');
  await Hive.openBox('attendance_records');

  // Initialize Supabase
  await NewsService.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );

  // Initialize Alarm Service
  await AlarmService.init();
  
  // Initialize Timetable (seeds on first run)
  await TimetableService.initializeTimetable();

  // Request Permissions
  await _requestPermissions();

  runApp(
    MultiProvider(
      providers: [
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
  @override
  void initState() {
    super.initState();
    AlarmService.ringStream.listen((alarmSettings) {
      // Navigate to Alarm Ring Screen
      navigatorKey.currentState?.push(
        MaterialPageRoute(
          builder: (context) => AlarmRingScreen(alarmSettings: alarmSettings),
        ),
      );
    });
  }

  final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FluxFlow',
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: const SplashScreen(),
    );
  }
}

Future<void> _requestPermissions() async {
  // Notification permission (Android 13+)
  if (await Permission.notification.isDenied) {
    final status = await Permission.notification.request();
    debugPrint('Notification permission: $status');
  }
  
  // Exact alarm permission (Android 14+)
  if (await Permission.scheduleExactAlarm.isDenied) {
    final status = await Permission.scheduleExactAlarm.request();
    debugPrint('Schedule exact alarm permission: $status');
  }
  
  // System alert window permission (for full-screen intent)
  if (await Permission.systemAlertWindow.isDenied) {
    final status = await Permission.systemAlertWindow.request();
    debugPrint('System alert window permission: $status');
  }
}
