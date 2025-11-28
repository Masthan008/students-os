import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:audioplayers/audioplayers.dart';

enum TreeStatus { none, seed, sprout, tree, dead }

class FocusProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool _isFocusing = false;
  int _timeLeft = 0;
  int _sessionDuration = 25 * 60; // 25 minutes (customizable)
  TreeStatus _treeStatus = TreeStatus.none;
  Timer? _timer;
  int _forestCount = 0;
  String _ambientSound = 'Silence';
  final AudioPlayer _audioPlayer = AudioPlayer();

  bool get isFocusing => _isFocusing;
  int get timeLeft => _timeLeft;
  TreeStatus get treeStatus => _treeStatus;
  int get forestCount => _forestCount;
  int get sessionDuration => _sessionDuration;
  String get ambientSound => _ambientSound;

  void setSessionDuration(int minutes) {
    _sessionDuration = minutes * 60;
    notifyListeners();
  }

  void setAmbientSound(String sound) {
    _ambientSound = sound;
    notifyListeners();
  }

  FocusProvider() {
    _loadForestCount();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    
    // THE KILL SWITCH: If user leaves app while focusing, kill the tree
    if (state == AppLifecycleState.paused && _isFocusing) {
      _killTree();
    }
  }

  Future<void> _loadForestCount() async {
    final box = await Hive.openBox('user_forest');
    _forestCount = box.get('tree_count', defaultValue: 0);
    notifyListeners();
  }

  Future<void> startFocus() async {
    if (_isFocusing) return;

    _isFocusing = true;
    _timeLeft = _sessionDuration;
    _treeStatus = TreeStatus.seed;
    notifyListeners();

    // Start ambient sound
    await _playAmbientSound();

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
        _updateTreeStatus();
        notifyListeners();
      } else {
        _completeSession();
      }
    });
  }

  Future<void> _playAmbientSound() async {
    if (_ambientSound == 'Silence') return;

    try {
      // Map sound names to asset paths
      final soundMap = {
        'Rain': 'sounds/rain.mp3',
        'Fire': 'sounds/fire.mp3',
        'Night': 'sounds/night.mp3',
        'Library': 'sounds/library.mp3',
      };

      final assetPath = soundMap[_ambientSound];
      if (assetPath != null) {
        await _audioPlayer.setReleaseMode(ReleaseMode.loop);
        await _audioPlayer.play(AssetSource(assetPath));
      }
    } catch (e) {
      debugPrint('⚠️ Could not play ambient sound: $e');
    }
  }

  Future<void> _stopAmbientSound() async {
    try {
      await _audioPlayer.stop();
    } catch (e) {
      debugPrint('⚠️ Could not stop ambient sound: $e');
    }
  }

  void _updateTreeStatus() {
    if (!_isFocusing) return;
    
    final progress = 1 - (_timeLeft / _sessionDuration);
    
    if (progress < 0.33) {
      _treeStatus = TreeStatus.seed;
    } else if (progress < 0.66) {
      _treeStatus = TreeStatus.sprout;
    } else {
      _treeStatus = TreeStatus.tree;
    }
  }

  Future<void> _killTree() async {
    _timer?.cancel();
    await _stopAmbientSound();
    
    // Save dead tree to history
    final minutesStudied = (_sessionDuration - _timeLeft) ~/ 60;
    await _saveToHistory(minutesStudied, 'dead');
    
    _isFocusing = false;
    _timeLeft = 0;
    _treeStatus = TreeStatus.dead;
    notifyListeners();
    
    debugPrint('🔴 Focus killed: User left the app');
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    await _stopAmbientSound();
    
    _isFocusing = false;
    _treeStatus = TreeStatus.tree;
    
    // Save to forest
    final box = await Hive.openBox('user_forest');
    final currentCount = box.get('tree_count', defaultValue: 0);
    await box.put('tree_count', currentCount + 1);
    
    _forestCount = currentCount + 1;
    
    // Save to history
    final minutesStudied = _sessionDuration ~/ 60;
    await _saveToHistory(minutesStudied, 'alive');
    
    notifyListeners();
    
    debugPrint('✅ Focus completed! Total trees: $_forestCount');
  }

  Future<void> _saveToHistory(int minutes, String status) async {
    try {
      final box = await Hive.openBox('forest_history');
      final history = box.get('trees', defaultValue: <Map<String, dynamic>>[]) as List;
      
      history.add({
        'date': DateTime.now().toIso8601String(),
        'minutes': minutes,
        'status': status,
      });
      
      await box.put('trees', history);
      debugPrint('💾 Saved to history: $minutes min, $status');
    } catch (e) {
      debugPrint('⚠️ Could not save to history: $e');
    }
  }

  Future<List<Map<String, dynamic>>> getHistory() async {
    try {
      final box = await Hive.openBox('forest_history');
      final history = box.get('trees', defaultValue: <Map<String, dynamic>>[]) as List;
      return history.cast<Map<String, dynamic>>();
    } catch (e) {
      debugPrint('⚠️ Could not load history: $e');
      return [];
    }
  }

  int getTotalFocusHours() {
    // This will be calculated from history in the UI
    return 0;
  }

  void resetTree() {
    _treeStatus = TreeStatus.none;
    _timeLeft = 0;
    notifyListeners();
  }

  String formatTime() {
    final minutes = _timeLeft ~/ 60;
    final seconds = _timeLeft % 60;
    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  IconData getTreeIcon() {
    switch (_treeStatus) {
      case TreeStatus.seed:
        return Icons.grass;
      case TreeStatus.sprout:
        return Icons.local_florist;
      case TreeStatus.tree:
        return Icons.park;
      case TreeStatus.dead:
        return Icons.dangerous;
      case TreeStatus.none:
        return Icons.eco_outlined;
    }
  }

  // Get tree icon based on minutes studied
  static IconData getTreeIconByMinutes(int minutes) {
    if (minutes < 15) {
      return Icons.grass; // Grass
    } else if (minutes < 30) {
      return Icons.local_florist; // Flower
    } else if (minutes < 60) {
      return Icons.park; // Pine Tree
    } else {
      return Icons.forest; // Oak Forest
    }
  }

  // Get tree color based on minutes
  static Color getTreeColorByMinutes(int minutes) {
    if (minutes < 15) {
      return Colors.brown;
    } else if (minutes < 30) {
      return Colors.lightGreen;
    } else if (minutes < 60) {
      return Colors.green;
    } else {
      return Colors.green.shade900;
    }
  }

  Color getTreeColor() {
    switch (_treeStatus) {
      case TreeStatus.seed:
        return Colors.brown;
      case TreeStatus.sprout:
        return Colors.lightGreen;
      case TreeStatus.tree:
        return Colors.green;
      case TreeStatus.dead:
        return Colors.red;
      case TreeStatus.none:
        return Colors.grey;
    }
  }
}
