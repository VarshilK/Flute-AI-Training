import 'package:flutter/material.dart';
import 'pages/ai_training_page.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';
import 'main.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 1;

  final List<Widget> _pages = const [
    AITrainingPage(),
    HomePage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final active = Theme.of(context).colorScheme.primary;
    final inactive = isDark ? Colors.white30 : Colors.black26;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      body: SafeArea(
        bottom: false,
        child: _pages[_currentIndex],
      ),
      bottomNavigationBar: ValueListenableBuilder<bool>(
        valueListenable: liquidGlassNotifier,
        builder: (context, isGlass, _) {
          final bg = isGlass
              ? (isDark
                  ? const Color(0xFF1E1E35)
                  : const Color(0xFFF8F9FF))
              : (isDark
                  ? const Color(0xFF12121F)
                  : const Color(0xFFFFFFFF));

          return Padding(
            padding: EdgeInsets.fromLTRB(
                20, 0, 20, bottomPadding + 12),
            child: Container(
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(
                  color: isGlass
                      ? Colors.white
                          .withValues(alpha: isDark ? 0.15 : 0.6)
                      : Colors.transparent,
                  width: isGlass ? 1.0 : 0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.18),
                    blurRadius: 24,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _NavItem(
                      icon: Icons.psychology_outlined,
                      label: 'AI Training',
                      selected: _currentIndex == 0,
                      activeColor: active,
                      inactiveColor: inactive,
                      onTap: () =>
                          setState(() => _currentIndex = 0),
                    ),
                    _NavItem(
                      icon: Icons.music_note_rounded,
                      label: 'Home',
                      selected: _currentIndex == 1,
                      activeColor: active,
                      inactiveColor: inactive,
                      onTap: () =>
                          setState(() => _currentIndex = 1),
                    ),
                    _NavItem(
                      icon: Icons.info_outline_rounded,
                      label: 'About',
                      selected: _currentIndex == 2,
                      activeColor: active,
                      inactiveColor: inactive,
                      onTap: () =>
                          setState(() => _currentIndex = 2),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final Color activeColor;
  final Color inactiveColor;
  final VoidCallback onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.activeColor,
    required this.inactiveColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(
            horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected
              ? activeColor.withValues(alpha: 0.12)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon,
                color: selected ? activeColor : inactiveColor,
                size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: selected
                    ? FontWeight.w700
                    : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}