import 'dart:math' as math;
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
  bool _isDegrees = true; // DEG/RAD toggle

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
      } else if (value == 'DEG/RAD') {
        _isDegrees = !_isDegrees;
      } else if (value == '√') {
        _expression += 'sqrt(';
      } else if (value == 'sin') {
        _expression += 'sin(';
      } else if (value == 'cos') {
        _expression += 'cos(';
      } else if (value == 'tan') {
        _expression += 'tan(';
      } else if (value == 'log') {
        _expression += 'log(';
      } else if (value == 'ln') {
        _expression += 'ln(';
      } else if (value == '^') {
        _expression += '^';
      } else {
        _expression += value;
      }
    });
  }

  void _evaluateExpression() {
    try {
      String expr = _expression
          .replaceAll('×', '*')
          .replaceAll('÷', '/')
          .replaceAll('π', math.pi.toString())
          .replaceAll('e', math.e.toString());
      
      // Convert degrees to radians if needed for trig functions
      if (_isDegrees) {
        expr = _convertDegreesToRadians(expr);
      }
      
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

  String _convertDegreesToRadians(String expr) {
    // Convert sin(x), cos(x), tan(x) from degrees to radians
    final degToRad = math.pi / 180;
    
    // Replace sin(x) with sin(x*pi/180)
    expr = expr.replaceAllMapped(
      RegExp(r'sin\(([^)]+)\)'),
      (match) => 'sin((${match.group(1)})*$degToRad)',
    );
    expr = expr.replaceAllMapped(
      RegExp(r'cos\(([^)]+)\)'),
      (match) => 'cos((${match.group(1)})*$degToRad)',
    );
    expr = expr.replaceAllMapped(
      RegExp(r'tan\(([^)]+)\)'),
      (match) => 'tan((${match.group(1)})*$degToRad)',
    );
    
    return expr;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF2A2A2A), // Dark Grey
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 20),
            
            // LCD Screen with Inset Shadow Effect
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                width: double.infinity,
                height: 140,
                decoration: BoxDecoration(
                  color: const Color(0xFF3A3A3A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF555555), width: 3),
                ),
                child: Container(
                  margin: const EdgeInsets.all(4),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9EA792), // Classic LCD Green
                    borderRadius: BorderRadius.circular(4),
                    boxShadow: [
                      // Inner shadow effect (simulated)
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 6,
                        spreadRadius: -2,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Mode Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SCIENTIFIC',
                            style: GoogleFonts.orbitron(
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.4),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            _isDegrees ? 'DEG' : 'RAD',
                            style: GoogleFonts.orbitron(
                              fontSize: 10,
                              color: Colors.black.withOpacity(0.6),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      // Expression
                      Text(
                        _expression.isEmpty ? '0' : _expression,
                        style: GoogleFonts.orbitron(
                          fontSize: 20,
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
                            fontSize: 48,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            const SizedBox(height: 10),
            
            // Solar Panel (Cosmetic)
            Container(
              width: 120,
              height: 25,
              decoration: BoxDecoration(
                color: const Color(0xFF1A1A1A),
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: const Color(0xFF444444)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                  5,
                  (index) => Container(
                    width: 2,
                    height: 20,
                    color: const Color(0xFF333333),
                  ),
                ),
              ),
            ),
            
            const Spacer(),
            
            // Scientific Keypad
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // Row 1: Scientific Functions
                  _buildRow(['sin', 'cos', 'tan', 'DEG/RAD'], isScientific: true),
                  const SizedBox(height: 8),
                  // Row 2: More Functions
                  _buildRow(['log', 'ln', '√', '^'], isScientific: true),
                  const SizedBox(height: 8),
                  // Row 3: AC, DEL, Parentheses, Division
                  _buildRow(['AC', 'DEL', '(', ')'], isFunction: true),
                  const SizedBox(height: 8),
                  // Row 4: 7, 8, 9, Division
                  _buildRow(['7', '8', '9', '÷']),
                  const SizedBox(height: 8),
                  // Row 5: 4, 5, 6, Multiply
                  _buildRow(['4', '5', '6', '×']),
                  const SizedBox(height: 8),
                  // Row 6: 1, 2, 3, Subtract
                  _buildRow(['1', '2', '3', '-']),
                  const SizedBox(height: 8),
                  // Row 7: 0, Decimal, Equals, Add
                  _buildRow(['0', '.', '=', '+']),
                ],
              ),
            ),
            
            const SizedBox(height: 80), // Space for bottom nav
          ],
        ),
      ),
    );
  }

  Widget _buildRow(List<String> labels, {bool isScientific = false, bool isFunction = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: labels.map((label) {
        return _buildButton(label, isScientific: isScientific, isFunction: isFunction);
      }).toList(),
    );
  }

  Widget _buildButton(String label, {bool isScientific = false, bool isFunction = false}) {
    bool isOperator = ['÷', '×', '-', '+'].contains(label);
    bool isEquals = label == '=';
    bool isSpecialFunction = ['AC', 'DEL'].contains(label);
    
    Color buttonColor;
    Color textColor;
    
    if (isEquals) {
      buttonColor = const Color(0xFFFF9500);
      textColor = Colors.white;
    } else if (isScientific) {
      buttonColor = const Color(0xFF1A1A1A); // Black for scientific
      textColor = Colors.cyan;
    } else if (isSpecialFunction) {
      buttonColor = const Color(0xFFFF6B35); // Orange for AC/DEL
      textColor = Colors.white;
    } else if (isFunction) {
      buttonColor = const Color(0xFF505050);
      textColor = Colors.orange;
    } else if (isOperator) {
      buttonColor = const Color(0xFF505050);
      textColor = Colors.orange;
    } else {
      buttonColor = const Color(0xFF3A3A3A); // Grey for numbers
      textColor = Colors.white;
    }
    
    return GestureDetector(
      onTap: () => _onButtonPressed(label),
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 4,
        height: 60,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            // Top-left highlight (3D effect)
            BoxShadow(
              color: Colors.white.withOpacity(0.15),
              offset: const Offset(-2, -2),
              blurRadius: 4,
            ),
            // Bottom-right shadow (3D effect)
            BoxShadow(
              color: Colors.black.withOpacity(0.6),
              offset: const Offset(3, 3),
              blurRadius: 6,
            ),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.roboto(
              fontSize: label.length > 3 ? 14 : 20,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}
