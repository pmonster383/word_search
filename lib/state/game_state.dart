import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../core/services/audio_service.dart';
import '../core/services/storage_service.dart';
import '../game_engine/grid_generator.dart';
import '../game_engine/selection_tracker.dart';
import '../models/cell_position.dart';
import '../models/chapter_model.dart';
import '../models/level_model.dart';
import '../models/timer_difficulty.dart';
import '../models/word_placement.dart';

class GameState extends ChangeNotifier {
  final AudioService _audio = AudioService();

  int coins = 200;
  late LevelModel currentLevel;
  late ChapterModel currentChapter;

  List<List<String>> grid = [];
  List<WordPlacement> placements = [];
  List<WordPlacement> foundPlacements = [];

  // Drag selection state
  List<CellPosition> selectedCells = [];
  String currentSelectedWord = '';
  bool isDragging = false;
  CellPosition? dragStartCell;

  // Level & Chapter completion state
  bool isLevelCompleted = false;
  bool isChapterCompleted = false;
  String? celebrationToast;
  Timer? _toastTimer;

  // Timer Challenge state
  TimerDifficulty? timerDifficulty;
  int remainingSeconds = 0;
  int totalTimerSeconds = 0;
  bool isTimeUp = false;
  Timer? _countdownTimer;

  bool get isTimerMode => timerDifficulty != null;

  // Hints & Reveal state
  Set<CellPosition> revealedLetters = {}; // Magnifying glass hints
  int gridRotationAngle = 0; // Visual shuffle state (0, 90, 180, 270)

  // Settings
  bool get soundEnabled => _audio.soundEnabled;
  bool get vibrationEnabled => _audio.vibrationEnabled;

  GameState() {
    // Synchronously initialize with defaults so currentLevel and Chapter are immediately available
    coins = StorageService.getCoins();
    _audio.soundEnabled = StorageService.getSoundEnabled();
    _audio.vibrationEnabled = StorageService.getVibrationEnabled();
    final savedLevelId = StorageService.getCurrentLevel();
    loadLevel(savedLevelId);

    _init();
  }

  Future<void> _init() async {
    await StorageService.init();
    if (_disposed) return;
    coins = StorageService.getCoins();
    _audio.soundEnabled = StorageService.getSoundEnabled();
    _audio.vibrationEnabled = StorageService.getVibrationEnabled();

    final savedLevelId = StorageService.getCurrentLevel();
    if (currentLevel.id != savedLevelId) {
      loadLevel(savedLevelId);
    } else {
      notifyListeners();
    }
  }

  void loadLevel(int levelId, {TimerDifficulty? difficulty, bool keepCurrentDifficulty = false}) {
    _countdownTimer?.cancel();
    if (!keepCurrentDifficulty) {
      timerDifficulty = difficulty;
    }

    currentLevel = LevelData.getLevel(levelId);
    currentChapter = ChapterData.getChapterForLevel(levelId);

    final genResult = GridGenerator.generateGrid(
      rows: currentLevel.rows,
      cols: currentLevel.cols,
      words: currentLevel.words,
      coveredWord: currentLevel.coveredWord,
    );

    grid = genResult.grid;
    placements = genResult.placements;
    foundPlacements = [];
    selectedCells = [];
    currentSelectedWord = '';
    isDragging = false;
    dragStartCell = null;
    isLevelCompleted = false;
    isChapterCompleted = false;
    _toastTimer?.cancel();
    celebrationToast = null;
    revealedLetters.clear();
    gridRotationAngle = 0;

    if (timerDifficulty != null) {
      totalTimerSeconds = timerDifficulty!.durationSeconds;
      remainingSeconds = totalTimerSeconds;
      isTimeUp = false;
      _startCountdownTimer();
    } else {
      totalTimerSeconds = 0;
      remainingSeconds = 0;
      isTimeUp = false;
    }

    StorageService.setCurrentLevel(levelId);
    notifyListeners();
  }

  void _startCountdownTimer() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (isLevelCompleted || isChapterCompleted) {
        timer.cancel();
        return;
      }
      if (remainingSeconds > 1) {
        remainingSeconds--;
        if (remainingSeconds <= 10) {
          _audio.playTimeAlert();
        }
        notifyListeners();
      } else {
        remainingSeconds = 0;
        isTimeUp = true;
        timer.cancel();
        _audio.playTimeUp();
        notifyListeners();
      }
    });
  }

  void setExtraTime(int seconds) {
    _countdownTimer?.cancel();
    remainingSeconds = seconds;
    if (totalTimerSeconds < seconds) {
      totalTimerSeconds = seconds;
    }
    isTimeUp = false;
    _showCelebrationToast('+$seconds Seconds! Go!');
    notifyListeners();
  }

  void startExtraTimeWithCoins({int cost = 50, int seconds = 15}) {
    if (coins <= 0) return;
    if (coins >= cost) {
      coins -= cost;
    } else {
      coins = 0;
    }
    StorageService.setCoins(coins);

    _countdownTimer?.cancel();
    remainingSeconds = seconds;
    if (totalTimerSeconds < seconds) {
      totalTimerSeconds = seconds;
    }
    isTimeUp = false;
    _startCountdownTimer();
    _showCelebrationToast('+$seconds Seconds! Go!');
    notifyListeners();
  }

  void addExtraTime(int seconds) {
    _countdownTimer?.cancel();
    remainingSeconds = (remainingSeconds <= 0) ? seconds : (remainingSeconds + seconds);
    if (totalTimerSeconds < remainingSeconds) {
      totalTimerSeconds = remainingSeconds;
    }
    isTimeUp = false;
    _startCountdownTimer();
    _showCelebrationToast('+$seconds Seconds Added!');
    notifyListeners();
  }

  void useCoinsForExtraTime({int cost = 50, int seconds = 15}) {
    startExtraTimeWithCoins(cost: cost, seconds: seconds);
  }

  void pauseTimer() {
    _countdownTimer?.cancel();
  }

  void resumeTimer() {
    if (isTimerMode && !isLevelCompleted && !isTimeUp && remainingSeconds > 0) {
      _startCountdownTimer();
    }
  }

  void retryCurrentLevel() {
    loadLevel(currentLevel.id, keepCurrentDifficulty: true);
  }

  void onDragStart(Offset localPos, Size gridSize) {
    if (isLevelCompleted || isTimeUp) return;

    final cell = SelectionTracker.getCellFromOffset(
      localPosition: localPos,
      gridSize: gridSize,
      rows: currentLevel.rows,
      cols: currentLevel.cols,
    );

    if (cell != null) {
      isDragging = true;
      dragStartCell = cell;
      selectedCells = [cell];
      currentSelectedWord = grid[cell.row][cell.col];
      _audio.playLetterSelect();
      notifyListeners();
    }
  }

  void onDragUpdate(Offset localPos, Size gridSize) {
    if (!isDragging || dragStartCell == null || isLevelCompleted || isTimeUp) return;

    final currentCell = SelectionTracker.getCellFromOffset(
      localPosition: localPos,
      gridSize: gridSize,
      rows: currentLevel.rows,
      cols: currentLevel.cols,
    );

    if (currentCell != null) {
      final newPath = SelectionTracker.getPathBetween(
        start: dragStartCell!,
        current: currentCell,
        rows: currentLevel.rows,
        cols: currentLevel.cols,
      );

      // Only notify if selection changed
      if (newPath.length != selectedCells.length ||
          (newPath.isNotEmpty &&
              selectedCells.isNotEmpty &&
              newPath.last != selectedCells.last)) {
        selectedCells = newPath;
        currentSelectedWord = SelectionTracker.getWordFromPath(
          grid: grid,
          path: newPath,
        );
        _audio.playLetterSelect();
        notifyListeners();
      }
    }
  }

  void onDragEnd() {
    if (!isDragging || isLevelCompleted) {
      isDragging = false;
      selectedCells = [];
      currentSelectedWord = '';
      notifyListeners();
      return;
    }

    isDragging = false;

    if (selectedCells.isNotEmpty) {
      final validation = SelectionTracker.validateSelection(
        selectedCells: selectedCells,
        selectedWord: currentSelectedWord,
        placements: placements,
      );

      if (validation.isValid && validation.matchedPlacement != null) {
        final matched = validation.matchedPlacement!;
        matched.isFound = true;
        matched.colorIndex = foundPlacements.length;
        foundPlacements.add(matched);

        _audio.playWordFound();

        // Check if covered mystery word was found
        if (matched.isCovered) {
          coins += 50; // Bonus for mystery covered word!
          StorageService.setCoins(coins);
          _showCelebrationToast('Mystery Word Solved! +50 Coins');
        } else {
          final toasts = ['Awesome!', 'Incredible!', 'Splendid!', 'Superb!'];
          _showCelebrationToast(toasts[Random().nextInt(toasts.length)]);
        }

        // Check if level completed!
        if (foundPlacements.length == placements.length) {
          _handleLevelComplete();
        }
      }
    }

    selectedCells = [];
    currentSelectedWord = '';
    notifyListeners();
  }

  void _handleLevelComplete() {
    _countdownTimer?.cancel();
    isLevelCompleted = true;
    _audio.playLevelComplete();

    // Award level coins + bonus for timer
    int earnedCoins = 25;
    if (timerDifficulty != null) {
      earnedCoins += timerDifficulty!.bonusCoins;
      _showCelebrationToast('Timer Cleared! +$earnedCoins Coins');
    }

    coins += earnedCoins;
    StorageService.setCoins(coins);
    StorageService.addCompletedLevel(currentLevel.id);

    final nextLvlId = currentLevel.id + 1;
    if (nextLvlId > StorageService.getUnlockedLevel()) {
      StorageService.setUnlockedLevel(nextLvlId);
    }

    // Check if chapter ended
    if (currentLevel.id == currentChapter.endLevel) {
      isChapterCompleted = true;
    }

    notifyListeners();
  }

  void nextLevel() {
    final nextId = currentLevel.id + 1;
    final targetId = nextId > LevelData.levels.length ? 1 : nextId;
    loadLevel(targetId, keepCurrentDifficulty: true);
  }

  // Power-up 1: Magic Wand (Reveals full word for 200 coins)
  bool useMagicWand() {
    if (coins < 200 || isLevelCompleted) return false;

    final unfound = placements.where((p) => !p.isFound).toList();
    if (unfound.isEmpty) return false;

    coins -= 200;
    StorageService.setCoins(coins);

    final target = unfound.first;
    target.isFound = true;
    target.colorIndex = foundPlacements.length;
    foundPlacements.add(target);

    _audio.playPowerUp();
    _audio.playWordFound();

    _showCelebrationToast('Magic Word Revealed!');

    if (foundPlacements.length == placements.length) {
      _handleLevelComplete();
    }

    notifyListeners();
    return true;
  }

  // Power-up 2: Magnifying Glass (Reveals first letter of a word for 100 coins)
  bool useMagnifyingGlass() {
    if (coins < 100 || isLevelCompleted) return false;

    final unfound = placements.where((p) => !p.isFound).toList();
    if (unfound.isEmpty) return false;

    coins -= 100;
    StorageService.setCoins(coins);

    // Pick first unrevealed first-letter
    for (final placement in unfound) {
      if (!placement.isFirstLetterRevealed && placement.cells.isNotEmpty) {
        placement.isFirstLetterRevealed = true;
        revealedLetters.add(placement.cells.first);
        _audio.playPowerUp();
        _showCelebrationToast('Hint: Letter "${placement.word[0]}" Revealed!');
        notifyListeners();
        return true;
      }
    }

    notifyListeners();
    return false;
  }

  // Power-up 3: Shuffle / Shake Grid View
  void useShuffle() {
    gridRotationAngle = (gridRotationAngle + 90) % 360;
    _audio.playLetterSelect();
    notifyListeners();
  }

  // Rewarded Ad Bonus (+100 coins)
  void grantRewardedCoins({int amount = 100}) {
    coins += amount;
    StorageService.setCoins(coins);
    _audio.playCoinCollect();
    _showCelebrationToast('+$amount Coins Received!');
    notifyListeners();
  }

  bool spendCoins(int amount) {
    if (coins >= amount) {
      coins -= amount;
      StorageService.setCoins(coins);
      notifyListeners();
      return true;
    }
    return false;
  }

  void doubleChapterReward() {
    final bonus = currentChapter.rewardCoins * 2;
    grantRewardedCoins(amount: bonus);
    isChapterCompleted = false;
    nextLevel();
  }

  void collectChapterReward() {
    grantRewardedCoins(amount: currentChapter.rewardCoins);
    isChapterCompleted = false;
    nextLevel();
  }

  void toggleSound() {
    _audio.soundEnabled = !_audio.soundEnabled;
    StorageService.setSoundEnabled(_audio.soundEnabled);
    notifyListeners();
  }

  void toggleVibration() {
    _audio.vibrationEnabled = !_audio.vibrationEnabled;
    StorageService.setVibrationEnabled(_audio.vibrationEnabled);
    notifyListeners();
  }

  void _showCelebrationToast(String message, {Duration duration = const Duration(milliseconds: 1400)}) {
    _toastTimer?.cancel();
    celebrationToast = message;
    notifyListeners();

    _toastTimer = Timer(duration, () {
      celebrationToast = null;
      notifyListeners();
    });
  }

  void clearToast() {
    _toastTimer?.cancel();
    celebrationToast = null;
    notifyListeners();
  }

  bool _disposed = false;

  @override
  void notifyListeners() {
    if (!_disposed) {
      super.notifyListeners();
    }
  }

  @override
  void dispose() {
    _disposed = true;
    _countdownTimer?.cancel();
    _toastTimer?.cancel();
    super.dispose();
  }
}
