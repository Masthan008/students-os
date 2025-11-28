import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        backgroundColor: const Color(0xFF2A2A2A),
        appBar: AppBar(
          backgroundColor: Colors.grey.shade900,
          title: Text(
            'Calculator Pro',
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontWeight: FontWeight.bold,
            ),
          ),
          iconTheme: const IconThemeData(color: Colors.cyanAccent),
          bottom: const TabBar(
            indicatorColor: Colors.cyanAccent,
            labelColor: Colors.cyanAccent,
            unselectedLabelColor: Colors.grey,
            tabs: [
              Tab(icon: Icon(Icons.calculate), text: 'Calc'),
              Tab(icon: Icon(Icons.swap_horiz), text: 'Converter'),
              Tab(icon: Icon(Icons.school), text: 'CGPA'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ScientificCalculatorTab(),
            _ConverterTab(),
            _CGPATab(),
          ],
        ),
      ),
    );
  }
}

// ============================================
// TAB 1: Scientific Calculator
// ============================================
class _ScientificCalculatorTab extends StatefulWidget {
  const _ScientificCalculatorTab();

  @override
  State<_ScientificCalculatorTab> createState() => _ScientificCalculatorTabState();
}

class _ScientificCalculatorTabState extends State<_ScientificCalculatorTab> {
  String _expression = '';
  String _result = '0';
  bool _isDegrees = true;

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
      
      if (_isDegrees) {
        expr = _convertDegreesToRadians(expr);
      }
      
      Parser parser = Parser();
      Expression exp = parser.parse(expr);
      ContextModel contextModel = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, contextModel);
      
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
    final degToRad = math.pi / 180;
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
    return Column(
      children: [
        const SizedBox(height: 20),
        // LCD Screen
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Container(
            width: double.infinity,
            height: 120,
            decoration: BoxDecoration(
              color: const Color(0xFF3A3A3A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF555555), width: 3),
            ),
            child: Container(
              margin: const EdgeInsets.all(4),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF9EA792),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'SCIENTIFIC',
                        style: GoogleFonts.orbitron(
                          fontSize: 9,
                          color: Colors.black.withOpacity(0.4),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        _isDegrees ? 'DEG' : 'RAD',
                        style: GoogleFonts.orbitron(
                          fontSize: 9,
                          color: Colors.black.withOpacity(0.6),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  Text(
                    _expression.isEmpty ? '0' : _expression,
                    style: GoogleFonts.orbitron(
                      fontSize: 16,
                      color: Colors.black.withOpacity(0.6),
                      fontWeight: FontWeight.w400,
                    ),
                    textAlign: TextAlign.right,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _result,
                      style: GoogleFonts.orbitron(
                        fontSize: 40,
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
        const Spacer(),
        // Keypad
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _buildRow(['sin', 'cos', 'tan', 'DEG/RAD'], isScientific: true),
              const SizedBox(height: 6),
              _buildRow(['log', 'ln', '√', '^'], isScientific: true),
              const SizedBox(height: 6),
              _buildRow(['AC', 'DEL', '(', ')'], isFunction: true),
              const SizedBox(height: 6),
              _buildRow(['7', '8', '9', '÷']),
              const SizedBox(height: 6),
              _buildRow(['4', '5', '6', '×']),
              const SizedBox(height: 6),
              _buildRow(['1', '2', '3', '-']),
              const SizedBox(height: 6),
              _buildRow(['0', '.', '=', '+']),
            ],
          ),
        ),
        const SizedBox(height: 20),
      ],
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
      buttonColor = const Color(0xFF1A1A1A);
      textColor = Colors.cyan;
    } else if (isSpecialFunction) {
      buttonColor = const Color(0xFFFF6B35);
      textColor = Colors.white;
    } else if (isFunction) {
      buttonColor = const Color(0xFF505050);
      textColor = Colors.orange;
    } else if (isOperator) {
      buttonColor = const Color(0xFF505050);
      textColor = Colors.orange;
    } else {
      buttonColor = const Color(0xFF3A3A3A);
      textColor = Colors.white;
    }
    
    return GestureDetector(
      onTap: () => _onButtonPressed(label),
      child: Container(
        width: (MediaQuery.of(context).size.width - 64) / 4,
        height: 55,
        decoration: BoxDecoration(
          color: buttonColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.white.withOpacity(0.15),
              offset: const Offset(-2, -2),
              blurRadius: 4,
            ),
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
              fontSize: label.length > 3 ? 12 : 18,
              fontWeight: FontWeight.bold,
              color: textColor,
            ),
          ),
        ),
      ),
    );
  }
}

// ============================================
// TAB 2: Unit Converter
// ============================================
class _ConverterTab extends StatefulWidget {
  const _ConverterTab();

  @override
  State<_ConverterTab> createState() => _ConverterTabState();
}

class _ConverterTabState extends State<_ConverterTab> {
  String _category = 'Length';
  String _fromUnit = 'Meter';
  String _toUnit = 'Kilometer';
  final TextEditingController _inputController = TextEditingController();
  String _output = '0';

  final Map<String, Map<String, double>> _conversions = {
    'Length': {
      'Meter': 1.0,
      'Kilometer': 0.001,
      'Centimeter': 100.0,
      'Mile': 0.000621371,
      'Foot': 3.28084,
      'Inch': 39.3701,
    },
    'Mass': {
      'Kilogram': 1.0,
      'Gram': 1000.0,
      'Pound': 2.20462,
      'Ounce': 35.274,
      'Ton': 0.001,
    },
    'Temperature': {
      'Celsius': 1.0,
      'Fahrenheit': 1.0,
      'Kelvin': 1.0,
    },
  };

  void _convert() {
    final input = double.tryParse(_inputController.text) ?? 0;
    double result = 0;

    if (_category == 'Temperature') {
      result = _convertTemperature(input, _fromUnit, _toUnit);
    } else {
      final baseValue = input / _conversions[_category]![_fromUnit]!;
      result = baseValue * _conversions[_category]![_toUnit]!;
    }

    setState(() {
      _output = result.toStringAsFixed(4).replaceAll(RegExp(r'0*$'), '').replaceAll(RegExp(r'\.$'), '');
    });
  }

  double _convertTemperature(double value, String from, String to) {
    // Convert to Celsius first
    double celsius = value;
    if (from == 'Fahrenheit') {
      celsius = (value - 32) * 5 / 9;
    } else if (from == 'Kelvin') {
      celsius = value - 273.15;
    }

    // Convert from Celsius to target
    if (to == 'Fahrenheit') {
      return celsius * 9 / 5 + 32;
    } else if (to == 'Kelvin') {
      return celsius + 273.15;
    }
    return celsius;
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // Category Selector
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.cyanAccent.withOpacity(0.3)),
            ),
            child: DropdownButton<String>(
              value: _category,
              isExpanded: true,
              dropdownColor: Colors.grey.shade900,
              underline: const SizedBox(),
              style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
              items: ['Length', 'Mass', 'Temperature']
                  .map((cat) => DropdownMenuItem(value: cat, child: Text(cat)))
                  .toList(),
              onChanged: (val) {
                setState(() {
                  _category = val!;
                  _fromUnit = _conversions[_category]!.keys.first;
                  _toUnit = _conversions[_category]!.keys.toList()[1];
                  _output = '0';
                });
              },
            ),
          ),
          const SizedBox(height: 30),

          // Input Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('From:', style: GoogleFonts.montserrat(color: Colors.grey)),
                const SizedBox(height: 8),
                TextField(
                  controller: _inputController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 24),
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: '0',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (_) => _convert(),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _fromUnit,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade800,
                  underline: const SizedBox(),
                  style: GoogleFonts.montserrat(color: Colors.cyanAccent),
                  items: _conversions[_category]!
                      .keys
                      .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _fromUnit = val!;
                      _convert();
                    });
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),
          const Icon(Icons.arrow_downward, color: Colors.cyanAccent, size: 30),
          const SizedBox(height: 20),

          // Output Section
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF9EA792),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.black, width: 2),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('To:', style: GoogleFonts.montserrat(color: Colors.black54)),
                const SizedBox(height: 8),
                Text(
                  _output,
                  style: GoogleFonts.orbitron(
                    color: Colors.black,
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                DropdownButton<String>(
                  value: _toUnit,
                  isExpanded: true,
                  dropdownColor: Colors.grey.shade800,
                  underline: const SizedBox(),
                  style: GoogleFonts.montserrat(color: Colors.black87, fontWeight: FontWeight.bold),
                  items: _conversions[_category]!
                      .keys
                      .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      _toUnit = val!;
                      _convert();
                    });
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 3: CGPA Calculator
// ============================================
class _CGPATab extends StatefulWidget {
  const _CGPATab();

  @override
  State<_CGPATab> createState() => _CGPATabState();
}

class _CGPATabState extends State<_CGPATab> {
  final List<Map<String, dynamic>> _subjects = [];

  final Map<String, int> _gradePoints = {
    'O': 10,
    'A+': 9,
    'A': 8,
    'B+': 7,
    'B': 6,
    'C': 5,
    'F': 0,
  };

  void _addSubject() {
    setState(() {
      _subjects.add({
        'name': 'Subject ${_subjects.length + 1}',
        'credits': 3,
        'grade': 'A',
      });
    });
  }

  double _calculateSGPA() {
    if (_subjects.isEmpty) return 0.0;
    
    double totalPoints = 0;
    int totalCredits = 0;

    for (var subject in _subjects) {
      final credits = subject['credits'] as int;
      final grade = subject['grade'] as String;
      final points = _gradePoints[grade] ?? 0;
      
      totalPoints += credits * points;
      totalCredits += credits;
    }

    return totalCredits > 0 ? totalPoints / totalCredits : 0.0;
  }

  @override
  Widget build(BuildContext context) {
    final sgpa = _calculateSGPA();

    return Column(
      children: [
        // SGPA Display
        Container(
          margin: const EdgeInsets.all(20),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.cyanAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.3)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.cyanAccent),
          ),
          child: Column(
            children: [
              Text(
                'Your SGPA',
                style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Text(
                sgpa.toStringAsFixed(2),
                style: GoogleFonts.orbitron(
                  color: Colors.cyanAccent,
                  fontSize: 48,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),

        // Subject List
        Expanded(
          child: _subjects.isEmpty
              ? Center(
                  child: Text(
                    'Add subjects to calculate SGPA',
                    style: GoogleFonts.montserrat(color: Colors.grey),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  itemCount: _subjects.length,
                  itemBuilder: (context, index) {
                    final subject = _subjects[index];
                    return Card(
                      color: Colors.grey.shade900,
                      margin: const EdgeInsets.only(bottom: 12),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 2,
                              child: TextField(
                                style: const TextStyle(color: Colors.white),
                                decoration: InputDecoration(
                                  hintText: 'Subject Name',
                                  hintStyle: TextStyle(color: Colors.grey.shade600),
                                  border: InputBorder.none,
                                ),
                                onChanged: (val) {
                                  setState(() {
                                    subject['name'] = val;
                                  });
                                },
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Credits
                            DropdownButton<int>(
                              value: subject['credits'],
                              dropdownColor: Colors.grey.shade800,
                              underline: const SizedBox(),
                              items: [1, 2, 3, 4, 5]
                                  .map((c) => DropdownMenuItem(
                                        value: c,
                                        child: Text('$c', style: const TextStyle(color: Colors.white)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  subject['credits'] = val!;
                                });
                              },
                            ),
                            const SizedBox(width: 8),
                            // Grade
                            DropdownButton<String>(
                              value: subject['grade'],
                              dropdownColor: Colors.grey.shade800,
                              underline: const SizedBox(),
                              items: _gradePoints.keys
                                  .map((g) => DropdownMenuItem(
                                        value: g,
                                        child: Text(g, style: const TextStyle(color: Colors.cyanAccent)),
                                      ))
                                  .toList(),
                              onChanged: (val) {
                                setState(() {
                                  subject['grade'] = val!;
                                });
                              },
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () {
                                setState(() {
                                  _subjects.removeAt(index);
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ),

        // Add Subject Button
        Padding(
          padding: const EdgeInsets.all(20),
          child: ElevatedButton.icon(
            onPressed: _addSubject,
            icon: const Icon(Icons.add),
            label: const Text('Add Subject'),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.cyanAccent,
              foregroundColor: Colors.black,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
            ),
          ),
        ),
      ],
    );
  }
}
