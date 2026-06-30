import 'package:flutter/material.dart';

class CalcButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final bool isCompact;

  const CalcButton({
    super.key,
    required this.label,
    required this.onTap,
    this.isCompact = false,
  });

  @override
  State<CalcButton> createState() => _CalcButtonState();
}

class _CalcButtonState extends State<CalcButton> {
  bool _isPressed = false;

  Color _getTextColor(ColorScheme colors) {
    final label = widget.label;
    if (label == 'AC' || label == 'DEL') return colors.error;
    if (label == '+' || label == '-' || label == '×' || label == '÷') {
      return colors.primary;
    }
    return colors.onSurface;
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final isEquals = widget.label == '=';
    final textColor = isEquals ? colors.surface : _getTextColor(colors);
    final isCompact = widget.isCompact;

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) {
        setState(() => _isPressed = false);
        widget.onTap();
      },
      onTapCancel: () => setState(() => _isPressed = false),
      child: AnimatedScale(
        scale: _isPressed ? 0.92 : 1.0,
        duration: const Duration(milliseconds: 100),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            color: isEquals ? colors.primary : colors.surface,
            borderRadius: BorderRadius.circular(isCompact ? 24 : 100),
          ),
          child: Center(
            child: FittedBox(
              fit: BoxFit.scaleDown,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: AnimatedDefaultTextStyle(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  style: TextStyle(
                    color: textColor,
                    fontSize: isCompact ? 20 : 28,
                    fontWeight: isEquals ? FontWeight.w600 : FontWeight.w400,
                  ),
                  child: Text(widget.label),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
