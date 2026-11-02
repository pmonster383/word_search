import 'dart:math';
import 'package:flutter/material.dart';
import '../models/timer_difficulty.dart';

class TimerBarWidget extends StatefulWidget {
  final int remainingSeconds;
  final int totalSeconds;
  final TimerDifficulty difficulty;

  const TimerBarWidget({
    super.key,
    required this.remainingSeconds,
    required this.totalSeconds,
    required this.difficulty,
  });

  @override
  State<TimerBarWidget> createState() => _TimerBarWidgetState();
}

class _TimerBarWidgetState extends State<TimerBarWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  String _formatTime(int seconds) {
    final m = seconds ~/ 60;
    final s = seconds % 60;
    return '${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final ratio = widget.totalSeconds > 0
        ? (widget.remainingSeconds / widget.totalSeconds).clamp(0.0, 1.0)
        : 0.0;
    final isLowTime = widget.remainingSeconds <= 10 && widget.remainingSeconds > 0;

    // Determine color based on time left
    Color barColor = widget.difficulty.color;
    if (widget.remainingSeconds <= 10) {
      barColor = const Color(0xFFEF4444); // Red
    } else if (widget.remainingSeconds <= 20) {
      barColor = const Color(0xFFF59E0B); // Amber
    }

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 8.0),
      decoration: BoxDecoration(
        color: isLowTime ? const Color(0xFF450A0A).withOpacity(0.92) : Colors.white.withOpacity(0.94),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isLowTime ? const Color(0xFFEF4444) : barColor.withOpacity(0.6),
          width: isLowTime ? 2.0 : 1.2,
        ),
        boxShadow: [
          BoxShadow(
            color: isLowTime ? const Color(0xFFEF4444).withOpacity(0.4) : Colors.black.withOpacity(0.15),
            blurRadius: isLowTime ? 12 : 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Difficulty Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: widget.difficulty.color.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: widget.difficulty.color, width: 1),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.bolt_rounded, size: 14, color: widget.difficulty.color),
                    const SizedBox(width: 4),
                    Text(
                      '${widget.difficulty.label.toUpperCase()} (${widget.difficulty.durationSeconds}s)',
                      style: TextStyle(
                        color: widget.difficulty.color,
                        fontWeight: FontWeight.w900,
                        fontSize: 11,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),

              // Countdown Clock
              AnimatedBuilder(
                animation: _pulseController,
                builder: (context, child) {
                  final scale = isLowTime ? 1.0 + 0.12 * sin(_pulseController.value * pi) : 1.0;
                  return Transform.scale(
                    scale: scale,
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          isLowTime ? Icons.alarm_rounded : Icons.timer_rounded,
                          size: 18,
                          color: isLowTime ? const Color(0xFFEF4444) : barColor,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(widget.remainingSeconds),
                          style: TextStyle(
                            fontFamily: 'Courier',
                            fontSize: 16,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.0,
                            color: isLowTime ? Colors.white : const Color(0xFF1E293B),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ],
          ),

          const SizedBox(height: 6),

          // Visual Progress Gauge Bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6),
            child: Container(
              height: 6,
              color: isLowTime ? Colors.white24 : Colors.grey.shade300,
              child: Stack(
                children: [
                  FractionallySizedBox(
                    widthFactor: ratio,
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            barColor,
                            barColor.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
