import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(
          'About',
          style: GoogleFonts.orbitron(
            fontWeight: FontWeight.bold,
            color: Colors.cyanAccent,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // --- HEADER ---
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.cyanAccent.withOpacity(0.3),
                    Colors.blueAccent.withOpacity(0.3),
                  ],
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.cyanAccent.withOpacity(0.3),
                    blurRadius: 30,
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: const Icon(
                Icons.psychology,
                size: 80,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'NovaMind OS',
              style: GoogleFonts.orbitron(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.white,
                letterSpacing: 2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'v1.0.0 (Stable Release)',
              style: GoogleFonts.firaCode(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'The Ultimate Student Operating System',
              style: GoogleFonts.montserrat(
                fontSize: 12,
                color: Colors.grey.shade600,
                fontStyle: FontStyle.italic,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 40),

            // --- FEATURES SECTION ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.cyanAccent.withOpacity(0.3),
                  width: 2,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.widgets,
                        color: Colors.cyanAccent,
                        size: 24,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        'SYSTEM MODULES',
                        style: GoogleFonts.orbitron(
                          color: Colors.cyanAccent,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  _buildFeature(
                    'Smart Attendance',
                    'Geo-Fencing & Face Verification',
                    Icons.fingerprint,
                  ),
                  _buildFeature(
                    'Student Hub',
                    'Real-Time Global Classroom Chat',
                    Icons.chat_bubble,
                  ),
                  _buildFeature(
                    'C-Coding Lab',
                    'Cloud-Synced Patterns & Compiler',
                    Icons.code,
                  ),
                  _buildFeature(
                    'Books & Notes',
                    'Organize Study Materials & Quick Notes',
                    Icons.library_books,
                  ),
                  _buildFeature(
                    'Cyber Vault',
                    'Ethical Hacking Resource Library',
                    Icons.security,
                  ),
                  _buildFeature(
                    'Focus Forest',
                    'Gamified Productivity Timer',
                    Icons.park,
                  ),
                  _buildFeature(
                    'Sleep Architect',
                    'Circadian Rhythm Calculator',
                    Icons.bedtime,
                  ),
                  _buildFeature(
                    'Campus News',
                    'Live Notice Board & Announcements',
                    Icons.notifications_active,
                  ),
                  _buildFeature(
                    'Scientific Calculator',
                    'Advanced Math Functions',
                    Icons.calculate,
                  ),
                  _buildFeature(
                    'Smart Alarms',
                    'Never Miss a Class',
                    Icons.alarm,
                  ),
                  _buildFeature(
                    'Games Arcade',
                    '6 Games with 20-min Time Limit: 2048, Tic-Tac-Toe, Memory, Snake, Puzzle, Simon',
                    Icons.games,
                  ),
                  _buildFeature(
                    'Enhanced Calendar',
                    'Persistent Reminders with Categories',
                    Icons.calendar_today,
                  ),
                  _buildFeature(
                    'Optimized Performance',
                    'Faster Load Times & Bug Fixes',
                    Icons.speed,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 30),

            // --- TEAM CREDITS (GOLDEN CARD) ---
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.amber.shade900.withOpacity(0.3),
                    Colors.orange.shade900.withOpacity(0.3),
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: Colors.amber,
                  width: 2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.amber.withOpacity(0.3),
                    blurRadius: 20,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.stars,
                    color: Colors.amber,
                    size: 40,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'SPECIAL THANKS',
                    style: GoogleFonts.orbitron(
                      color: Colors.amber,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 2,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'To my Co-Developers for their immense contribution to logic, testing, and feature development:',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.white70,
                      fontSize: 13,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 24),
                  _buildTeamMember('AKHIL', Icons.code),
                  const SizedBox(height: 12),
                  _buildTeamMember('NADIR', Icons.code),
                  const SizedBox(height: 12),
                  _buildTeamMember('MOUNIKA', Icons.code),
                  const SizedBox(height: 16),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      '🚀 Core Development Team',
                      style: GoogleFonts.montserrat(
                        color: Colors.amber,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- INSTITUTION ---
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade900.withOpacity(0.5),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white10,
                ),
              ),
              child: Column(
                children: [
                  const Icon(
                    Icons.school,
                    color: Colors.cyanAccent,
                    size: 30,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'RGMCET',
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    'Rajiv Gandhi Memorial College of Engineering & Technology',
                    textAlign: TextAlign.center,
                    style: GoogleFonts.montserrat(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),

            // --- SIGNATURE ---
            Column(
              children: [
                Text(
                  'Designed & Developed by',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey,
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Masthan Valli',
                  style: GoogleFonts.greatVibes(
                    fontSize: 36,
                    color: Colors.cyanAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Lead Developer & Architect',
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade600,
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 30),

            // --- FOOTER ---
            Text(
              '© 2024 NovaMind OS',
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade700,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Made with ❤️ for Students',
              style: GoogleFonts.montserrat(
                color: Colors.grey.shade700,
                fontSize: 10,
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildFeature(String title, String subtitle, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.greenAccent.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              icon,
              color: Colors.greenAccent,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.montserrat(
                    color: Colors.grey.shade400,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String name, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.amber.withOpacity(0.3),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            icon,
            color: Colors.amber,
            size: 20,
          ),
          const SizedBox(width: 12),
          Text(
            name,
            style: GoogleFonts.orbitron(
              fontSize: 18,
              color: Colors.white,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
            ),
          ),
        ],
      ),
    );
  }
}
