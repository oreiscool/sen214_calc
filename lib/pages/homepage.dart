import 'package:flutter/material.dart';
import 'package:sen214_calc/widgets/display.dart';
import '../widgets/standard_mathpad.dart';
import '../widgets/scientific_mathpad.dart';

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  bool _isCompact = false;

  void _toggleCompact() {
    setState(() {
      _isCompact = !_isCompact;
    });
  }

  void onButtonPressed(String value) {}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    _isCompact ? 'SCI' : 'STD',
                    style: const TextStyle(
                      color: Colors.white54,
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: _toggleCompact,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withAlpha(13),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _isCompact
                            ? Icons.compress
                            : Icons.expand,
                        color: Colors.white70,
                        size: 22,
                      ),
                    ),
                  ),
                ],
              ),
              const Expanded(
                flex: 45,
                child: Padding(
                  padding: EdgeInsets.only(bottom: 16.0),
                  child: Display(),
                ),
              ),
              Expanded(
                flex: 55,
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final totalHeight = constraints.maxHeight;
                    const gapHeight = 8.0;
                    final scientificTargetHeight = (totalHeight - gapHeight) * (4.0 / 9.0);

                    return Column(
                      children: [
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: _isCompact ? scientificTargetHeight : 0,
                          child: ClipRect(
                            child: OverflowBox(
                              minHeight: 0,
                              maxHeight: scientificTargetHeight,
                              alignment: Alignment.bottomCenter,
                              child: ScientificMathpad(
                                isCompact: true,
                                onButtonPressed: onButtonPressed,
                              ),
                            ),
                          ),
                        ),
                        AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          height: _isCompact ? gapHeight : 0,
                        ),
                        Expanded(
                          child: StandardMathpad(
                            isCompact: _isCompact,
                            onButtonPressed: onButtonPressed,
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
