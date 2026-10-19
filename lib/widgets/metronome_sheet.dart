import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'sheet_wrapper.dart';

class MetronomeSheet extends StatefulWidget {
  const MetronomeSheet({super.key});

  @override
  State<MetronomeSheet> createState() => _MetronomeSheetState();
}

class _MetronomeSheetState extends State<MetronomeSheet>
    with SingleTickerProviderStateMixin {
  double _bpm = 120;
  bool _isPlaying = false;
  bool _advancedMode = false;
  int _colorIndex = 0;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;
  bool _disposed = false;

  final List<Color> _beatColors = [
    const Color(0xFFFF3B30), // red
    const Color(0xFF34C759), // green
    const Color(0xFFFFCC00), // yellow
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 80),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _disposed = true;
    _isPlaying = false;
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startLoop() async {
    while (_isPlaying && !_disposed && mounted) {
      final intervalMs = (60000 / _bpm).round();
      _pulseController.forward(from: 0);
      HapticFeedback.heavyImpact();
      if (_advancedMode) {
        setState(() {
          _colorIndex = (_colorIndex + 1) % _beatColors.length;
        });
      }
      await Future.delayed(Duration(milliseconds: intervalMs));
    }
  }

  void _toggle() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) _startLoop();
  }

  String _bpmLabel() {
    if (_bpm < 60) return 'Larghissimo';
    if (_bpm < 80) return 'Adagio';
    if (_bpm < 100) return 'Andante';
    if (_bpm < 120) return 'Moderato';
    if (_bpm < 160) return 'Allegro';
    if (_bpm < 200) return 'Presto';
    return 'Prestissimo 🔥';
  }

  Color get _currentColor => _advancedMode
      ? _beatColors[_colorIndex]
      : const Color(0xFF5B8CFF);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final subColor = isDark ? Colors.white54 : Colors.black45;
    final bgColor = _advancedMode
        ? _beatColors[_colorIndex].withValues(alpha: isDark ? 0.12 : 0.08)
        : Colors.transparent;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        color: isDark
            ? Color.lerp(const Color(0xFF1A1A2E), _advancedMode ? _beatColors[_colorIndex] : const Color(0xFF1A1A2E), 0.15)
            : Color.lerp(Colors.white, _advancedMode ? _beatColors[_colorIndex] : Colors.white, 0.08),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: SheetWrapper(
        title: 'Metronome',
        transparent: true,
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Advanced Mode Button
            GestureDetector(
              onTap: () => setState(() {
                _advancedMode = !_advancedMode;
                _colorIndex = 0;
              }),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                padding: const EdgeInsets.symmetric(
                    horizontal: 20, vertical: 10),
                decoration: BoxDecoration(
                  color: _advancedMode
                      ? const Color(0xFF5B8CFF)
                      : (isDark
                          ? Colors.white10
                          : Colors.black.withValues(alpha: 0.06)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.auto_awesome,
                      color: _advancedMode
                          ? Colors.white
                          : subColor,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Advanced Metronome',
                      style: TextStyle(
                        color: _advancedMode
                            ? Colors.white
                            : subColor,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // BPM Circle
            ScaleTransition(
              scale: _pulseAnim,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 130,
                height: 130,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: _isPlaying
                        ? [_currentColor, _currentColor.withValues(alpha: 0.7)]
                        : [Colors.grey.shade700, Colors.grey.shade600],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: _isPlaying
                      ? [
                          BoxShadow(
                            color: _currentColor.withValues(alpha: 0.5),
                            blurRadius: 40,
                            spreadRadius: 4,
                          )
                        ]
                      : [],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '${_bpm.round()}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 38,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const Text(
                      'BPM',
                      style: TextStyle(
                          color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),
            Text(
              _bpmLabel(),
              style: TextStyle(
                color: subColor,
                fontSize: 14,
                fontWeight: FontWeight.w500,
              ),
            ),

            if (_advancedMode) ...[
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: _beatColors.asMap().entries.map((e) {
                  final isActive = e.key == _colorIndex;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: isActive ? 24 : 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: e.value.withValues(alpha: isActive ? 1.0 : 0.4),
                      borderRadius: BorderRadius.circular(5),
                    ),
                  );
                }).toList(),
              ),
            ],

            const SizedBox(height: 30),

            // Slider
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: Row(
                children: [
                  Text('50',
                      style:
                          TextStyle(color: subColor, fontSize: 12)),
                  Expanded(
                    child: SliderTheme(
                      data: SliderTheme.of(context).copyWith(
                        activeTrackColor: _currentColor,
                        inactiveTrackColor: isDark
                            ? Colors.white12
                            : Colors.black12,
                        thumbColor: _currentColor,
                        trackHeight: 4,
                      ),
                      child: Slider(
                        value: _bpm,
                        min: 50,
                        max: 500,
                        divisions: 450,
                        onChanged: (v) =>
                            setState(() => _bpm = v),
                      ),
                    ),
                  ),
                  Text('500',
                      style:
                          TextStyle(color: subColor, fontSize: 12)),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Start/Stop Button
            GestureDetector(
              onTap: _toggle,
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                width: 160,
                height: 56,
                decoration: BoxDecoration(
                  gradient: _isPlaying
                      ? LinearGradient(colors: [
                          _currentColor,
                          _currentColor.withValues(alpha: 0.7)
                        ])
                      : const LinearGradient(colors: [
                          Color(0xFF5B8CFF),
                          Color(0xFF3D6FE8)
                        ]),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [
                    BoxShadow(
                      color: (_isPlaying
                              ? _currentColor
                              : const Color(0xFF5B8CFF))
                          .withValues(alpha: 0.4),
                      blurRadius: 20,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      _isPlaying
                          ? Icons.stop_rounded
                          : Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                    const SizedBox(width: 6),
                    Text(
                      _isPlaying ? 'Stop' : 'Start',
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
      ),
    );
  }
}