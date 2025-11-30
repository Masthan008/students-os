import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import '../services/battery_service.dart';
import '../services/auth_service.dart';
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
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Colors.grey.shade900,
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.grey.shade900,
              Colors.black,
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            // Profile Card
            Card(
              color: Colors.grey.shade900,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    GestureDetector(
                      onTap: _editProfile,
                      child: Stack(
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundColor: Colors.cyanAccent,
                            backgroundImage: userPhoto != null 
                              ? FileImage(File(userPhoto)) 
                              : null,
                            child: userPhoto == null 
                              ? const Icon(Icons.person, size: 50, color: Colors.black)
                              : null,
                          ),
                          Positioned(
                            bottom: 0,
                            right: 0,
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.cyanAccent,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.camera_alt,
                                size: 20,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      userName,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _editName,
                      icon: const Icon(Icons.edit, color: Colors.cyanAccent),
                      label: const Text(
                        'Edit Name',
                        style: TextStyle(color: Colors.cyanAccent),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Settings Section
            const Text(
              'App Settings',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 16),
            
            // Power Saver Mode
            Card(
              color: Colors.grey.shade900,
              child: SwitchListTile(
                title: const Text(
                  'Power Saver Mode',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: const Text(
                  'Disable animations to save battery',
                  style: TextStyle(color: Colors.grey),
                ),
                value: _powerSaverMode,
                onChanged: _togglePowerSaver,
                activeColor: Colors.green,
                secondary: Icon(
                  _powerSaverMode ? Icons.battery_saver : Icons.battery_full,
                  color: _powerSaverMode ? Colors.green : Colors.grey,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // Battery Optimization
            Card(
              color: Colors.grey.shade900,
              child: ListTile(
                leading: Icon(
                  _batteryOptimizationDisabled 
                    ? Icons.battery_charging_full 
                    : Icons.battery_alert,
                  color: _batteryOptimizationDisabled ? Colors.green : Colors.orange,
                ),
                title: const Text(
                  'Allow Background Running',
                  style: TextStyle(color: Colors.white, fontSize: 16),
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
                    : _requestBatteryOptimization,
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
              color: Colors.grey.shade900,
              child: SwitchListTile(
                title: const Text(
                  'Biometric Lock',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: const Text(
                  'Require fingerprint on startup',
                  style: TextStyle(color: Colors.grey),
                ),
                value: _biometricLock,
                onChanged: _toggleBiometric,
                activeColor: Colors.cyanAccent,
                secondary: Icon(
                  Icons.fingerprint,
                  color: _biometricLock ? Colors.cyanAccent : Colors.grey,
                ),
              ),
            ),
            
            const SizedBox(height: 12),
            
            // System Settings Button
            Card(
              color: Colors.grey.shade900,
              child: ListTile(
                leading: const Icon(Icons.settings, color: Colors.cyanAccent),
                title: const Text(
                  'System Settings',
                  style: TextStyle(color: Colors.white, fontSize: 16),
                ),
                subtitle: const Text(
                  'Open Android app settings',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.grey, size: 16),
                onTap: () async {
                  await openAppSettings();
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      backgroundColor: Colors.cyanAccent,
                      content: Text(
                        'Opening system settings...',
                        style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                      ),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 2),
                    ),
                  );
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
                  color: Colors.grey.shade900,
                  child: SwitchListTile(
                    title: const Text(
                      'Use 24-Hour Format',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                    subtitle: Text(
                      use24h ? 'Time shown as 14:30' : 'Time shown as 2:30 PM',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    value: use24h,
                    onChanged: (value) async {
                      await box.put('use24h', value);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          backgroundColor: Colors.cyanAccent,
                          content: Text(
                            value ? '24-hour format enabled' : '12-hour format enabled',
                            style: const TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    activeColor: Colors.cyanAccent,
                    secondary: Icon(
                      Icons.access_time,
                      color: use24h ? Colors.cyanAccent : Colors.grey,
                    ),
                  ),
                );
              },
            ),
            
            const SizedBox(height: 32),
            
            // Logout Button
            Card(
              color: Colors.red.shade900.withOpacity(0.3),
              child: ListTile(
                leading: const Icon(Icons.logout, color: Colors.red),
                title: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.red, fontSize: 16, fontWeight: FontWeight.bold),
                ),
                subtitle: const Text(
                  'Sign out of your account',
                  style: TextStyle(color: Colors.grey),
                ),
                trailing: const Icon(Icons.arrow_forward_ios, color: Colors.red, size: 16),
                onTap: _logout,
              ),
            ),
            
            const SizedBox(height: 32),
            
            // App Info
            const Text(
              'About',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Colors.cyanAccent,
              ),
            ),
            const SizedBox(height: 16),
            Card(
              color: Colors.grey.shade900,
              child: const ListTile(
                leading: Icon(Icons.info_outline, color: Colors.cyanAccent),
                title: Text(
                  'Version',
                  style: TextStyle(color: Colors.white),
                ),
                trailing: Text(
                  '1.0.0',
                  style: TextStyle(color: Colors.grey, fontSize: 16),
                ),
              ),
            ),
            
            Card(
              color: Colors.grey.shade900,
              child: const ListTile(
                leading: Icon(Icons.code, color: Colors.cyanAccent),
                title: Text(
                  'NovaMind - Ultimate Student OS',
                  style: TextStyle(color: Colors.white),
                ),
                subtitle: Text(
                  'Developed by Masthan Valli',
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
