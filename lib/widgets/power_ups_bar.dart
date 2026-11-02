import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class PowerUpsBar extends StatelessWidget {
  final int userCoins;
  final VoidCallback onWatchAd;
  final VoidCallback onMagicWand;
  final VoidCallback onMagnifyingGlass;
  final VoidCallback onShuffle;

  const PowerUpsBar({
    super.key,
    required this.userCoins,
    required this.onWatchAd,
    required this.onMagicWand,
    required this.onMagnifyingGlass,
    required this.onShuffle,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          // 1. Rewarded Ad Video Bonus Button
          _buildPowerUpItem(
            icon: Icons.play_arrow_rounded,
            badgeWidget: const Icon(Icons.movie_creation_outlined, size: 14, color: Colors.white),
            gradientColors: [const Color(0xFF38BDF8), const Color(0xFF0284C7)],
            onTap: onWatchAd,
          ),

          // 2. Magic Wand (200 coins)
          _buildPowerUpItem(
            icon: Icons.auto_fix_high_rounded,
            cost: 200,
            gradientColors: [const Color(0xFFFBBF24), const Color(0xFFD97706)],
            onTap: onMagicWand,
          ),

          // 3. Magnifying Glass (100 coins)
          _buildPowerUpItem(
            icon: Icons.search_rounded,
            cost: 100,
            gradientColors: [const Color(0xFF38BDF8), const Color(0xFF2563EB)],
            onTap: onMagnifyingGlass,
          ),

          // 4. Shuffle / Rotate Grid (Free)
          _buildPowerUpItem(
            icon: Icons.refresh_rounded,
            gradientColors: [const Color(0xFF34D399), const Color(0xFF059669)],
            onTap: onShuffle,
          ),
        ],
      ),
    );
  }

  Widget _buildPowerUpItem({
    required IconData icon,
    int? cost,
    Widget? badgeWidget,
    required List<Color> gradientColors,
    required VoidCallback onTap,
  }) {
    final canAfford = cost == null || userCoins >= cost;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        GestureDetector(
          onTap: onTap,
          child: Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: canAfford
                    ? gradientColors
                    : [Colors.grey.shade400, Colors.grey.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.25),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 28,
                ),
                if (badgeWidget != null)
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: badgeWidget,
                  ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 4),

        // Cost Badge under button
        if (cost != null)
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: canAfford ? const Color(0xFFF59E0B) : Colors.grey,
                width: 1.2,
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.monetization_on_rounded, size: 12, color: AppColors.goldCoinDark),
                const SizedBox(width: 2),
                Text(
                  '$cost',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w900,
                    color: canAfford ? const Color(0xFFB45309) : Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          )
        else
          const SizedBox(height: 18),
      ],
    );
  }
}
