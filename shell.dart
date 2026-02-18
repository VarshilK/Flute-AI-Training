import 'package:flutter/material.dart';
import 'pages/ai_training_page.dart';
import 'pages/home_page.dart';
import 'pages/about_page.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key});

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  int _currentIndex = 1; // Start on Home (middle tab)

  final List<Widget> _pages = const [
    AITrainingPage(),
    HomePage(),
    AboutPage(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF12121F) : const Color(0xFFFFFFFF);
    final active = Theme.of(context).colorScheme.primary;
    final inactive = isDark ? Colors.white30 : Colors.black26;

    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: bg,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.15),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _NavItem(
                  icon: Icons.psychology_outlined,
                  label: 'AI Training',
                  selected: _currentIndex == 0,
                  activeColor: active,
                  inactiveColor: inactive,
                  onTap: () => setState(() => _currentIndex = 0),
                ),
                _NavItem(
                  icon: Icons.music_note_rounded,
                  label: 'Home',
                  selected: _currentIndex == 1,
                  activeColor: active,
                  inactiveColor: inactive,
                  onTap: () => setState(() => _currentIndex = 1),
                ),
                _NavItem(
                  icon: Icons.info_outline_rounded,
                  label: 'About',
                  selected: _currentIndex == 2,
                  activeColor: active,
                  inactiveColor: inactive,
                  onTap: () => setState(() => _currentIndex = 2),
                ),
              ],
            ),
          ),
        ),
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
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: selected ? activeColor.withOpacity(0.12) : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: selected ? activeColor : inactiveColor, size: 24),
            const SizedBox(height: 3),
            Text(
              label,
              style: TextStyle(
                color: selected ? activeColor : inactiveColor,
                fontSize: 10,
                fontWeight: selected ? FontWeight.w700 : FontWeight.w400,
                letterSpacing: 0.3,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
