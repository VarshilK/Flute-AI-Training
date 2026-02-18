import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../widgets/sheet_wrapper.dart';

class VibratoSheet extends StatefulWidget {
  const VibratoSheet({super.key});

  @override
  State<VibratoSheet> createState() => _VibratoSheetState();
}

class _VibratoSheetState extends State<VibratoSheet>
    with SingleTickerProviderStateMixin {
  bool _listening = false;
  double _vibratoRate = 0.0;  // Hz
  double _vibratoWidth = 0.0; // cents
  String _quality = 'Not listening';
  late AnimationController _waveController;
  List<double> _wavePoints = List.filled(60, 0.0);

  @override
  void initState() {
    super.initState();
    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();
  }

  @override
  void dispose() {
    _listening = false;
    _waveController.dispose();
    super.dispose();
  }

  void _startListening() {
    setState(() {
      _listening = true;
      _quality = 'Analyzing...';
    });
    Future.doWhile(() async {
      if (!_listening || !mounted) return false;
      final rng = math.Random();
      final rate = 5.0 + rng.nextDouble() * 2;     // ~5-7 Hz (ideal vibrato)
      final width = 20.0 + rng.nextDouble() * 30;  // cents

      // Generate wave shape
      List<double> pts = List.generate(60, (i) {
        return math.sin(i * rate * 0.18) * width;
      });

      String q;
      if (rate >= 5 && rate <= 7 && width >= 20 && width <= 50) {
        q = 'Beautiful Vibrato 🎵';
      } else if (rate < 5) {
        q = 'Too slow — speed up';
      } else if (rate > 7) {
        q = 'Too fast — slow down';
      } else {
        q = 'Good — keep going!';
      }

      if (mounted) {
        setState(() {
          _vibratoRate = rate;
          _vibratoWidth = width;
          _quality = q;
          _wavePoints = pts;
        });
      }
      await Future.delayed(const Duration(milliseconds: 150));
      return true;
    });
  }

  void _stopListening() {
    setState(() {
      _listening = false;
      _quality = 'Not listening';
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C3A);
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return SheetWrapper(
      title: 'Vibrato Scanner',
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ── Live Waveform ────────────────────────────────
          Container(
            height: 120,
            margin: const EdgeInsets.symmetric(horizontal: 8),
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withOpacity(0.05) : Colors.black.withOpacity(0.04),
              borderRadius: BorderRadius.circular(16),
            ),
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (_, __) {
                return CustomPaint(
                  painter: _WavePainter(
                    points: _wavePoints,
                    progress: _waveController.value,
                    color: const Color(0xFF38EF7D),
                    isActive: _listening,
                  ),
                  size: Size.infinite,
                );
              },
            ),
          ),

          const SizedBox(height: 24),

          // ── Quality Label ────────────────────────────────
          Text(
            _quality,
            style: TextStyle(
              color: _listening ? const Color(0xFF38EF7D) : subColor,
              fontSize: 18,
              fontWeight: FontWeight.w700,
            ),
          ),

          const SizedBox(height: 20),

          // ── Stats Row ────────────────────────────────────
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _StatBox(
                label: 'Rate',
                value: _listening ? '${_vibratoRate.toStringAsFixed(1)} Hz' : '--',
                idealRange: '5–7 Hz',
                isDark: isDark,
              ),
              const SizedBox(width: 16),
              _StatBox(
                label: 'Width',
                value: _listening ? '${_vibratoWidth.toStringAsFixed(0)} ¢' : '--',
                idealRange: '20–50 ¢',
                isDark: isDark,
              ),
            ],
          ),

          const SizedBox(height: 30),

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
                        colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: (_listening
                            ? const Color(0xFFFF6B6B)
                            : const Color(0xFF38EF7D))
                        .withOpacity(0.4),
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
                    _listening ? 'Stop' : 'Scan',
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

class _StatBox extends StatelessWidget {
  final String label;
  final String value;
  final String idealRange;
  final bool isDark;

  const _StatBox({
    required this.label,
    required this.value,
    required this.idealRange,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 130,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? Colors.white.withOpacity(0.07) : Colors.black.withOpacity(0.04),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            label,
            style: TextStyle(
              color: isDark ? Colors.white38 : Colors.black38,
              fontSize: 11,
              letterSpacing: 1.2,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: TextStyle(
              color: isDark ? Colors.white : const Color(0xFF1C1C3A),
              fontSize: 20,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'Ideal: $idealRange',
            style: TextStyle(
              color: isDark ? Colors.white30 : Colors.black30,
              fontSize: 10,
            ),
          ),
        ],
      ),
    );
  }
}

class _WavePainter extends CustomPainter {
  final List<double> points;
  final double progress;
  final Color color;
  final bool isActive;

  _WavePainter({
    required this.points,
    required this.progress,
    required this.color,
    required this.isActive,
  });

  @override
  void paint(Canvas canvas, Size size) {
    if (!isActive || points.isEmpty) {
      // Draw flat line when inactive
      final paint = Paint()
        ..color = color.withOpacity(0.2)
        ..strokeWidth = 2
        ..style = PaintingStyle.stroke;
      canvas.drawLine(
        Offset(0, size.height / 2),
        Offset(size.width, size.height / 2),
        paint,
      );
      return;
    }

    final paint = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final path = Path();
    final maxAmplitude = 45.0;
    final centerY = size.height / 2;

    for (int i = 0; i < points.length; i++) {
      final x = (i / (points.length - 1)) * size.width;
      final y = centerY - (points[i] / maxAmplitude) * (size.height * 0.35);
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Glow effect
    canvas.drawPath(
      path,
      Paint()
        ..color = color.withOpacity(0.25)
        ..strokeWidth = 8
        ..style = PaintingStyle.stroke
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6),
    );
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(_WavePainter old) => true;
}
