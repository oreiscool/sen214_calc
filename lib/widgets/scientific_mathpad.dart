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
      '⇋', 'RAD_TOGGLE', '√', 'x²',
      'xⁿ', 'sin', 'cos', 'tan',
      'n!', '(-)', 'π', 'ln',
      'eˣ', 'log', '1/x', '|x|',
    ];
    final page2 = [
      '⇋', 'RAD_TOGGLE', '∛', '2ˣ',
      'sin⁻¹', 'cos⁻¹', 'tan⁻¹', 'x³',
      'sinh', 'cosh', 'tanh', 'ⁿPᵣ',
      'sinh⁻¹', 'cosh⁻¹', 'tanh⁻¹', 'ⁿCᵣ',
    ];

    final currentButtons = _isPage2 ? page2 : page1;
    
    // Chunk into 4 rows of 4 buttons
    final List<List<String>> rows = [];
    for (var i = 0; i < currentButtons.length; i += 4) {
      rows.add(currentButtons.sublist(i, i + 4));
    }

    return Column(
      children: rows.map((row) {
        return Expanded(
          child: Row(
            children: row.map((label) {
              final displayLabel = label == 'RAD_TOGGLE'
                  ? (_isRad ? 'Rad' : 'Deg')
                  : label;
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(6.0),
                  child: CalcButton(
                    label: displayLabel,
                    isCompact: widget.isCompact,
                    onTap: () {
                      if (label == '⇋') {
                        setState(() => _isPage2 = !_isPage2);
                      } else if (label == 'RAD_TOGGLE') {
                        setState(() => _isRad = !_isRad);
                      }
                      widget.onButtonPressed(displayLabel);
                    },
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
