import 'package:flutter/material.dart';
import '../widgets/calc_button.dart';

class StandardMathpad extends StatelessWidget {
  final bool isCompact;
  final void Function(String) onButtonPressed;

  const StandardMathpad({
    super.key,
    required this.isCompact,
    required this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final buttons = [
      'AC',
      'DEL',
      '%',
      '÷',
      '7',
      '8',
      '9',
      '×',
      '4',
      '5',
      '6',
      '-',
      '1',
      '2',
      '3',
      '+',
      '()',
      '0',
      '.',
      '=',
    ];
    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: buttons
          .map(
            (label) =>
                CalcButton(label: label, onTap: () => onButtonPressed(label)),
          )
          .toList(),
    );
  }
}
