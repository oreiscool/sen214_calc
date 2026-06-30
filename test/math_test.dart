import 'package:flutter_test/flutter_test.dart';
import 'package:sen214_calc/utils/math_utils.dart';

void main() {
  group('Basic operations', () {
    test('addition', () {
      expect(evaluateExpression('2+3', true), 5.0);
    });
    test('subtraction', () {
      expect(evaluateExpression('5-3', true), 2.0);
    });
    test('multiplication', () {
      expect(evaluateExpression('2×3', true), 6.0);
    });
    test('division', () {
      expect(evaluateExpression('6÷3', true), 2.0);
    });
    test('power', () {
      expect(evaluateExpression('2^3', true), 8.0);
    });
    test('modulo', () {
      expect(evaluateExpression('10%3', true), 1.0);
    });
    test('percent', () {
      expect(evaluateExpression('50%', true), 0.5);
    });
    test('expression with precedence', () {
      expect(evaluateExpression('2+3×4', true), 14.0);
    });
    test('parentheses', () {
      expect(evaluateExpression('(2+3)×4', true), 20.0);
    });
    test('initial zero', () {
      expect(evaluateExpression('0+5', true), 5.0);
    });
  });

  group('Scientific operations', () {
    test('sin in radians', () {
      final result = evaluateExpression('sin(3.141592653589793÷2)', true);
      expect(result, closeTo(1.0, 0.000000001));
    });
    test('cos in radians', () {
      final result = evaluateExpression('cos(0)', true);
      expect(result, closeTo(1.0, 0.000000001));
    });
    test('tan in radians', () {
      final result = evaluateExpression('tan(3.141592653589793÷4)', true);
      expect(result, closeTo(1.0, 0.000000001));
    });
    test('sin in degrees', () {
      final result = evaluateExpression('sin(90)', false);
      expect(result, closeTo(1.0, 0.000000001));
    });
    test('ln', () {
      final result = evaluateExpression('ln(e)', true);
      expect(result, closeTo(1.0, 0.000000001));
    });
    test('log base 10', () {
      final result = evaluateExpression('log(100)', true);
      expect(result, closeTo(2.0, 0.000000001));
    });
    test('sqrt', () {
      expect(evaluateExpression('√(9)', true), 3.0);
    });
    test('sqrt without parens', () {
      final result = evaluateExpression('√9', true);
      expect(result, 3.0);
    });
    test('factorial', () {
      expect(evaluateExpression('5!', true), 120.0);
    });
    test('permutations', () {
      expect(evaluateExpression('5nPr2', true), 20.0);
    });
    test('combinations', () {
      expect(evaluateExpression('5nCr2', true), 10.0);
    });
    test('power squared symbol', () {
      expect(evaluateExpression('5²', true), 25.0);
    });
    test('power cubed symbol', () {
      expect(evaluateExpression('3³', true), 27.0);
    });
    test('cube root', () {
      expect(evaluateExpression('∛(8)', true), 2.0);
    });
    test('sinh', () {
      final result = evaluateExpression('sinh(0)', true);
      expect(result, closeTo(0.0, 0.000000001));
    });
    test('cosh', () {
      final result = evaluateExpression('cosh(0)', true);
      expect(result, closeTo(1.0, 0.000000001));
    });
    test('tanh', () {
      final result = evaluateExpression('tanh(0)', true);
      expect(result, closeTo(0.0, 0.000000001));
    });
    test('abs', () {
      expect(evaluateExpression('abs(-5)', true), 5.0);
    });
  });

  group('Auto-close parentheses', () {
    test('unmatched log with value evaluates', () {
      final result = evaluateExpression('log(8', true);
      expect(result, closeTo(0.903089987, 0.000000001));
    });
    test('unmatched sin with value evaluates', () {
      final result = evaluateExpression('sin(3.141592653589793÷2', true);
      expect(result, closeTo(1.0, 0.000000001));
    });
    test('unmatched arithmetic parens evaluates', () {
      expect(evaluateExpression('(5+3', true), 8.0);
    });
    test('unmatched sin in degrees evaluates', () {
      final result = evaluateExpression('sin(90', false);
      expect(result, closeTo(1.0, 0.000000001));
    });
    test('ends with operator throws', () {
      expect(() => evaluateExpression('5+', true), throwsA(isA<Exception>()));
    });
    test('log with value then operator throws', () {
      expect(() => evaluateExpression('log(8×', true), throwsA(isA<Exception>()));
    });
    test('already balanced parens still work', () {
      expect(evaluateExpression('log(100)', true), closeTo(2.0, 0.000000001));
    });
    test('nested unmatched parens still work', () {
      final result = evaluateExpression('sin((3.141592653589793÷2', true);
      expect(result, closeTo(1.0, 0.000000001));
    });
  });
}
