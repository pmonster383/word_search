import 'package:flutter/material.dart';

enum TimerDifficulty {
  easy(90, 'Easy', Color(0xFF10B981), '90 Seconds'),
  medium(60, 'Medium', Color(0xFFF59E0B), '60 Seconds'),
  hard(30, 'Hard', Color(0xFFEF4444), '30 Seconds');

  final int durationSeconds;
  final String label;
  final Color color;
  final String description;

  const TimerDifficulty(
    this.durationSeconds,
    this.label,
    this.color,
    this.description,
  );

  int get bonusCoins {
    switch (this) {
      case TimerDifficulty.easy:
        return 25;
      case TimerDifficulty.medium:
        return 50;
      case TimerDifficulty.hard:
        return 100;
    }
  }
}
