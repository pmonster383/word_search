import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/timer_difficulty.dart';

class TimerModeDialog extends StatefulWidget {
  final int currentLevelId;
  final int unlockedMaxLevel;
  final Function(TimerDifficulty difficulty, int levelId) onStartTimerLevel;
  final VoidCallback onBrowseTimerLevels;

  const TimerModeDialog({
    super.key,
    required this.currentLevelId,
    required this.unlockedMaxLevel,
    required this.onStartTimerLevel,
    required this.onBrowseTimerLevels,
  });

  @override
  State<TimerModeDialog> createState() => _TimerModeDialogState();
}

class _TimerModeDialogState extends State<TimerModeDialog> {
  TimerDifficulty _selectedDifficulty = TimerDifficulty.easy;
  late int _selectedLevelId;

  @override
  void initState() {
    super.initState();
    _selectedLevelId = widget.currentLevelId;
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 24, 20, 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEF4444).withOpacity(0.12),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.timer_rounded, color: Color(0xFFEF4444), size: 26),
                    ),
                    const SizedBox(width: 10),
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Timer Challenge',
                          style: TextStyle(
                            fontSize: 19,
                            fontWeight: FontWeight.w900,
                            color: AppColors.darkText,
                          ),
                        ),
                        Text(
                          'Beat all 6,000 Levels against the clock!',
                          style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(height: 20),

            // Section Label
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'SELECT DIFFICULTY',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w900,
                  color: Colors.grey.shade600,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            const SizedBox(height: 10),

            // 3 Difficulty Options
            _buildDifficultyCard(
              difficulty: TimerDifficulty.easy,
              subtitle: 'Ideal for relaxed speed search',
              timeLabel: '90s',
            ),
            const SizedBox(height: 8),
            _buildDifficultyCard(
              difficulty: TimerDifficulty.medium,
              subtitle: 'Balanced test of focus & speed',
              timeLabel: '60s',
            ),
            const SizedBox(height: 8),
            _buildDifficultyCard(
              difficulty: TimerDifficulty.hard,
              subtitle: 'Master sprint puzzle challenge',
              timeLabel: '30s',
            ),

            const SizedBox(height: 16),

            // Level Selector Row
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.flag_rounded, color: Color(0xFF2563EB), size: 20),
                      const SizedBox(width: 8),
                      Text(
                        'Level $_selectedLevelId',
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                  TextButton.icon(
                    onPressed: () {
                      Navigator.pop(context);
                      widget.onBrowseTimerLevels();
                    },
                    icon: const Icon(Icons.format_list_numbered_rounded, size: 16),
                    label: const Text('Change Level', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 12)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Start Challenge Button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  widget.onStartTimerLevel(_selectedDifficulty, _selectedLevelId);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: _selectedDifficulty.color,
                  foregroundColor: Colors.white,
                  elevation: 6,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.play_arrow_rounded, size: 24),
                    const SizedBox(width: 8),
                    Text(
                      'START (${_selectedDifficulty.durationSeconds}s)',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDifficultyCard({
    required TimerDifficulty difficulty,
    required String subtitle,
    required String timeLabel,
  }) {
    final isSelected = _selectedDifficulty == difficulty;

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedDifficulty = difficulty;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? difficulty.color.withOpacity(0.12) : Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: isSelected ? difficulty.color : Colors.grey.shade300,
            width: isSelected ? 2.2 : 1.0,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: difficulty.color.withOpacity(0.2),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
          ],
        ),
        child: Row(
          children: [
            // Time Badge
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: difficulty.color,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(
                  timeLabel,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w900,
                    fontSize: 15,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        difficulty.label,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w900,
                          color: isSelected ? difficulty.color : AppColors.darkText,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          '+${difficulty.bonusCoins} Coins',
                          style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                            color: Color(0xFF92400E),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),

            // Radio Indicator
            Icon(
              isSelected ? Icons.check_circle_rounded : Icons.radio_button_unchecked_rounded,
              color: isSelected ? difficulty.color : Colors.grey.shade400,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
