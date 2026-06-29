import 'package:flutter/material.dart';

class CalcButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;
  final bool isCompact;

  const CalcButton({
    super.key,
    required this.label,
    required this.onTap,
    this.color = Colors.grey,
    this.textColor = Colors.white,
    this.isCompact = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          shape: isCompact ? BoxShape.rectangle : BoxShape.circle,
          color: color,
        ),

        child: Center(
          child: Text(
            label,
            style: TextStyle(color: textColor, fontSize: isCompact ? 8 : 16),
          ),
        ),
      ),
    );
  }
}
