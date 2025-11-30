import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';
import '../../services/game_time_service.dart';

class PuzzleSliderScreen extends StatefulWidget {
  const PuzzleSliderScreen({super.key});

  @override
  State<PuzzleSliderScreen> createState() => _PuzzleSliderScreenState();
}

class _PuzzleSliderScreenState extends State<PuzzleSliderScreen> {
  static const String gameName = 'puzzle_slider';
  List<int> tiles = [];
  int gridSize = 4;
  int moves = 0;
  bool gameStarted = false;
  bool gameWon = false;

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
      _initializePuzzle();
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
          'You\'ve played for 20 minutes today!\n\nCome back in ${GameTimeService.getTimeRemainingMessage(minutes)} to play again.',
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

  void _initializePuzzle() {
    tiles = List.generate(gridSize * gridSize - 1, (index) => index + 1);
    tiles.add(0); // 0 represents empty space
    _shuffleTiles();
    setState(() {
      moves = 0;
      gameStarted = true;
      gameWon = false;
    });
  }

  void _shuffleTiles() {
    final random = Random();
    for (int i = 0; i < 100; i++) {
      final emptyIndex = tiles.indexOf(0);
      final possibleMoves = _getPossibleMoves(emptyIndex);
      if (possibleMoves.isNotEmpty) {
        final randomMove = possibleMoves[random.nextInt(possibleMoves.length)];
        _swapTiles(emptyIndex, randomMove);
      }
    }
  }

  List<int> _getPossibleMoves(int emptyIndex) {
    final List<int> moves = [];
    final row = emptyIndex ~/ gridSize;
    final col = emptyIndex % gridSize;

    if (row > 0) moves.add(emptyIndex - gridSize); // Up
    if (row < gridSize - 1) moves.add(emptyIndex + gridSize); // Down
    if (col > 0) moves.add(emptyIndex - 1); // Left
    if (col < gridSize - 1) moves.add(emptyIndex + 1); // Right

    return moves;
  }

  void _swapTiles(int index1, int index2) {
    final temp = tiles[index1];
    tiles[index1] = tiles[index2];
    tiles[index2] = temp;
  }

  void _onTileTap(int index) {
    if (gameWon) return;

    final emptyIndex = tiles.indexOf(0);
    final possibleMoves = _getPossibleMoves(emptyIndex);

    if (possibleMoves.contains(index)) {
      setState(() {
        _swapTiles(emptyIndex, index);
        moves++;
        _checkWin();
      });
    }
  }

  void _checkWin() {
    bool won = true;
    for (int i = 0; i < tiles.length - 1; i++) {
      if (tiles[i] != i + 1) {
        won = false;
        break;
      }
    }

    if (won) {
      setState(() {
        gameWon = true;
      });
      _showWinDialog();
    }
  }

  void _showWinDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('🎉 Congratulations!', style: TextStyle(color: Colors.green)),
        content: Text(
          'You solved the puzzle in $moves moves!',
          style: const TextStyle(color: Colors.white, fontSize: 18),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializePuzzle();
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
          'Puzzle Slider',
          style: GoogleFonts.orbitron(color: Colors.cyanAccent, fontWeight: FontWeight.bold),
        ),
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializePuzzle,
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          Container(
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
                      'Moves',
                      style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      '$moves',
                      style: GoogleFonts.orbitron(
                        color: Colors.cyanAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  children: [
                    Text(
                      'Grid',
                      style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 12),
                    ),
                    Text(
                      '${gridSize}x$gridSize',
                      style: GoogleFonts.orbitron(
                        color: Colors.orange,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Spacer(),
          if (gameStarted)
            Center(
              child: AspectRatio(
                aspectRatio: 1,
                child: Container(
                  margin: const EdgeInsets.all(20),
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade900,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.cyanAccent.withOpacity(0.3),
                        blurRadius: 20,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: GridView.builder(
                    physics: const NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: gridSize,
                      crossAxisSpacing: 8,
                      mainAxisSpacing: 8,
                    ),
                    itemCount: tiles.length,
                    itemBuilder: (context, index) {
                      final tile = tiles[index];
                      if (tile == 0) {
                        return Container(
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.3),
                            borderRadius: BorderRadius.circular(8),
                          ),
                        );
                      }

                      return GestureDetector(
                        onTap: () => _onTileTap(index),
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.cyanAccent.withOpacity(0.8),
                                Colors.blueAccent.withOpacity(0.8),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(8),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.3),
                                blurRadius: 4,
                                offset: const Offset(2, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Text(
                              '$tile',
                              style: GoogleFonts.orbitron(
                                color: Colors.black,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(20),
            child: Text(
              'Slide tiles to arrange them in order',
              style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}
