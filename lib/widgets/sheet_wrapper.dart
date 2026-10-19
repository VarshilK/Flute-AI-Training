import 'package:flutter/material.dart';

class SheetWrapper extends StatelessWidget {
  final String title;
  final Widget child;
  final bool transparent;

  const SheetWrapper({
    super.key,
    required this.title,
    required this.child,
    this.transparent = false,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = transparent
        ? Colors.transparent
        : (isDark ? const Color(0xFF1A1A2E) : const Color(0xFFFFFFFF));
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C3A);

    return Container(
      decoration: BoxDecoration(
        color: bg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: const EdgeInsets.only(top: 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40, height: 4,
            decoration: BoxDecoration(
              color: isDark ? Colors.white24 : Colors.black12,
              borderRadius: BorderRadius.circular(4),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(title,
                    style: TextStyle(
                        color: textColor,
                        fontSize: 22,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.5)),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    width: 34, height: 34,
                    decoration: BoxDecoration(
                      color: isDark ? Colors.white12 : Colors.black12,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.close_rounded,
                        color: isDark ? Colors.white60 : Colors.black45,
                        size: 18),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
  child: SingleChildScrollView(
    padding: const EdgeInsets.symmetric(horizontal: 24),
    child: child,
  ),
),
        ],
      ),
    );
  }
}
