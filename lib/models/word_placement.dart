import 'cell_position.dart';

class WordPlacement {
  final String word;
  List<CellPosition> cells;
  bool isFound;
  final bool isCovered; // Covered / mystery word e.g. G**WL
  bool isFirstLetterRevealed; // From magnifying glass hint
  int colorIndex;

  WordPlacement({
    required this.word,
    required this.cells,
    this.isFound = false,
    this.isCovered = false,
    this.isFirstLetterRevealed = false,
    this.colorIndex = 0,
  });

  /// Display text for word chips. If covered and not found, show masked letters (e.g., G**WL)
  String get displayWord {
    if (!isCovered || isFound) return word;
    if (word.length <= 2) return word;
    final buffer = StringBuffer();
    buffer.write(word[0]);
    for (int i = 1; i < word.length - 1; i++) {
      buffer.write('*');
    }
    buffer.write(word[word.length - 1]);
    return buffer.toString();
  }
}
