import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
import '../widgets/sheet_wrapper.dart';

class MetronomeSheet extends StatefulWidget {
  const MetronomeSheet({super.key});

  @override
  State<MetronomeSheet> createState() => _MetronomeSheetState();
}

class _MetronomeSheetState extends State<MetronomeSheet>
    with SingleTickerProviderStateMixin {
  double _bpm = 120;
  bool _isPlaying = false;
  late AudioPlayer _player;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnim;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
    );
    _pulseAnim = Tween<double>(begin: 1.0, end: 1.18).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _isPlaying = false;
    _player.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  Future<void> _startLoop() async {
    // Use system max volume via AudioSession
    await _player.setVolume(1.0);
    // Load the tick asset
    await _player.setAsset('assets/tick.mp3');

    while (_isPlaying && mounted) {
      _pulseController.forward(from: 0);
      await _player.seek(Duration.zero);
      await _player.play();
      // Haptic feedback for tactile beat feel
      HapticFeedback.mediumImpact();
      final interval = (60000 / _bpm).round();
      await Future.delayed(Duration(milliseconds: interval));
    }
  }

  void _toggle() {
    setState(() => _isPlaying = !_isPlaying);
    if (_isPlaying) {
      _startLoop();
    }
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

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C3A);
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return SheetWrapper(
      title: 'Metronome',
      child: Column(
        children: [
          const SizedBox(height: 20),

          // ── Beat Circle ──────────────────────────────────
          ScaleTransition(
            scale: _pulseAnim,
            child: Container(
              width: 130,
              height: 130,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: _isPlaying
                      ? const [Color(0xFF5B8CFF), Color(0xFF8B5CF6)]
                      : [Colors.grey.shade700, Colors.grey.shade600],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                boxShadow: _isPlaying
                    ? [
                        BoxShadow(
                          color: const Color(0xFF5B8CFF).withOpacity(0.5),
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
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 38,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                  Text(
                    'BPM',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
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
              letterSpacing: 0.5,
            ),
          ),

          const SizedBox(height: 30),

          // ── BPM Slider ───────────────────────────────────
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Row(
              children: [
                Text('50', style: TextStyle(color: subColor, fontSize: 12)),
                Expanded(
                  child: SliderTheme(
                    data: SliderTheme.of(context).copyWith(
                      activeTrackColor: const Color(0xFF5B8CFF),
                      inactiveTrackColor:
                          isDark ? Colors.white12 : Colors.black12,
                      thumbColor: const Color(0xFF5B8CFF),
                      overlayColor: const Color(0xFF5B8CFF).withOpacity(0.2),
                      trackHeight: 4,
                    ),
                    child: Slider(
                      value: _bpm,
                      min: 50,
                      max: 1000,
                      divisions: 950,
                      onChanged: (v) => setState(() => _bpm = v),
                    ),
                  ),
                ),
                Text('1000', style: TextStyle(color: subColor, fontSize: 12)),
              ],
            ),
          ),

          const SizedBox(height: 8),
          Text(
            '🔊 Volume controlled by your phone buttons',
            style: TextStyle(color: subColor, fontSize: 12),
          ),

          const SizedBox(height: 28),

          // ── Play Button ──────────────────────────────────
          GestureDetector(
            onTap: _toggle,
            child: Container(
              width: 160,
              height: 56,
              decoration: BoxDecoration(
                gradient: _isPlaying
                    ? const LinearGradient(
                        colors: [Color(0xFFFF6B6B), Color(0xFFFF4757)])
                    : const LinearGradient(
                        colors: [Color(0xFF5B8CFF), Color(0xFF3D6FE8)]),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: (_isPlaying
                            ? const Color(0xFFFF6B6B)
                            : const Color(0xFF5B8CFF))
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
                    _isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
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
    );
  }
}
