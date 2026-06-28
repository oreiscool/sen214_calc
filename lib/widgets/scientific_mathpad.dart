import 'package:flutter/material.dart';
import '../widgets/calc_button.dart';

class ScientificMathpad extends StatefulWidget {
  final bool isCompact;
  final void Function(String) onButtonPressed;

  const ScientificMathpad({
    super.key,
    required this.isCompact,
    required this.onButtonPressed,
  });

  @override
  State<ScientificMathpad> createState() => _ScientificMathpadState();
}

class _ScientificMathpadState extends State<ScientificMathpad> {
  bool _isPage2 = false;
  bool _isRad = true;

  @override
  Widget build(BuildContext context) {
    final page1 = [
      '⇋',
      'RAD_TOGGLE',
      '√',
      'x²',
      'xⁿ',
      'sin',
      'cos',
      'tan',
      'n!',
      '(-)',
      'π',
      'ln',
      'eˣ',
      'log',
      '1/x',
      '|x|',
    ];
    final page2 = [
      '⇋',
      'RAD_TOGGLE',
      '∛',
      '2ˣ',
      'sin⁻¹',
      'cos⁻¹',
      'tan⁻¹',
      'x³',
      'sinh',
      'cosh',
      'tanh',
      'ⁿPᵣ',
      'sinh⁻¹',
      'cosh⁻¹',
      'tanh⁻¹',
      'ⁿCᵣ',
    ];

    final currentButtons = _isPage2 ? page2 : page1;

    return GridView.count(
      crossAxisCount: 4,
      mainAxisSpacing: 8,
      crossAxisSpacing: 8,
      children: currentButtons.map((label) {
        final displayLabel = label == 'RAD_TOGGLE'
            ? (_isRad ? 'Rad' : 'Deg')
            : label;
        return CalcButton(
          label: displayLabel,
          isCompact: widget.isCompact,
          onTap: () => widget.onButtonPressed(displayLabel),
        );
      }).toList(),
    );
  }
}
