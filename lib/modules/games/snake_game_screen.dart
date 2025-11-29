import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class SnakeGameScreen extends StatefulWidget {
  const SnakeGameScreen({super.key});

  @override
  State<SnakeGameScreen> createState() => _SnakeGameScreenState();
}

class _SnakeGameScreenState extends State<SnakeGameScreen> {
  static const int rows = 20;
  static const int columns = 20;
  
  List<int> snake = [45, 44, 43];
  int food = 67;
  String direction = 'right';
  bool isPlaying = false;
  int score = 0;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startGame() {
    snake = [45, 44, 43];
    food = Random().nextInt(rows * columns);
    direction = 'right';
    score = 0;
    isPlaying = true;
    
    timer = Timer.periodic(const Duration(milliseconds: 200), (timer) {
      updateSnake();
    });
    
    setState(() {});
  }

  void updateSnake() {
    setState(() {
      int head = snake.first;
      int newHead = head;

      switch (direction) {
        case 'up':
          newHead = head - columns;
          break;
        case 'down':
          newHead = head + columns;
          break;
        case 'left':
          newHead = head - 1;
          break;
        case 'right':
          newHead = head + 1;
          break;
      }

      // Check collision with walls
      if (newHead < 0 || newHead >= rows * columns ||
          (direction == 'left' && head % columns == 0) ||
          (direction == 'right' && (head + 1) % columns == 0)) {
        gameOver();
        return;
      }

      // Check collision with self
      if (snake.contains(newHead)) {
        gameOver();
        return;
      }

      snake.insert(0, newHead);

      // Check if food eaten
      if (newHead == food) {
        score += 10;
        food = Random().nextInt(rows * columns);
        while (snake.contains(food)) {
          food = Random().nextInt(rows * columns);
        }
      } else {
        snake.removeLast();
      }
    });
  }

  void gameOver() {
    timer?.cancel();
    isPlaying = false;
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: const Color(0xFF1a1a2e),
        title: const Text('Game Over!', style: TextStyle(color: Colors.redAccent)),
        content: Text('Score: $score', style: const TextStyle(color: Colors.white, fontSize: 24)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              startGame();
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
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text('Snake Game', style: TextStyle(color: Colors.cyanAccent)),
        backgroundColor: Colors.transparent,
        actions: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text('Score: $score', style: const TextStyle(color: Colors.white, fontSize: 18)),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: GestureDetector(
              onVerticalDragUpdate: (details) {
                if (direction != 'up' && details.delta.dy > 0) {
                  direction = 'down';
                } else if (direction != 'down' && details.delta.dy < 0) {
                  direction = 'up';
                }
              },
              onHorizontalDragUpdate: (details) {
                if (direction != 'left' && details.delta.dx > 0) {
                  direction = 'right';
                } else if (direction != 'right' && details.delta.dx < 0) {
                  direction = 'left';
                }
              },
              child: GridView.builder(
                physics: const NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                ),
                itemCount: rows * columns,
                itemBuilder: (context, index) {
                  bool isSnake = snake.contains(index);
                  bool isFood = index == food;
                  bool isHead = index == snake.first;

                  return Container(
                    margin: const EdgeInsets.all(1),
                    decoration: BoxDecoration(
                      color: isHead
                          ? Colors.green
                          : isSnake
                              ? Colors.greenAccent
                              : isFood
                                  ? Colors.redAccent
                                  : Colors.grey[900],
                      borderRadius: BorderRadius.circular(4),
                    ),
                  );
                },
              ),
            ),
          ),
          if (!isPlaying)
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: startGame,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.cyanAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
                ),
                child: const Text('Start Game', style: TextStyle(color: Colors.black, fontSize: 20)),
              ),
            ),
          const SizedBox(height: 100),
        ],
      ),
    );
  }
}
