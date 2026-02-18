import 'package:flutter/material.dart';
import '../main.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0E0E1A) : const Color(0xFFF4F1EE);
    final cardBg = isDark ? const Color(0xFF1A1A2E) : Colors.white;
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C3A);
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // ── Header ──────────────────────────────────────
              Text(
                'About Us',
                style: TextStyle(
                  color: textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'The team behind Flute AI',
                style: TextStyle(color: subColor, fontSize: 15),
              ),

              const SizedBox(height: 36),

              // ── Founder Card ─────────────────────────────────
              _FounderCard(
                name: 'Varshil Kaipu',
                role: 'Founder',
                bio: 'Founder of Flute AI Training',
                emoji: '🎸',
                gradientColors: const [Color(0xFF5B8CFF), Color(0xFF8B5CF6)],
                cardBg: cardBg,
                textColor: textColor,
                subColor: subColor,
                isDark: isDark,
              ),

              const SizedBox(height: 16),

              // ── Co-Founder Card ───────────────────────────────
              _FounderCard(
                name: 'Swarup Sathish',
                role: 'Co-Founder',
                bio: 'CoFounder of Flute AI Training',
                emoji: '🎵',
                gradientColors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                cardBg: cardBg,
                textColor: textColor,
                subColor: subColor,
                isDark: isDark,
              ),

              const SizedBox(height: 40),

              // ── Divider ──────────────────────────────────────
              Divider(
                color: isDark ? Colors.white12 : Colors.black12,
                thickness: 1,
              ),

              const SizedBox(height: 32),

              // ── Theme Toggle ─────────────────────────────────
              Text(
                'APPEARANCE',
                style: TextStyle(
                  color: subColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),
              const SizedBox(height: 16),

              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: cardBg,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(isDark ? 0.3 : 0.07),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: ValueListenableBuilder<ThemeMode>(
                  valueListenable: themeNotifier,
                  builder: (context, mode, _) {
                    final isDarkMode = mode == ThemeMode.dark;
                    return Row(
                      children: [
                        _ThemeToggleOption(
                          icon: Icons.wb_sunny_rounded,
                          label: 'Light',
                          selected: !isDarkMode,
                          onTap: () => themeNotifier.value = ThemeMode.light,
                          selectedBg: const Color(0xFFFFCC00),
                          selectedIconColor: Colors.white,
                          isDark: isDark,
                        ),
                        _ThemeToggleOption(
                          icon: Icons.nightlight_round,
                          label: 'Dark',
                          selected: isDarkMode,
                          onTap: () => themeNotifier.value = ThemeMode.dark,
                          selectedBg: const Color(0xFF1C1C3A),
                          selectedIconColor: const Color(0xFF5B8CFF),
                          isDark: isDark,
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 48),

              // ── Footer ───────────────────────────────────────
              Center(
                child: Column(
                  children: [
                    Text(
                      '🎶',
                      style: TextStyle(fontSize: 28),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Flute AI — v1.0.0',
                      style: TextStyle(color: subColor, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Built with ❤️ in Dublin, CA',
                      style: TextStyle(color: subColor, fontSize: 12),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }
}

class _FounderCard extends StatelessWidget {
  final String name;
  final String role;
  final String bio;
  final String emoji;
  final List<Color> gradientColors;
  final Color cardBg;
  final Color textColor;
  final Color subColor;
  final bool isDark;

  const _FounderCard({
    required this.name,
    required this.role,
    required this.bio,
    required this.emoji,
    required this.gradientColors,
    required this.cardBg,
    required this.textColor,
    required this.subColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isDark ? 0.3 : 0.07),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Avatar
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: gradientColors,
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 16),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        color: textColor,
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(colors: gradientColors),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        role,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.3,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  bio,
                  style: TextStyle(
                    color: subColor,
                    fontSize: 13,
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ThemeToggleOption extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final Color selectedBg;
  final Color selectedIconColor;
  final bool isDark;

  const _ThemeToggleOption({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    required this.selectedBg,
    required this.selectedIconColor,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            color: selected ? selectedBg : Colors.transparent,
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: selected
                    ? selectedIconColor
                    : (isDark ? Colors.white38 : Colors.black38),
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  color: selected
                      ? (selectedBg == const Color(0xFFFFCC00)
                          ? Colors.white
                          : const Color(0xFF5B8CFF))
                      : (isDark ? Colors.white38 : Colors.black38),
                  fontSize: 15,
                  fontWeight:
                      selected ? FontWeight.w700 : FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
