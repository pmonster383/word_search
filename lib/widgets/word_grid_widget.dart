import 'dart:math';
import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../models/cell_position.dart';
import '../models/word_placement.dart';

class WordGridWidget extends StatefulWidget {
  final List<List<String>> grid;
  final int rows;
  final int cols;
  final List<WordPlacement> foundPlacements;
  final List<CellPosition> selectedCells;
  final String currentSelectedWord;
  final bool isDragging;
  final Set<CellPosition> revealedLetters;
  final int rotationAngle;
  final Function(Offset localPos, Size gridSize) onDragStart;
  final Function(Offset localPos, Size gridSize) onDragUpdate;
  final VoidCallback onDragEnd;

  const WordGridWidget({
    super.key,
    required this.grid,
    required this.rows,
    required this.cols,
    required this.foundPlacements,
    required this.selectedCells,
    required this.currentSelectedWord,
    required this.isDragging,
    required this.revealedLetters,
    required this.rotationAngle,
    required this.onDragStart,
    required this.onDragUpdate,
    required this.onDragEnd,
  });

  @override
  State<WordGridWidget> createState() => _WordGridWidgetState();
}

class _WordGridWidgetState extends State<WordGridWidget> {
  final GlobalKey _gridKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Maintain a square or near-square board with responsive padding
        final maxDimension = min(constraints.maxWidth - 24, constraints.maxHeight - 20);
        final boardSize = maxDimension.clamp(260.0, 420.0);

        return Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              // Main Grid Board Container
              AnimatedRotation(
                turns: widget.rotationAngle / 360.0,
                duration: const Duration(milliseconds: 400),
                curve: Curves.easeInOutBack,
                child: Container(
                  key: _gridKey,
                  width: boardSize,
                  height: boardSize,
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.96),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.22),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onPanStart: (details) {
                      widget.onDragStart(
                        details.localPosition,
                        Size(boardSize, boardSize),
                      );
                    },
                    onPanUpdate: (details) {
                      widget.onDragUpdate(
                        details.localPosition,
                        Size(boardSize, boardSize),
                      );
                    },
                    onPanEnd: (_) {
                      widget.onDragEnd();
                    },
                    onPanCancel: () {
                      widget.onDragEnd();
                    },
                    child: Stack(
                      children: [
                        // Highlight capsules painter (underneath letters)
                        Positioned.fill(
                          child: CustomPaint(
                            painter: GridHighlightPainter(
                              rows: widget.rows,
                              cols: widget.cols,
                              foundPlacements: widget.foundPlacements,
                              selectedCells: widget.selectedCells,
                              revealedLetters: widget.revealedLetters,
                            ),
                          ),
                        ),

                        // Letters Grid
                        Positioned.fill(
                          child: _buildLettersGrid(boardSize),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              // Floating Word Preview Bubble (above finger touch)
              if (widget.isDragging && widget.currentSelectedWord.isNotEmpty)
                Positioned(
                  top: -46,
                  child: _buildFloatingWordBadge(widget.currentSelectedWord),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLettersGrid(double boardSize) {
    if (widget.grid.isEmpty) return const SizedBox();

    return Column(
      children: List.generate(widget.rows, (r) {
        return Expanded(
          child: Row(
            children: List.generate(widget.cols, (c) {
              final letter = widget.grid[r][c];
              final isRevealed = widget.revealedLetters.contains(CellPosition(r, c));

              return Expanded(
                child: Center(
                  child: AnimatedScale(
                    scale: isRevealed ? 1.25 : 1.0,
                    duration: const Duration(milliseconds: 300),
                    child: Text(
                      letter,
                      style: TextStyle(
                        fontSize: widget.rows > 7 ? 20 : 23,
                        fontWeight: FontWeight.w900,
                        color: isRevealed ? const Color(0xFFD97706) : AppColors.darkText,
                        letterSpacing: 1.0,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }

  Widget _buildFloatingWordBadge(String word) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0284C7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Text(
        word,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          letterSpacing: 2.0,
        ),
      ),
    );
  }
}

class GridHighlightPainter extends CustomPainter {
  final int rows;
  final int cols;
  final List<WordPlacement> foundPlacements;
  final List<CellPosition> selectedCells;
  final Set<CellPosition> revealedLetters;

  GridHighlightPainter({
    required this.rows,
    required this.cols,
    required this.foundPlacements,
    required this.selectedCells,
    required this.revealedLetters,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final cellWidth = size.width / cols;
    final cellHeight = size.height / rows;

    Offset getCenter(CellPosition pos) {
      return Offset(
        (pos.col + 0.5) * cellWidth,
        (pos.row + 0.5) * cellHeight,
      );
    }

    final strokeWidth = min(cellWidth, cellHeight) * 0.78;

    // 1. Draw Permanent Found Word Capsules
    for (final placement in foundPlacements) {
      if (placement.cells.isEmpty) continue;

      final color = AppColors.getWordColor(placement.colorIndex);
      final paint = Paint()
        ..color = color.withOpacity(0.42)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final start = getCenter(placement.cells.first);
      final end = getCenter(placement.cells.last);
      canvas.drawLine(start, end, paint);

      // Inner subtle border highlight
      final borderPaint = Paint()
        ..color = color.withOpacity(0.85)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      // Draw faint rounded pill boundary
      canvas.drawLine(start, end, borderPaint..strokeWidth = 2.0);
    }

    // 2. Draw Active Drag Selection Capsule
    if (selectedCells.isNotEmpty) {
      final activePaint = Paint()
        ..color = const Color(0xFF38BDF8).withOpacity(0.45)
        ..strokeWidth = strokeWidth
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;

      final start = getCenter(selectedCells.first);
      final end = getCenter(selectedCells.last);
      canvas.drawLine(start, end, activePaint);

      final activeOutline = Paint()
        ..color = const Color(0xFF0284C7).withOpacity(0.8)
        ..strokeWidth = 2.2
        ..strokeCap = StrokeCap.round
        ..style = PaintingStyle.stroke;
      canvas.drawLine(start, end, activeOutline);
    }

    // 3. Draw Magnifying Glass Hint Glows
    final hintPaint = Paint()
      ..color = const Color(0xFFFBBF24).withOpacity(0.35)
      ..style = PaintingStyle.fill;

    final hintBorder = Paint()
      ..color = const Color(0xFFD97706)
      ..strokeWidth = 2.0
      ..style = PaintingStyle.stroke;

    for (final pos in revealedLetters) {
      final center = getCenter(pos);
      canvas.drawCircle(center, strokeWidth * 0.45, hintPaint);
      canvas.drawCircle(center, strokeWidth * 0.45, hintBorder);
    }
  }

  @override
  bool shouldRepaint(covariant GridHighlightPainter oldDelegate) => true;
}
