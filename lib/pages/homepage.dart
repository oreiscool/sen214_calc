import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sen214_calc/widgets/display.dart';
import '../widgets/standard_mathpad.dart';
import '../widgets/scientific_mathpad.dart';
import '../utils/math_utils.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isCompact = false;
  bool _isRad = true;
  String _inputExpression = '0';
  String _resultString = '';
  bool _showHighlight = false;
  bool _isResultState = false;
  int _cursorPosition = 0;

  void _toggleCompact() {
    HapticFeedback.lightImpact();
    setState(() {
      _isCompact = !_isCompact;
    });
  }

  String sanitizeInput(String text) {
    String sanitized = text
        .replaceAll('*', '×')
        .replaceAll('/', '÷')
        .replaceAll('x', '×');
    
    final allowedRegex = RegExp(r'[0-9+\-×÷%().^√πe²³ⁿ!⁻¹PᵣC∛sincotalgprdbe]');
    sanitized = sanitized.split('').where((char) => allowedRegex.hasMatch(char)).join('');
    return sanitized;
  }
  
  bool _validateAndAlert(String newExpr) {
    // 1. Check operator count
    final operatorRegex = RegExp(r'[+\-×÷%^√∛]|ⁿPᵣ|ⁿCᵣ');
    if (operatorRegex.allMatches(newExpr).length > 40) {
      _showSnackBar("Exceeding 40 operators in the expression");
      return false;
    }

    // 2. Check digit count per number
    final numberRegex = RegExp(r'[0-9.]+');
    for (final match in numberRegex.allMatches(newExpr)) {
      final numStr = match.group(0)!;
      final digitCount = numStr.replaceAll('.', '').length;
      if (digitCount > 15) {
        _showSnackBar("Exceeding 15 digits in a single number");
        return false;
      }
    }

    return true;
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  String _mapButtonValue(String value) {
    switch (value) {
      case 'sin': return 'sin(';
      case 'cos': return 'cos(';
      case 'tan': return 'tan(';
      case 'sin⁻¹': return 'asin(';
      case 'cos⁻¹': return 'acos(';
      case 'tan⁻¹': return 'atan(';
      case 'sinh': return 'sinh(';
      case 'cosh': return 'cosh(';
      case 'tanh': return 'tanh(';
      case 'sinh⁻¹': return 'asinh(';
      case 'cosh⁻¹': return 'acosh(';
      case 'tanh⁻¹': return 'atanh(';
      case 'ln': return 'ln(';
      case 'log': return 'log(';
      case '√': return '√(';
      case '∛': return '∛(';
      case '|x|': return 'abs(';
      case '1/x': return '1÷(';
      case 'eˣ': return 'e^(';
      case 'x²': return '²';
      case 'x³': return '³';
      case 'xⁿ': return '^';
      case '(-)': return '-';
      default: return value;
    }
  }

  String _handleParentheses() {
    int openCount = 0;
    int closeCount = 0;
    for (int i = 0; i < _inputExpression.length; i++) {
      if (_inputExpression[i] == '(') openCount++;
      if (_inputExpression[i] == ')') closeCount++;
    }
    
    if (openCount > closeCount) {
      final lastChar = _inputExpression.isNotEmpty ? _inputExpression[_inputExpression.length - 1] : '';
      if (RegExp(r'[0-9)πe!²³]').hasMatch(lastChar)) {
        return ')';
      }
    }
    return '(';
  }

  void _evaluate() {
    try {
      double result = evaluateExpression(_inputExpression, _isRad);
      
      String resultText;
      if (result == result.toInt()) {
        resultText = result.toInt().toString();
      } else {
        resultText = result.toString();
        if (resultText.length > 20) {
          resultText = result.toStringAsPrecision(12);
        }
      }

      setState(() {
        _inputExpression = resultText;
        _resultString = '';
        _showHighlight = true;
        _isResultState = true;
        _cursorPosition = resultText.length;
      });
    } catch (e) {
      _showSnackBar("Invalid Expression");
    }
  }

  void _calculateLiveResult() {
    if (_inputExpression.isEmpty || _inputExpression == '0') {
      setState(() {
        _resultString = '';
      });
      return;
    }
    try {
      double result = evaluateExpression(_inputExpression, _isRad);
      String resultText;
      if (result == result.toInt()) {
        resultText = result.toInt().toString();
      } else {
        resultText = result.toString();
        if (resultText.length > 20) {
          resultText = result.toStringAsPrecision(12);
        }
      }
      setState(() {
        _resultString = resultText;
      });
    } catch (_) {
      setState(() {
        _resultString = '';
      });
    }
  }

  void onButtonPressed(String value) {
    HapticFeedback.lightImpact();

    if (value == 'AC') {
      setState(() {
        _inputExpression = '0';
        _resultString = '';
        _showHighlight = false;
        _isResultState = false;
        _cursorPosition = 1;
      });
      return;
    } 
    
    if (value == 'DEL') {
      setState(() {
        _showHighlight = false;
        _isResultState = false;
        if (_inputExpression.isNotEmpty && _inputExpression != '0') {
          final pos = _cursorPosition.clamp(0, _inputExpression.length);
          if (pos > 0) {
            final tokens = [
              'asinh(', 'acosh(', 'atanh(', 
              'sinh(', 'cosh(', 'tanh(', 
              'asin(', 'acos(', 'atan(', 
              'sin(', 'cos(', 'tan(', 
              'ln(', 'log(', '√(', '∛(', 
              'abs(', '1÷(', 'e^('
            ];
            bool tokenDeleted = false;
            for (final token in tokens) {
              if (pos >= token.length && _inputExpression.substring(pos - token.length, pos) == token) {
                _inputExpression = _inputExpression.substring(0, pos - token.length) + _inputExpression.substring(pos);
                _cursorPosition = pos - token.length;
                tokenDeleted = true;
                break;
              }
            }
            if (!tokenDeleted) {
              _inputExpression = _inputExpression.substring(0, pos - 1) + _inputExpression.substring(pos);
              _cursorPosition = pos - 1;
            }
            if (_inputExpression.isEmpty) {
              _inputExpression = '0';
              _cursorPosition = 1;
            }
          }
        }
      });
      _calculateLiveResult();
      return;
    } 
    
    if (value == '=') {
      _evaluate();
      return;
    } 
    
    if (value == 'Rad' || value == 'Deg') {
      setState(() {
        _isRad = !_isRad;
      });
      _calculateLiveResult();
      return;
    }

    final mappedValue = value == '()' ? _handleParentheses() : _mapButtonValue(value);
    final isOperator = ['+', '-', '×', '÷', '%', '^', 'ⁿPᵣ', 'ⁿCᵣ'].contains(mappedValue);
    
    String nextExpr;
    int nextCursorPos;
    if (_isResultState) {
      if (isOperator) {
        nextExpr = _inputExpression + mappedValue;
        nextCursorPos = nextExpr.length;
      } else {
        nextExpr = mappedValue;
        nextCursorPos = mappedValue.length;
      }
    } else if (_inputExpression == '0') {
      nextExpr = (isOperator || mappedValue == '.') ? _inputExpression + mappedValue : mappedValue;
      nextCursorPos = nextExpr.length;
    } else if (_cursorPosition < _inputExpression.length) {
      nextExpr = _inputExpression.substring(0, _cursorPosition) + mappedValue + _inputExpression.substring(_cursorPosition);
      nextCursorPos = _cursorPosition + mappedValue.length;
    } else {
      nextExpr = _inputExpression + mappedValue;
      nextCursorPos = nextExpr.length;
    }

    String sanitized = sanitizeInput(nextExpr);
    if (_validateAndAlert(sanitized)) {
      setState(() {
        _inputExpression = sanitized;
        _showHighlight = false;
        _isResultState = false;
        _cursorPosition = sanitized.length == nextExpr.length ? nextCursorPos : sanitized.length;
      });
      _calculateLiveResult();
    }
  }

  void _onDisplayChanged(String val) {
    String sanitized = sanitizeInput(val);
    if (sanitized.length != val.length) {
      _showSnackBar("Attempting to paste non-mathematical characters");
    }

    if (_validateAndAlert(sanitized)) {
      setState(() {
        _inputExpression = sanitized;
        _showHighlight = false;
        _isResultState = false;
        _cursorPosition = sanitized.length;
      });
      _calculateLiveResult();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      HapticFeedback.lightImpact();
                      setState(() {
                        _isRad = !_isRad;
                      });
                      _calculateLiveResult();
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(13),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        _isRad ? 'RAD' : 'DEG',
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Text(
                        _isCompact ? 'SCI' : 'STD',
                        style: const TextStyle(
                          color: Colors.white54,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.5,
                        ),
                      ),
                      const SizedBox(width: 8),
                      GestureDetector(
                        onTap: _toggleCompact,
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: Colors.white.withAlpha(13),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(
                            _isCompact
                                ? Icons.compress
                                : Icons.expand,
                            color: Colors.white70,
                            size: 22,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Expanded(
                flex: 45,
                child: Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                    child: Display(
                      inputExpression: _inputExpression,
                      resultString: _resultString,
                      showHighlight: _showHighlight,
                      cursorPosition: _cursorPosition,
                      onChanged: _onDisplayChanged,
                      onCursorChanged: (pos) {
                        _cursorPosition = pos;
                      },
                    ),
                ),
              ),
              Expanded(
                flex: 55,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final totalHeight = constraints.maxHeight;
                    const gapHeight = 8.0;
                    final scientificTargetHeight = (totalHeight - gapHeight) * (4.0 / 9.0);

                    return Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: _isCompact ? scientificTargetHeight : 0,
                          child: ClipRect(
                            child: OverflowBox(
                              minHeight: 0,
                              maxHeight: scientificTargetHeight,
                              alignment: Alignment.bottomCenter,
                              child: ScientificMathpad(
                                isCompact: true,
                                isRad: _isRad,
                                onButtonPressed: onButtonPressed,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: _isCompact ? gapHeight : 0,
                        ),
                        Expanded(
                          child: StandardMathpad(
                            isCompact: _isCompact,
                            onButtonPressed: onButtonPressed,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
