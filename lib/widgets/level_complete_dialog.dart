import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/chapter_model.dart';

class LevelCompleteDialog extends StatelessWidget {
  final int levelId;
  final ChapterModel chapter;
  final VoidCallback onNextLevel;

  const LevelCompleteDialog({
    super.key,
    required this.levelId,
    required this.chapter,
    required this.onNextLevel,
  });

  @override
  Widget build(BuildContext context) {
    final chapterCurrent = (levelId - chapter.startLevel + 1).clamp(1, chapter.totalLevels);
    final progressRatio = chapterCurrent / chapter.totalLevels;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Main Card
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.3),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Encouraging Toast
                const Text(
                  'Awesome!',
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF10B981),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 16),

                // Chapter & Progress Title
                Text(
                  '${chapter.title}: Chapter 1',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),

                // Progress Bar with Gift Box
                Row(
                  children: [
                    Expanded(
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          height: 22,
                          color: const Color(0xFFE2E8F0),
                          child: Stack(
                            children: [
                              FractionallySizedBox(
                                widthFactor: progressRatio,
                                child: Container(
                                  decoration: const BoxDecoration(
                                    gradient: LinearGradient(
                                      colors: [
                                        Color(0xFF38BDF8),
                                        Color(0xFF2563EB),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Center(
                                child: Text(
                                  '$chapterCurrent/${chapter.totalLevels}',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black45,
                                        blurRadius: 2,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Gift box icon at the milestone
                    Container(
                      padding: const EdgeInsets.all(6),
                      decoration: const BoxDecoration(
                        color: Color(0xFF10B981),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.card_giftcard_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 20),

                // Coins earned banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF3C7),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFF59E0B)),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.monetization_on_rounded, color: AppColors.goldCoinDark, size: 22),
                      SizedBox(width: 8),
                      Text(
                        '+25 Coins Earned!',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                // Next Level Button
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onNextLevel,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                      elevation: 6,
                    ),
                    child: const Text(
                      'CONTINUE',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top Ribbon: "Level X Completed!"
          Positioned(
            top: 0,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white, width: 2.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Text(
                'Level $levelId Completed!',
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
