import 'dart:math';
import '../models/cell_position.dart';
import '../models/word_placement.dart';

class GridGenerationResult {
  final List<List<String>> grid;
  final List<WordPlacement> placements;

  GridGenerationResult({
    required this.grid,
    required this.placements,
  });
}

class GridGenerator {
  static final Random _random = Random();

  // Common English letter distribution for natural-looking filler letters
  static const String _fillerAlphabet =
      'EEEEAAAAIIIIOOOOUNNNRRRTTTLLSSSSDDDGGGMBBCPPHFYYWKVXZJQ';

  static GridGenerationResult generateGrid({
    required int rows,
    required int cols,
    required List<String> words,
    String? coveredWord,
  }) {
    // Sort words by length descending to place longer words first
    final sortedWords = List<String>.from(words)
      ..sort((a, b) => b.length.compareTo(a.length));

    // Try generating with backtracking / retry limit
    for (int attempt = 0; attempt < 100; attempt++) {
      final grid = List.generate(rows, (_) => List.filled(cols, ''));
      final placements = <WordPlacement>[];
      bool allPlaced = true;

      for (int i = 0; i < sortedWords.length; i++) {
        final rawWord = sortedWords[i].toUpperCase().replaceAll(' ', '');
        final placement = _tryPlaceWord(grid, rows, cols, rawWord, i);

        if (placement == null) {
          allPlaced = false;
          break;
        }

        // Check if this is the covered/mystery word
        final isCovered = (coveredWord != null &&
            rawWord == coveredWord.toUpperCase().replaceAll(' ', ''));

        placements.add(WordPlacement(
          word: rawWord,
          cells: placement,
          isFound: false,
          isCovered: isCovered,
          colorIndex: i,
        ));
      }

      if (allPlaced) {
        // Fill empty cells with random letters
        for (int r = 0; r < rows; r++) {
          for (int c = 0; c < cols; c++) {
            if (grid[r][c].isEmpty) {
              grid[r][c] =
                  _fillerAlphabet[_random.nextInt(_fillerAlphabet.length)];
            }
          }
        }

        return GridGenerationResult(grid: grid, placements: placements);
      }
    }

    // Fallback: If placement failed after retries, place guaranteed horizontal/vertical
    final fallbackGrid = List.generate(rows, (_) => List.filled(cols, ''));
    final fallbackPlacements = <WordPlacement>[];

    for (int i = 0; i < sortedWords.length; i++) {
      final rawWord = sortedWords[i].toUpperCase().replaceAll(' ', '');
      final r = i % rows;
      final maxStart = max(0, cols - rawWord.length);
      final c = min(maxStart, 0);

      final cells = <CellPosition>[];
      for (int k = 0; k < rawWord.length && (c + k) < cols; k++) {
        fallbackGrid[r][c + k] = rawWord[k];
        cells.add(CellPosition(r, c + k));
      }

      final isCovered = (coveredWord != null &&
          rawWord == coveredWord.toUpperCase().replaceAll(' ', ''));

      fallbackPlacements.add(WordPlacement(
        word: rawWord,
        cells: cells,
        isCovered: isCovered,
        colorIndex: i,
      ));
    }

    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        if (fallbackGrid[r][c].isEmpty) {
          fallbackGrid[r][c] =
              _fillerAlphabet[_random.nextInt(_fillerAlphabet.length)];
        }
      }
    }

    return GridGenerationResult(
      grid: fallbackGrid,
      placements: fallbackPlacements,
    );
  }

  static List<CellPosition>? _tryPlaceWord(
    List<List<String>> grid,
    int rows,
    int cols,
    String word,
    int wordIndex,
  ) {
    // 8 directions: [dr, dc]
    final directions = [
      [0, 1],   // Right
      [1, 0],   // Down
      [1, 1],   // Diagonal Down-Right
      [0, -1],  // Left
      [-1, 0],  // Up
      [-1, -1], // Diagonal Up-Left
      [1, -1],  // Diagonal Down-Left
      [-1, 1],  // Diagonal Up-Right
    ];

    directions.shuffle(_random);

    final startPositions = <CellPosition>[];
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols; c++) {
        startPositions.add(CellPosition(r, c));
      }
    }
    startPositions.shuffle(_random);

    for (final pos in startPositions) {
      for (final dir in directions) {
        final dr = dir[0];
        final dc = dir[1];

        final endR = pos.row + dr * (word.length - 1);
        final endC = pos.col + dc * (word.length - 1);

        if (endR >= 0 && endR < rows && endC >= 0 && endC < cols) {
          bool canPlace = true;
          for (int i = 0; i < word.length; i++) {
            final checkR = pos.row + dr * i;
            final checkC = pos.col + dc * i;
            final existingChar = grid[checkR][checkC];

            if (existingChar.isNotEmpty && existingChar != word[i]) {
              canPlace = false;
              break;
            }
          }

          if (canPlace) {
            final cellList = <CellPosition>[];
            for (int i = 0; i < word.length; i++) {
              final placeR = pos.row + dr * i;
              final placeC = pos.col + dc * i;
              grid[placeR][placeC] = word[i];
              cellList.add(CellPosition(placeR, placeC));
            }
            return cellList;
          }
        }
      }
    }

    return null;
  }
}
