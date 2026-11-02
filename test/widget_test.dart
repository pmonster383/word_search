import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:word_search/core/constants/admob_constants.dart';
import 'package:word_search/core/services/storage_service.dart';
import 'package:word_search/game_engine/grid_generator.dart';
import 'package:word_search/game_engine/selection_tracker.dart';
import 'package:word_search/models/cell_position.dart';
import 'package:word_search/models/chapter_model.dart';
import 'package:word_search/models/level_model.dart';
import 'package:word_search/models/timer_difficulty.dart';
import 'package:word_search/state/game_state.dart';
import 'package:word_search/widgets/time_up_dialog.dart';
import 'package:word_search/main.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  test('GridGenerator places all words successfully', () {
    final words = ['SAND', 'WAVE', 'SURF', 'SUN'];
    final result = GridGenerator.generateGrid(
      rows: 6,
      cols: 6,
      words: words,
    );

    expect(result.grid.length, 6);
    expect(result.grid[0].length, 6);
    expect(result.placements.length, 4);

    for (final placement in result.placements) {
      expect(placement.cells.length, placement.word.length);
      final wordFromCells = SelectionTracker.getWordFromPath(
        grid: result.grid,
        path: placement.cells,
      );
      expect(wordFromCells, placement.word);
    }
  });

  test('SelectionTracker correctly computes straight line path', () {
    final path = SelectionTracker.getPathBetween(
      start: const CellPosition(0, 0),
      current: const CellPosition(0, 3),
      rows: 6,
      cols: 6,
    );

    expect(path.length, 4);
    expect(path[0], const CellPosition(0, 0));
    expect(path[3], const CellPosition(0, 3));
  });

  test('Levels and Chapters scale to 6000 successfully', () {
    expect(LevelData.levels.length, 6000);
    expect(ChapterData.chapters.length, 1000);

    // Verify boundary levels
    final first = LevelData.getLevel(1);
    expect(first.id, 1);
    expect(first.chapterId, 1);

    final mid = LevelData.getLevel(3000);
    expect(mid.id, 3000);
    expect(mid.words.isNotEmpty, true);

    final last = LevelData.getLevel(6000);
    expect(last.id, 6000);
    expect(last.chapterId, 1000);
    expect(last.words.isNotEmpty, true);
  });

  testWidgets('WordSearchApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const WordSearchApp());
    await tester.pumpAndSettle();

    // Verify header and level display
    expect(find.textContaining('Level'), findsWidgets);
    expect(find.text('Chapters and Levels'), findsWidgets);
    expect(find.text('Timer'), findsWidgets);
  });

  test('Timer difficulty levels configured correctly (Easy 90s, Medium 60s, Hard 30s)', () {
    expect(TimerDifficulty.easy.durationSeconds, 90);
    expect(TimerDifficulty.medium.durationSeconds, 60);
    expect(TimerDifficulty.hard.durationSeconds, 30);

    final gameState = GameState();
    
    // Easy mode
    gameState.loadLevel(1, difficulty: TimerDifficulty.easy);
    expect(gameState.isTimerMode, true);
    expect(gameState.remainingSeconds, 90);
    expect(gameState.totalTimerSeconds, 90);

    // Medium mode
    gameState.loadLevel(1, difficulty: TimerDifficulty.medium);
    expect(gameState.remainingSeconds, 60);

    // Hard mode
    gameState.loadLevel(1, difficulty: TimerDifficulty.hard);
    expect(gameState.remainingSeconds, 30);

    gameState.dispose();
  });

  testWidgets('TimeUpDialog handles 0 coins by disabling +15s (50 Coins)', (WidgetTester tester) async {
    bool coinsClicked = false;

    // Test with 0 coins
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TimeUpDialog(
          levelId: 3,
          foundWordsCount: 4,
          totalWordsCount: 5,
          userCoins: 0, // 0 coins -> must be unable to use
          onAddExtraTimeWithCoins: () {
            coinsClicked = true;
          },
          onAddExtraTimeWithAd: () {},
          onQuit: () {},
        ),
      ),
    ));

    // Verify Retry Level is NOT present
    expect(find.text('RETRY LEVEL'), findsNothing);

    // Verify Watch Video (+100 Coins) is present
    expect(find.text('Watch Video (+100 Coins)'), findsOneWidget);

    // Verify +15s (50 Coins) is present but disabled with 0 coins
    final coinsButton = find.text('+15s (50 Coins)');
    expect(coinsButton, findsOneWidget);

    await tester.tap(coinsButton);
    await tester.pump();

    // Must NOT have been clicked because user has 0 coins
    expect(coinsClicked, false);

    // Test with coins >= 50 (e.g. 100 coins)
    await tester.pumpWidget(MaterialApp(
      home: Scaffold(
        body: TimeUpDialog(
          levelId: 3,
          foundWordsCount: 4,
          totalWordsCount: 5,
          userCoins: 100, // >= 50 coins -> able to use
          onAddExtraTimeWithCoins: () {
            coinsClicked = true;
          },
          onAddExtraTimeWithAd: () {},
          onQuit: () {},
        ),
      ),
    ));

    await tester.tap(find.text('+15s (50 Coins)'));
    await tester.pump();

    expect(coinsClicked, true);
  });

  test('Watching video advertisement increases total coin count by 100', () {
    final gameState = GameState();
    final initialCoins = gameState.coins;

    // Simulate watching video advertisement
    gameState.grantRewardedCoins(amount: 100);

    expect(gameState.coins, initialCoins + 100);
    expect(StorageService.getCoins(), initialCoins + 100);

    // Verify user can now spend coins (e.g. 50 coins for +15s or 100 for hint)
    expect(gameState.coins >= 50, true);
    final canSpend = gameState.spendCoins(50);
    expect(canSpend, true);
    expect(gameState.coins, initialCoins + 50);

    gameState.dispose();
  });

  test('startExtraTimeWithCoins starts timer at exactly 15 seconds without wasting time', () {
    final gameState = GameState();
    gameState.loadLevel(1, difficulty: TimerDifficulty.hard); // 30s
    gameState.grantRewardedCoins(amount: 100);

    // Simulate time running up
    gameState.remainingSeconds = 0;
    gameState.isTimeUp = true;

    // Use coins for extra time
    gameState.startExtraTimeWithCoins(cost: 50, seconds: 15);

    expect(gameState.isTimeUp, false);
    expect(gameState.remainingSeconds, 15);
    expect(gameState.totalTimerSeconds >= 15, true);

    gameState.dispose();
  });

  test('Chapter completion sets isChapterCompleted and processes rewards', () {
    final gameState = GameState();
    final initialCoins = gameState.coins;

    // Load end level of Chapter 1 (Level 6)
    gameState.loadLevel(6);
    expect(gameState.currentChapter.endLevel, 6);

    // Simulate level completion
    gameState.foundPlacements = List.from(gameState.placements);
    gameState.isLevelCompleted = true;
    gameState.isChapterCompleted = true;

    expect(gameState.isChapterCompleted, true);

    // Collect chapter reward
    final reward = gameState.currentChapter.rewardCoins;
    gameState.collectChapterReward();

    expect(gameState.coins, initialCoins + reward);
    expect(gameState.isChapterCompleted, false);
    expect(gameState.currentLevel.id, 7); // Advanced to Chapter 2 Level 7!

    gameState.dispose();
  });

  test('AdMob test IDs configured correctly with official Google test units', () {
    // App IDs
    expect(AdMobConstants.testAppIdAndroid, 'ca-app-pub-3940256099942544~3347511713');
    expect(AdMobConstants.testAppIdIOS, 'ca-app-pub-3940256099942544~1458602516');

    // Unit IDs
    expect(AdMobConstants.testBannerIdAndroid, 'ca-app-pub-3940256099942544/6300978111');
    expect(AdMobConstants.testInterstitialIdAndroid, 'ca-app-pub-3940256099942544/1033173712');
    expect(AdMobConstants.testRewardedIdAndroid, 'ca-app-pub-3940256099942544/5224354917');
    expect(AdMobConstants.testRewardedInterstitialIdAndroid, 'ca-app-pub-3940256099942544/5354046379');
    expect(AdMobConstants.testNativeIdAndroid, 'ca-app-pub-3940256099942544/2247696110');
    expect(AdMobConstants.testAppOpenIdAndroid, 'ca-app-pub-3940256099942544/9257395921');

    // Resolvers
    expect(AdMobConstants.bannerAdUnitId.isNotEmpty, true);
    expect(AdMobConstants.rewardedAdUnitId.isNotEmpty, true);
  });
}
