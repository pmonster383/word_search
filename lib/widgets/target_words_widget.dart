import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/word_placement.dart';
import 'butterfly_widget.dart';

class TargetWordsWidget extends StatelessWidget {
  final String categoryName;
  final int completedWordsCount;
  final int totalWordsCount;
  final List<WordPlacement> placements;

  const TargetWordsWidget({
    super.key,
    required this.categoryName,
    required this.completedWordsCount,
    required this.totalWordsCount,
    required this.placements,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.92),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.18),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Category Banner & Star Progress
          Row(
            children: [
              // Star Progress Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF10B981),
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.star, color: Color(0xFFFFD166), size: 16),
                    const SizedBox(width: 4),
                    Text(
                      '$completedWordsCount/$totalWordsCount',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Category Name Banner
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Center(
                    child: Text(
                      categoryName,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w900,
                        fontSize: 14,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Words Grid (Columns x Rows)
          Wrap(
            spacing: 12,
            runSpacing: 8,
            alignment: WrapAlignment.center,
            children: placements.map((placement) {
              return _buildWordChip(placement);
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildWordChip(WordPlacement placement) {
    final isFound = placement.isFound;
    final color = AppColors.getWordColor(placement.colorIndex);

    return Stack(
      clipBehavior: Clip.none,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            color: isFound ? color.withOpacity(0.25) : Colors.grey.shade100,
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: isFound ? color : Colors.grey.shade300,
              width: isFound ? 1.8 : 1.0,
            ),
          ),
          child: Text(
            placement.displayWord,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              letterSpacing: 1.0,
              color: isFound ? color : AppColors.darkText,
              decoration: isFound ? TextDecoration.lineThrough : null,
              decorationColor: color,
              decorationThickness: 2.5,
            ),
          ),
        ),

        // Butterfly on mystery covered word!
        if (placement.isCovered && !isFound)
          const Positioned(
            top: -14,
            right: -10,
            child: ButterflyWidget(size: 24),
          ),
      ],
    );
  }
}
