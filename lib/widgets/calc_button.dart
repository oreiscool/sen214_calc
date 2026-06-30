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

  static const _backgroundColor = Color(0xFF222222);
  static const _operatorColor = Color(0xFFFF9800);
  static const _errorColor = Color(0xFFF44336);
  static const _numberColor = Color(0xFFEEEEEE);

  Color _getTextColor() {
    final label = widget.label;
    if (label == 'AC' || label == 'DEL') return _errorColor;
    if (RegExp(r'^[0-9]$').hasMatch(label) ||
        label == '.' ||
        label == '=' ||
        label == '()') {
      return _numberColor;
    }
    return _operatorColor;
  }

  @override
  Widget build(BuildContext context) {
    final textColor = _getTextColor();
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
            color: _backgroundColor,
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
                    fontWeight: FontWeight.w400,
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
