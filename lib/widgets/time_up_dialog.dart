import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class TimeUpDialog extends StatelessWidget {
  final int levelId;
  final int foundWordsCount;
  final int totalWordsCount;
  final int userCoins;
  final VoidCallback onAddExtraTimeWithCoins;
  final VoidCallback onAddExtraTimeWithAd;
  final VoidCallback onQuit;

  const TimeUpDialog({
    super.key,
    required this.levelId,
    required this.foundWordsCount,
    required this.totalWordsCount,
    required this.userCoins,
    required this.onAddExtraTimeWithCoins,
    required this.onAddExtraTimeWithAd,
    required this.onQuit,
  });

  @override
  Widget build(BuildContext context) {
    final canUseCoins = userCoins >= 50;

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Stack(
        alignment: Alignment.topCenter,
        clipBehavior: Clip.none,
        children: [
          // Main Dialog Card
          Container(
            margin: const EdgeInsets.only(top: 40),
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.96),
              borderRadius: BorderRadius.circular(28),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 20,
                  offset: const Offset(0, 10),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "TIME'S UP!",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFFEF4444),
                    letterSpacing: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Level $levelId Challenge Failed',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: AppColors.darkText,
                  ),
                ),
                const SizedBox(height: 12),

                // Words completed badge
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFFCA5A5)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.spellcheck_rounded, color: Color(0xFFEF4444), size: 18),
                      const SizedBox(width: 8),
                      Text(
                        '$foundWordsCount of $totalWordsCount Words Found',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 12),

                // User Coins Balance Indicator
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFE2E8F0)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.monetization_on_rounded, size: 18, color: AppColors.goldCoinDark),
                      const SizedBox(width: 6),
                      Text(
                        'Your Coins: $userCoins',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: AppColors.darkText,
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // Option 1: Watch Video for +100 Coins
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: onAddExtraTimeWithAd,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: 4,
                    ),
                    child: const Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.movie_creation_outlined, size: 18),
                        SizedBox(width: 8),
                        Text(
                          'Watch Video (+100 Coins)',
                          style: TextStyle(fontWeight: FontWeight.w900, fontSize: 14),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Option 2: +15s with 50 Coins (Enabled when user has >= 50 coins)
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: canUseCoins ? onAddExtraTimeWithCoins : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFF59E0B),
                      disabledBackgroundColor: Colors.grey.shade300,
                      foregroundColor: Colors.white,
                      disabledForegroundColor: Colors.grey.shade500,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                      elevation: canUseCoins ? 4 : 0,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.monetization_on_rounded,
                          size: 20,
                          color: canUseCoins ? Colors.white : Colors.grey.shade500,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '+15s (50 Coins)',
                          style: TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 14,
                            color: canUseCoins ? Colors.white : Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Quit Button
                TextButton(
                  onPressed: onQuit,
                  child: const Text(
                    'Quit to Home',
                    style: TextStyle(
                      color: Colors.grey,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Top Header Icon Graphic
          Positioned(
            top: 0,
            child: Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFEF4444), Color(0xFFB91C1C)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4)),
                ],
              ),
              child: const Icon(
                Icons.alarm_off_rounded,
                color: Colors.white,
                size: 38,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
