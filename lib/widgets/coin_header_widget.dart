import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class CoinHeaderWidget extends StatelessWidget {
  final int levelNumber;
  final int coins;
  final VoidCallback onBack;
  final VoidCallback onSettings;
  final VoidCallback onAddCoins;

  const CoinHeaderWidget({
    super.key,
    required this.levelNumber,
    required this.coins,
    required this.onBack,
    required this.onSettings,
    required this.onAddCoins,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left: Navigation & Settings Buttons
          Row(
            children: [
              _buildCircularButton(
                icon: Icons.arrow_back_ios_new_rounded,
                onPressed: onBack,
              ),
              const SizedBox(width: 8),
              _buildCircularButton(
                icon: Icons.settings_rounded,
                onPressed: onSettings,
              ),
            ],
          ),

          // Center: Level Pill Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.92),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: const Color(0xFF60A5FA), width: 1.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.15),
                  blurRadius: 8,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              'Level $levelNumber',
              style: const TextStyle(
                color: Color(0xFF1E3A8A),
                fontWeight: FontWeight.w800,
                fontSize: 15,
                letterSpacing: 0.5,
              ),
            ),
          ),

          // Right: Coin Wallet Pill
          GestureDetector(
            onTap: onAddCoins,
            child: Container(
              padding: const EdgeInsets.only(left: 4, right: 8, top: 4, bottom: 4),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.9),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Gold coin circle
                  Container(
                    width: 26,
                    height: 26,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [AppColors.goldCoin, AppColors.goldCoinDark],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black26,
                          blurRadius: 3,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text(
                        '\$',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w900,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '$coins',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(
                    Icons.add_circle,
                    color: Color(0xFFFFD54F),
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCircularButton({
    required IconData icon,
    required VoidCallback onPressed,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2563EB),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.2),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 20),
        onPressed: onPressed,
        constraints: const BoxConstraints(minWidth: 38, minHeight: 38),
        padding: EdgeInsets.zero,
      ),
    );
  }
}
