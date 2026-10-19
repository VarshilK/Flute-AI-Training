import 'package:flutter/material.dart';
import 'sheet_wrapper.dart';

class FingeringSheet extends StatefulWidget {
  const FingeringSheet({super.key});

  @override
  State<FingeringSheet> createState() => _FingeringSheetState();
}

class _FingeringSheetState extends State<FingeringSheet> {
  int _selectedIndex = 0;

  final List<Map<String, dynamic>> _notes = [
    {
      'name': 'C',
      'alt': '',
      'octave': '4',
      'label': 'Middle C',
      'tip': 'All fingers down. The most common starting note.',
      'keys': [true, true, true, true, false, true, true, true, true, false, false, false],
    },
    {
      'name': 'C♯',
      'alt': 'D♭',
      'octave': '4',
      'label': '',
      'tip': 'Like C but lift R3. Keep the rest down.',
      'keys': [true, true, true, true, false, true, true, false, true, false, false, false],
    },
    {
      'name': 'D',
      'alt': '',
      'octave': '4',
      'label': '',
      'tip': 'All main keys down except foot Eb key and R3.',
      'keys': [true, true, true, true, false, true, false, false, false, false, false, false],
    },
    {
      'name': 'D♯',
      'alt': 'E♭',
      'octave': '4',
      'label': '',
      'tip': 'Like D but add the Eb key with your right pinky.',
      'keys': [true, true, true, true, false, true, false, false, true, false, false, false],
    },
    {
      'name': 'E',
      'alt': '',
      'octave': '4',
      'label': '',
      'tip': 'Lift R2 and R3. Keep L1 L2 L3 and R1 down.',
      'keys': [true, true, true, true, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'F',
      'alt': '',
      'octave': '4',
      'label': '',
      'tip': 'Keep L1 L2 L3 down. Lift R1 R2 R3.',
      'keys': [true, true, true, false, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'F♯',
      'alt': 'G♭',
      'octave': '4',
      'label': '',
      'tip': 'L1 L2 down, L3 up. R1 down. Eb key down.',
      'keys': [true, true, true, false, false, true, false, false, true, false, false, false],
    },
    {
      'name': 'G',
      'alt': '',
      'octave': '4',
      'label': '',
      'tip': 'L1 L2 down, L3 up. All right hand up.',
      'keys': [true, true, false, false, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'G♯',
      'alt': 'A♭',
      'octave': '4',
      'label': '',
      'tip': 'L1 down. L2 L3 up. G# pinky key pressed.',
      'keys': [true, true, false, false, true, false, false, false, true, false, false, false],
    },
    {
      'name': 'A',
      'alt': '',
      'octave': '4',
      'label': '',
      'tip': 'L1 down. L2 L3 up. All right hand up.',
      'keys': [true, false, false, false, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'A♯',
      'alt': 'B♭',
      'octave': '4',
      'label': '',
      'tip': 'Thumb Bb lever + L1 down. OR: L2 + R1 down.',
      'keys': [true, false, false, false, false, true, false, false, true, false, false, false],
    },
    {
      'name': 'B',
      'alt': '',
      'octave': '4',
      'label': '',
      'tip': 'Thumb on B key. L1 L2 L3 up. Eb key down.',
      'keys': [true, false, true, false, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'C',
      'alt': '',
      'octave': '5',
      'label': '',
      'tip': 'Same as C4 — blow faster/tighter for octave.',
      'keys': [true, true, true, true, false, true, true, true, true, false, false, false],
    },
    {
      'name': 'C♯',
      'alt': 'D♭',
      'octave': '5',
      'label': '',
      'tip': 'Same as C#4 — increase air speed.',
      'keys': [true, true, true, true, false, true, true, false, true, false, false, false],
    },
    {
      'name': 'D',
      'alt': '',
      'octave': '5',
      'label': '',
      'tip': 'Same as D4 — blow faster.',
      'keys': [true, true, true, true, false, true, false, false, false, false, false, false],
    },
    {
      'name': 'D♯',
      'alt': 'E♭',
      'octave': '5',
      'label': '',
      'tip': 'Same as Eb4 — faster air.',
      'keys': [true, true, true, true, false, true, false, false, true, false, false, false],
    },
    {
      'name': 'E',
      'alt': '',
      'octave': '5',
      'label': '',
      'tip': 'Same as E4 — faster air.',
      'keys': [true, true, true, true, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'F',
      'alt': '',
      'octave': '5',
      'label': '',
      'tip': 'Same as F4 — faster air.',
      'keys': [true, true, true, false, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'F♯',
      'alt': 'G♭',
      'octave': '5',
      'label': '',
      'tip': 'Same as F#4 — faster air.',
      'keys': [true, true, true, false, false, true, false, false, true, false, false, false],
    },
    {
      'name': 'G',
      'alt': '',
      'octave': '5',
      'label': '',
      'tip': 'Same as G4 — faster air.',
      'keys': [true, true, false, false, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'G♯',
      'alt': 'A♭',
      'octave': '5',
      'label': '',
      'tip': 'Same as G#4 — faster air.',
      'keys': [true, true, false, false, true, false, false, false, true, false, false, false],
    },
    {
      'name': 'A',
      'alt': '',
      'octave': '5',
      'label': '',
      'tip': 'Same as A4 — faster air.',
      'keys': [true, false, false, false, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'A♯',
      'alt': 'B♭',
      'octave': '5',
      'label': '',
      'tip': 'Same as Bb4 — faster air.',
      'keys': [true, false, false, false, false, true, false, false, true, false, false, false],
    },
    {
      'name': 'B',
      'alt': '',
      'octave': '5',
      'label': '',
      'tip': 'Same as B4 — faster air.',
      'keys': [true, false, true, false, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'C',
      'alt': '',
      'octave': '6',
      'label': '',
      'tip': 'T L1 L2 L3 down. R1 up. R2 R3 down. Eb down.',
      'keys': [true, true, true, true, false, false, true, true, true, false, false, false],
    },
    {
      'name': 'C♯',
      'alt': 'D♭',
      'octave': '6',
      'label': '',
      'tip': 'T L1 L2 L3 R2 down. Rest up.',
      'keys': [true, true, true, true, false, false, true, false, true, false, false, false],
    },
    {
      'name': 'D',
      'alt': '',
      'octave': '6',
      'label': '',
      'tip': 'T L1 L2 L3 down. R1 R2 R3 up.',
      'keys': [true, true, true, true, false, false, false, false, false, false, false, false],
    },
    {
      'name': 'D♯',
      'alt': 'E♭',
      'octave': '6',
      'label': '',
      'tip': 'T L1 L2 L3 down. Eb pinky down. R1 R2 R3 up.',
      'keys': [true, true, true, true, false, false, false, false, true, false, false, false],
    },
    {
      'name': 'E',
      'alt': '',
      'octave': '6',
      'label': '',
      'tip': 'T L1 L2 down. L3 up. All right hand up.',
      'keys': [true, true, true, false, false, false, false, false, false, false, false, false],
    },
    {
      'name': 'F',
      'alt': '',
      'octave': '6',
      'label': '',
      'tip': 'T L1 down. L2 L3 up. R1 down. Rest up.',
      'keys': [true, true, false, false, false, true, false, false, false, false, false, false],
    },
    {
      'name': 'F♯',
      'alt': 'G♭',
      'octave': '6',
      'label': '',
      'tip': 'T L1 down. L2 L3 up. All right hand up.',
      'keys': [true, true, false, false, false, false, false, false, false, false, false, false],
    },
    {
      'name': 'G',
      'alt': '',
      'octave': '6',
      'label': '',
      'tip': 'T down. L1 up. L2 down. R1 R2 down. Eb down.',
      'keys': [true, false, true, false, false, true, true, false, true, false, false, false],
    },
    {
      'name': 'G♯',
      'alt': 'A♭',
      'octave': '6',
      'label': '',
      'tip': 'T down. L2 down. G# pinky down. R1 down.',
      'keys': [true, false, true, false, true, true, false, false, false, false, false, false],
    },
    {
      'name': 'A',
      'alt': '',
      'octave': '6',
      'label': '',
      'tip': 'T down. L1 L3 down. R1 R3 down. Eb down.',
      'keys': [true, true, false, true, false, true, false, true, true, false, false, false],
    },
    {
      'name': 'A♯',
      'alt': 'B♭',
      'octave': '6',
      'label': '',
      'tip': 'T down. L1 L2 down. R2 R3 down. Eb down.',
      'keys': [true, true, true, false, false, false, true, true, true, false, false, false],
    },
    {
      'name': 'B',
      'alt': '',
      'octave': '6',
      'label': '',
      'tip': 'T L1 down. L2 L3 up. R1 R2 down. Eb down.',
      'keys': [true, true, false, false, false, true, true, false, true, false, false, false],
    },
    {
      'name': 'C',
      'alt': '',
      'octave': '7',
      'label': 'High C',
      'tip': 'T L1 L2 down. R1 down. Eb down. Very fast air.',
      'keys': [true, true, true, false, false, true, false, false, true, false, false, false],
    },
  ];

  String get _displayName {
    final note = _notes[_selectedIndex];
    final name = note['name'] as String;
    final alt = note['alt'] as String;
    final octave = note['octave'] as String;
    if (alt.isNotEmpty) return '$name / $alt $octave';
    return '$name$octave';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C3A);
    final subColor = isDark ? Colors.white54 : Colors.black45;
    final cardBg = isDark
        ? Colors.white.withOpacity(0.06)
        : Colors.black.withOpacity(0.04);
    final note = _notes[_selectedIndex];
    final keys = note['keys'] as List<bool>;
    final label = note['label'] as String;
    final tip = note['tip'] as String;

    return SheetWrapper(
      title: 'Fingering Chart',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Note name display
          Center(
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF5B8CFF), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF5B8CFF).withOpacity(0.4),
                        blurRadius: 16,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Text(
                    _displayName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ),
                if (label.isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(label,
                      style:
                          TextStyle(color: subColor, fontSize: 12)),
                ],
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Fingering diagram
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Column(
              children: [
                Text('KEY DIAGRAM',
                    style: TextStyle(
                        color: subColor,
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5)),
                const SizedBox(height: 16),
                _FingeringDiagram(keys: keys, isDark: isDark),
                const SizedBox(height: 16),
                _KeyLegendRow(isDark: isDark),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Tip box
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: cardBg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: const Color(0xFF5B8CFF).withOpacity(0.3),
                width: 1,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(tip,
                      style: TextStyle(
                          color: textColor,
                          fontSize: 13,
                          height: 1.5)),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          Text('ALL NOTES',
              style: TextStyle(
                  color: subColor,
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5)),
          const SizedBox(height: 10),

          // Note selector grid
          SizedBox(
            height: 320,
            child: GridView.builder(
              physics: const BouncingScrollPhysics(),
              gridDelegate:
                  const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                childAspectRatio: 1.6,
              ),
              itemCount: _notes.length,
              itemBuilder: (_, i) {
                final n = _notes[i];
                final isSelected = i == _selectedIndex;
                final noteName = n['name'] as String;
                final noteOct = n['octave'] as String;
                final noteAlt = n['alt'] as String;
                return GestureDetector(
                  onTap: () =>
                      setState(() => _selectedIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    decoration: BoxDecoration(
                      gradient: isSelected
                          ? const LinearGradient(colors: [
                              Color(0xFF5B8CFF),
                              Color(0xFF8B5CF6)
                            ])
                          : null,
                      color: isSelected ? null : cardBg,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: const Color(0xFF5B8CFF)
                                    .withOpacity(0.35),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              )
                            ]
                          : null,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          noteName,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white
                                : textColor,
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        if (noteAlt.isNotEmpty)
                          Text(
                            noteAlt,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white70
                                  : subColor,
                              fontSize: 8,
                            ),
                          ),
                        Text(
                          noteOct,
                          style: TextStyle(
                            color: isSelected
                                ? Colors.white60
                                : subColor,
                            fontSize: 8,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _FingeringDiagram extends StatelessWidget {
  final List<bool> keys;
  final bool isDark;

  const _FingeringDiagram({required this.keys, required this.isDark});

  @override
  Widget build(BuildContext context) {
    final closedColor = const Color(0xFF5B8CFF);
    final openColor =
        isDark ? Colors.white12 : Colors.black.withOpacity(0.08);
    final openBorder = isDark ? Colors.white30 : Colors.black26;

    Widget hole(bool closed, {double size = 28, String? label}) {
      return Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: size,
            height: size,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: closed ? closedColor : openColor,
              border: Border.all(
                color: closed ? closedColor : openBorder,
                width: 2,
              ),
              boxShadow: closed
                  ? [
                      BoxShadow(
                        color: closedColor.withOpacity(0.4),
                        blurRadius: 6,
                        spreadRadius: 1,
                      )
                    ]
                  : null,
            ),
          ),
          if (label != null && label.isNotEmpty) ...[
            const SizedBox(height: 4),
            Text(label,
                style: TextStyle(
                    color:
                        isDark ? Colors.white38 : Colors.black38,
                    fontSize: 8)),
          ],
        ],
      );
    }

    Widget divider() => Container(
          width: 1,
          height: 40,
          margin: const EdgeInsets.symmetric(horizontal: 4),
          color: isDark ? Colors.white12 : Colors.black12,
        );

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [hole(keys[0], label: 'T')],
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              children: [
                Text('LEFT',
                    style: TextStyle(
                        color:
                            isDark ? Colors.white38 : Colors.black38,
                        fontSize: 8,
                        letterSpacing: 1)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    hole(keys[1], label: 'L1'),
                    const SizedBox(width: 8),
                    hole(keys[2], label: 'L2'),
                    const SizedBox(width: 8),
                    hole(keys[3], label: 'L3'),
                  ],
                ),
              ],
            ),
            divider(),
            Column(
              children: [
                Text('G#',
                    style: TextStyle(
                        color:
                            isDark ? Colors.white38 : Colors.black38,
                        fontSize: 8)),
                const SizedBox(height: 6),
                hole(keys[4], size: 20),
              ],
            ),
            divider(),
            Column(
              children: [
                Text('RIGHT',
                    style: TextStyle(
                        color:
                            isDark ? Colors.white38 : Colors.black38,
                        fontSize: 8,
                        letterSpacing: 1)),
                const SizedBox(height: 6),
                Row(
                  children: [
                    hole(keys[5], label: 'R1'),
                    const SizedBox(width: 8),
                    hole(keys[6], label: 'R2'),
                    const SizedBox(width: 8),
                    hole(keys[7], label: 'R3'),
                  ],
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          children: [
            Text('FOOT KEYS',
                style: TextStyle(
                    color: isDark ? Colors.white38 : Colors.black38,
                    fontSize: 8,
                    letterSpacing: 1)),
            const SizedBox(height: 6),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                hole(keys[8], size: 22, label: 'E♭'),
                const SizedBox(width: 10),
                hole(keys[9], size: 22, label: 'C♯'),
                const SizedBox(width: 10),
                hole(keys[10], size: 22, label: 'C'),
                const SizedBox(width: 10),
                hole(keys[11], size: 22, label: 'B'),
              ],
            ),
          ],
        ),
      ],
    );
  }
}

class _KeyLegendRow extends StatelessWidget {
  final bool isDark;
  const _KeyLegendRow({required this.isDark});

  @override
  Widget build(BuildContext context) {
    final subColor = isDark ? Colors.white54 : Colors.black45;
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 14,
          height: 14,
          decoration: const BoxDecoration(
            color: Color(0xFF5B8CFF),
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 6),
        Text('Pressed',
            style: TextStyle(color: subColor, fontSize: 11)),
        const SizedBox(width: 20),
        Container(
          width: 14,
          height: 14,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(
              color: isDark ? Colors.white30 : Colors.black26,
              width: 2,
            ),
          ),
        ),
        const SizedBox(width: 6),
        Text('Open',
            style: TextStyle(color: subColor, fontSize: 11)),
      ],
    );
  }
}