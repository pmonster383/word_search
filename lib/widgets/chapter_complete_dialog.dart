import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/chapter_model.dart';

class ChapterCompleteDialog extends StatelessWidget {
  final ChapterModel completedChapter;
  final ChapterModel nextChapter;
  final VoidCallback onDoubleReward;
  final VoidCallback onCollect;

  const ChapterCompleteDialog({
    super.key,
    required this.completedChapter,
    required this.nextChapter,
    required this.onDoubleReward,
    required this.onCollect,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Darkened backdrop card
          Container(
            margin: const EdgeInsets.only(top: 50),
            padding: const EdgeInsets.fromLTRB(24, 70, 24, 28),
            decoration: BoxDecoration(
              color: const Color(0xFF0F172A).withOpacity(0.92),
              borderRadius: BorderRadius.circular(32),
              border: Border.all(color: Colors.white.withOpacity(0.2), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.5),
                  blurRadius: 30,
                  offset: const Offset(0, 12),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Big Stack of Coins Graphic
                Container(
                  width: 120,
                  height: 100,
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Glow
                      Container(
                        width: 90,
                        height: 90,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.goldCoin.withOpacity(0.25),
                        ),
                      ),
                      // Coins Stack Icon
                      const Icon(
                        Icons.monetization_on_rounded,
                        size: 80,
                        color: AppColors.goldCoin,
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 8),

                // Coins Amount Badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.goldCoin, width: 1.5),
                  ),
                  child: Text(
                    '${completedChapter.rewardCoins}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ),

                const SizedBox(height: 18),

                // Unlocked Next Chapter Banner
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.stars_rounded, color: AppColors.starYellow, size: 22),
                          const SizedBox(width: 8),
                          Text(
                            '${nextChapter.title} Unlocked!',
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'New Chapter Unlocked!',
                        style: TextStyle(
                          color: Colors.white.withOpacity(0.8),
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 28),

                // DOUBLE Button (Rewarded Ad)
                SizedBox(
                  width: double.infinity,
                  height: 52,
                  child: ElevatedButton(
                    onPressed: onDoubleReward,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF38BDF8),
                      foregroundColor: Colors.white,
                      elevation: 6,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(26),
                      ),
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'DOUBLE',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.5,
                          ),
                        ),
                        SizedBox(width: 10),
                        Icon(Icons.movie_creation_outlined, size: 22),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // COLLECT Text Button
                TextButton(
                  onPressed: onCollect,
                  child: const Text(
                    'COLLECT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      decoration: TextDecoration.underline,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top Header Ribbon & Pill: "Sea" & "Chapter Completed!"
          Positioned(
            top: 15,
            child: Column(
              children: [
                // Chapter Name Pill
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: const [
                      BoxShadow(color: Colors.black26, blurRadius: 4),
                    ],
                  ),
                  child: Text(
                    completedChapter.title,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontWeight: FontWeight.w900,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(height: 4),
                // Pink Banner: "Chapter Completed!"
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFF43F5E), Color(0xFFE11D48)],
                    ),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white, width: 2),
                    boxShadow: const [
                      BoxShadow(color: Colors.black38, blurRadius: 8),
                    ],
                  ),
                  child: const Text(
                    'Chapter Completed!',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 17,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
