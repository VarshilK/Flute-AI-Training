import 'package:flutter/material.dart';
import 'shell.dart';

// Global theme notifier - controls dark/light mode across the whole app
final ValueNotifier<ThemeMode> themeNotifier = ValueNotifier(ThemeMode.dark);

void main() {
  runApp(
    ValueListenableBuilder<ThemeMode>(
      valueListenable: themeNotifier,
      builder: (context, mode, _) => FluteAIApp(themeMode: mode),
    ),
  );
}

class FluteAIApp extends StatelessWidget {
  final ThemeMode themeMode;
  const FluteAIApp({super.key, required this.themeMode});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flute AI',
      debugShowCheckedModeBanner: false,
      themeMode: themeMode,

      // ── LIGHT THEME ──────────────────────────────────────────
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: const Color(0xFFF4F1EE),
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF1C1C3A),
          secondary: Color(0xFF5B8CFF),
          surface: Color(0xFFFFFFFF),
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),

      // ── DARK THEME ───────────────────────────────────────────
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0E0E1A),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF5B8CFF),
          secondary: Color(0xFF7FAAFF),
          surface: Color(0xFF1A1A2E),
        ),
        useMaterial3: true,
        fontFamily: 'SF Pro Display',
      ),

      home: const AppShell(),
    );
  }
}
