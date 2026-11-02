import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';

class SettingsDialog extends StatelessWidget {
  final bool soundEnabled;
  final bool vibrationEnabled;
  final VoidCallback onToggleSound;
  final VoidCallback onToggleVibration;
  final VoidCallback onResetProgress;

  const SettingsDialog({
    super.key,
    required this.soundEnabled,
    required this.vibrationEnabled,
    required this.onToggleSound,
    required this.onToggleVibration,
    required this.onResetProgress,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24),
      child: Container(
        padding: const EdgeInsets.all(24),
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
            // Title
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.settings, color: Color(0xFF2563EB), size: 26),
                    SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        color: AppColors.darkText,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            const SizedBox(height: 8),

            // Sound Toggle
            _buildSettingTile(
              icon: soundEnabled ? Icons.volume_up_rounded : Icons.volume_off_rounded,
              title: 'Sound Effects',
              value: soundEnabled,
              onChanged: (_) => onToggleSound(),
            ),

            // Vibration Toggle
            _buildSettingTile(
              icon: vibrationEnabled ? Icons.vibration_rounded : Icons.smartphone_rounded,
              title: 'Haptic Vibration',
              value: vibrationEnabled,
              onChanged: (_) => onToggleVibration(),
            ),

            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 8),

            // How To Play
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.help_outline_rounded, color: Color(0xFF0284C7)),
              title: const Text('How to Play', style: TextStyle(fontWeight: FontWeight.w700)),
              trailing: const Icon(Icons.chevron_right_rounded),
              onTap: () {
                Navigator.pop(context);
                _showHowToPlay(context);
              },
            ),

            // Reset Game Progress
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: const Icon(Icons.restore_rounded, color: Colors.redAccent),
              title: const Text('Reset Progress', style: TextStyle(fontWeight: FontWeight.w700, color: Colors.redAccent)),
              onTap: () {
                Navigator.pop(context);
                _showResetConfirm(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSettingTile({
    required IconData icon,
    required String title,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF2563EB), size: 24),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.darkText,
                ),
              ),
            ],
          ),
          Switch.adaptive(
            value: value,
            activeThumbColor: const Color(0xFF2563EB),
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  void _showHowToPlay(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('How to Play', style: TextStyle(fontWeight: FontWeight.w800)),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('• Touch and drag across letters horizontally, vertically, or diagonally.'),
            SizedBox(height: 8),
            Text('• Find all target words listed at the top to complete the level.'),
            SizedBox(height: 8),
            Text('• Find covered mystery words to earn bonus coins and unlock special rewards!'),
            SizedBox(height: 8),
            Text('• Use Magic Wand or Magnifying Glass power-ups when you need a helpful hint.'),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Got it!'),
          ),
        ],
      ),
    );
  }

  void _showResetConfirm(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Reset Progress?'),
        content: const Text('This will reset your levels and coins back to initial state.'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.redAccent),
            onPressed: () {
              Navigator.pop(ctx);
              onResetProgress();
            },
            child: const Text('Reset', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
