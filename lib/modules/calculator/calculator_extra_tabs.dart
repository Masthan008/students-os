import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;

// ============================================
// TAB 6: Equation Solver
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

  void _solveQuadratic() {
    final a = double.tryParse(_aController.text) ?? 0;
    final b = double.tryParse(_bController.text) ?? 0;
    final c = double.tryParse(_cController.text) ?? 0;

    if (a == 0) {
      setState(() {
        _solution = 'Not a quadratic equation (a cannot be 0)';
      });
      return;
    }

    final discriminant = b * b - 4 * a * c;

    if (discriminant > 0) {
      final x1 = (-b + math.sqrt(discriminant)) / (2 * a);
      final x2 = (-b - math.sqrt(discriminant)) / (2 * a);
      setState(() {
        _solution = 'Two real solutions:\nx₁ = ${x1.toStringAsFixed(4)}\nx₂ = ${x2.toStringAsFixed(4)}';
      });
    } else if (discriminant == 0) {
      final x = -b / (2 * a);
      setState(() {
        _solution = 'One real solution:\nx = ${x.toStringAsFixed(4)}';
      });
    } else {
      final realPart = -b / (2 * a);
      final imaginaryPart = math.sqrt(-discriminant) / (2 * a);
      setState(() {
        _solution = 'Two complex solutions:\nx₁ = ${realPart.toStringAsFixed(4)} + ${imaginaryPart.toStringAsFixed(4)}i\nx₂ = ${realPart.toStringAsFixed(4)} - ${imaginaryPart.toStringAsFixed(4)}i';
      });
    }
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
            style: GoogleFonts.montserrat(color: Colors.grey, fontSize: 16),
          ),
          const SizedBox(height: 30),
          
          // Coefficient inputs
          _buildCoefficientField('a', _aController),
          const SizedBox(height: 16),
          _buildCoefficientField('b', _bController),
          const SizedBox(height: 16),
          _buildCoefficientField('c', _cController),
          const SizedBox(height: 30),

          // Solve button
          Center(
            child: ElevatedButton(
              onPressed: _solveQuadratic,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('Solve', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 30),

          // Solution display
          if (_solution.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF9EA792),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Solution:',
                    style: GoogleFonts.orbitron(
                      color: Colors.black54,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _solution,
                    style: GoogleFonts.orbitron(
                      color: Colors.black,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCoefficientField(String label, TextEditingController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Text(
            '$label = ',
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
              style: const TextStyle(color: Colors.white, fontSize: 20),
              decoration: const InputDecoration(
                border: InputBorder.none,
                hintText: '0',
                hintStyle: TextStyle(color: Colors.grey),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ============================================
// TAB 7: Matrix Calculator
// ============================================
class _MatrixCalculatorTab extends StatefulWidget {
  const _MatrixCalculatorTab();

  @override
  State<_MatrixCalculatorTab> createState() => _MatrixCalculatorTabState();
}

class _MatrixCalculatorTabState extends State<_MatrixCalculatorTab> {
  int _rows = 2;
  int _cols = 2;
  List<List<TextEditingController>> _matrixA = [];
  List<List<TextEditingController>> _matrixB = [];
  String _result = '';
  String _operation = 'Add';

  @override
  void initState() {
    super.initState();
    _initializeMatrices();
  }

  void _initializeMatrices() {
    _matrixA = List.generate(
      _rows,
      (i) => List.generate(_cols, (j) => TextEditingController(text: '0')),
    );
    _matrixB = List.generate(
      _rows,
      (i) => List.generate(_cols, (j) => TextEditingController(text: '0')),
    );
  }

  void _resizeMatrices(int rows, int cols) {
    setState(() {
      _rows = rows;
      _cols = cols;
      _initializeMatrices();
      _result = '';
    });
  }

  void _calculate() {
    try {
      final matA = _matrixA.map((row) => 
        row.map((controller) => double.tryParse(controller.text) ?? 0).toList()
      ).toList();
      
      final matB = _matrixB.map((row) => 
        row.map((controller) => double.tryParse(controller.text) ?? 0).toList()
      ).toList();

      List<List<double>> resultMatrix = [];

      if (_operation == 'Add') {
        resultMatrix = List.generate(_rows, (i) => 
          List.generate(_cols, (j) => matA[i][j] + matB[i][j])
        );
      } else if (_operation == 'Subtract') {
        resultMatrix = List.generate(_rows, (i) => 
          List.generate(_cols, (j) => matA[i][j] - matB[i][j])
        );
      } else if (_operation == 'Multiply') {
        if (_cols != _rows) {
          setState(() {
            _result = 'For multiplication, matrix must be square or compatible';
          });
          return;
        }
        resultMatrix = List.generate(_rows, (i) => 
          List.generate(_cols, (j) {
            double sum = 0;
            for (int k = 0; k < _cols; k++) {
              sum += matA[i][k] * matB[k][j];
            }
            return sum;
          })
        );
      }

      String resultStr = '';
      for (var row in resultMatrix) {
        resultStr += row.map((val) => val.toStringAsFixed(2)).join('  ') + '\n';
      }

      setState(() {
        _result = resultStr;
      });
    } catch (e) {
      setState(() {
        _result = 'Error: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Matrix Calculator',
            style: GoogleFonts.orbitron(
              color: Colors.cyanAccent,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),

          // Size selector
          Row(
            children: [
              Text('Size:', style: GoogleFonts.montserrat(color: Colors.white)),
              const SizedBox(width: 16),
              DropdownButton<int>(
                value: _rows,
                dropdownColor: Colors.grey.shade800,
                items: [2, 3, 4].map((size) => 
                  DropdownMenuItem(value: size, child: Text('${size}x$size', style: const TextStyle(color: Colors.white)))
                ).toList(),
                onChanged: (val) => _resizeMatrices(val!, val),
              ),
              const Spacer(),
              DropdownButton<String>(
                value: _operation,
                dropdownColor: Colors.grey.shade800,
                items: ['Add', 'Subtract', 'Multiply'].map((op) => 
                  DropdownMenuItem(value: op, child: Text(op, style: const TextStyle(color: Colors.cyanAccent)))
                ).toList(),
                onChanged: (val) => setState(() => _operation = val!),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Matrix A
          Text('Matrix A:', style: GoogleFonts.montserrat(color: Colors.grey)),
          const SizedBox(height: 8),
          _buildMatrix(_matrixA),
          const SizedBox(height: 20),

          // Matrix B
          Text('Matrix B:', style: GoogleFonts.montserrat(color: Colors.grey)),
          const SizedBox(height: 8),
          _buildMatrix(_matrixB),
          const SizedBox(height: 20),

          // Calculate button
          Center(
            child: ElevatedButton(
              onPressed: _calculate,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.cyanAccent,
                foregroundColor: Colors.black,
                padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              ),
              child: const Text('Calculate', style: TextStyle(fontSize: 18)),
            ),
          ),
          const SizedBox(height: 20),

          // Result
          if (_result.isNotEmpty)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF9EA792),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.black, width: 2),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Result:',
                    style: GoogleFonts.orbitron(color: Colors.black54, fontSize: 14),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    _result,
                    style: GoogleFonts.robotoMono(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMatrix(List<List<TextEditingController>> matrix) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade900,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: List.generate(_rows, (i) => 
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(_cols, (j) => 
                Expanded(
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: TextField(
                      controller: matrix[i][j],
                      keyboardType: const TextInputType.numberWithOptions(decimal: true, signed: true),
                      textAlign: TextAlign.center,
                      style: const TextStyle(color: Colors.white, fontSize: 16),
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        isDense: true,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    for (var row in _matrixA) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    for (var row in _matrixB) {
      for (var controller in row) {
        controller.dispose();
      }
    }
    super.dispose();
  }
}
