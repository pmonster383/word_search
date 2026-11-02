import 'package:flutter/material.dart';

class RateUsDialog extends StatefulWidget {
  final VoidCallback onClose;

  const RateUsDialog({super.key, required this.onClose});

  @override
  State<RateUsDialog> createState() => _RateUsDialogState();
}

class _RateUsDialogState extends State<RateUsDialog> {
  int _selectedStars = 5;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topRight,
        children: [
          // Content Card
          Container(
            padding: const EdgeInsets.fromLTRB(24, 28, 24, 28),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.35),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 8),
                const Text(
                  'Are you enjoying\nthe game? Rate Us!',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: Color(0xFF1E293B),
                    height: 1.3,
                  ),
                ),
                const SizedBox(height: 24),

                // 5 Interactive Stars (matching the video's rate modal)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(5, (index) {
                    final starIndex = index + 1;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedStars = starIndex;
                        });
                        Future.delayed(const Duration(milliseconds: 300), () {
                          widget.onClose();
                        });
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 4.0),
                        child: Icon(
                          Icons.star_rounded,
                          size: 42,
                          color: starIndex <= _selectedStars
                              ? const Color(0xFF1E293B)
                              : Colors.grey.shade400,
                        ),
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),

          // Green 'X' close button on top right (exact match to video)
          Positioned(
            top: -10,
            right: -10,
            child: GestureDetector(
              onTap: widget.onClose,
              child: Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: const Color(0xFF22C55E),
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                  boxShadow: const [
                    BoxShadow(color: Colors.black26, blurRadius: 4),
                  ],
                ),
                child: const Icon(
                  Icons.close_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
