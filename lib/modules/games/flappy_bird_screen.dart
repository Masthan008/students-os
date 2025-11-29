import 'package:flutter/material.dart';
import 'dart:async';

class FlappyBirdScreen extends StatefulWidget {
  const FlappyBirdScreen({super.key});

  @override
  State<FlappyBirdScreen> createState() => _FlappyBirdScreenState();
}

class _FlappyBirdScreenState extends State<FlappyBirdScreen> {
  double birdY = 0;
  double velocity = 0;
  double gravity = 0.5;
  double jump = -8;
  
  bool gameStarted = false;
  int score = 0;
  
  List<double> barrierX = [2, 2 + 1.5];
  List<List<double>> barrierHeight = [
    [0.6, 0.4],
    [0.4, 0.6],
  ];

  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void startGame() {
    gameStarted = true;
    birdY = 0;
    velocity = 0;
    score = 0;
    barrierX = [2, 2 + 1.5];
    
    timer = Timer.periodic(const Duration(milliseconds: 50), (timer) {
      setState(() {
        // Bird physics
        velocity += gravity;
        birdY += velocity * 0.05;

        // Move barriers
        for (int i = 0; i < barrierX.length; i++) {
          barrierX[i] -= 0.05;
          
          if (barrierX[i] < -0.5) {
            barrierX[i] += 3;
            score++;
          }
        }

        // Check collision
        if (birdY > 1 || birdY < -1) {
          gameOver();
        }

        for (int i = 0; i < barrierX.length; i++) {
          if (barrierX[i] < 0.2 && barrierX[i] > -0.2) {
            if (birdY < -1 + barrierHeight[i][0] || birdY > 1 - barrierHeight[i][1]) {
              gameOver();
            }
          }
        }
      });
    });
  }

  void gameOver() {
    timer?.cancel();
    gameStarted = false;
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

  void onTap() {
    if (gameStarted) {
      velocity = jump;
    } else {
      startGame();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[300],
      body: GestureDetector(
        onTap: onTap,
        child: Stack(
          children: [
            // Bird
            AnimatedContainer(
              duration: const Duration(milliseconds: 0),
              alignment: Alignment(0, birdY),
              child: Container(
                width: 50,
                height: 50,
                decoration: const BoxDecoration(
                  color: Colors.yellow,
                  shape: BoxShape.circle,
                ),
                child: const Center(
                  child: Text('🐦', style: TextStyle(fontSize: 30)),
                ),
              ),
            ),

            // Barriers
            ...List.generate(barrierX.length, (index) {
              return Stack(
                children: [
                  // Top barrier
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierX[index], -1),
                    child: Container(
                      width: 100,
                      height: MediaQuery.of(context).size.height * barrierHeight[index][0] / 2,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        border: Border.all(color: Colors.green[900]!, width: 3),
                      ),
                    ),
                  ),
                  // Bottom barrier
                  AnimatedContainer(
                    duration: const Duration(milliseconds: 0),
                    alignment: Alignment(barrierX[index], 1),
                    child: Container(
                      width: 100,
                      height: MediaQuery.of(context).size.height * barrierHeight[index][1] / 2,
                      decoration: BoxDecoration(
                        color: Colors.green[700],
                        border: Border.all(color: Colors.green[900]!, width: 3),
                      ),
                    ),
                  ),
                ],
              );
            }),

            // Score
            Positioned(
              top: 50,
              left: 0,
              right: 0,
              child: Center(
                child: Text(
                  'Score: $score',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),

            // Start message
            if (!gameStarted)
              const Center(
                child: Text(
                  'TAP TO START',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
