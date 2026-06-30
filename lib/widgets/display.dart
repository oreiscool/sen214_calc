import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ColorizingTextEditingController extends TextEditingController {
  final Color operatorColor;
  final Color normalColor;
  bool showHighlight;

  ColorizingTextEditingController({
    super.text,
    required this.operatorColor,
    required this.normalColor,
    this.showHighlight = false,
  });

  void forceUpdate() {
    notifyListeners();
  }

  @override
  TextSpan buildTextSpan({
    required BuildContext context,
    TextStyle? style,
    required bool withComposing,
  }) {
    final textVal = text;
    if (showHighlight) {
      return TextSpan(
        text: textVal,
        style: style?.copyWith(color: operatorColor),
      );
    }

    final List<InlineSpan> children = [];

    // Split by operators (+, -, ×, ÷)
    final regex = RegExp(r'([+\-×÷])');
    final parts = textVal.split(regex);
    final matches = regex.allMatches(textVal).toList();

    for (int i = 0; i < parts.length; i++) {
      children.add(TextSpan(
        text: parts[i],
        style: style?.copyWith(color: normalColor),
      ));
      if (i < matches.length) {
        children.add(TextSpan(
          text: matches[i].group(0),
          style: style?.copyWith(color: operatorColor),
        ));
      }
    }

    return TextSpan(style: style, children: children);
  }
}

class Display extends StatefulWidget {
  final String inputExpression;
  final String resultString;
  final bool showHighlight;
  final ValueChanged<String> onChanged;

  const Display({
    super.key,
    required this.inputExpression,
    required this.resultString,
    required this.showHighlight,
    required this.onChanged,
  });

  @override
  State<Display> createState() => _DisplayState();
}

class _DisplayState extends State<Display> {
  final ColorizingTextEditingController _controller = ColorizingTextEditingController(
    operatorColor: const Color(0xFFFF9800), // Yellow/Amber operator accent
    normalColor: Colors.white,
  );
  final FocusNode _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller.text = widget.inputExpression;
    _controller.showHighlight = widget.showHighlight;
    _controller.addListener(_onTextChanged);
  }

  @override
  void didUpdateWidget(Display oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showHighlight != oldWidget.showHighlight) {
      _controller.showHighlight = widget.showHighlight;
      _controller.forceUpdate();
    }
    if (widget.inputExpression != _controller.text) {
      _controller.text = widget.inputExpression;
      // Force selection to jump to the end of the text on programmatic updates
      _controller.selection = TextSelection.collapsed(offset: widget.inputExpression.length);
    }
  }

  void _onTextChanged() {
    if (_controller.text != widget.inputExpression) {
      widget.onChanged(_controller.text);
    }
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final normalResultColor = Colors.white54;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Input text field (scrolls, supports cursor selection, max 3 lines)
        Scrollbar(
          child: TextField(
            controller: _controller,
            focusNode: _focusNode,
            readOnly: false, // Allow selection/paste
            showCursor: true,
            keyboardType: TextInputType.none, // Hide system keyboard
            maxLines: 3,
            textAlign: TextAlign.end,
            cursorColor: const Color(0xFFFF9800),
            inputFormatters: [
              FilteringTextInputFormatter.allow(
                RegExp(r'[0-9+\-×÷%().^√πe²³ⁿ!⁻¹P C∛sincotalgprdbe]'),
              ),
            ],
            style: const TextStyle(
              fontSize: 40,
              fontWeight: FontWeight.w400,
              color: Colors.white,
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.zero,
            ),
          ),
        ),
        const SizedBox(height: 2), // Padding spacing between input and output
        // Result line (smaller font size than input, no default '0' placeholder)
        AnimatedDefaultTextStyle(
          duration: const Duration(milliseconds: 150),
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: normalResultColor,
          ),
          child: Text(
            widget.resultString,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
