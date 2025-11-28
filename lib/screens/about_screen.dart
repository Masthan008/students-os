import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'About NovaMind',
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo/Icon
            Center(
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Colors.cyanAccent, Colors.blueAccent],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.cyanAccent.withOpacity(0.5),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.school,
                  size: 60,
                  color: Colors.black,
                ),
              ),
            ),
            const SizedBox(height: 30),
            
            // App Name & Version
            Center(
              child: Column(
                children: [
                  Text(
                    'NovaMind OS',
                    style: GoogleFonts.orbitron(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: Colors.cyanAccent,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Version 1.0',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 40),
            
            // Developer Info
            _buildInfoCard(
              icon: Icons.person,
              title: 'Developer',
              content: 'Masthan Valli',
            ),
            const SizedBox(height: 20),
            
            // Features Section
            _buildSectionTitle('Features'),
            const SizedBox(height: 12),
            _buildFeatureItem(Icons.calendar_today, 'Smart Timetable', 'Manage your class schedule'),
            _buildFeatureItem(Icons.fingerprint, 'GPS Attendance', 'Location-based check-in'),
            _buildFeatureItem(Icons.security, 'Cyber Vault', 'Secure password manager'),
            _buildFeatureItem(Icons.code, 'Code Lab', 'C programming patterns & compiler'),
            _buildFeatureItem(Icons.calculate, 'Calculator', 'Advanced scientific calculator'),
            _buildFeatureItem(Icons.alarm, 'Smart Alarm', 'Never miss a class'),
            _buildFeatureItem(Icons.games, '2048 Game', 'Brain training puzzle'),
            _buildFeatureItem(Icons.park, 'Focus Forest', 'Pomodoro timer with gamification'),
            _buildFeatureItem(Icons.bedtime, 'Sleep Architect', 'Optimize your sleep schedule'),
            _buildFeatureItem(Icons.chat, 'Hub Chatroom', 'Real-time student communication'),
            _buildFeatureItem(Icons.notifications, 'News Feed', 'Stay updated with announcements'),
            
            const SizedBox(height: 30),
            
            // Description
            _buildSectionTitle('About'),
            const SizedBox(height: 12),
            Text(
              'NovaMind is the ultimate student operating system designed specifically for RGMCET students. '
              'It combines productivity tools, academic management, and entertainment features into one seamless experience.',
              style: GoogleFonts.montserrat(
                fontSize: 14,
                color: Colors.grey.shade300,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 30),
            
            // Footer
            Center(
              child: Text(
                '© 2024 NovaMind OS\nMade with ❤️ for Students',
                textAlign: TextAlign.center,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required IconData icon,
    required String title,
    required String content,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 30),
          const SizedBox(width: 16),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
              Text(
                content,
                style: GoogleFonts.montserrat(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: GoogleFonts.orbitron(
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Colors.cyanAccent,
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String title, String description) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: Colors.cyanAccent, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.montserrat(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  description,
                  style: GoogleFonts.montserrat(
                    fontSize: 12,
                    color: Colors.grey.shade400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
