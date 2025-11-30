import 'dart:math';
import 'package:flutter/material.dart';
import '../../widgets/glass_container.dart';
import '../../services/game_time_service.dart';

enum Direction { up, down, left, right }

class Game2048Screen extends StatefulWidget {
  const Game2048Screen({super.key});

  @override
  State<Game2048Screen> createState() => _Game2048ScreenState();
}

class _Game2048ScreenState extends State<Game2048Screen> {
  static const String gameName = 'game_2048';
  late List<List<int>> _grid;
  int _score = 0;
  bool _gameOver = false;

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
      _initializeGame();
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

  void _initializeGame() {
    _grid = List.generate(4, (_) => List.filled(4, 0));
    _score = 0;
    _gameOver = false;
    _addRandomTile();
    _addRandomTile();
    setState(() {});
  }

  void _addRandomTile() {
    final emptyCells = <Point<int>>[];
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) {
          emptyCells.add(Point(i, j));
        }
      }
    }

    if (emptyCells.isEmpty) return;

    final random = Random();
    final cell = emptyCells[random.nextInt(emptyCells.length)];
    _grid[cell.x][cell.y] = random.nextDouble() < 0.9 ? 2 : 4;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          '2048 Game',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF191970),
              Colors.black,
              Color(0xFF4B0082),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildScoreBoard(),
                  const SizedBox(height: 30),
                  // Wrap in Stack to properly layer the game over overlay
                  Stack(
                    children: [
                      GestureDetector(
                        onVerticalDragEnd: (details) {
                          if (details.primaryVelocity! < -100) {
                            _move(Direction.up);
                          } else if (details.primaryVelocity! > 100) {
                            _move(Direction.down);
                          }
                        },
                        onHorizontalDragEnd: (details) {
                          if (details.primaryVelocity! < -100) {
                            _move(Direction.left);
                          } else if (details.primaryVelocity! > 100) {
                            _move(Direction.right);
                          }
                        },
                        child: _buildGameGrid(),
                      ),
                      // Game Over Overlay - Last child for proper z-index
                      if (_gameOver)
                        IgnorePointer(
                          ignoring: !_gameOver,
                          child: _buildGameOverOverlay(),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildScoreBoard() {
    return GlassContainer(
      width: 200,
      padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            'SCORE',
            style: TextStyle(
              color: Colors.white70,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 20),
          Text(
            _score.toString(),
            style: const TextStyle(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGameGrid() {
    return Container(
      width: 320,
      height: 320,
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.3),
        borderRadius: BorderRadius.circular(15),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(4, (i) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: List.generate(4, (j) {
              return _buildTile(_grid[i][j]);
            }),
          );
        }),
      ),
    );
  }

  Widget _buildTile(int value) {
    final color = _getTileColor(value);

    return Container(
      width: 70,
      height: 70,
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: value == 0 ? Colors.white.withOpacity(0.1) : color.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: value == 0 ? Colors.white24 : color,
          width: 2,
        ),
      ),
      child: Center(
        child: value == 0
            ? const SizedBox.shrink()
            : Text(
                value.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: value < 100 ? 32 : (value < 1000 ? 28 : 24),
                  fontWeight: FontWeight.bold,
                ),
              ),
      ),
    );
  }

  Color _getTileColor(int value) {
    switch (value) {
      case 2:
        return const Color(0xFF00FFFF); // Cyan
      case 4:
        return const Color(0xFF00FF00); // Green
      case 8:
        return const Color(0xFFFFFF00); // Yellow
      case 16:
        return const Color(0xFFFF00FF); // Magenta
      case 32:
        return const Color(0xFFFF0000); // Red
      case 64:
        return const Color(0xFF0000FF); // Blue
      case 128:
        return const Color(0xFFFF6600); // Orange
      case 256:
        return const Color(0xFF9900FF); // Purple
      case 512:
        return const Color(0xFFFF0099); // Pink
      case 1024:
        return const Color(0xFF00FF99); // Mint
      case 2048:
        return const Color(0xFFFFD700); // Gold
      default:
        return Colors.white24;
    }
  }

  Widget _buildGameOverOverlay() {
    return Positioned.fill(
      child: Container(
        color: Colors.black.withOpacity(0.8), // Dark overlay instead of grey
        child: Center(
          child: GlassContainer(
            width: 300,
            padding: const EdgeInsets.all(30),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  'GAME OVER',
                  style: TextStyle(
                    color: Color(0xFFFF073A), // Neon Red
                    fontSize: 40, // Larger size
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                Text(
                  'Score: $_score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _initializeGame();
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.purpleAccent,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 40,
                      vertical: 15,
                    ),
                  ),
                  child: const Text(
                    'Try Again', // Changed from PLAY AGAIN
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _move(Direction direction) {
    if (_gameOver) return;

    final oldGrid = _grid.map((row) => List<int>.from(row)).toList();

    switch (direction) {
      case Direction.up:
        _moveUp();
        break;
      case Direction.down:
        _moveDown();
        break;
      case Direction.left:
        _moveLeft();
        break;
      case Direction.right:
        _moveRight();
        break;
    }

    // Check if grid changed
    bool gridChanged = false;
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (oldGrid[i][j] != _grid[i][j]) {
          gridChanged = true;
          break;
        }
      }
      if (gridChanged) break;
    }

    if (gridChanged) {
      _addRandomTile();
      _checkGameOver();
      setState(() {});
    }
  }

  void _moveLeft() {
    for (int i = 0; i < 4; i++) {
      // Compress: move all non-zero tiles left
      final row = _grid[i].where((val) => val != 0).toList();

      // Merge: combine adjacent equal tiles
      for (int j = 0; j < row.length - 1; j++) {
        if (row[j] == row[j + 1]) {
          row[j] *= 2;
          _score += row[j];
          row.removeAt(j + 1);
        }
      }

      // Fill remaining with zeros
      while (row.length < 4) {
        row.add(0);
      }

      _grid[i] = row;
    }
  }

  void _moveRight() {
    for (int i = 0; i < 4; i++) {
      // Reverse, move left, then reverse back
      _grid[i] = _grid[i].reversed.toList();
    }
    _moveLeft();
    for (int i = 0; i < 4; i++) {
      _grid[i] = _grid[i].reversed.toList();
    }
  }

  void _moveUp() {
    // Transpose grid
    _transposeGrid();
    // Move left (which is now up in original orientation)
    _moveLeft();
    // Transpose back
    _transposeGrid();
  }

  void _moveDown() {
    // Transpose grid
    _transposeGrid();
    // Move right (which is now down in original orientation)
    _moveRight();
    // Transpose back
    _transposeGrid();
  }

  void _transposeGrid() {
    final newGrid = List.generate(4, (_) => List.filled(4, 0));
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        newGrid[j][i] = _grid[i][j];
      }
    }
    _grid = newGrid;
  }

  void _checkGameOver() {
    // Check for empty cells
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        if (_grid[i][j] == 0) return;
      }
    }

    // Check for possible merges
    for (int i = 0; i < 4; i++) {
      for (int j = 0; j < 4; j++) {
        final current = _grid[i][j];
        // Check right
        if (j < 3 && _grid[i][j + 1] == current) return;
        // Check down
        if (i < 3 && _grid[i + 1][j] == current) return;
      }
    }

    _gameOver = true;
  }
}
