import 'dart:async';
import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

enum TreeStatus { none, seed, sprout, tree, dead }

class FocusProvider extends ChangeNotifier with WidgetsBindingObserver {
  bool _isFocusing = false;
  int _timeLeft = 0;
  final int _sessionDuration = 25 * 60; // 25 minutes
  TreeStatus _treeStatus = TreeStatus.none;
  Timer? _timer;
  int _forestCount = 0;

  bool get isFocusing => _isFocusing;
  int get timeLeft => _timeLeft;
  TreeStatus get treeStatus => _treeStatus;
  int get forestCount => _forestCount;
  int get sessionDuration => _sessionDuration;

  FocusProvider() {
    _loadForestCount();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _timer?.cancel();
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

  void startFocus() {
    if (_isFocusing) return;

    _isFocusing = true;
    _timeLeft = _sessionDuration;
    _treeStatus = TreeStatus.seed;
    notifyListeners();

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

  void _killTree() {
    _timer?.cancel();
    _isFocusing = false;
    _timeLeft = 0;
    _treeStatus = TreeStatus.dead;
    notifyListeners();
    
    debugPrint('🔴 Focus killed: User left the app');
  }

  Future<void> _completeSession() async {
    _timer?.cancel();
    _isFocusing = false;
    _treeStatus = TreeStatus.tree;
    
    // Save to forest
    final box = await Hive.openBox('user_forest');
    final currentCount = box.get('tree_count', defaultValue: 0);
    await box.put('tree_count', currentCount + 1);
    
    _forestCount = currentCount + 1;
    notifyListeners();
    
    debugPrint('✅ Focus completed! Total trees: $_forestCount');
    
    // TODO: Send notification via NotificationService
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
