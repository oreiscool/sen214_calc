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
  final int cursorPosition;
  final ValueChanged<String> onChanged;
  final ValueChanged<int>? onCursorChanged;

  const Display({
    super.key,
    required this.inputExpression,
    required this.resultString,
    required this.showHighlight,
    required this.cursorPosition,
    required this.onChanged,
    this.onCursorChanged,
  });

  @override
  State<Display> createState() => _DisplayState();
}

class _NoHandleControls extends MaterialTextSelectionControls {
  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textLineHeight, [VoidCallback? onTap]) {
    return const SizedBox.shrink();
  }
}

class _DisplayState extends State<Display> {
  late final ColorizingTextEditingController _controller;
  final FocusNode _focusNode = FocusNode();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    final colors = Theme.of(context).colorScheme;
    _controller = ColorizingTextEditingController(
      operatorColor: colors.primary,
      normalColor: colors.onSurface,
    );
    _controller.text = widget.inputExpression;
    _controller.showHighlight = widget.showHighlight;
    _controller.addListener(_onTextChanged);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) _focusNode.requestFocus();
    });
  }

  @override
  void didUpdateWidget(Display oldWidget) {
    super.didUpdateWidget(oldWidget);
    final highlightChanged = widget.showHighlight != oldWidget.showHighlight;
    final expressionChanged = widget.inputExpression != oldWidget.inputExpression;

    if (highlightChanged) {
      _controller.showHighlight = widget.showHighlight;
    }
    if (expressionChanged) {
      _controller.text = widget.inputExpression;
      _controller.selection = TextSelection.collapsed(
        offset: widget.cursorPosition.clamp(0, widget.inputExpression.length),
      );
    }
    if (highlightChanged || expressionChanged) {
      _controller.value = _controller.value;
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
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
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Flexible(
          child: Scrollbar(
            controller: _scrollController,
            child: TextField(
              controller: _controller,
              focusNode: _focusNode,
              scrollController: _scrollController,
              selectionControls: _NoHandleControls(),
              showCursor: true,
              onTap: () {
                widget.onCursorChanged?.call(_controller.selection.baseOffset);
              },
              keyboardType: TextInputType.none,
              maxLines: 3,
              textAlign: TextAlign.end,
              cursorColor: colors.primary,
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'[0-9+\-×÷%().^√πe²³ⁿ!⁻¹PᵣC∛sincotalgprdbe]'),
                ),
              ],
              style: TextStyle(
                fontSize: 40,
                fontWeight: FontWeight.w400,
                color: colors.onSurface,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          widget.resultString,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w500,
            color: colors.onSurface.withValues(alpha: 0.54),
          ),
        ),
      ],
    );
  }
}
