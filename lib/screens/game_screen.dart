import 'package:flutter/material.dart';
import '../models/chapter_model.dart';
import '../state/game_state.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/background_scenery_widget.dart';
import '../widgets/chapter_complete_dialog.dart';
import '../widgets/coin_header_widget.dart';
import '../widgets/level_complete_dialog.dart';
import '../widgets/power_ups_bar.dart';
import '../widgets/rate_us_dialog.dart';
import '../widgets/rewarded_ad_dialog.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/target_words_widget.dart';
import '../widgets/time_up_dialog.dart';
import '../widgets/timer_bar_widget.dart';
import '../widgets/word_grid_widget.dart';
import 'chapter_select_screen.dart';

class GameScreen extends StatefulWidget {
  final GameState gameState;

  const GameScreen({super.key, required this.gameState});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _hasShownMysteryTutorial = false;
  bool _isLevelDialogShowing = false;
  bool _isChapterDialogShowing = false;
  bool _isTimeUpDialogShowing = false;

  @override
  void initState() {
    super.initState();
    widget.gameState.addListener(_onGameStateChanged);
  }

  @override
  void dispose() {
    widget.gameState.removeListener(_onGameStateChanged);
    super.dispose();
  }

  void _onGameStateChanged() {
    // Show tutorial for covered word mode when entering Level 12 (matching video 02:08!)
    if (widget.gameState.currentLevel.coveredWord != null &&
        !_hasShownMysteryTutorial &&
        !widget.gameState.isLevelCompleted) {
      _hasShownMysteryTutorial = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showMysteryModeTutorial();
      });
    }

    // Check for level complete (guard so only one dialog is opened)
    if (widget.gameState.isLevelCompleted &&
        !widget.gameState.isChapterCompleted &&
        !_isLevelDialogShowing &&
        mounted) {
      _isLevelDialogShowing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showLevelCompleteDialog();
      });
    }

    // Check for chapter complete (guard so only one dialog is opened)
    if (widget.gameState.isChapterCompleted &&
        !_isChapterDialogShowing &&
        mounted) {
      _isChapterDialogShowing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showChapterCompleteDialog();
      });
    }

    // Check for time up (guard so only one dialog is opened)
    if (widget.gameState.isTimeUp &&
        !widget.gameState.isLevelCompleted &&
        !_isTimeUpDialogShowing &&
        mounted) {
      _isTimeUpDialogShowing = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showTimeUpDialog();
      });
    }
  }

  void _showMysteryModeTutorial() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => Dialog(
        backgroundColor: Colors.transparent,
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFFFDFBF7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFE2E8F0), width: 1.5),
            boxShadow: const [
              BoxShadow(color: Colors.black26, blurRadius: 16, offset: Offset(0, 6)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Text(
                  'New Game Mode Unlocked!',
                  style: TextStyle(
                    color: Color(0xFF92400E),
                    fontWeight: FontWeight.w900,
                    fontSize: 16,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Find the COVERED word before the butterfly flies away and win amazing gifts!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF1E293B),
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(ctx),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: const Text(
                  'Got It!',
                  style: TextStyle(fontWeight: FontWeight.w900, fontSize: 16),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => LevelCompleteDialog(
        levelId: widget.gameState.currentLevel.id,
        chapter: widget.gameState.currentChapter,
        onNextLevel: () {
          _isLevelDialogShowing = false;
          Navigator.pop(ctx);
          // Occasionally show Rate Us dialog (e.g. after level 11 or 12, matching video!)
          if (widget.gameState.currentLevel.id == 11) {
            _showRateUsDialog();
          } else {
            widget.gameState.nextLevel();
          }
        },
      ),
    ).then((_) {
      _isLevelDialogShowing = false;
    });
  }

  void _showChapterCompleteDialog() {
    final nextChapter = ChapterData.getChapterForLevel(
      widget.gameState.currentLevel.id + 1,
    );

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => ChapterCompleteDialog(
        completedChapter: widget.gameState.currentChapter,
        nextChapter: nextChapter,
        onDoubleReward: () {
          _isChapterDialogShowing = false;
          Navigator.pop(ctx);
          _showRewardedAd(
            awardCoins: false,
            onReward: () {
              widget.gameState.doubleChapterReward();
            },
          );
        },
        onCollect: () {
          _isChapterDialogShowing = false;
          Navigator.pop(ctx);
          _showRewardedAd(
            awardCoins: false,
            onReward: () {
              widget.gameState.collectChapterReward();
            },
          );
        },
      ),
    ).then((_) {
      _isChapterDialogShowing = false;
    });
  }

  void _showRateUsDialog() {
    showDialog(
      context: context,
      builder: (ctx) => RateUsDialog(
        onClose: () {
          Navigator.pop(context);
          widget.gameState.nextLevel();
        },
      ),
    );
  }

  void _showRewardedAd({VoidCallback? onReward, bool awardCoins = true}) {
    widget.gameState.pauseTimer();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => RewardedAdDialog(
        onRewardEarned: () {
          if (awardCoins) {
            widget.gameState.grantRewardedCoins(amount: 100);
          }
          onReward?.call();
        },
      ),
    ).then((_) {
      if (widget.gameState.isTimeUp && mounted) {
        // Watched ad while time is up: re-open TimeUpDialog and WAIT for user input!
        _isTimeUpDialogShowing = true;
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && widget.gameState.isTimeUp) {
            _showTimeUpDialog();
          }
        });
      } else if (widget.gameState.isTimerMode &&
          !widget.gameState.isLevelCompleted &&
          !widget.gameState.isTimeUp &&
          widget.gameState.remainingSeconds > 0) {
        widget.gameState.resumeTimer();
      }
    });
  }

  void _showTimeUpDialog() {
    _isTimeUpDialogShowing = true;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => TimeUpDialog(
        levelId: widget.gameState.currentLevel.id,
        foundWordsCount: widget.gameState.foundPlacements.length,
        totalWordsCount: widget.gameState.placements.length,
        userCoins: widget.gameState.coins,
        onAddExtraTimeWithCoins: () {
          if (widget.gameState.coins < 50) return;
          _isTimeUpDialogShowing = false;
          Navigator.of(ctx).pop();
          widget.gameState.startExtraTimeWithCoins(cost: 50, seconds: 15);
        },
        onAddExtraTimeWithAd: () {
          Navigator.of(ctx).pop();
          _showRewardedAd();
        },
        onQuit: () {
          _isTimeUpDialogShowing = false;
          Navigator.of(ctx).pop();
          if (Navigator.canPop(context)) {
            Navigator.pop(context);
          }
        },
      ),
    ).then((_) {
      if (!widget.gameState.isTimeUp) {
        _isTimeUpDialogShowing = false;
      }
    });
  }

  void _showSettings() {
    widget.gameState.pauseTimer();
    showDialog(
      context: context,
      builder: (ctx) => SettingsDialog(
        soundEnabled: widget.gameState.soundEnabled,
        vibrationEnabled: widget.gameState.vibrationEnabled,
        onToggleSound: widget.gameState.toggleSound,
        onToggleVibration: widget.gameState.toggleVibration,
        onResetProgress: () {
          widget.gameState.loadLevel(1);
        },
      ),
    ).then((_) {
      widget.gameState.resumeTimer();
    });
  }

  void _handleBack() {
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      _openChapterSelect();
    }
  }

  void _openChapterSelect() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChapterSelectScreen(
          currentLevelId: widget.gameState.currentLevel.id,
          onSelectLevel: (lvlId) {
            widget.gameState.loadLevel(lvlId);
          },
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: widget.gameState,
      builder: (context, _) {
        final state = widget.gameState;

        return Scaffold(
          body: BackgroundSceneryWidget(
            theme: state.currentLevel.theme,
            child: SafeArea(
              child: Stack(
                children: [
                  Column(
                    children: [
                      // 1. Top Header Bar (Level, coins, nav, settings)
                      CoinHeaderWidget(
                        levelNumber: state.currentLevel.id,
                        coins: state.coins,
                        onBack: _handleBack,
                        onSettings: _showSettings,
                        onAddCoins: () {
                          _showRewardedAd();
                        },
                      ),

                      // Timer Mode Bar (Active when playing in 90s, 60s, or 30s challenge)
                      if (state.isTimerMode)
                        TimerBarWidget(
                          remainingSeconds: state.remainingSeconds,
                          totalSeconds: state.totalTimerSeconds,
                          difficulty: state.timerDifficulty!,
                        ),

                      // 2. Target Words & Category Banner
                      TargetWordsWidget(
                        categoryName: state.currentLevel.categoryName,
                        completedWordsCount: state.foundPlacements.length,
                        totalWordsCount: state.placements.length,
                        placements: state.placements,
                      ),

                      const Spacer(),

                      // 3. Main Word Search Letter Grid
                      WordGridWidget(
                        grid: state.grid,
                        rows: state.currentLevel.rows,
                        cols: state.currentLevel.cols,
                        foundPlacements: state.foundPlacements,
                        selectedCells: state.selectedCells,
                        currentSelectedWord: state.currentSelectedWord,
                        isDragging: state.isDragging,
                        revealedLetters: state.revealedLetters,
                        rotationAngle: state.gridRotationAngle,
                        onDragStart: state.onDragStart,
                        onDragUpdate: state.onDragUpdate,
                        onDragEnd: state.onDragEnd,
                      ),

                      const Spacer(),

                      // 4. Power-ups Bottom Bar
                      PowerUpsBar(
                        userCoins: state.coins,
                        onWatchAd: () {
                          _showRewardedAd();
                        },
                        onMagicWand: () {
                          final success = state.useMagicWand();
                          if (!success && state.coins < 200) {
                            _showNotEnoughCoinsSnackBar(200);
                          }
                        },
                        onMagnifyingGlass: () {
                          final success = state.useMagnifyingGlass();
                          if (!success && state.coins < 100) {
                            _showNotEnoughCoinsSnackBar(100);
                          }
                        },
                        onShuffle: state.useShuffle,
                      ),

                      // 5. Monetization Banner Ad
                      const AdBannerWidget(),
                    ],
                  ),

                  // Celebration Toast Overlay ("Awesome!", "Incredible!")
                  if (state.celebrationToast != null)
                    Positioned(
                      top: 130,
                      left: 0,
                      right: 0,
                      child: IgnorePointer(
                        child: Center(
                          child: TweenAnimationBuilder<double>(
                            key: ValueKey(state.celebrationToast),
                            tween: Tween(begin: 0.0, end: 1.0),
                            duration: const Duration(milliseconds: 250),
                            curve: Curves.easeOutBack,
                            builder: (context, val, child) {
                              return Opacity(
                                opacity: val.clamp(0.0, 1.0),
                                child: Transform.scale(
                                  scale: 0.75 + 0.25 * val,
                                  child: child,
                                ),
                              );
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981),
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: Colors.white, width: 2),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black38, blurRadius: 10, offset: Offset(0, 4)),
                                ],
                              ),
                              child: Text(
                                state.celebrationToast!,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showNotEnoughCoinsSnackBar(int needed) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Need $needed coins! Watch a free video to get +100 coins.'),
        backgroundColor: const Color(0xFFB45309),
        action: SnackBarAction(
          label: 'FREE COINS',
          textColor: Colors.white,
          onPressed: () {
            _showRewardedAd();
          },
        ),
      ),
    );
  }
}
