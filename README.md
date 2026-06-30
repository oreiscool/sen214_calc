# Calc

![Flutter](https://img.shields.io/badge/Flutter-3.44.4-02569B?style=for-the-badge&logo=flutter)
![Dart](https://img.shields.io/badge/Dart-3.12.2-0175C2?style=for-the-badge&logo=dart)
![License](https://img.shields.io/badge/License-MIT-yellow?style=for-the-badge)
![Platform](https://img.shields.io/badge/Platform-Android%20%7C%20iOS-green?style=for-the-badge)

A minimal calculator with standard and scientific modes. 

## Features

- Standard and scientific keypads with toggle
- 32 scientific functions across two pages (trig, log, hyperbolic, factorial, permutations, combinations)
- Live result preview as you type
- Radian/degree toggle
- Smart delete (handles multi-character tokens like `sin(`, `cosh(`, etc.)
- Paste support with automatic sanitization
- Dark theme with amber accent (Samsung Calculator style)
- Haptic feedback
- Input validation (max 40 operators, max 15 digits per number)

## Getting Started

```bash
git clone https://github.com/oreiscool/sen214_calc.git
cd sen214_calc
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── main.dart              # Entry point + dark theme
├── pages/
│   └── homepage.dart      # Layout, state, expression orchestration
├── widgets/
│   ├── calc_button.dart   # Reusable button with tap animation
│   ├── display.dart       # Colorized text display with paste support
│   ├── standard_mathpad.dart    # 5x4 standard keypad
│   └── scientific_mathpad.dart  # 2-page 4x4 scientific keypad
└── utils/
    └── math_utils.dart    # Expression preprocessing + evaluation
```

## License

MIT
