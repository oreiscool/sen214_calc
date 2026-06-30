import 'package:math_expressions/math_expressions.dart';

double factorial(double n) {
  if (n < 0) throw ArgumentError("Factorial of negative number");
  int val = n.round();
  double result = 1;
  for (int i = 2; i <= val; i++) {
    result *= i;
  }
  return result;
}

double permutations(double n, double r) {
  if (n < r) return 0;
  return factorial(n) / factorial(n - r);
}

double combinations(double n, double r) {
  if (n < r) return 0;
  return factorial(n) / (factorial(r) * factorial(n - r));
}

String evaluateFactorials(String expr) {
  final regexNum = RegExp(r'([0-9.]+)!');
  String processed = expr;
  while (true) {
    final match = regexNum.firstMatch(processed);
    if (match == null) break;
    double val = double.parse(match.group(1)!);
    double factVal = factorial(val);
    processed = processed.replaceFirst(match.group(0)!, factVal.toString());
  }
  return processed;
}

String evaluatePermutationsAndCombinations(String expr) {
  final regexP = RegExp(r'([0-9.]+)nPr([0-9.]+)');
  final regexC = RegExp(r'([0-9.]+)nCr([0-9.]+)');
  String processed = expr;
  
  while (true) {
    final match = regexP.firstMatch(processed);
    if (match == null) break;
    double n = double.parse(match.group(1)!);
    double r = double.parse(match.group(2)!);
    double val = permutations(n, r);
    processed = processed.replaceFirst(match.group(0)!, val.toString());
  }
  
  while (true) {
    final match = regexC.firstMatch(processed);
    if (match == null) break;
    double n = double.parse(match.group(1)!);
    double r = double.parse(match.group(2)!);
    double val = combinations(n, r);
    processed = processed.replaceFirst(match.group(0)!, val.toString());
  }
  
  return processed;
}

String resolveCubeRoots(String expr) {
  String processed = expr;
  while (true) {
    int index = processed.indexOf('∛(');
    if (index == -1) break;
    
    int openCount = 1;
    int closeIndex = -1;
    for (int i = index + 2; i < processed.length; i++) {
      if (processed[i] == '(') openCount++;
      if (processed[i] == ')') openCount--;
      if (openCount == 0) {
        closeIndex = i;
        break;
      }
    }
    if (closeIndex == -1) break;
    
    String inner = processed.substring(index + 2, closeIndex);
    processed = processed.replaceRange(index, closeIndex + 1, '(($inner)^(1/3))');
  }
  return processed;
}

String resolveHyperbolic(String expr) {
  String processed = expr;
  
  String replaceFunc(String text, String funcName, String Function(String) generator) {
    String temp = text;
    while (true) {
      int index = temp.indexOf('$funcName(');
      if (index == -1) break;
      
      int openCount = 1;
      int closeIndex = -1;
      for (int i = index + funcName.length + 1; i < temp.length; i++) {
        if (temp[i] == '(') openCount++;
        if (temp[i] == ')') openCount--;
        if (openCount == 0) {
          closeIndex = i;
          break;
        }
      }
      if (closeIndex == -1) break;
      String inner = temp.substring(index + funcName.length + 1, closeIndex);
      String replacement = generator(inner);
      temp = temp.replaceRange(index, closeIndex + 1, '($replacement)');
    }
    return temp;
  }

  processed = replaceFunc(processed, 'asinh', (x) => 'ln(($x) + sqrt(($x)^2 + 1))');
  processed = replaceFunc(processed, 'acosh', (x) => 'ln(($x) + sqrt(($x)^2 - 1))');
  processed = replaceFunc(processed, 'atanh', (x) => '0.5 * ln((1 + ($x)) / (1 - ($x)))');
  processed = replaceFunc(processed, 'sinh', (x) => '(e^($x) - e^(-$x)) / 2');
  processed = replaceFunc(processed, 'cosh', (x) => '(e^($x) + e^(-$x)) / 2');
  processed = replaceFunc(processed, 'tanh', (x) => '(e^($x) - e^(-$x)) / (e^($x) + e^(-$x))');
  
  return processed;
}

String resolvePercents(String expr) {
  String processed = expr;
  while (true) {
    int index = processed.indexOf('%');
    if (index == -1) break;
    
    if (index > 0 && processed[index - 1] == ')') {
      int closeCount = 1;
      int openIndex = -1;
      for (int i = index - 2; i >= 0; i--) {
        if (processed[i] == ')') closeCount++;
        if (processed[i] == '(') closeCount--;
        if (closeCount == 0) {
          openIndex = i;
          break;
        }
      }
      if (openIndex != -1) {
        String inner = processed.substring(openIndex, index);
        processed = processed.replaceRange(openIndex, index + 1, '(($inner)/100)');
      } else {
        processed = processed.replaceRange(index, index + 1, '/100');
      }
    } else {
      int start = index - 1;
      while (start >= 0 && RegExp(r'[0-9.]').hasMatch(processed[start])) {
        start--;
      }
      start++;
      String numStr = processed.substring(start, index);
      processed = processed.replaceRange(start, index + 1, '(($numStr)/100)');
    }
  }
  return processed;
}

String resolveTrigMode(String expr, bool isRad) {
  if (isRad) return expr;
  
  String temp = expr;
  
  String replaceTrigArgs(String text, String func) {
    String s = text;
    int pos = 0;
    while (true) {
      int index = s.indexOf('$func(', pos);
      if (index == -1) break;
      
      if (index > 0 && s[index - 1] == 'a') {
        pos = index + func.length + 1;
        continue;
      }
      if (index + func.length < s.length && s[index + func.length] == 'h') {
        pos = index + func.length + 1;
        continue;
      }
      
      int openCount = 1;
      int closeIndex = -1;
      for (int i = index + func.length + 1; i < s.length; i++) {
        if (s[i] == '(') openCount++;
        if (s[i] == ')') openCount--;
        if (openCount == 0) {
          closeIndex = i;
          break;
        }
      }
      if (closeIndex == -1) break;
      
      String inner = s.substring(index + func.length + 1, closeIndex);
      String newInner = '(($inner) * 3.141592653589793 / 180)';
      s = s.replaceRange(index + func.length + 1, closeIndex, newInner);
      pos = index + func.length + 1 + newInner.length + 1;
    }
    return s;
  }
  
  String replaceInverseTrig(String text, String func) {
    String s = text;
    int pos = 0;
    while (true) {
      int index = s.indexOf('$func(', pos);
      if (index == -1) break;
      
      if (index + func.length < s.length && s[index + func.length] == 'h') {
        pos = index + func.length + 1;
        continue;
      }
      
      int openCount = 1;
      int closeIndex = -1;
      for (int i = index + func.length + 1; i < s.length; i++) {
        if (s[i] == '(') openCount++;
        if (s[i] == ')') openCount--;
        if (openCount == 0) {
          closeIndex = i;
          break;
        }
      }
      if (closeIndex == -1) break;
      
      String wholeFunc = s.substring(index, closeIndex + 1);
      String replacement = '(($wholeFunc) * 180 / 3.141592653589793)';
      s = s.replaceRange(index, closeIndex + 1, replacement);
      pos = index + replacement.length;
    }
    return s;
  }

  temp = replaceTrigArgs(temp, 'sin');
  temp = replaceTrigArgs(temp, 'cos');
  temp = replaceTrigArgs(temp, 'tan');
  
  temp = replaceInverseTrig(temp, 'asin');
  temp = replaceInverseTrig(temp, 'acos');
  temp = replaceInverseTrig(temp, 'atan');
  
  return temp;
}

double evaluateExpression(String expr, bool isRad) {
  if (expr.isEmpty || expr == '0') return 0;
  
  // 1. Basic character normalizations
  String temp = expr
      .replaceAll('×', '*')
      .replaceAll('÷', '/')
      .replaceAll('π', '3.141592653589793')
      .replaceAll('√(', 'sqrt(')
      .replaceAll('²', '^2')
      .replaceAll('³', '^3')
      .replaceAll('^', '^');
  
  // 2. Pre-process complex structures
  temp = evaluateFactorials(temp);
  temp = evaluatePermutationsAndCombinations(temp);
  temp = resolveCubeRoots(temp);
  temp = resolveHyperbolic(temp);
  temp = resolvePercents(temp);
  
  // 3. Trigonometric Angle Mode Adjustments
  temp = resolveTrigMode(temp, isRad);
  
  // 4. Evaluate with math_expressions
  GrammarParser p = GrammarParser();
  Expression exp = p.parse(temp);
  
  double result = RealEvaluator().evaluate(exp).toDouble();
  if (result.isNaN || result.isInfinite) {
    throw Exception("Math Error");
  }
  
  return result;
}
