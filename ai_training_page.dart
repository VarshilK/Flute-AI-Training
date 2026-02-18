import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:permission_handler/permission_handler.dart';

class AITrainingPage extends StatefulWidget {
  const AITrainingPage({super.key});

  @override
  State<AITrainingPage> createState() => _AITrainingPageState();
}

class _AITrainingPageState extends State<AITrainingPage> {
  CameraController? _cameraController;
  bool _cameraReady = false;
  final TextEditingController _chatController = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _aiThinking = false;

  // Simulated AI responses for flute posture/practice questions
  static const _aiResponses = [
    'Try keeping your flute parallel to the floor — it helps with airflow and tone production.',
    'Your embouchure looks tense. Relax your lips slightly and direct air downward across the tone hole.',
    'For this passage, slow it down to 60 BPM first. Master accuracy before speed.',
    'Focus on long tones today — sustain each note for 8 counts and listen for a warm, centered sound.',
    'Your wrist angle looks stiff. Let your right wrist drop naturally to reduce tension.',
    'Great question! Practice the chromatic scale slowly to build finger independence.',
    'Try using more air support from your diaphragm. Push your stomach out as you breathe in.',
  ];

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  @override
  void dispose() {
    _cameraController?.dispose();
    _chatController.dispose();
    super.dispose();
  }

  Future<void> _initCamera() async {
    final status = await Permission.camera.request();
    if (!status.isGranted) return;

    final cameras = await availableCameras();
    if (cameras.isEmpty) return;

    // Use front camera for posture checking
    final frontCamera = cameras.firstWhere(
      (c) => c.lensDirection == CameraLensDirection.front,
      orElse: () => cameras.first,
    );

    _cameraController = CameraController(
      frontCamera,
      ResolutionPreset.medium,
      enableAudio: false,
    );

    await _cameraController!.initialize();
    if (mounted) setState(() => _cameraReady = true);
  }

  void _sendMessage() async {
    final text = _chatController.text.trim();
    if (text.isEmpty) return;

    setState(() {
      _messages.add({'role': 'user', 'text': text});
      _aiThinking = true;
    });
    _chatController.clear();

    // Simulate AI thinking delay
    await Future.delayed(const Duration(milliseconds: 900));

    final response = _aiResponses[
        (_messages.length - 1) % _aiResponses.length];

    if (mounted) {
      setState(() {
        _messages.add({'role': 'ai', 'text': response});
        _aiThinking = false;
      });
    }
  }

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
        child: Column(
          children: [
            // ── Header ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 16),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'AI Training',
                        style: TextStyle(
                          color: textColor,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.8,
                        ),
                      ),
                      Text(
                        'Posture check + practice coach',
                        style: TextStyle(color: subColor, fontSize: 13),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    // ── Camera Card ──────────────────────────
                    Container(
                      height: 220,
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      clipBehavior: Clip.hardEdge,
                      child: Stack(
                        children: [
                          if (_cameraReady && _cameraController != null)
                            Positioned.fill(
                              child: CameraPreview(_cameraController!),
                            )
                          else
                            Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.videocam_outlined,
                                      color: subColor, size: 40),
                                  const SizedBox(height: 8),
                                  Text(
                                    _cameraReady
                                        ? 'Camera ready'
                                        : 'Allow camera access\nto check your posture',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: subColor, fontSize: 13),
                                  ),
                                ],
                              ),
                            ),

                          // Overlay badge
                          Positioned(
                            top: 12,
                            left: 12,
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 5),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 7,
                                    height: 7,
                                    decoration: const BoxDecoration(
                                      color: Color(0xFF34C759),
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  const Text(
                                    'LIVE',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 11,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 1,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── AI Chat ──────────────────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: cardBg,
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(isDark ? 0.3 : 0.08),
                            blurRadius: 16,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Ask Your Coach',
                            style: TextStyle(
                              color: textColor,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 12),

                          // Messages
                          if (_messages.isEmpty)
                            Padding(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              child: Text(
                                'Not sure what to practice? Describe your problem and I\'ll help.',
                                style:
                                    TextStyle(color: subColor, fontSize: 13),
                              ),
                            )
                          else
                            ...(_messages.map((m) => _ChatBubble(
                                  message: m['text']!,
                                  isUser: m['role'] == 'user',
                                  isDark: isDark,
                                ))),

                          if (_aiThinking)
                            Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 14, vertical: 10),
                                    decoration: BoxDecoration(
                                      color: isDark
                                          ? Colors.white10
                                          : Colors.black06,
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Text(
                                      '...',
                                      style: TextStyle(
                                        color: subColor,
                                        fontSize: 18,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const SizedBox(height: 12),

                          // Input row
                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: _chatController,
                                  style: TextStyle(
                                      color: textColor, fontSize: 14),
                                  decoration: InputDecoration(
                                    hintText: 'Describe your problem...',
                                    hintStyle: TextStyle(
                                        color: subColor, fontSize: 14),
                                    filled: true,
                                    fillColor: isDark
                                        ? Colors.white.withOpacity(0.07)
                                        : Colors.black.withOpacity(0.04),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(16),
                                      borderSide: BorderSide.none,
                                    ),
                                    contentPadding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 12),
                                  ),
                                  onSubmitted: (_) => _sendMessage(),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: _sendMessage,
                                child: Container(
                                  width: 46,
                                  height: 46,
                                  decoration: BoxDecoration(
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF5B8CFF),
                                        Color(0xFF3D6FE8)
                                      ],
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                  child: const Icon(Icons.send_rounded,
                                      color: Colors.white, size: 20),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ChatBubble extends StatelessWidget {
  final String message;
  final bool isUser;
  final bool isDark;

  const _ChatBubble({
    required this.message,
    required this.isUser,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment:
            isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          if (!isUser) ...[
            Container(
              width: 28,
              height: 28,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF5B8CFF), Color(0xFF8B5CF6)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.auto_awesome,
                  color: Colors.white, size: 14),
            ),
            const SizedBox(width: 8),
          ],
          Flexible(
            child: Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                gradient: isUser
                    ? const LinearGradient(
                        colors: [Color(0xFF5B8CFF), Color(0xFF3D6FE8)])
                    : null,
                color: isUser
                    ? null
                    : (isDark
                        ? Colors.white.withOpacity(0.08)
                        : Colors.black.withOpacity(0.05)),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(
                message,
                style: TextStyle(
                  color: isUser
                      ? Colors.white
                      : (isDark ? Colors.white : const Color(0xFF1C1C3A)),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
