import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/sheet_wrapper.dart';
// NOTE: In production, replace the simulated pitch with:
// import 'package:pitch_detector_dart/pitch_detector.dart';

class TunerSheet extends StatefulWidget {
  const TunerSheet({super.key});

  @override
  State<TunerSheet> createState() => _TunerSheetState();
}

class _TunerSheetState extends State<TunerSheet>
    with SingleTickerProviderStateMixin {
  double _cents = 0.0;      // -50 to +50 cents from target
  double _frequency = 440.0;
  String _noteName = 'A4';
  bool _listening = false;
  late AnimationController _wobbleController;

  // Standard note names for tuning display
  static const _noteNames = [
    'C', 'C#', 'D', 'D#', 'E', 'F',
    'F#', 'G', 'G#', 'A', 'A#', 'B'
  ];

  @override
  void initState() {
    super.initState();
    _wobbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _listening = false;
    _wobbleController.dispose();
    super.dispose();
  }

  // Converts frequency to note name + cents deviation
  Map<String, dynamic> _frequencyToNote(double freq) {
    if (freq <= 0) return {'note': '--', 'cents': 0.0};
    final midiNote = 12 * math.log(freq / 440.0) / math.log(2) + 69;
    final roundedMidi = midiNote.round();
    final cents = (midiNote - roundedMidi) * 100;
    final octave = (roundedMidi ~/ 12) - 1;
    final noteIndex = roundedMidi % 12;
    return {
      'note': '${_noteNames[noteIndex]}$octave',
      'cents': cents,
    };
  }

  // TODO: replace with real mic input via pitch_detector_dart
  // For now, simulates a signal drifting around A4
  void _startListening() {
    setState(() => _listening = true);
    Future.doWhile(() async {
      if (!_listening || !mounted) return false;
      final drift = (math.Random().nextDouble() - 0.5) * 30;
      final simFreq = 440.0 * math.pow(2, drift / 1200);
      final result = _frequencyToNote(simFreq.toDouble());
      if (mounted) {
        setState(() {
          _frequency = simFreq.toDouble();
          _cents = (result['cents'] as double);
          _noteName = result['note'] as String;
        });
      }
      await Future.delayed(const Duration(milliseconds: 120));
      return true;
    });
  }

  void _stopListening() => setState(() => _listening = false);

  // Smiley changes based on how in-tune you are
  String _getMoodEmoji() {
    final abs = _cents.abs();
    if (abs <= 5) return '😄';
    if (abs <= 15) return '🙂';
    if (abs <= 30) return '😐';
    return '😟';
  }

  Color _getMoodColor() {
    final abs = _cents.abs();
    if (abs <= 5) return const Color(0xFF34C759);
    if (abs <= 15) return const Color(0xFFFFCC00);
    if (abs <= 30) return const Color(0xFFFF9500);
    return const Color(0xFFFF3B30);
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C3A);
    final subColor = isDark ? Colors.white54 : Colors.black45;
    final centsLabel = _cents >= 0
        ? '+${_cents.toStringAsFixed(1)} ¢'
        : '${_cents.toStringAsFixed(1)} ¢';
    final sharpFlat = _cents > 2
        ? 'Sharp ▲'
        : _cents < -2
            ? 'Flat ▼'
            : 'In Tune ✓';

    return SheetWrapper(
      title: 'Tuner',
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ── Mood Emoji ───────────────────────────────────
          Text(
            _getMoodEmoji(),
            style: const TextStyle(fontSize: 72),
          ),
          const SizedBox(height: 8),
          Text(
            sharpFlat,
            style: TextStyle(
              color: _getMoodColor(),
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 24),

          // ── Note Name ────────────────────────────────────
          Text(
            _noteName,
            style: TextStyle(
              color: textColor,
              fontSize: 56,
              fontWeight: FontWeight.w900,
              letterSpacing: -2,
            ),
          ),
          Text(
            '${_frequency.toStringAsFixed(1)} Hz',
            style: TextStyle(color: subColor, fontSize: 14),
          ),

          const SizedBox(height: 24),

          // ── Cents Bar ────────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text('−50¢', style: TextStyle(color: subColor, fontSize: 11)),
                    Text(
                      centsLabel,
                      style: TextStyle(
                        color: _getMoodColor(),
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text('+50¢', style: TextStyle(color: subColor, fontSize: 11)),
                  ],
                ),
                const SizedBox(height: 6),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    // Track
                    Container(
                      height: 10,
                      decoration: BoxDecoration(
                        color: isDark ? Colors.white12 : Colors.black12,
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    // Center line
                    Container(
                      width: 2,
                      height: 18,
                      color: isDark ? Colors.white38 : Colors.black26,
                    ),
                    // Indicator
                    Align(
                      alignment: Alignment((_cents / 50).clamp(-1.0, 1.0), 0),
                      child: Container(
                        width: 20,
                        height: 20,
                        decoration: BoxDecoration(
                          color: _getMoodColor(),
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: _getMoodColor().withOpacity(0.5),
                              blurRadius: 8,
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 32),

          // ── Listen Button ────────────────────────────────
          GestureDetector(
            onTap: _listening ? _stopListening : _startListening,
            child: Container(
              width: 160,
              height: 56,
              decoration: BoxDecoration(
                gradient: _listening
                    ? const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF4757)])
                    : const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFFF6B6B).withOpacity(0.4),
                    blurRadius: 20,
                    offset: const Offset(0, 6),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    _listening ? Icons.stop_rounded : Icons.mic_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    _listening ? 'Stop' : 'Listen',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
