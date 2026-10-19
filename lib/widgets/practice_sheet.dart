import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'sheet_wrapper.dart';

class PracticeSheet extends StatefulWidget {
  const PracticeSheet({super.key});

  @override
  State<PracticeSheet> createState() => _PracticeSheetState();
}

class _PracticeSheetState extends State<PracticeSheet>
    with SingleTickerProviderStateMixin {
  int _selectedScale = 0;
  int _currentNoteIndex = 0;
  bool _isPlaying = false;
  List<_NoteResult> _results = [];
  double _bpm = 60.0;
  late AnimationController _playheadController;
  double _playheadX = 0.0;

  final List<Map<String, dynamic>> _scales = [
    {
      'name': 'C Major',
      'notes': ['C4','D4','E4','F4','G4','A4','B4','C5','D5','E5','F5','G5','A5','B5','C6'],
      'frequencies': [261.63,293.66,329.63,349.23,392.00,440.00,493.88,523.25,587.33,659.25,698.46,783.99,880.00,987.77,1046.50],
    },
    {
      'name': 'G Major',
      'notes': ['G4','A4','B4','C5','D5','E5','F#5','G5','A5','B5','C6','D6','E6','F#6','G6'],
      'frequencies': [392.00,440.00,493.88,523.25,587.33,659.25,739.99,783.99,880.00,987.77,1046.50,1174.66,1318.51,1479.98,1567.98],
    },
    {
      'name': 'D Major',
      'notes': ['D4','E4','F#4','G4','A4','B4','C#5','D5','E5','F#5','G5','A5','B5','C#6','D6'],
      'frequencies': [293.66,329.63,369.99,392.00,440.00,493.88,554.37,587.33,659.25,739.99,783.99,880.00,987.77,1108.73,1174.66],
    },
    {
      'name': 'F Major',
      'notes': ['F4','G4','A4','Bb4','C5','D5','E5','F5','G5','A5','Bb5','C6','D6','E6','F6'],
      'frequencies': [349.23,392.00,440.00,466.16,523.25,587.33,659.25,698.46,783.99,880.00,932.33,1046.50,1174.66,1318.51,1396.91],
    },
    {
      'name': 'A Minor',
      'notes': ['A4','B4','C5','D5','E5','F5','G5','A5','B5','C6','D6','E6','F6','G6','A6'],
      'frequencies': [440.00,493.88,523.25,587.33,659.25,698.46,783.99,880.00,987.77,1046.50,1174.66,1318.51,1396.91,1567.98,1760.00],
    },
  ];

  static const int _notesPerLine = 8;

  // Correct treble clef positions: E4=0 (bottom line), each step = 1
  static const Map<String, int> _noteStaffPosition = {
    'C4': -2, 'D4': -1,
    'E4': 0, 'F4': 1, 'F#4': 1, 'G4': 2, 'A4': 3, 'B4': 4,
    'Bb4': 1,
    'C5': 5, 'C#5': 5, 'D5': 6, 'E5': 7, 'F5': 8, 'F#5': 8,
    'G5': 9, 'A5': 10, 'B5': 11, 'Bb5': 8,
    'C6': 12, 'C#6': 12, 'D6': 13, 'E6': 14, 'F6': 15, 'F#6': 15,
    'G6': 16, 'A6': 17,
  };

  @override
  void initState() {
    super.initState();
    _playheadController = AnimationController(vsync: this);
    _playheadController.addListener(() {
      setState(() => _playheadX = _playheadController.value);
    });
  }

  @override
  void dispose() {
    _isPlaying = false;
    _playheadController.dispose();
    super.dispose();
  }

  int get _currentLine => _currentNoteIndex ~/ _notesPerLine;
  int get _totalLines {
    final notes = _scales[_selectedScale]['notes'] as List;
    return (notes.length / _notesPerLine).ceil();
  }

  Future<void> _startPractice() async {
    final notes = _scales[_selectedScale]['notes'] as List<String>;
    setState(() {
      _isPlaying = true;
      _currentNoteIndex = 0;
      _results = List.filled(notes.length, _NoteResult.pending);
      _playheadX = 0.0;
    });
    _runPlayhead();
  }

  void _runPlayhead() {
    if (!_isPlaying || !mounted) return;
    final notes = _scales[_selectedScale]['notes'] as List<String>;
    final totalNotes = notes.length;
    final beatDuration = 60.0 / _bpm; // seconds per beat
    final totalDuration = beatDuration * totalNotes;

    _playheadController.duration = Duration(
      milliseconds: (totalDuration * 1000).round(),
    );
    _playheadController.forward(from: 0).then((_) {
      if (mounted && _isPlaying) {
        setState(() => _isPlaying = false);
      }
    });

    // Schedule note evaluations
    for (int i = 0; i < totalNotes; i++) {
      final delay = Duration(milliseconds: ((beatDuration * i + beatDuration * 0.5) * 1000).round());
      Future.delayed(delay, () {
        if (!_isPlaying || !mounted) return;
        final noteIndex = i;
        setState(() => _currentNoteIndex = noteIndex);
        // Simulate detection
        final rand = math.Random();
        final targetFreq = (_scales[_selectedScale]['frequencies'] as List<double>)[noteIndex];
        final simFreq = targetFreq * (0.85 + rand.nextDouble() * 0.3);
        final percentOff = ((simFreq - targetFreq) / targetFreq).abs() * 100;
        _NoteResult result;
        if (percentOff <= 3.0) {
          result = _NoteResult.correct;
        } else if (percentOff <= 8.0) {
          result = _NoteResult.wrongTime;
        } else {
          result = _NoteResult.wrongNote;
        }
        setState(() {
          _results[noteIndex] = result;
        });
      });
    }
  }

  void _stopPractice() {
    _playheadController.stop();
    setState(() {
      _isPlaying = false;
      _playheadX = 0.0;
      _currentNoteIndex = 0;
    });
  }

  Color _resultColor(_NoteResult r) {
    switch (r) {
      case _NoteResult.correct: return const Color(0xFF34C759);
      case _NoteResult.wrongTime: return const Color(0xFFFFCC00);
      case _NoteResult.wrongNote: return const Color(0xFFFF3B30);
      case _NoteResult.pending: return Colors.transparent;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = isDark ? Colors.white : const Color(0xFF1C1C3A);
    final subColor = isDark ? Colors.white54 : Colors.black45;
    final notes = _scales[_selectedScale]['notes'] as List<String>;

    // Which line are we on based on playhead progress
    final totalNotes = notes.length;
    final globalNoteIndex = (_playheadX * totalNotes).floor().clamp(0, totalNotes - 1);
    final currentLine = globalNoteIndex ~/ _notesPerLine;
    final lineStart = currentLine * _notesPerLine;
    final lineEnd = (lineStart + _notesPerLine).clamp(0, totalNotes);
    final lineNotes = notes.sublist(lineStart, lineEnd);
    final lineResults = _results.isEmpty
        ? List.filled(lineNotes.length, _NoteResult.pending)
        : _results.sublist(lineStart, lineEnd);

    // Playhead position within current line (0.0 to 1.0)
    final notesPerLineActual = lineEnd - lineStart;
    final noteInLine = globalNoteIndex - lineStart;
    final playheadFraction = _isPlaying
        ? (noteInLine + (_playheadX * totalNotes - globalNoteIndex)) / notesPerLineActual
        : 0.0;

    return SheetWrapper(
      title: 'Scale Practice',
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 16),

          // Scale Selector
          Text('SELECT SCALE', style: TextStyle(
              color: subColor, fontSize: 11,
              fontWeight: FontWeight.w700, letterSpacing: 1.5)),
          const SizedBox(height: 10),
          SizedBox(
            height: 38,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _scales.length,
              itemBuilder: (_, i) {
                final selected = i == _selectedScale;
                return GestureDetector(
                  onTap: _isPlaying ? null : () => setState(() {
                    _selectedScale = i;
                    _results = [];
                    _currentNoteIndex = 0;
                    _playheadX = 0.0;
                  }),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    decoration: BoxDecoration(
                      gradient: selected ? const LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)]) : null,
                      color: selected ? null : (isDark ? Colors.white10
                          : Colors.black.withValues(alpha: 0.06)),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(_scales[i]['name'],
                        style: TextStyle(
                          color: selected ? Colors.white : subColor,
                          fontSize: 13,
                          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                        )),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 20),

          // BPM Slider
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('TEMPO', style: TextStyle(
                  color: subColor, fontSize: 11,
                  fontWeight: FontWeight.w700, letterSpacing: 1.5)),
              Text('${_bpm.round()} BPM', style: TextStyle(
                  color: textColor, fontSize: 13, fontWeight: FontWeight.w700)),
            ],
          ),
          const SizedBox(height: 6),
          SliderTheme(
            data: SliderTheme.of(context).copyWith(
              activeTrackColor: const Color(0xFF11998E),
              inactiveTrackColor: isDark ? Colors.white12 : Colors.black12,
              thumbColor: const Color(0xFF38EF7D),
              trackHeight: 4,
            ),
            child: Slider(
              value: _bpm,
              min: 40,
              max: 160,
              divisions: 120,
              onChanged: _isPlaying ? null : (v) => setState(() => _bpm = v),
            ),
          ),

          const SizedBox(height: 8),

          // Sheet Music
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('SHEET MUSIC', style: TextStyle(
                  color: subColor, fontSize: 11,
                  fontWeight: FontWeight.w700, letterSpacing: 1.5)),
              Text('Line ${currentLine + 1} of $_totalLines',
                  style: TextStyle(color: subColor, fontSize: 11)),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: isDark ? Colors.white.withValues(alpha: 0.05) : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? Colors.white12 : Colors.black12,
              ),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16),
              child: CustomPaint(
                painter: _SheetMusicPainter(
                  notes: lineNotes,
                  playheadFraction: playheadFraction,
                  results: lineResults,
                  isDark: isDark,
                  notePositions: _noteStaffPosition,
                  isPlaying: _isPlaying,
                  currentNoteInLine: noteInLine,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Now playing
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: isDark ? Colors.white10 : Colors.black.withValues(alpha: 0.05),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              children: [
                Text('NOW PLAYING', style: TextStyle(
                    color: subColor, fontSize: 11,
                    fontWeight: FontWeight.w700, letterSpacing: 1.5)),
                const SizedBox(height: 4),
                Text(
                  _isPlaying && globalNoteIndex < notes.length
                      ? notes[globalNoteIndex] : '--',
                  style: TextStyle(
                      color: textColor, fontSize: 28,
                      fontWeight: FontWeight.w900),
                ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Legend
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _LegendDot(color: const Color(0xFF34C759), label: 'Correct'),
              const SizedBox(width: 12),
              _LegendDot(color: const Color(0xFFFFCC00), label: 'Close'),
              const SizedBox(width: 12),
              _LegendDot(color: const Color(0xFFFF3B30), label: 'Wrong'),
            ],
          ),

          const SizedBox(height: 14),

          // Score
          if (_results.isNotEmpty && _results.any((r) => r != _NoteResult.pending))
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? Colors.white.withValues(alpha: 0.06)
                    : Colors.black.withValues(alpha: 0.04),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _ScoreStat(
                    value: _results.where((r) => r == _NoteResult.correct).length.toString(),
                    label: 'Correct', color: const Color(0xFF34C759)),
                  _ScoreStat(
                    value: _results.where((r) => r == _NoteResult.wrongTime).length.toString(),
                    label: 'Close', color: const Color(0xFFFFCC00)),
                  _ScoreStat(
                    value: _results.where((r) => r == _NoteResult.wrongNote).length.toString(),
                    label: 'Wrong', color: const Color(0xFFFF3B30)),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Start/Stop
          Center(
            child: GestureDetector(
              onTap: _isPlaying ? _stopPractice : _startPractice,
              child: Container(
                width: 180, height: 52,
                decoration: BoxDecoration(
                  gradient: _isPlaying
                      ? const LinearGradient(
                          colors: [Color(0xFFFF6B6B), Color(0xFFFF4757)])
                      : const LinearGradient(
                          colors: [Color(0xFF11998E), Color(0xFF38EF7D)]),
                  borderRadius: BorderRadius.circular(28),
                  boxShadow: [BoxShadow(
                    color: (_isPlaying ? const Color(0xFFFF6B6B)
                        : const Color(0xFF38EF7D)).withValues(alpha: 0.4),
                    blurRadius: 20, offset: const Offset(0, 6),
                  )],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(_isPlaying ? Icons.stop_rounded : Icons.play_arrow_rounded,
                        color: Colors.white, size: 26),
                    const SizedBox(width: 8),
                    Text(_isPlaying ? 'Stop' : 'Start Practice',
                        style: const TextStyle(
                            color: Colors.white, fontSize: 15,
                            fontWeight: FontWeight.w700)),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _SheetMusicPainter extends CustomPainter {
  final List<String> notes;
  final double playheadFraction;
  final List<_NoteResult> results;
  final bool isDark;
  final Map<String, int> notePositions;
  final bool isPlaying;
  final int currentNoteInLine;

  _SheetMusicPainter({
    required this.notes,
    required this.playheadFraction,
    required this.results,
    required this.isDark,
    required this.notePositions,
    required this.isPlaying,
    required this.currentNoteInLine,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final lineColor = isDark ? Colors.white24 : Colors.black26;
    final linePaint = Paint()..color = lineColor..strokeWidth = 1.0;

    // Staff positioning — keep notes well within the box
    final double staffTop = size.height * 0.30;
    final double lineSpacing = size.height * 0.11;
    final double leftPad = 52.0;
    final double rightPad = 16.0;
    final double usableWidth = size.width - leftPad - rightPad;
    final double noteSpacing = usableWidth / (notes.length + 1);

    // Draw 5 staff lines
    for (int i = 0; i < 5; i++) {
      final y = staffTop + i * lineSpacing;
      canvas.drawLine(
        Offset(leftPad - 8, y),
        Offset(size.width - rightPad, y),
        linePaint,
      );
    }

    // Treble clef
    final clef = TextPainter(
      text: TextSpan(text: '𝄞',
          style: TextStyle(fontSize: 68,
              color: isDark ? Colors.white38 : Colors.black38)),
      textDirection: TextDirection.ltr,
    );
    clef.layout();
    clef.paint(canvas, Offset(2, staffTop - 20));

    // E4 is position 0 = bottom line of staff = staffTop + 4*lineSpacing
    // Each position step = lineSpacing/2
    double noteY(int position) {
      return staffTop + 4 * lineSpacing - position * (lineSpacing / 2);
    }

    // Draw notes
    for (int i = 0; i < notes.length; i++) {
      final note = notes[i];
      final position = notePositions[note] ?? 0;
      final x = leftPad + (i + 1) * noteSpacing;
      final y = noteY(position);

      // Note color
      Color noteColor;
      if (i < results.length && results[i] != _NoteResult.pending) {
        switch (results[i]) {
          case _NoteResult.correct:
            noteColor = const Color(0xFF34C759); break;
          case _NoteResult.wrongTime:
            noteColor = const Color(0xFFFFCC00); break;
          case _NoteResult.wrongNote:
            noteColor = const Color(0xFFFF3B30); break;
          default:
            noteColor = isDark ? Colors.white60 : Colors.black54;
        }
      } else if (i == currentNoteInLine && isPlaying) {
        noteColor = const Color(0xFF5B8CFF);
      } else {
        noteColor = isDark ? Colors.white60 : Colors.black54;
      }

      final notePaint = Paint()..color = noteColor;

      // Ledger line for C4 (position -2)
      if (position <= -2) {
        for (int l = -2; l >= position; l -= 2) {
          canvas.drawLine(
            Offset(x - 10, noteY(l)),
            Offset(x + 10, noteY(l)),
            Paint()..color = noteColor..strokeWidth = 1.5,
          );
        }
      }

      // Ledger lines above staff (position >= 10)
      if (position >= 10) {
        for (int l = 10; l <= position; l += 2) {
          canvas.drawLine(
            Offset(x - 10, noteY(l)),
            Offset(x + 10, noteY(l)),
            Paint()..color = noteColor..strokeWidth = 1.5,
          );
        }
      }

      // Highlight ring for current note
      if (i == currentNoteInLine && isPlaying) {
        canvas.drawOval(
          Rect.fromCenter(center: Offset(x, y), width: 22, height: 18),
          Paint()
            ..color = const Color(0xFF5B8CFF).withValues(alpha: 0.25)
            ..style = PaintingStyle.fill,
        );
      }

      // Note head
      canvas.drawOval(
        Rect.fromCenter(center: Offset(x, y), width: 13, height: 10),
        notePaint,
      );

      // Stem — up if below middle, down if above
      final stemUp = position < 6;
      canvas.drawLine(
        Offset(x + (stemUp ? 6 : -6), y),
        Offset(x + (stemUp ? 6 : -6), y + (stemUp ? -32 : 32)),
        Paint()..color = noteColor..strokeWidth = 1.5,
      );

      // Accidentals
      if (note.contains('#')) {
        final p = TextPainter(
          text: TextSpan(text: '♯',
              style: TextStyle(fontSize: 12, color: noteColor)),
          textDirection: TextDirection.ltr,
        );
        p.layout();
        p.paint(canvas, Offset(x - 20, y - 8));
      } else if (note.length > 2 && note[1] == 'b') {
        final p = TextPainter(
          text: TextSpan(text: '♭',
              style: TextStyle(fontSize: 12, color: noteColor)),
          textDirection: TextDirection.ltr,
        );
        p.layout();
        p.paint(canvas, Offset(x - 20, y - 8));
      }
    }

    // Continuous playhead line
    if (isPlaying && notes.isNotEmpty) {
      final playheadXPos = leftPad + playheadFraction * usableWidth + noteSpacing * 0.5;
      canvas.drawLine(
        Offset(playheadXPos, staffTop - 18),
        Offset(playheadXPos, staffTop + 4 * lineSpacing + 18),
        Paint()
          ..color = const Color(0xFF5B8CFF).withValues(alpha: 0.8)
          ..strokeWidth = 2.5,
      );
    }
  }

  @override
  bool shouldRepaint(_SheetMusicPainter old) =>
      old.playheadFraction != playheadFraction ||
      old.results != results ||
      old.isPlaying != isPlaying ||
      old.currentNoteInLine != currentNoteInLine;
}

enum _NoteResult { correct, wrongTime, wrongNote, pending }

class _LegendDot extends StatelessWidget {
  final Color color;
  final String label;
  const _LegendDot({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return Row(
      children: [
        Container(width: 10, height: 10,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle)),
        const SizedBox(width: 5),
        Text(label, style: TextStyle(
            color: isDark ? Colors.white54 : Colors.black45, fontSize: 11)),
      ],
    );
  }
}

class _ScoreStat extends StatelessWidget {
  final String value, label;
  final Color color;
  const _ScoreStat(
      {required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(value, style: TextStyle(
            color: color, fontSize: 26, fontWeight: FontWeight.w900)),
        Text(label, style: const TextStyle(
            color: Colors.white54, fontSize: 11)),
      ],
    );
  }
}