import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import '../services/battery_service.dart';
import '../services/auth_service.dart';
import '../providers/theme_provider.dart';
import '../providers/accessibility_provider.dart';
import 'settings/main_settings_screen.dart';
import 'auth_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late Box _settingsBox;
  bool _powerSaverMode = false;
  bool _biometricLock = false;
  bool _batteryOptimizationDisabled = false;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    _settingsBox = await Hive.openBox('user_prefs');
    
    setState(() {
      _powerSaverMode = _settingsBox.get('power_saver', defaultValue: false);
      _biometricLock = _settingsBox.get('biometric_enabled', defaultValue: true);
    });
    
    // Check battery optimization status
    final batteryStatus = await BatteryService.checkBatteryOptimization();
    setState(() {
      _batteryOptimizationDisabled = batteryStatus;
    });
  }

  Future<void> _togglePowerSaver(bool value) async {
    await _settingsBox.put('power_saver', value);
    setState(() => _powerSaverMode = value);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyanAccent,
        content: Text(
          value ? 'Power Saver Mode enabled' : 'Power Saver Mode disabled',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _toggleBiometric(bool value) async {
    await _settingsBox.put('biometric_enabled', value);
    setState(() => _biometricLock = value);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: Colors.cyanAccent,
        content: Text(
          value ? 'Biometric Lock enabled' : 'Biometric Lock disabled',
          style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  Future<void> _requestBatteryOptimization() async {
    final result = await BatteryService.requestBatteryOptimization(context);
    setState(() => _batteryOptimizationDisabled = result);
  }

  Future<void> _editProfile() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final userPrefs = Hive.box('user_prefs');
      await userPrefs.put('user_photo', image.path);
      
      setState(() {});
      
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          backgroundColor: Colors.cyanAccent,
          content: Text('Profile photo updated!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: const Text('Logout', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Are you sure you want to logout?\n\nYour data will be preserved.',
          style: TextStyle(color: Colors.grey),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel', style: TextStyle(color: Colors.grey)),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Logout', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm == true) {
      // Only clear session flag, keep all user data
      final userPrefs = Hive.box('user_prefs');
      await userPrefs.put('is_logged_in', false);
      
      // Navigate to auth screen
      if (mounted) {
        Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AuthScreen()),
          (route) => false,
        );
      }
    }
  }

  Future<void> _editName() async {
    final userPrefs = Hive.box('user_prefs');
    final currentName = userPrefs.get('user_name', defaultValue: 'Student');
    
    final TextEditingController controller = TextEditingController(text: currentName);
    
    await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Name'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            labelText: 'Name',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              await userPrefs.put('user_name', controller.text);
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  backgroundColor: Colors.cyanAccent,
                  content: Text('Name updated!', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // Check if user_prefs box is open, if not return loading
    if (!Hive.isBoxOpen('user_prefs')) {
      return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          title: const Text('Settings'),
          backgroundColor: Colors.grey.shade900,
        ),
        body: const Center(
          child: CircularProgressIndicator(color: Colors.cyanAccent),
        ),
      );
    }
    
    final userPrefs = Hive.box('user_prefs');
    final userName = userPrefs.get('user_name', defaultValue: 'Student');
    final userPhoto = userPrefs.get('user_photo');
    
    return Consumer2<ThemeProvider, AccessibilityProvider>(
      builder: (context, themeProvider, accessibilityProvider, child) {
        return Container(
          decoration: themeProvider.getCurrentBackgroundDecoration(),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text('Settings'),
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            body: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // Profile Card
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        GestureDetector(
                          onTap: () {
                            accessibilityProvider.provideFeedback(text: 'Edit profile photo');
                            _editProfile();
                          },
                          child: Stack(
                            children: [
                              CircleAvatar(
                                radius: 50,
                                backgroundColor: themeProvider.getCurrentPrimaryColor(),
                                backgroundImage: userPhoto != null 
                                  ? FileImage(File(userPhoto)) 
                                  : null,
                                child: userPhoto == null 
                                  ? const Icon(Icons.person, size: 50, color: Colors.white)
                                  : null,
                              ),
                              Positioned(
                                bottom: 0,
                                right: 0,
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: themeProvider.getCurrentPrimaryColor(),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.camera_alt,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          userName,
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            accessibilityProvider.provideFeedback(text: 'Edit name');
                            _editName();
                          },
                          icon: Icon(Icons.edit, color: themeProvider.getCurrentPrimaryColor()),
                          label: Text(
                            'Edit Name',
                            style: TextStyle(color: themeProvider.getCurrentPrimaryColor()),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                
                const SizedBox(height: 24),
                
                // Enhanced Settings Button
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(Icons.palette, color: themeProvider.getCurrentPrimaryColor()),
                    title: Text(
                      'Enhanced Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Themes, Accessibility, Dashboard & More',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70),
                    onTap: () {
                      accessibilityProvider.provideFeedback(text: 'Opening enhanced settings');
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const MainSettingsScreen(),
                        ),
                      );
                    },
                  ),
                ),
                
                const SizedBox(height: 16),
                
                // Legacy Settings Section
                Text(
                  'System Settings',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                
                // Power Saver Mode
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: SwitchListTile(
                    title: Text(
                      'Power Saver Mode',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Disable animations to save battery',
                      style: TextStyle(color: Colors.white70),
                    ),
                    value: _powerSaverMode,
                    onChanged: (value) {
                      accessibilityProvider.provideFeedback(
                        text: value ? 'Power saver enabled' : 'Power saver disabled',
                      );
                      _togglePowerSaver(value);
                    },
                    activeColor: Colors.green,
                    secondary: Icon(
                      _powerSaverMode ? Icons.battery_saver : Icons.battery_full,
                      color: _powerSaverMode ? Colors.green : Colors.white70,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Battery Optimization
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(
                      _batteryOptimizationDisabled 
                        ? Icons.battery_charging_full 
                        : Icons.battery_alert,
                      color: _batteryOptimizationDisabled ? Colors.green : Colors.orange,
                    ),
                    title: Text(
                      'Allow Background Running',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    subtitle: Text(
                      _batteryOptimizationDisabled 
                        ? 'Enabled - Alarms will work reliably' 
                        : 'Disabled - May affect alarm reliability',
                      style: TextStyle(
                        color: _batteryOptimizationDisabled ? Colors.green : Colors.orange,
                      ),
                    ),
                    trailing: ElevatedButton(
                      onPressed: _batteryOptimizationDisabled 
                        ? null 
                        : () {
                            accessibilityProvider.provideFeedback(text: 'Requesting battery optimization');
                            _requestBatteryOptimization();
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                      ),
                      child: Text(_batteryOptimizationDisabled ? 'Enabled' : 'Enable'),
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // Biometric Lock
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: SwitchListTile(
                    title: Text(
                      'Biometric Lock',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Require fingerprint on startup',
                      style: TextStyle(color: Colors.white70),
                    ),
                    value: _biometricLock,
                    onChanged: (value) {
                      accessibilityProvider.provideFeedback(
                        text: value ? 'Biometric lock enabled' : 'Biometric lock disabled',
                      );
                      _toggleBiometric(value);
                    },
                    activeColor: themeProvider.getCurrentPrimaryColor(),
                    secondary: Icon(
                      Icons.fingerprint,
                      color: _biometricLock ? themeProvider.getCurrentPrimaryColor() : Colors.white70,
                    ),
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // System Settings Button
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(Icons.settings, color: themeProvider.getCurrentPrimaryColor()),
                    title: Text(
                      'System Settings',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Open Android app settings',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white70, size: 16),
                    onTap: () async {
                      accessibilityProvider.provideFeedback(text: 'Opening system settings');
                      await openAppSettings();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            backgroundColor: themeProvider.getCurrentPrimaryColor(),
                            content: const Text(
                              'Opening system settings...',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                            behavior: SnackBarBehavior.floating,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    },
                  ),
                ),
                
                const SizedBox(height: 12),
                
                // 24-Hour Format Toggle
                ValueListenableBuilder(
                  valueListenable: Hive.box('user_prefs').listenable(),
                  builder: (context, Box box, _) {
                    final use24h = box.get('use24h', defaultValue: false);
                    return Card(
                      color: Colors.white.withOpacity(0.1),
                      child: SwitchListTile(
                        title: Text(
                          'Use 24-Hour Format',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(color: Colors.white),
                        ),
                        subtitle: Text(
                          use24h ? 'Time shown as 14:30' : 'Time shown as 2:30 PM',
                          style: const TextStyle(color: Colors.white70),
                        ),
                        value: use24h,
                        onChanged: (value) async {
                          accessibilityProvider.provideFeedback(
                            text: value ? '24-hour format enabled' : '12-hour format enabled',
                          );
                          await box.put('use24h', value);
                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                backgroundColor: themeProvider.getCurrentPrimaryColor(),
                                content: Text(
                                  value ? '24-hour format enabled' : '12-hour format enabled',
                                  style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        activeColor: themeProvider.getCurrentPrimaryColor(),
                        secondary: Icon(
                          Icons.access_time,
                          color: use24h ? themeProvider.getCurrentPrimaryColor() : Colors.white70,
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 32),
                
                // Logout Button
                Card(
                  color: Colors.red.withOpacity(0.2),
                  child: ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: Text(
                      'Logout',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    subtitle: const Text(
                      'Sign out of your account',
                      style: TextStyle(color: Colors.white70),
                    ),
                    trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
                    onTap: () {
                      accessibilityProvider.provideFeedback(text: 'Logout');
                      _logout();
                    },
                  ),
                ),
                
                const SizedBox(height: 32),
                
                // App Info
                Text(
                  'About',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 16),
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(Icons.info_outline, color: themeProvider.getCurrentPrimaryColor()),
                    title: const Text(
                      'Version',
                      style: TextStyle(color: Colors.white),
                    ),
                    trailing: const Text(
                      '1.0.0',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                  ),
                ),
                
                Card(
                  color: Colors.white.withOpacity(0.1),
                  child: ListTile(
                    leading: Icon(Icons.code, color: themeProvider.getCurrentPrimaryColor()),
                    title: const Text(
                      'FluxFlow - Ultimate Student OS',
                      style: TextStyle(color: Colors.white),
                    ),
                    subtitle: const Text(
                      'Developed by Masthan Valli',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
