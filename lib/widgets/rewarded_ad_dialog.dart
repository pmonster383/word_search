import 'dart:async';
import 'package:flutter/material.dart';

class RewardedAdDialog extends StatefulWidget {
  final VoidCallback onRewardEarned;

  const RewardedAdDialog({super.key, required this.onRewardEarned});

  @override
  State<RewardedAdDialog> createState() => _RewardedAdDialogState();
}

class _RewardedAdDialogState extends State<RewardedAdDialog> {
  int _secondsRemaining = 5;
  bool _rewardGranted = false;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 1) {
        setState(() {
          _secondsRemaining--;
        });
      } else {
        setState(() {
          _secondsRemaining = 0;
          _rewardGranted = true;
        });
        _timer?.cancel();
        widget.onRewardEarned();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: _rewardGranted,
      child: Dialog.fullscreen(
        child: Container(
          color: const Color(0xFF0F172A),
          child: Stack(
            children: [
              // Ad Creative Content
              Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Ad Header Badge
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.15),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'SPONSORED ADVERTISEMENT',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 1.5,
                            ),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Featured Ad Banner Card
                        Container(
                          width: double.infinity,
                          constraints: const BoxConstraints(maxWidth: 340),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF6366F1), Color(0xFF9333EA)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: const [
                              BoxShadow(color: Colors.black45, blurRadius: 16),
                            ],
                          ),
                          child: Column(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(16),
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.videogame_asset_rounded,
                                  size: 54,
                                  color: Color(0xFF6366F1),
                                ),
                              ),
                              const SizedBox(height: 16),
                              const Text(
                                'Goods Puzzle: 3D Sorting',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'No timer. No rush. Only pure fun!\nPlay and relax anytime.',
                                textAlign: TextAlign.center,
                                style: TextStyle(color: Colors.white70, fontSize: 13),
                              ),
                              const SizedBox(height: 20),
                              ElevatedButton(
                                onPressed: () {},
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF22C55E),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                                ),
                                child: const Text(
                                  'INSTALL NOW',
                                  style: TextStyle(fontWeight: FontWeight.w900),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 32),

                        // Reward Notification Status
                        if (_rewardGranted) ...[
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                            decoration: BoxDecoration(
                              color: const Color(0xFF22C55E).withOpacity(0.2),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFF22C55E)),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(Icons.check_circle_rounded, color: Color(0xFF22C55E)),
                                SizedBox(width: 8),
                                Text(
                                  'Reward Granted! +100 Coins',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton.icon(
                            onPressed: () {
                              if (Navigator.canPop(context)) {
                                Navigator.pop(context);
                              }
                            },
                            icon: const Icon(Icons.check_circle_outline_rounded, size: 20),
                            label: const Text(
                              'COLLECT & CONTINUE',
                              style: TextStyle(fontWeight: FontWeight.w900, fontSize: 15),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF22C55E),
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                              elevation: 4,
                            ),
                          ),
                        ] else
                          Text(
                            'Reward in $_secondsRemaining seconds...',
                            style: const TextStyle(
                              color: Colors.white70,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
              ),

              // Top Bar with Timer & Close Button
              Positioned(
                top: 40,
                right: 20,
                child: Row(
                  children: [
                    if (!_rewardGranted)
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Reward in ${_secondsRemaining}s',
                          style: const TextStyle(color: Colors.white, fontSize: 13),
                        ),
                      ),
                    const SizedBox(width: 10),
                    GestureDetector(
                      onTap: _rewardGranted
                          ? () => Navigator.pop(context)
                          : null,
                      child: Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: _rewardGranted ? Colors.white : Colors.white24,
                        ),
                        child: Icon(
                          Icons.close_rounded,
                          color: _rewardGranted ? Colors.black : Colors.white38,
                          size: 22,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
