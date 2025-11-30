import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:math_expressions/math_expressions.dart';

class CalculatorScreen extends StatelessWidget {
  const CalculatorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 9,
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
          bottom: TabBar(
            isScrollable: true,
            indicatorColor: Colors.cyanAccent,
            labelColor: Colors.cyanAccent,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(icon: Icon(Icons.calculate), text: 'Calc'),
              Tab(icon: Icon(Icons.swap_horiz), text: 'Convert'),
              Tab(icon: Icon(Icons.school), text: 'CGPA'),
              Tab(icon: Icon(Icons.monitor_weight), text: 'BMI'),
              Tab(icon: Icon(Icons.cake), text: 'Age'),
              Tab(icon: Icon(Icons.functions), text: 'Equation'),
              Tab(icon: Icon(Icons.percent), text: 'Percent'),
              Tab(icon: Icon(Icons.restaurant), text: 'Tip'),
              Tab(icon: Icon(Icons.account_balance), text: 'Loan'),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            _ScientificCalculatorTab(),
            _ConverterTab(),
            _CGPATab(),
            _BMITab(),
            _AgeCalculatorTab(),
            _EquationSolverTab(),
            _PercentageTab(),
            _TipCalculatorTab(),
            _LoanCalculatorTab(),
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
  List<String> _history = [];

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
      } else if (value == 'π') {
        _expression += 'π';
      } else if (value == 'e') {
        _expression += 'e';
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
      
      _history.insert(0, '$_expression = $_result');
      if (_history.length > 10) _history.removeLast();
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
              _buildRow(['π', 'e', '(', ')'], isScientific: true),
              const SizedBox(height: 6),
              _buildRow(['AC', 'DEL', '%', '÷'], isFunction: true),
              const SizedBox(height: 6),
              _buildRow(['7', '8', '9', '×']),
              const SizedBox(height: 6),
              _buildRow(['4', '5', '6', '-']),
              const SizedBox(height: 6),
              _buildRow(['1', '2', '3', '+']),
              const SizedBox(height: 6),
              _buildRow(['0', '.', '=', '=']),
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
    bool isOperator = ['÷', '×', '-', '+', '%'].contains(label);
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
    'Speed': {
      'Meter/Second': 1.0,
      'Kilometer/Hour': 3.6,
      'Mile/Hour': 2.23694,
      'Knot': 1.94384,
    },
    'Area': {
      'Square Meter': 1.0,
      'Square Kilometer': 0.000001,
      'Square Foot': 10.7639,
      'Acre': 0.000247105,
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
    double celsius = value;
    if (from == 'Fahrenheit') {
      celsius = (value - 32) * 5 / 9;
    } else if (from == 'Kelvin') {
      celsius = value - 273.15;
    }

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
              items: _conversions.keys
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


// ============================================
// TAB 4: BMI Calculator
// ============================================
class _BMITab extends StatefulWidget {
  const _BMITab();

  @override
  State<_BMITab> createState() => _BMITabState();
}

class _BMITabState extends State<_BMITab> {
  final TextEditingController _heightController = TextEditingController();
  final TextEditingController _weightController = TextEditingController();
  double _bmi = 0;
  String _category = '';
  String _unit = 'Metric';

  void _calculateBMI() {
    final height = double.tryParse(_heightController.text) ?? 0;
    final weight = double.tryParse(_weightController.text) ?? 0;

    if (height > 0 && weight > 0) {
      double bmi;
      if (_unit == 'Metric') {
        bmi = weight / ((height / 100) * (height / 100));
      } else {
        bmi = (weight / (height * height)) * 703;
      }

      setState(() {
        _bmi = bmi;
        if (bmi < 18.5) {
          _category = 'Underweight';
        } else if (bmi < 25) {
          _category = 'Normal';
        } else if (bmi < 30) {
          _category = 'Overweight';
        } else {
          _category = 'Obese';
        }
      });
    }
  }

  Color _getCategoryColor() {
    switch (_category) {
      case 'Underweight':
        return Colors.blue;
      case 'Normal':
        return Colors.green;
      case 'Overweight':
        return Colors.orange;
      case 'Obese':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          SegmentedButton<String>(
            segments: const [
              ButtonSegment(value: 'Metric', label: Text('Metric (kg/cm)')),
              ButtonSegment(value: 'Imperial', label: Text('Imperial (lb/in)')),
            ],
            selected: {_unit},
            onSelectionChanged: (Set<String> newSelection) {
              setState(() {
                _unit = newSelection.first;
                _heightController.clear();
                _weightController.clear();
                _bmi = 0;
                _category = '';
              });
            },
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _heightController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    labelText: _unit == 'Metric' ? 'Height (cm)' : 'Height (inches)',
                    labelStyle: const TextStyle(color: Colors.cyanAccent),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                  ),
                  onChanged: (_) => _calculateBMI(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: InputDecoration(
                    labelText: _unit == 'Metric' ? 'Weight (kg)' : 'Weight (lbs)',
                    labelStyle: const TextStyle(color: Colors.cyanAccent),
                    border: const OutlineInputBorder(),
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade700),
                    ),
                  ),
                  onChanged: (_) => _calculateBMI(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          if (_bmi > 0)
            Container(
              padding: const EdgeInsets.all(30),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [_getCategoryColor().withOpacity(0.3), _getCategoryColor().withOpacity(0.1)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: _getCategoryColor(), width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Your BMI',
                    style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _bmi.toStringAsFixed(1),
                    style: GoogleFonts.orbitron(
                      color: _getCategoryColor(),
                      fontSize: 56,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                    decoration: BoxDecoration(
                      color: _getCategoryColor(),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      _category,
                      style: GoogleFonts.montserrat(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'BMI Categories:',
                  style: GoogleFonts.montserrat(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                _buildBMICategory('Underweight', '< 18.5', Colors.blue),
                _buildBMICategory('Normal', '18.5 - 24.9', Colors.green),
                _buildBMICategory('Overweight', '25 - 29.9', Colors.orange),
                _buildBMICategory('Obese', '≥ 30', Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBMICategory(String label, String range, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '$label: ',
            style: GoogleFonts.montserrat(color: Colors.white, fontWeight: FontWeight.w600),
          ),
          Text(
            range,
            style: GoogleFonts.montserrat(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 5: Age Calculator
// ============================================
class _AgeCalculatorTab extends StatefulWidget {
  const _AgeCalculatorTab();

  @override
  State<_AgeCalculatorTab> createState() => _AgeCalculatorTabState();
}

class _AgeCalculatorTabState extends State<_AgeCalculatorTab> {
  DateTime? _birthDate;
  DateTime _currentDate = DateTime.now();
  Map<String, int> _age = {};

  void _selectBirthDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: ThemeData.dark().copyWith(
            colorScheme: const ColorScheme.dark(
              primary: Colors.cyanAccent,
              onPrimary: Colors.black,
              surface: Color(0xFF2A2A2A),
              onSurface: Colors.white,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      setState(() {
        _birthDate = picked;
        _calculateAge();
      });
    }
  }

  void _calculateAge() {
    if (_birthDate == null) return;

    int years = _currentDate.year - _birthDate!.year;
    int months = _currentDate.month - _birthDate!.month;
    int days = _currentDate.day - _birthDate!.day;

    if (days < 0) {
      months--;
      days += DateTime(_currentDate.year, _currentDate.month, 0).day;
    }

    if (months < 0) {
      years--;
      months += 12;
    }

    final totalDays = _currentDate.difference(_birthDate!).inDays;
    final totalWeeks = (totalDays / 7).floor();
    final totalMonths = years * 12 + months;

    setState(() {
      _age = {
        'years': years,
        'months': months,
        'days': days,
        'totalDays': totalDays,
        'totalWeeks': totalWeeks,
        'totalMonths': totalMonths,
      };
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Text(
                  'Birth Date',
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 10),
                Text(
                  _birthDate == null
                      ? 'Not Selected'
                      : '${_birthDate!.day}/${_birthDate!.month}/${_birthDate!.year}',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _selectBirthDate,
                  icon: const Icon(Icons.calendar_today),
                  label: const Text('Select Birth Date'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ],
            ),
          ),
          if (_age.isNotEmpty) ...[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(24),
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
                    'Your Age',
                    style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAgeBox('${_age['years']}', 'Years'),
                      _buildAgeBox('${_age['months']}', 'Months'),
                      _buildAgeBox('${_age['days']}', 'Days'),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildDetailRow('Total Months', '${_age['totalMonths']}'),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Total Weeks', '${_age['totalWeeks']}'),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Total Days', '${_age['totalDays']}'),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Total Hours', '${_age['totalDays']! * 24}'),
                  const Divider(color: Colors.grey),
                  _buildDetailRow('Total Minutes', '${_age['totalDays']! * 24 * 60}'),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAgeBox(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontSize: 36,
            fontWeight: FontWeight.bold,
          ),
        ),
        Text(
          label,
          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 14),
        ),
      ],
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16),
          ),
          Text(
            value,
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 6: Equation Solver (Quadratic)
// ============================================
class _EquationSolverTab extends StatefulWidget {
  const _EquationSolverTab();

  @override
  State<_EquationSolverTab> createState() => _EquationSolverTabState();
}

class _EquationSolverTabState extends State<_EquationSolverTab> {
  final TextEditingController _aController = TextEditingController();
  final TextEditingController _bController = TextEditingController();
  final TextEditingController _cController = TextEditingController();
  
  String _solution = '';
  String _steps = '';

  void _solveEquation() {
    final a = double.tryParse(_aController.text) ?? 0;
    final b = double.tryParse(_bController.text) ?? 0;
    final c = double.tryParse(_cController.text) ?? 0;

    if (a == 0) {
      setState(() {
        _solution = 'Error: a cannot be 0';
        _steps = '';
      });
      return;
    }

    final discriminant = b * b - 4 * a * c;
    
    String solution;
    String steps = 'Equation: ${a}x² + ${b}x + $c = 0\n\n';
    steps += 'Discriminant (Δ) = b² - 4ac\n';
    steps += 'Δ = (${b})² - 4(${a})(${c})\n';
    steps += 'Δ = ${discriminant.toStringAsFixed(2)}\n\n';

    if (discriminant > 0) {
      final x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      final x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      solution = 'Two Real Solutions:\nx₁ = ${x1.toStringAsFixed(4)}\nx₂ = ${x2.toStringAsFixed(4)}';
      steps += 'Since Δ > 0, two real solutions exist.\n\n';
      steps += 'x = (-b ± √Δ) / 2a\n';
      steps += 'x₁ = (${-b} + ${math.sqrt(discriminant).toStringAsFixed(2)}) / ${2 * a}\n';
      steps += 'x₂ = (${-b} - ${math.sqrt(discriminant).toStringAsFixed(2)}) / ${2 * a}';
    } else if (discriminant == 0) {
      final x = -b / (2 * a);
      solution = 'One Real Solution:\nx = ${x.toStringAsFixed(4)}';
      steps += 'Since Δ = 0, one real solution exists.\n\n';
      steps += 'x = -b / 2a\n';
      steps += 'x = ${-b} / ${2 * a}';
    } else {
      final realPart = -b / (2 * a);
      final imagPart = math.sqrt(-discriminant) / (2 * a);
      solution = 'Two Complex Solutions:\nx₁ = ${realPart.toStringAsFixed(4)} + ${imagPart.toStringAsFixed(4)}i\nx₂ = ${realPart.toStringAsFixed(4)} - ${imagPart.toStringAsFixed(4)}i';
      steps += 'Since Δ < 0, two complex solutions exist.\n\n';
      steps += 'x = (-b ± i√|Δ|) / 2a';
    }

    setState(() {
      _solution = solution;
      _steps = steps;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Quadratic Equation Solver',
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
          Text(
            'ax² + bx + c = 0',
            style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 18),
          ),
          const SizedBox(height: 30),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _aController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          labelText: 'a',
                          labelStyle: TextStyle(color: Colors.cyanAccent, fontSize: 24),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _bController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          labelText: 'b',
                          labelStyle: TextStyle(color: Colors.cyanAccent, fontSize: 24),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _cController,
                        keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                        style: const TextStyle(color: Colors.white, fontSize: 20),
                        decoration: const InputDecoration(
                          labelText: 'c',
                          labelStyle: TextStyle(color: Colors.cyanAccent, fontSize: 24),
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  onPressed: _solveEquation,
                  icon: const Icon(Icons.calculate),
                  label: const Text('Solve'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.cyanAccent,
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    minimumSize: const Size(double.infinity, 50),
                  ),
                ),
              ],
            ),
          ),
          if (_solution.isNotEmpty) ...[
            const SizedBox(height: 30),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.3), Colors.teal.withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solution:',
                    style: GoogleFonts.orbitron(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _solution,
                    style: GoogleFonts.orbitron(
                      color: Colors.greenAccent,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Steps:',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _steps,
                    style: GoogleFonts.robotoMono(
                      color: Colors.white70,
                      fontSize: 14,
                      height: 1.5,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

// ============================================
// TAB 7: Percentage Calculator
// ============================================
class _PercentageTab extends StatefulWidget {
  const _PercentageTab();

  @override
  State<_PercentageTab> createState() => _PercentageTabState();
}

class _PercentageTabState extends State<_PercentageTab> {
  final TextEditingController _valueController = TextEditingController();
  final TextEditingController _percentController = TextEditingController();
  final TextEditingController _totalController = TextEditingController();
  
  double _percentOfValue = 0;
  double _percentageResult = 0;
  double _increaseResult = 0;
  double _decreaseResult = 0;

  void _calculate() {
    final value = double.tryParse(_valueController.text) ?? 0;
    final percent = double.tryParse(_percentController.text) ?? 0;
    final total = double.tryParse(_totalController.text) ?? 0;

    setState(() {
      _percentOfValue = (percent / 100) * value;
      _percentageResult = total > 0 ? (value / total) * 100 : 0;
      _increaseResult = value + (value * percent / 100);
      _decreaseResult = value - (value * percent / 100);
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          // What is X% of Y?
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'What is X% of Y?',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _percentController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Percent (%)',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('of', style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _valueController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9EA792),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Result:',
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        _percentOfValue.toStringAsFixed(2),
                        style: GoogleFonts.orbitron(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // X is what % of Y?
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'X is what % of Y?',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _valueController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Value',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8),
                      child: Text('of', style: TextStyle(color: Colors.white70)),
                    ),
                    Expanded(
                      child: TextField(
                        controller: _totalController,
                        keyboardType: TextInputType.number,
                        style: const TextStyle(color: Colors.white),
                        decoration: const InputDecoration(
                          labelText: 'Total',
                          labelStyle: TextStyle(color: Colors.grey),
                          border: OutlineInputBorder(),
                        ),
                        onChanged: (_) => _calculate(),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: const Color(0xFF9EA792),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Result:',
                        style: GoogleFonts.montserrat(
                          color: Colors.black87,
                          fontSize: 16,
                        ),
                      ),
                      Text(
                        '${_percentageResult.toStringAsFixed(2)}%',
                        style: GoogleFonts.orbitron(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          // Increase/Decrease by %
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Increase/Decrease by %',
                  style: GoogleFonts.orbitron(
                    color: Colors.cyanAccent,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.green),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.arrow_upward, color: Colors.green),
                            const SizedBox(height: 8),
                            Text(
                              'Increase',
                              style: GoogleFonts.montserrat(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _increaseResult.toStringAsFixed(2),
                              style: GoogleFonts.orbitron(
                                color: Colors.green,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.red.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: Colors.red),
                        ),
                        child: Column(
                          children: [
                            const Icon(Icons.arrow_downward, color: Colors.red),
                            const SizedBox(height: 8),
                            Text(
                              'Decrease',
                              style: GoogleFonts.montserrat(color: Colors.white70),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              _decreaseResult.toStringAsFixed(2),
                              style: GoogleFonts.orbitron(
                                color: Colors.red,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
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
// TAB 8: Tip Calculator
// ============================================
class _TipCalculatorTab extends StatefulWidget {
  const _TipCalculatorTab();

  @override
  State<_TipCalculatorTab> createState() => _TipCalculatorTabState();
}

class _TipCalculatorTabState extends State<_TipCalculatorTab> {
  final TextEditingController _billController = TextEditingController();
  double _tipPercent = 15;
  int _splitCount = 1;
  
  double _tipAmount = 0;
  double _totalAmount = 0;
  double _perPerson = 0;

  void _calculate() {
    final bill = double.tryParse(_billController.text) ?? 0;
    
    setState(() {
      _tipAmount = bill * (_tipPercent / 100);
      _totalAmount = bill + _tipAmount;
      _perPerson = _splitCount > 0 ? _totalAmount / _splitCount : 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bill Amount',
                  style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 14),
                ),
                const SizedBox(height: 8),
                TextField(
                  controller: _billController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 32),
                  decoration: const InputDecoration(
                    prefixText: '\$ ',
                    prefixStyle: TextStyle(color: Colors.cyanAccent, fontSize: 32),
                    border: InputBorder.none,
                    hintText: '0.00',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Tip Percentage',
                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
                    ),
                    Text(
                      '${_tipPercent.toInt()}%',
                      style: GoogleFonts.orbitron(
                        color: Colors.cyanAccent,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Slider(
                  value: _tipPercent,
                  min: 0,
                  max: 50,
                  divisions: 50,
                  activeColor: Colors.cyanAccent,
                  inactiveColor: Colors.grey,
                  onChanged: (val) {
                    setState(() {
                      _tipPercent = val;
                      _calculate();
                    });
                  },
                ),
                const SizedBox(height: 8),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [10, 15, 18, 20, 25].map((percent) {
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _tipPercent = percent.toDouble();
                          _calculate();
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: _tipPercent == percent 
                              ? Colors.cyanAccent 
                              : Colors.grey.shade800,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '$percent%',
                          style: TextStyle(
                            color: _tipPercent == percent 
                                ? Colors.black 
                                : Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Split Between',
                      style: GoogleFonts.montserrat(color: Colors.white, fontSize: 16),
                    ),
                    Row(
                      children: [
                        IconButton(
                          onPressed: () {
                            if (_splitCount > 1) {
                              setState(() {
                                _splitCount--;
                                _calculate();
                              });
                            }
                          },
                          icon: const Icon(Icons.remove_circle, color: Colors.red),
                        ),
                        Text(
                          '$_splitCount',
                          style: GoogleFonts.orbitron(
                            color: Colors.cyanAccent,
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () {
                            setState(() {
                              _splitCount++;
                              _calculate();
                            });
                          },
                          icon: const Icon(Icons.add_circle, color: Colors.green),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.cyanAccent.withOpacity(0.3), Colors.blueAccent.withOpacity(0.3)],
              ),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.cyanAccent),
            ),
            child: Column(
              children: [
                _buildResultRow('Tip Amount', '\$${_tipAmount.toStringAsFixed(2)}'),
                const Divider(color: Colors.white30, height: 32),
                _buildResultRow('Total Amount', '\$${_totalAmount.toStringAsFixed(2)}'),
                const Divider(color: Colors.white30, height: 32),
                _buildResultRow('Per Person', '\$${_perPerson.toStringAsFixed(2)}', isLarge: true),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildResultRow(String label, String value, {bool isLarge = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(
            color: Colors.white70,
            fontSize: isLarge ? 18 : 16,
          ),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontSize: isLarge ? 32 : 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

// ============================================
// TAB 9: Loan Calculator
// ============================================
class _LoanCalculatorTab extends StatefulWidget {
  const _LoanCalculatorTab();

  @override
  State<_LoanCalculatorTab> createState() => _LoanCalculatorTabState();
}

class _LoanCalculatorTabState extends State<_LoanCalculatorTab> {
  final TextEditingController _principalController = TextEditingController();
  final TextEditingController _rateController = TextEditingController();
  final TextEditingController _yearsController = TextEditingController();
  
  double _monthlyPayment = 0;
  double _totalPayment = 0;
  double _totalInterest = 0;

  void _calculate() {
    final principal = double.tryParse(_principalController.text) ?? 0;
    final annualRate = double.tryParse(_rateController.text) ?? 0;
    final years = double.tryParse(_yearsController.text) ?? 0;

    if (principal > 0 && annualRate > 0 && years > 0) {
      final monthlyRate = annualRate / 100 / 12;
      final numPayments = years * 12;
      
      final monthly = principal * 
          (monthlyRate * math.pow(1 + monthlyRate, numPayments)) / 
          (math.pow(1 + monthlyRate, numPayments) - 1);
      
      final total = monthly * numPayments;
      final interest = total - principal;

      setState(() {
        _monthlyPayment = monthly;
        _totalPayment = total;
        _totalInterest = interest;
      });
    } else {
      setState(() {
        _monthlyPayment = 0;
        _totalPayment = 0;
        _totalInterest = 0;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.grey.shade900,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              children: [
                TextField(
                  controller: _principalController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: 'Loan Amount (\$)',
                    labelStyle: TextStyle(color: Colors.cyanAccent),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.attach_money, color: Colors.cyanAccent),
                  ),
                  onChanged: (_) => _calculate(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _rateController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: 'Annual Interest Rate (%)',
                    labelStyle: TextStyle(color: Colors.cyanAccent),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.percent, color: Colors.cyanAccent),
                  ),
                  onChanged: (_) => _calculate(),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _yearsController,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 20),
                  decoration: const InputDecoration(
                    labelText: 'Loan Term (Years)',
                    labelStyle: TextStyle(color: Colors.cyanAccent),
                    border: OutlineInputBorder(),
                    prefixIcon: Icon(Icons.calendar_today, color: Colors.cyanAccent),
                  ),
                  onChanged: (_) => _calculate(),
                ),
              ],
            ),
          ),
          const SizedBox(height: 30),
          
          if (_monthlyPayment > 0) ...[
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.green.withOpacity(0.3), Colors.teal.withOpacity(0.3)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.green, width: 2),
              ),
              child: Column(
                children: [
                  Text(
                    'Monthly Payment',
                    style: GoogleFonts.orbitron(color: Colors.white70, fontSize: 16),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    '\$${_monthlyPayment.toStringAsFixed(2)}',
                    style: GoogleFonts.orbitron(
                      color: Colors.greenAccent,
                      fontSize: 48,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  _buildLoanDetailRow('Total Payment', '\$${_totalPayment.toStringAsFixed(2)}'),
                  const Divider(color: Colors.grey, height: 32),
                  _buildLoanDetailRow('Total Interest', '\$${_totalInterest.toStringAsFixed(2)}'),
                  const Divider(color: Colors.grey, height: 32),
                  _buildLoanDetailRow('Principal', '\$${_principalController.text}'),
                  const Divider(color: Colors.grey, height: 32),
                  _buildLoanDetailRow('Number of Payments', '${(double.tryParse(_yearsController.text) ?? 0) * 12}'),
                ],
              ),
            ),
            const SizedBox(height: 20),
            
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.grey.shade900,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Payment Breakdown',
                    style: GoogleFonts.orbitron(
                      color: Colors.cyanAccent,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        flex: (_principalController.text.isNotEmpty 
                            ? double.parse(_principalController.text) 
                            : 0).toInt(),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(8),
                              bottomLeft: Radius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Principal',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: _totalInterest.toInt(),
                        child: Container(
                          height: 40,
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: const BorderRadius.only(
                              topRight: Radius.circular(8),
                              bottomRight: Radius.circular(8),
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              'Interest',
                              style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildLoanDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.montserrat(color: Colors.white70, fontSize: 16),
        ),
        Text(
          value,
          style: GoogleFonts.orbitron(
            color: Colors.cyanAccent,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
