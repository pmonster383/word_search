import 'dart:math';
import 'package:flutter/material.dart';
import '../models/cell_position.dart';
import '../models/word_placement.dart';

class SelectionResult {
  final List<CellPosition> cells;
  final String word;
  final WordPlacement? matchedPlacement;
  final bool isValid;

  SelectionResult({
    required this.cells,
    required this.word,
    this.matchedPlacement,
    required this.isValid,
  });
}

class SelectionTracker {
  /// Maps a local Offset within the grid board to a CellPosition
  static CellPosition? getCellFromOffset({
    required Offset localPosition,
    required Size gridSize,
    required int rows,
    required int cols,
  }) {
    if (localPosition.dx < 0 ||
        localPosition.dx > gridSize.width ||
        localPosition.dy < 0 ||
        localPosition.dy > gridSize.height) {
      return null;
    }

    final cellWidth = gridSize.width / cols;
    final cellHeight = gridSize.height / rows;

    final c = (localPosition.dx / cellWidth).floor().clamp(0, cols - 1);
    final r = (localPosition.dy / cellHeight).floor().clamp(0, rows - 1);

    return CellPosition(r, c);
  }

  /// Calculates the straight line path of cells from start to current
  /// Snapping to horizontal, vertical, or diagonal directions
  static List<CellPosition> getPathBetween({
    required CellPosition start,
    required CellPosition current,
    required int rows,
    required int cols,
  }) {
    final dr = current.row - start.row;
    final dc = current.col - start.col;

    if (dr == 0 && dc == 0) {
      return [start];
    }

    // Determine nearest of 8 directions
    int stepR = 0;
    int stepC = 0;
    int steps = 0;

    final absDr = dr.abs();
    final absDc = dc.abs();

    if (absDr == 0) {
      // Pure Horizontal
      stepR = 0;
      stepC = dc > 0 ? 1 : -1;
      steps = absDc;
    } else if (absDc == 0) {
      // Pure Vertical
      stepR = dr > 0 ? 1 : -1;
      stepC = 0;
      steps = absDr;
    } else if (absDr == absDc) {
      // Pure Diagonal
      stepR = dr > 0 ? 1 : -1;
      stepC = dc > 0 ? 1 : -1;
      steps = absDr;
    } else {
      // Snap to whichever angle is closest (horizontal, vertical, or diagonal)
      final angle = atan2(dr, dc); // radians: -pi to pi
      // Normalize angle to 8 sectors (each 45 deg = pi/4)
      final sector = ((angle / (pi / 4)).round()) % 8;
      final normalizedSector = sector < 0 ? sector + 8 : sector;

      switch (normalizedSector) {
        case 0: // Right (0)
          stepR = 0;
          stepC = 1;
          steps = absDc;
          break;
        case 1: // Down-Right (45)
          stepR = 1;
          stepC = 1;
          steps = min(absDr, absDc);
          break;
        case 2: // Down (90)
          stepR = 1;
          stepC = 0;
          steps = absDr;
          break;
        case 3: // Down-Left (135)
          stepR = 1;
          stepC = -1;
          steps = min(absDr, absDc);
          break;
        case 4: // Left (180)
          stepR = 0;
          stepC = -1;
          steps = absDc;
          break;
        case 5: // Up-Left (225)
          stepR = -1;
          stepC = -1;
          steps = min(absDr, absDc);
          break;
        case 6: // Up (270)
          stepR = -1;
          stepC = 0;
          steps = absDr;
          break;
        case 7: // Up-Right (315)
          stepR = -1;
          stepC = 1;
          steps = min(absDr, absDc);
          break;
      }
    }

    final path = <CellPosition>[];
    for (int i = 0; i <= steps; i++) {
      final r = start.row + stepR * i;
      final c = start.col + stepC * i;
      if (r >= 0 && r < rows && c >= 0 && c < cols) {
        path.add(CellPosition(r, c));
      }
    }

    return path.isEmpty ? [start] : path;
  }

  /// Builds the string of letters formed by the path
  static String getWordFromPath({
    required List<List<String>> grid,
    required List<CellPosition> path,
  }) {
    final buffer = StringBuffer();
    for (final pos in path) {
      buffer.write(grid[pos.row][pos.col]);
    }
    return buffer.toString();
  }

  /// Validates if the selected word matches any remaining target word
  static SelectionResult validateSelection({
    required List<CellPosition> selectedCells,
    required String selectedWord,
    required List<WordPlacement> placements,
  }) {
    final revWord = selectedWord.split('').reversed.join('');

    for (final placement in placements) {
      if (placement.isFound) continue;

      if (placement.word == selectedWord || placement.word == revWord) {
        // Update placement's cells to the ones selected by the user
        // so that whichever way the user selects the word, it is accepted and highlighted!
        placement.cells = List<CellPosition>.from(selectedCells);

        return SelectionResult(
          cells: selectedCells,
          word: placement.word,
          matchedPlacement: placement,
          isValid: true,
        );
      }
    }

    return SelectionResult(
      cells: selectedCells,
      word: selectedWord,
      isValid: false,
    );
  }
}
