import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:provider/provider.dart';
import 'dart:io';
import '../theme/app_theme.dart';
import '../providers/theme_provider.dart';
import '../providers/accessibility_provider.dart';
import '../widgets/glass_bottom_nav.dart';
import '../widgets/accessibility_wrapper.dart';
import '../modules/calculator/calculator_screen.dart';
import '../modules/alarm/alarm_screen.dart';
import '../modules/games/game_2048_screen.dart';
import '../modules/games/tictactoe_screen.dart';
import '../modules/games/memory_game_screen.dart';
import '../modules/games/snake_game_screen.dart';
import '../modules/games/puzzle_slider_screen.dart';
import '../modules/games/simon_says_screen.dart';
import '../modules/focus/focus_forest_screen.dart';
import '../modules/sleep/sleep_screen.dart';
import '../modules/cyber/cyber_vault_screen.dart';
import '../modules/coding/coding_lab_screen.dart';
import '../modules/coding/compiler_screen.dart';
import '../modules/coding/leetcode_screen.dart';
import '../modules/news/news_screen.dart';
import '../modules/academic/syllabus_screen.dart';
import '../modules/academic/books_notes_screen.dart';
import '../modules/roadmaps/roadmaps_screen.dart';
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
    
    return Consumer2<ThemeProvider, AccessibilityProvider>(
      builder: (context, themeProvider, accessibilityProvider, child) {
        return Scaffold(
          extendBody: true, // Important for floating nav bar
          drawer: Drawer(
        backgroundColor: Colors.black.withOpacity(0.9),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: themeProvider.getCurrentGradientColors().take(2).toList(),
                ),
              ),
              child: AccessibilityWrapper(
                semanticLabel: 'FluxFlow app drawer header',
                child: Text(
                  'FluxFlow OS',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    fontFamily: themeProvider.fontFamily,
                  ),
                ),
              ),
            ),
            AccessibilityWrapper(
              semanticLabel: 'Calculator app',
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const CalculatorScreen(),
                  ),
                );
              },
              child: ListTile(
                leading: Icon(Icons.calculate, color: themeProvider.getCurrentPrimaryColor()),
                title: Text(
                  'Calculator',
                  style: TextStyle(
                    color: Colors.white, 
                    fontSize: themeProvider.fontSize,
                    fontFamily: themeProvider.fontFamily,
                  ),
                ),
                onTap: () {
                  accessibilityProvider.provideFeedback(text: 'Opening Calculator');
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CalculatorScreen(),
                    ),
                  );
                },
              ),
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
            // Games Section
            ExpansionTile(
              leading: const Icon(Icons.games, color: Colors.cyanAccent),
              title: const Text(
                'Games Arcade',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              iconColor: Colors.cyanAccent,
              collapsedIconColor: Colors.grey,
              children: [
                ListTile(
                  leading: const Icon(Icons.grid_4x4, color: Colors.amber),
                  title: const Text(
                    '2048',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const Game2048Screen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.close, color: Colors.cyanAccent),
                  title: const Text(
                    'Tic-Tac-Toe',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const TicTacToeScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.psychology, color: Colors.purple),
                  title: const Text(
                    'Memory Match',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const MemoryGameScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.pets, color: Colors.green),
                  title: const Text(
                    'Snake Game',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SnakeGameScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.grid_4x4, color: Colors.orange),
                  title: const Text(
                    'Puzzle Slider',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const PuzzleSliderScreen(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.psychology_alt, color: Colors.pink),
                  title: const Text(
                    'Simon Says',
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SimonSaysScreen(),
                      ),
                    );
                  },
                ),
              ],
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
              leading: const Icon(Icons.code_off, color: Colors.orange),
              title: const Text(
                'LeetCode Problems',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LeetCodeScreen(),
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
              leading: const Icon(Icons.map, color: Colors.blue),
              title: const Text(
                'Tech Roadmaps',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const RoadmapsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.chat_bubble, color: Colors.purple),
              title: const Text(
                'Community Chat',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ChatScreen(),
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
              // Enhanced Animated Background
              Container(
                decoration: themeProvider.getCurrentBackgroundDecoration(),
              )
              .animate(onPlay: (controller) => controller.repeat(reverse: true))
              .shimmer(
                duration: accessibilityProvider.getAnimationDuration(const Duration(seconds: 10)),
                color: themeProvider.getCurrentPrimaryColor().withOpacity(0.3),
              )
              .saturate(
                duration: accessibilityProvider.getAnimationDuration(const Duration(seconds: 10)),
                begin: 0.8, 
                end: 1.2,
              ),

              // Content
              SafeArea(
                bottom: false, // We'll handle bottom padding manually
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 110), // Space for floating nav
                  child: _screens[_currentIndex],
                ),
              ),

              // Glass Bottom Nav - Positioned at bottom
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: GlassBottomNav(
                  currentIndex: _currentIndex,
                  onTap: (index) {
                    accessibilityProvider.provideFeedback(
                      text: 'Switched to ${_getScreenName(index)}',
                    );
                    setState(() {
                      _currentIndex = index;
                    });
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _getScreenName(int index) {
    switch (index) {
      case 0: return 'Timetable';
      case 1: return 'Alarm';
      case 2: return 'Calendar';
      case 3: return 'Attendance';
      case 4: return 'Chat';
      default: return 'Screen';
    }
  }
}
