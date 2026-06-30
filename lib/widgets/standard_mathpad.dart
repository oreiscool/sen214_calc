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
    final rows = [
      ['AC', 'DEL', '%', '÷'],
      ['7', '8', '9', '×'],
      ['4', '5', '6', '-'],
      ['1', '2', '3', '+'],
      ['()', '0', '.', '='],
    ];

    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Row(
            children: row.map((label) {
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CalcButton(
                    label: label,
                    onTap: () => onButtonPressed(label),
                    isCompact: isCompact,
                  ),
                ),
              );
            }).toList(),
          ),
        );
      }).toList(),
    );
  }
}
