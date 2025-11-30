import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:async';
import 'dart:math';
import '../../services/game_time_service.dart';

class SimonSaysScreen extends StatefulWidget {
  const SimonSaysScreen({super.key});

  @override
  State<SimonSaysScreen> createState() => _SimonSaysScreenState();
}

class _SimonSaysScreenState extends State<SimonSaysScreen> {
  static const String gameName = 'simon_says';
  List<int> sequence = [];
  List<int> playerSequence = [];
  int currentLevel = 1;
  bool isPlaying = false;
  bool isPlayerTurn = false;
  int highlightedButton = -1;
  int highScore = 0;

  final List<Color> buttonColors = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.yellow,
  ];

  @override
  void initState() {
    super.initState();
    _checkGameAccess();
  }

  Future<void> _checkGameAccess() async {
    final canPlay = await GameTimeService.canPlayGame(gameName);
    if (!canPlay) {
      final status = await GameTimeService.getGameStatus(gameName);
      if (mounted) {
        _showCooldownDialog(status['cooldownRemainingMinutes']);
      }
    } else {
      await GameTimeService.startGameSession(gameName);
    }
  }

  void _showCooldownDialog(int minutes) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('⏰ Game Time Limit', style: TextStyle(color: Colors.orange)),
        content: Text(
          'You have played for 20 minutes today!\n\nCome back in ${GameTimeService.getTimeRemainingMessage(minutes)} to play again.',
          style: const TextStyle(color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              Navigator.pop(context);
            },
            child: const Text('OK', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    GameTimeService.endGameSession(gameName);
    super.dispose();
  }

  void _startGame() {
    setState(() {
      sequence = [];
      playerSequence = [];
      currentLevel = 1;
      isPlaying = true;
    });
    _nextRound();
  }

  void _nextRound() {
    setState(() {
      playerSequence = [];
      isPlayerTurn = false;
    });

    final random = Random();
    sequence.add(random.nextInt(4));

    _playSequence();
  }

  Future<void> _playSequence() async {
    await Future.delayed(const Duration(milliseconds: 500));

    for (int i = 0; i < sequence.length; i++) {
      await _highlightButton(sequence[i]);
      await Future.delayed(const Duration(milliseconds: 200));
    }

    setState(() {
      isPlayerTurn = true;
    });
  }

  Future<void> _highlightButton(int index) async {
    setState(() {
      highlightedButton = index;
    });

    await Future.delayed(const Duration(milliseconds: 400));

    setState(() {
      highlightedButton = -1;
    });
  }

  void _onButtonPressed(int index) async {
    if (!isPlayerTurn || !isPlaying) return;

    playerSequence.add(index);
    await _highlightButton(index);

    if (playerSequence.length == sequence.length) {
      if (_checkSequence()) {
        setState(() {
          currentLevel++;
          if (currentLevel > highScore) {
            highScore = currentLevel;
          }
        });
        await Future.delayed(const Duration(milliseconds: 500));
        _nextRound();
      } else {
        _gameOver();
      }
    } else {
      if (playerSequence[playerSequence.length - 1] != sequence[playerSequence.length - 1]) {
        _gameOver();
      }
    }
  }

  bool _checkSequence() {
    for (int i = 0; i < playerSequence.length; i++) {
      if (playerSequence[i] != sequence[i]) {
        return false;
      }
    }
    return true;
  }

  void _gameOver() {
    setState(() {
      isPlaying = false;
      isPlayerTurn = false;
    });

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('Game Over!', style: TextStyle(color: Colors.redAccent)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Level Reached: $currentLevel',
              style: const TextStyle(color: Colors.white, fontSize: 20),
            ),
            const SizedBox(height: 8),
            Text(
              'High Score: $highScore',
              style: const TextStyle(color: Colors.cyanAccent, fontSize: 16),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _startGame();
            },
            child: const Text('Play Again', style: TextStyle(color: Colors.cyanAccent)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0f0f1e),
      appBar: AppBar(
        backgroundColor: Colors.grey.shade900,
        title: Text(
          'Simon Says',
          style: GoogleFonts.orbitron(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          _buildScoreBoard(),
          const Spacer(),
          _buildGameContent(),
          const Spacer(),
        ],
      ),
    );
  }

  Widget _buildScoreBoard() {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Column(
            children: [
              Text(
                'Level',
                style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12),
              ),
              Text(
                '$currentLevel',
                style: GoogleFonts.orbitron(
                  color: Colors.cyanAccent,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Column(
            children: [
              Text(
                'High Score',
                style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12),
              ),
              Text(
                '$highScore',
                style: GoogleFonts.orbitron(
                  color: Colors.orange,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGameContent() {
    if (!isPlaying) {
      return _buildStartScreen();
    } else {
      return _buildPlayingScreen();
    }
  }

  Widget _buildStartScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.psychology, size: 80, color: Colors.cyanAccent),
          const SizedBox(height: 20),
          Text(
            'Simon Says',
            style: GoogleFonts.orbitron(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'Remember the sequence!',
            style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 40),
          ElevatedButton(
            onPressed: _startGame,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
            ),
            child: Text(
              'START GAME',
              style: GoogleFonts.orbitron(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlayingScreen() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            isPlayerTurn ? 'Your turn!' : 'Watch the sequence...',
            style: GoogleFonts.montserrat(
              color: isPlayerTurn ? Colors.green : Colors.orange,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 40),
          SizedBox(
            width: 300,
            height: 300,
            child: GridView.builder(
              physics: const NeverScrollableScrollPhysics(),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
              ),
              itemCount: 4,
              itemBuilder: (context, index) {
                final isHighlighted = highlightedButton == index;
                return GestureDetector(
                  onTap: () => _onButtonPressed(index),
                  child: Container(
                    decoration: BoxDecoration(
                      color: isHighlighted
                          ? buttonColors[index]
                          : buttonColors[index].withOpacity(0.3),
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: isHighlighted
                          ? [
                              BoxShadow(
                                color: buttonColors[index],
                                blurRadius: 20,
                                spreadRadius: 5,
                              ),
                            ]
                          : [],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
