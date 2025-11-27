import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String _expression = '';
  String _result = '0';

  void _onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        _expression = '';
        _result = '0';
      } else if (value == 'DEL') {
        if (_expression.isNotEmpty) {
          _expression = _expression.substring(0, _expression.length - 1);
        }
      } else if (value == '=') {
        _evaluateExpression();
      } else {
        _expression += value;
      }
    });
  }

  void _evaluateExpression() {
    try {
      String expr = _expression.replaceAll('×', '*').replaceAll('÷', '/');
      Parser parser = Parser();
      Expression exp = parser.parse(expr);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      
      // Format result
      if (eval % 1 == 0) {
        _result = eval.toInt().toString();
      } else {
        _result = eval.toStringAsFixed(8).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
      }
    } catch (e) {
      _result = 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF222222), // Dark Grey
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // LCD Screen
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 140,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: const Color(0xFF9EA792), // Olive Green
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF666666), width: 3),
                  boxShadow: [
                    // Inner shadow effect
                    BoxShadow(
                      color: Colors.black.withOpacity(0.4),
                      blurRadius: 8,
                      spreadRadius: 2,
                      offset: const Offset(0, 0),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Expression
                    Text(
                      _expression.isEmpty ? '0' : _expression,
                      style: GoogleFonts.orbitron(
                        fontSize: 24,
                        color: Colors.black.withOpacity(0.6),
                        fontWeight: FontWeight.w400,
                      ),
                      textAlign: TextAlign.right,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Result
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerRight,
                      child: Text(
                        _result,
                        style: GoogleFonts.orbitron(
                          fontSize: 56,
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Solar Panel (Cosmetic)
            Container(
              width: 120,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF3A2F2F),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF555555)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 2,
                    height: 20,
                    color: const Color(0xFF555555),
                  ),
                ),
              ),
            ),
            
            const Spacer(),
            
            // Keypad
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  _buildRow(['AC', 'DEL', '%', '÷']),
                  const SizedBox(height: 12),
                  _buildRow(['7', '8', '9', '×']),
                  const SizedBox(height: 12),
                  _buildRow(['4', '5', '6', '-']),
                  const SizedBox(height: 12),
                  _buildRow(['1', '2', '3', '+']),
                  const SizedBox(height: 12),
                  _buildRow(['0', '.', '=', '']),
                ],
              ),
            ),
            
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> labels) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) {
        if (label.isEmpty) return const SizedBox(width: 70);
        return _buildButton(label);
      }).toList(),
    );
  }

  Widget _buildButton(String label) {
    bool isOperator = ['÷', '×', '-', '+', '='].contains(label);
    bool isFunction = ['AC', 'DEL', '%'].contains(label);
    bool isEquals = label == '=';
    
    Color buttonColor;
    Color textColor;
    
    if (isEquals) {
      buttonColor = const Color(0xFFFF9500);
      textColor = Colors.white;
    } else if (isOperator) {
      buttonColor = const Color(0xFF505050);
      textColor = Colors.orange;
    } else if (isFunction) {
      buttonColor = const Color(0xFF505050);
      textColor = Colors.cyan;
    } else {
      buttonColor = const Color(0xFF3A3A3A);
      textColor = Colors.white;
    }
    
    return GestureDetector(
      onTap: () => _onButtonPressed(label),
      child: Container(
        width: label == '0' ? 160 : 70,
        height: 70,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            // Top-left highlight
            BoxShadow(
              color: Colors.white.withOpacity(0.1),
              offset: const Offset(-2, -2),
              blurRadius: 4,
            ),
            // Bottom-right shadow
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(3, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: label.length > 2 ? 18 : 28,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
