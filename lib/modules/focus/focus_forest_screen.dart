import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/focus_provider.dart';

class FocusForestScreen extends StatefulWidget {
  const FocusForestScreen({super.key});

  @override
  State<FocusForestScreen> createState() => _FocusForestScreenState();
}

class _FocusForestScreenState extends State<FocusForestScreen> {
  @override
  void initState() {
    super.initState();
    // Listen for tree death to show dialog
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<FocusProvider>(context, listen: false);
      if (provider.treeStatus == TreeStatus.dead) {
        _showDeadDialog();
        provider.resetTree();
      }
    });
  }

  void _showDeadDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.dangerous, color: Colors.red, size: 32),
            SizedBox(width: 10),
            Text('Tree Died!'),
          ],
        ),
        content: const Text(
          'You left the app! The tree couldn\'t survive without your focus. Stay focused next time!',
          style: TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Try Again'),
          ),
        ],
      ),
    );
  }

  void _showSuccessDialog(int forestCount) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Row(
          children: [
            Icon(Icons.park, color: Colors.green, size: 32),
            SizedBox(width: 10),
            Text('Success!'),
          ],
        ),
        content: Text(
          'Congratulations! You stayed focused for 25 minutes.\n\nTrees planted: $forestCount 🌲',
          style: const TextStyle(fontSize: 16),
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(backgroundColor: Colors.green),
            child: const Text('Plant Another'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<FocusProvider>(
      builder: (context, focusProvider, child) {
        // Show success dialog when timer completes
        if (focusProvider.timeLeft == 0 && 
            !focusProvider.isFocusing && 
            focusProvider.treeStatus == TreeStatus.tree) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            _showSuccessDialog(focusProvider.forestCount);
            focusProvider.resetTree();
          });
        }

        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            title: const Text('Focus Forest'),
            backgroundColor: Colors.green.shade900,
            actions: [
              Padding(
                padding: const EdgeInsets.all(12.0),
                child: Row(
                  children: [
                    const Icon(Icons.park, color: Colors.greenAccent),
                    const SizedBox(width: 5),
                    Text(
                      '${focusProvider.forestCount}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.greenAccent,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          body: SafeArea(
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.green.shade900,
                    Colors.black,
                  ],
                ),
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Tree Icon
                    Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white.withOpacity(0.1),
                        border: Border.all(
                          color: focusProvider.getTreeColor(),
                          width: 4,
                        ),
                      ),
                      child: Icon(
                        focusProvider.getTreeIcon(),
                        size: 120,
                        color: focusProvider.getTreeColor(),
                      ),
                    )
                    .animate(
                      onPlay: (controller) => focusProvider.isFocusing ? controller.repeat() : null,
                    )
                    .shimmer(
                      duration: 2.seconds,
                      color: Colors.white.withOpacity(0.3),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Timer Display
                    Text(
                      focusProvider.isFocusing 
                        ? focusProvider.formatTime() 
                        : '25:00',
                      style: TextStyle(
                        fontSize: 72,
                        fontWeight: FontWeight.bold,
                        color: focusProvider.isFocusing ? Colors.greenAccent : Colors.grey,
                        letterSpacing: 4,
                      ),
                    ),
                    
                    const SizedBox(height: 20),
                    
                    // Status Text
                    Text(
                      focusProvider.isFocusing
                          ? 'Stay focused! Don\'t leave the app.'
                          : 'Ready to focus?',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.grey.shade400,
                      ),
                    ),
                    
                    const SizedBox(height: 60),
                    
                    // Action Button
                    ElevatedButton(
                      onPressed: focusProvider.isFocusing ? null : () => focusProvider.startFocus(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        disabledBackgroundColor: Colors.grey.shade800,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 60,
                          vertical: 20,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            focusProvider.isFocusing ? Icons.hourglass_bottom : Icons.eco,
                            size: 28,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            focusProvider.isFocusing ? 'Focusing...' : 'Plant Seed',
                            style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 40),
                    
                    // Warning
                    if (focusProvider.isFocusing)
                      Container(
                        padding: const EdgeInsets.all(16),
                        margin: const EdgeInsets.symmetric(horizontal: 40),
                        decoration: BoxDecoration(
                          color: Colors.orange.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.orange),
                        ),
                        child: const Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.warning_amber, color: Colors.orange),
                            SizedBox(width: 10),
                            Flexible(
                              child: Text(
                                'Leaving the app will kill your tree!',
                                style: TextStyle(
                                  color: Colors.orange,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
