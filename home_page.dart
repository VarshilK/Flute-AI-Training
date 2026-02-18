import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../widgets/tool_card.dart';
import '../widgets/metronome_sheet.dart';
import '../widgets/tuner_sheet.dart';
import '../widgets/vibrato_sheet.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _micEnabled = false;

  Future<void> _requestMic() async {
    final status = await Permission.microphone.request();
    if (status.isGranted) {
      setState(() => _micEnabled = true);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Microphone permission is needed for tools to work.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  void _openSheet(Widget sheet) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.6),
      builder: (_) => sheet,
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bg = isDark ? const Color(0xFF0E0E1A) : const Color(0xFFF4F1EE);
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C3A);
    final subColor = isDark ? Colors.white54 : Colors.black45;

    return Scaffold(
      backgroundColor: bg,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),

              // ── Header ──────────────────────────────────────
              Text(
                'Flute AI',
                style: TextStyle(
                  color: textColor,
                  fontSize: 36,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -1.0,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Your intelligent practice companion.',
                style: TextStyle(
                  color: subColor,
                  fontSize: 15,
                  fontWeight: FontWeight.w400,
                ),
              ),

              const SizedBox(height: 40),

              // ── Mic Enable Button ────────────────────────────
              GestureDetector(
                onTap: _micEnabled ? null : _requestMic,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  decoration: BoxDecoration(
                    gradient: _micEnabled
                        ? const LinearGradient(
                            colors: [Color(0xFF34C759), Color(0xFF28A745)],
                          )
                        : const LinearGradient(
                            colors: [Color(0xFF5B8CFF), Color(0xFF3D6FE8)],
                          ),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: (_micEnabled
                                ? const Color(0xFF34C759)
                                : const Color(0xFF5B8CFF))
                            .withOpacity(0.35),
                        blurRadius: 20,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        _micEnabled ? Icons.mic : Icons.mic_off,
                        color: Colors.white,
                        size: 22,
                      ),
                      const SizedBox(width: 10),
                      Text(
                        _micEnabled
                            ? 'Microphone Enabled ✓'
                            : 'Enable Microphone',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 36),

              Text(
                'TOOLS',
                style: TextStyle(
                  color: subColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.8,
                ),
              ),

              const SizedBox(height: 16),

              // ── Tool Cards ───────────────────────────────────
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(),
                  children: [
                    ToolCard(
                      icon: Icons.timer_outlined,
                      title: 'Metronome',
                      subtitle: '50 – 1000 BPM • Max volume',
                      gradientColors: const [Color(0xFF5B8CFF), Color(0xFF8B5CF6)],
                      locked: !_micEnabled,
                      onTap: () => _openSheet(const MetronomeSheet()),
                    ),
                    const SizedBox(height: 14),
                    ToolCard(
                      icon: Icons.tune_rounded,
                      title: 'Tuner',
                      subtitle: '440 Hz reference • Cent display',
                      gradientColors: const [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                      locked: !_micEnabled,
                      onTap: () => _openSheet(const TunerSheet()),
                    ),
                    const SizedBox(height: 14),
                    ToolCard(
                      icon: Icons.graphic_eq_rounded,
                      title: 'Vibrato Scanner',
                      subtitle: 'Waveform • Frequency analysis',
                      gradientColors: const [Color(0xFF11998E), Color(0xFF38EF7D)],
                      locked: !_micEnabled,
                      onTap: () => _openSheet(const VibratoSheet()),
                    ),
                    const SizedBox(height: 30),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
