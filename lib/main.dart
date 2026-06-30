import 'package:flutter/material.dart';
import 'pages/homepage.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  static const _scaffoldBg = Color(0xFF0D0D0D);
  static const _surface = Color(0xFF222222);
  static const _accent = Color(0xFFFF9800);
  static const _error = Color(0xFFF44336);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const Homepage(),
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: _scaffoldBg,
        colorScheme: const ColorScheme.dark(
          surface: _surface,
          primary: _accent,
          secondary: _accent,
          error: _error,
          onSurface: Colors.white,
        ),
        useMaterial3: true,
      ),
    );
  }
}
