import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math';

class TicTacToeScreen extends StatefulWidget {
  const TicTacToeScreen({super.key});

  @override
  State<TicTacToeScreen> createState() => _TicTacToeScreenState();
}

class _TicTacToeScreenState extends State<TicTacToeScreen> {
  List<String> _board = List.filled(9, '');
  bool _isPlayerTurn = true; // true = X (player), false = O (AI)
  String _winner = '';
  int _playerScore = 0;
  int _aiScore = 0;
  int _draws = 0;

  void _makeMove(int index) {
    if (_board[index].isEmpty && _winner.isEmpty && _isPlayerTurn) {
      setState(() {
        _board[index] = 'X';
        _isPlayerTurn = false;
        _checkWinner();
        
        // AI move after a short delay
        if (_winner.isEmpty && !_isBoardFull()) {
          Future.delayed(const Duration(milliseconds: 500), () {
            _makeAIMove();
          });
        }
      });
    }
  }

  void _makeAIMove() {
    // Simple AI: Try to win, block player, or random move
    int move = _findBestMove();
    
    setState(() {
      _board[move] = 'O';
      _isPlayerTurn = true;
      _checkWinner();
    });
  }

  int _findBestMove() {
    // 1. Try to win
    for (int i = 0; i < 9; i++) {
      if (_board[i].isEmpty) {
        _board[i] = 'O';
        if (_checkWinnerForPlayer('O')) {
          _board[i] = '';
          return i;
        }
        _board[i] = '';
      }
    }

    // 2. Block player from winning
    for (int i = 0; i < 9; i++) {
      if (_board[i].isEmpty) {
        _board[i] = 'X';
        if (_checkWinnerForPlayer('X')) {
          _board[i] = '';
          return i;
        }
        _board[i] = '';
      }
    }

    // 3. Take center if available
    if (_board[4].isEmpty) return 4;

    // 4. Take a corner
    final corners = [0, 2, 6, 8];
    final availableCorners = corners.where((i) => _board[i].isEmpty).toList();
    if (availableCorners.isNotEmpty) {
      return availableCorners[Random().nextInt(availableCorners.length)];
    }

    // 5. Take any available spot
    final available = List.generate(9, (i) => i).where((i) => _board[i].isEmpty).toList();
    return available[Random().nextInt(available.length)];
  }

  bool _checkWinnerForPlayer(String player) {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (_board[i] == player && _board[i + 1] == player && _board[i + 2] == player) {
        return true;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_board[i] == player && _board[i + 3] == player && _board[i + 6] == player) {
        return true;
      }
    }

    // Check diagonals
    if (_board[0] == player && _board[4] == player && _board[8] == player) return true;
    if (_board[2] == player && _board[4] == player && _board[6] == player) return true;

    return false;
  }

  void _checkWinner() {
    // Check rows
    for (int i = 0; i < 9; i += 3) {
      if (_board[i].isNotEmpty && 
          _board[i] == _board[i + 1] && 
          _board[i] == _board[i + 2]) {
        _setWinner(_board[i]);
        return;
      }
    }

    // Check columns
    for (int i = 0; i < 3; i++) {
      if (_board[i].isNotEmpty && 
          _board[i] == _board[i + 3] && 
          _board[i] == _board[i + 6]) {
        _setWinner(_board[i]);
        return;
      }
    }

    // Check diagonals
    if (_board[0].isNotEmpty && _board[0] == _board[4] && _board[0] == _board[8]) {
      _setWinner(_board[0]);
      return;
    }
    if (_board[2].isNotEmpty && _board[2] == _board[4] && _board[2] == _board[6]) {
      _setWinner(_board[2]);
      return;
    }

    // Check for draw
    if (_isBoardFull()) {
      setState(() {
        _winner = 'Draw';
        _draws++;
      });
    }
  }

  void _setWinner(String player) {
    setState(() {
      _winner = player;
      if (player == 'X') {
        _playerScore++;
      } else {
        _aiScore++;
      }
    });
  }

  bool _isBoardFull() {
    return !_board.contains('');
  }

  void _resetGame() {
    setState(() {
      _board = List.filled(9, '');
      _isPlayerTurn = true;
      _winner = '';
    });
  }

  void _resetScores() {
    setState(() {
      _playerScore = 0;
      _aiScore = 0;
      _draws = 0;
      _resetGame();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: Text(
          'Tic-Tac-Toe',
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
            onPressed: _resetScores,
            tooltip: 'Reset Scores',
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
            // Score Board
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildScoreCard('You (X)', _playerScore, Colors.cyanAccent),
                  _buildScoreCard('Draws', _draws, Colors.grey),
                  _buildScoreCard('AI (O)', _aiScore, Colors.orange),
                ],
              ),
            ),

            // Status Text
            Padding(
              padding: const EdgeInsets.all(16),
              child: Text(
                _winner.isEmpty
                    ? (_isPlayerTurn ? 'Your Turn' : 'AI Thinking...')
                    : _winner == 'Draw'
                        ? 'It\'s a Draw!'
                        : _winner == 'X'
                            ? '🎉 You Win!'
                            : '🤖 AI Wins!',
                style: GoogleFonts.orbitron(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: _winner == 'X'
                      ? Colors.cyanAccent
                      : _winner == 'O'
                          ? Colors.orange
                          : Colors.white,
                ),
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
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                      ),
                      itemCount: 9,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () => _makeMove(index),
                          child: Container(
                            decoration: BoxDecoration(
                              color: Colors.grey.shade900,
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.cyanAccent.withOpacity(0.3),
                                width: 2,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: _board[index] == 'X'
                                      ? Colors.cyanAccent.withOpacity(0.3)
                                      : _board[index] == 'O'
                                          ? Colors.orange.withOpacity(0.3)
                                          : Colors.transparent,
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Center(
                              child: Text(
                                _board[index],
                                style: GoogleFonts.orbitron(
                                  fontSize: 60,
                                  fontWeight: FontWeight.bold,
                                  color: _board[index] == 'X'
                                      ? Colors.cyanAccent
                                      : Colors.orange,
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
            ),

            // Play Again Button
            if (_winner.isNotEmpty)
              Padding(
                padding: const EdgeInsets.all(20),
                child: ElevatedButton(
                  onPressed: _resetGame,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'Play Again',
                    style: GoogleFonts.orbitron(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard(String label, int score, Color color) {
    return Column(
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.grey,
            fontSize: 12,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: color.withOpacity(0.5)),
          ),
          child: Text(
            '$score',
            style: GoogleFonts.orbitron(
              color: color,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }
}
