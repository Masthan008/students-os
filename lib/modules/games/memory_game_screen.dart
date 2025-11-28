import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class MemoryGameScreen extends StatefulWidget {
  const MemoryGameScreen({super.key});

  @override
  State<MemoryGameScreen> createState() => _MemoryGameScreenState();
}

class _MemoryGameScreenState extends State<MemoryGameScreen> {
  List<GameCard> _cards = [];
  List<int> _flippedIndices = [];
  bool _isChecking = false;
  int _moves = 0;
  int _matches = 0;
  int _bestScore = 0;

  final List<IconData> _icons = [
    Icons.star,
    Icons.favorite,
    Icons.flash_on,
    Icons.cloud,
    Icons.music_note,
    Icons.sports_esports,
    Icons.emoji_emotions,
    Icons.pets,
  ];

  @override
  void initState() {
    super.initState();
    _initializeGame();
  }

  void _initializeGame() {
    // Create pairs of cards
    List<GameCard> cards = [];
    for (int i = 0; i < 8; i++) {
      cards.add(GameCard(id: i, icon: _icons[i]));
      cards.add(GameCard(id: i, icon: _icons[i]));
    }

    // Shuffle
    cards.shuffle(Random());

    setState(() {
      _cards = cards;
      _flippedIndices = [];
      _moves = 0;
      _matches = 0;
      _isChecking = false;
    });
  }

  void _onCardTap(int index) {
    if (_isChecking ||
        _cards[index].isMatched ||
        _cards[index].isFlipped ||
        _flippedIndices.length >= 2) {
      return;
    }

    setState(() {
      _cards[index].isFlipped = true;
      _flippedIndices.add(index);

      if (_flippedIndices.length == 2) {
        _moves++;
        _checkMatch();
      }
    });
  }

  void _checkMatch() {
    _isChecking = true;

    final firstIndex = _flippedIndices[0];
    final secondIndex = _flippedIndices[1];

    if (_cards[firstIndex].id == _cards[secondIndex].id) {
      // Match found!
      setState(() {
        _cards[firstIndex].isMatched = true;
        _cards[secondIndex].isMatched = true;
        _matches++;
        _flippedIndices = [];
        _isChecking = false;

        // Check if game is complete
        if (_matches == 8) {
          _gameComplete();
        }
      });
    } else {
      // No match - flip back after delay
      Future.delayed(const Duration(milliseconds: 1000), () {
        setState(() {
          _cards[firstIndex].isFlipped = false;
          _cards[secondIndex].isFlipped = false;
          _flippedIndices = [];
          _isChecking = false;
        });
      });
    }
  }

  void _gameComplete() {
    if (_bestScore == 0 || _moves < _bestScore) {
      setState(() {
        _bestScore = _moves;
      });
    }

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.grey.shade900,
        title: Row(
          children: [
            const Icon(Icons.emoji_events, color: Colors.amber, size: 32),
            const SizedBox(width: 12),
            Text(
              'You Win!',
              style: GoogleFonts.orbitron(color: Colors.white),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Completed in $_moves moves!',
              style: GoogleFonts.montserrat(
                color: Colors.cyanAccent,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (_bestScore > 0) ...[
              const SizedBox(height: 12),
              Text(
                'Best: $_bestScore moves',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              _initializeGame();
            },
            child: Text(
              'Play Again',
              style: GoogleFonts.montserrat(
                color: Colors.cyanAccent,
                fontWeight: FontWeight.bold,
              ),
            ),
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
        title: Text(
          'Memory Match',
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.grey.shade900,
        iconTheme: const IconThemeData(color: Colors.cyanAccent),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _initializeGame,
            tooltip: 'New Game',
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.grey.shade900, Colors.black],
          ),
        ),
        child: Column(
          children: [
            // Stats
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatCard('Moves', _moves, Icons.touch_app, Colors.cyanAccent),
                  _buildStatCard('Matches', _matches, Icons.check_circle, Colors.green),
                  _buildStatCard('Best', _bestScore, Icons.emoji_events, Colors.amber),
                ],
              ),
            ),

            // Game Board
            Expanded(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Container(
                    margin: const EdgeInsets.all(20),
                    child: GridView.builder(
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 4,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 16,
                      itemBuilder: (context, index) {
                        final card = _cards[index];
                        return GestureDetector(
                          onTap: () => _onCardTap(index),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: card.isMatched
                                  ? Colors.green.withOpacity(0.3)
                                  : card.isFlipped
                                      ? Colors.cyanAccent.withOpacity(0.2)
                                      : Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: card.isMatched
                                    ? Colors.green
                                    : card.isFlipped
                                        ? Colors.cyanAccent
                                        : Colors.grey.shade700,
                                width: 2,
                              ),
                              boxShadow: [
                                if (card.isFlipped || card.isMatched)
                                  BoxShadow(
                                    color: card.isMatched
                                        ? Colors.green.withOpacity(0.3)
                                        : Colors.cyanAccent.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                              ],
                            ),
                            child: Center(
                              child: card.isFlipped || card.isMatched
                                  ? Icon(
                                      card.icon,
                                      size: 40,
                                      color: card.isMatched
                                          ? Colors.green
                                          : Colors.cyanAccent,
                                    )
                                  : Icon(
                                      Icons.help_outline,
                                      size: 40,
                                      color: Colors.grey.shade700,
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),

            // Instructions
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(
                'Match all pairs to win!',
                style: GoogleFonts.montserrat(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard(String label, int value, IconData icon, Color color) {
    return Column(
      children: [
        Icon(icon, color: color, size: 24),
        const SizedBox(height: 8),
        Text(
          '$value',
          style: GoogleFonts.orbitron(
            color: color,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}

class GameCard {
  final int id;
  final IconData icon;
  bool isFlipped;
  bool isMatched;

  GameCard({
    required this.id,
    required this.icon,
    this.isFlipped = false,
    this.isMatched = false,
  });
}
