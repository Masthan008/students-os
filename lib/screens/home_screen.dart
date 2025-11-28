import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../widgets/glass_bottom_nav.dart';
import '../modules/calculator/calculator_screen.dart';
import '../modules/alarm/alarm_screen.dart';
import '../modules/games/game_2048_screen.dart';
import '../modules/focus/focus_forest_screen.dart';
import '../modules/sleep/sleep_screen.dart';
import '../modules/cyber/cyber_vault_screen.dart';
import '../modules/coding/coding_lab_screen.dart';
import '../modules/coding/compiler_screen.dart';
import '../modules/news/news_screen.dart';
import '../modules/academic/syllabus_screen.dart';
import 'timetable_screen.dart';
import 'calendar_screen.dart';
import 'attendance_screen.dart';
import 'teacher_dashboard_screen.dart';
import 'settings_screen.dart';
import 'about_screen.dart';
import 'chat_screen.dart';
import '../services/auth_service.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const TimetableScreen(),
    const AlarmScreen(),
    const CalendarScreen(),
    const AttendanceScreen(),
    const ChatScreen(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _checkFirstRun();
    });
  }

  Future<void> _checkFirstRun() async {
    if (AuthService.userRole == null) {
      await AuthService.showSetupDialog(context, () {
        setState(() {}); // Refresh to update UI if needed
      });
    } else {
      // Biometric Auth on startup
      final authenticated = await AuthService.authenticate();
      if (!authenticated) {
        // Handle auth failure (maybe close app or show error)
        // For now, we just let them in or show a snackbar
         ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Authentication Failed!")),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final box = Hive.box('user_prefs');
    final userName = box.get('user_name', defaultValue: 'Student');
    final userPhoto = box.get('user_photo');
    
    return Scaffold(
      extendBody: true, // Important for floating nav bar
        drawer: Drawer(
        backgroundColor: Colors.black.withOpacity(0.9),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
              ),
              child: const Text(
                'NovaMind OS',
                style: TextStyle(
                  color: Colors.cyanAccent,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.calculate, color: Colors.cyanAccent),
              title: const Text(
                'Calculator',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculatorScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.bedtime, color: Colors.purpleAccent),
              title: const Text(
                'Sleep Architect',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SleepScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.games, color: Colors.cyanAccent),
              title: const Text(
                'Play 2048',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context); // Close drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const Game2048Screen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.park, color: Colors.green),
              title: const Text(
                'Focus Forest',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const FocusForestScreen(),
                  ),
                );
              },
            ),

            ListTile(
              leading: const Icon(Icons.security, color: Colors.amber),
              title: const Text(
                'Cyber Library',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CyberVaultScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.code, color: Colors.green),
              title: const Text(
                'C-Coding Lab',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CodingLabScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.computer, color: Colors.cyanAccent),
              title: const Text(
                'Online Compilers',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CompilerScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.menu_book, color: Colors.amber),
              title: const Text(
                'Syllabus',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SyllabusScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.info, color: Colors.cyanAccent),
              title: const Text(
                'About Us',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const AboutScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.settings, color: Colors.grey),
              title: const Text(
                'Settings',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const SettingsScreen(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.black.withOpacity(0.7),
        elevation: 0,
        title: Text(
          userName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          // News Bell Icon with Badge
          StreamBuilder<List<Map<String, dynamic>>>(
            stream: Supabase.instance.client
                .from('news')
                .stream(primaryKey: ['id'])
                .order('created_at', ascending: false)
                .limit(10),
            builder: (context, snapshot) {
              final unreadCount = snapshot.hasData ? snapshot.data!.length : 0;
              
              return Badge(
                label: Text('$unreadCount'),
                isLabelVisible: unreadCount > 0,
                backgroundColor: Colors.red,
                child: IconButton(
                  icon: const Icon(Icons.notifications_outlined, color: Colors.cyanAccent),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const NewsScreen(),
                      ),
                    );
                  },
                ),
              );
            },
          ),
          // User Photo
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: userPhoto != null
                ? ClipOval(
                    child: Image.file(
                      File(userPhoto),
                      width: 40,
                      height: 40,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return const CircleAvatar(
                          backgroundColor: Colors.cyanAccent,
                          child: Icon(Icons.person, color: Colors.black),
                        );
                      },
                    ),
                  )
                : const CircleAvatar(
                    backgroundColor: Colors.cyanAccent,
                    child: Icon(Icons.person, color: Colors.black),
                  ),
          ),
          IconButton(
            icon: const Icon(Icons.admin_panel_settings, color: Colors.amber),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const TeacherDashboardScreen(),
                ),
              );
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Animated Background
          Container(
            decoration: AppTheme.backgroundDecoration,
          )
          .animate(onPlay: (controller) => controller.repeat(reverse: true))
          .shimmer(duration: 10.seconds, color: Colors.purple.withOpacity(0.3))
          .saturate(duration: 10.seconds, begin: 0.8, end: 1.2),

          // Content
          SafeArea(
            child: _screens[_currentIndex],
          ),

          // Glass Bottom Nav
          GlassBottomNav(
            currentIndex: _currentIndex,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
          ),
        ],
      ),
    );
  }
}
