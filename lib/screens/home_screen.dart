import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/services/storage_service.dart';
import '../models/chapter_model.dart';
import '../models/timer_difficulty.dart';
import '../state/game_state.dart';
import '../widgets/ad_banner_widget.dart';
import '../widgets/background_scenery_widget.dart';
import '../widgets/rewarded_ad_dialog.dart';
import '../widgets/settings_dialog.dart';
import '../widgets/timer_mode_dialog.dart';
import 'chapter_select_screen.dart';
import 'game_screen.dart';

class HomeScreen extends StatefulWidget {
  final GameState gameState;

  const HomeScreen({super.key, required this.gameState});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    widget.gameState.addListener(_onStateChanged);
  }

  @override
  void dispose() {
    widget.gameState.removeListener(_onStateChanged);
    super.dispose();
  }

  void _onStateChanged() {
    if (mounted) setState(() {});
  }

  void _launchLevel(int levelId) {
    widget.gameState.loadLevel(levelId);
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => GameScreen(gameState: widget.gameState),
      ),
    );
  }

  void _openChaptersAndLevels() {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ChapterSelectScreen(
          currentLevelId: widget.gameState.currentLevel.id,
          onSelectLevel: (lvlId) {
            _launchLevel(lvlId);
          },
        ),
      ),
    );
  }

  void _openTimerChallenge() {
    showDialog(
      context: context,
      builder: (ctx) => TimerModeDialog(
        currentLevelId: widget.gameState.currentLevel.id,
        unlockedMaxLevel: StorageService.getUnlockedLevel(),
        onStartTimerLevel: (difficulty, levelId) {
          widget.gameState.loadLevel(levelId, difficulty: difficulty);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => GameScreen(gameState: widget.gameState),
            ),
          );
        },
        onBrowseTimerLevels: () {
          _openChaptersAndLevels();
        },
      ),
    );
  }

  void _showSettings() {
    showDialog(
      context: context,
      builder: (ctx) => SettingsDialog(
        soundEnabled: widget.gameState.soundEnabled,
        vibrationEnabled: widget.gameState.vibrationEnabled,
        onToggleSound: widget.gameState.toggleSound,
        onToggleVibration: widget.gameState.toggleVibration,
        onResetProgress: () {
          widget.gameState.loadLevel(1);
          setState(() {});
        },
      ),
    );
  }

  void _showRewardedAd() {
    showDialog(
      context: context,
      builder: (ctx) => RewardedAdDialog(
        onRewardEarned: () {
          widget.gameState.grantRewardedCoins();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final state = widget.gameState;
    final currentLevelId = state.currentLevel.id;
    final unlockedMaxLevel = StorageService.getUnlockedLevel();

    return Scaffold(
      body: BackgroundSceneryWidget(
        theme: state.currentLevel.theme,
        child: SafeArea(
          child: Column(
            children: [
              // 1. Top Bar: Left = Settings & Sound, Right = Fully-visible Coin Badge
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Settings Button
                    _buildTopCircleButton(
                      icon: Icons.settings_rounded,
                      tooltip: 'Settings',
                      onTap: _showSettings,
                    ),

                    // Total Coins Wallet (Spacious, 100% visible, never clipped)
                    GestureDetector(
                      onTap: _showRewardedAd,
                      child: Container(
                        padding: const EdgeInsets.only(left: 4, right: 10, top: 4, bottom: 4),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF059669), Color(0xFF10B981)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.25),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // 3D Gold Coin Icon
                            Container(
                              width: 26,
                              height: 26,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                gradient: LinearGradient(
                                  colors: [AppColors.goldCoin, AppColors.goldCoinDark],
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black26,
                                    blurRadius: 4,
                                    offset: Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Text(
                                  '\$',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w900,
                                    fontSize: 15,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Coin Amount Text
                            Text(
                              '${state.coins}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w900,
                                fontSize: 16,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(width: 6),
                            // Plus button
                            Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: Color(0xFFFFD54F),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add,
                                  color: Color(0xFF78350F),
                                  size: 14,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // 2. Main Game Body
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 6.0),
                  child: Column(
                    children: [
                      const SizedBox(height: 4),

                      // Word Search Game Title Logo (Letter Tiles)
                      _buildWordSearchGameLogo(),

                      const SizedBox(height: 18),

                      // Current Level Hero Card (Level, Chapter, Big 3D Play Button)
                      _buildCurrentLevelHeroCard(state, currentLevelId),

                      const SizedBox(height: 14),

                      // Mode 1: Chapters and Levels
                      _buildChaptersModeCard(currentLevelId, unlockedMaxLevel),

                      const SizedBox(height: 14),

                      // Mode 2: Timer Challenge (Speed Run 90s, 60s, 30s)
                      _buildTimerModeCard(),

                      const SizedBox(height: 14),

                      // Free Reward Bonus Button (+100 Coins Video)
                      _buildFreeCoinsButton(),

                      const SizedBox(height: 12),
                    ],
                  ),
                ),
              ),

              // 3. Bottom Banner
              const AdBannerWidget(),
            ],
          ),
        ),
      ),
    );
  }

  // --- UI Components ---

  Widget _buildTopCircleButton({
    required IconData icon,
    required VoidCallback onTap,
    String? tooltip,
  }) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2563EB), Color(0xFF1D4ED8)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.25),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white, size: 22),
        tooltip: tooltip,
        onPressed: onTap,
        constraints: const BoxConstraints(minWidth: 42, minHeight: 42),
        padding: EdgeInsets.zero,
      ),
    );
  }

  Widget _buildWordSearchGameLogo() {
    return Column(
      children: [
        // Top Row: W O R D
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLetterTile('W', const Color(0xFF3B82F6)),
            const SizedBox(width: 6),
            _buildLetterTile('O', const Color(0xFF10B981)),
            const SizedBox(width: 6),
            _buildLetterTile('R', const Color(0xFFF59E0B)),
            const SizedBox(width: 6),
            _buildLetterTile('D', const Color(0xFFEC4899)),
          ],
        ),
        const SizedBox(height: 6),
        // Bottom Row: S E A R C H
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildLetterTile('S', const Color(0xFF8B5CF6)),
            const SizedBox(width: 5),
            _buildLetterTile('E', const Color(0xFF06B6D4)),
            const SizedBox(width: 5),
            _buildLetterTile('A', const Color(0xFFF97316)),
            const SizedBox(width: 5),
            _buildLetterTile('R', const Color(0xFF10B981)),
            const SizedBox(width: 5),
            _buildLetterTile('C', const Color(0xFF3B82F6)),
            const SizedBox(width: 5),
            _buildLetterTile('H', const Color(0xFFEF4444)),
          ],
        ),
        const SizedBox(height: 8),
        // Sparkling Subtitle Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.black.withOpacity(0.32),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withOpacity(0.4), width: 1),
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.star_rounded, color: Color(0xFFFFD54F), size: 15),
              SizedBox(width: 6),
              Text(
                '1,000 CHAPTERS • 6,000 LEVELS',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
              SizedBox(width: 6),
              Icon(Icons.star_rounded, color: Color(0xFFFFD54F), size: 15),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildLetterTile(String letter, Color baseColor) {
    return Container(
      width: 38,
      height: 44,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            baseColor.withOpacity(0.85),
            baseColor,
          ],
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
        ),
        borderRadius: BorderRadius.circular(9),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.35),
            blurRadius: 4,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 23,
            fontWeight: FontWeight.w900,
            shadows: [
              Shadow(
                color: Colors.black45,
                offset: Offset(1, 1),
                blurRadius: 2,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCurrentLevelHeroCard(GameState state, int currentLevelId) {
    final chapter = state.currentChapter;
    final levelInChapter = ((currentLevelId - 1) % ChapterData.levelsPerChapter) + 1;
    final totalInChapter = ChapterData.levelsPerChapter;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(26),
        border: Border.all(color: Colors.white, width: 2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.22),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          // Level & Theme Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 3),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          'CHAPTER ${chapter.id}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                            fontSize: 10,
                            letterSpacing: 0.8,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        chapter.title,
                        style: TextStyle(
                          color: Colors.grey.shade700,
                          fontWeight: FontWeight.w700,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    state.currentLevel.categoryName,
                    style: const TextStyle(
                      color: Color(0xFF0F172A),
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                  Text(
                    '${state.currentLevel.words.length} Hidden Words',
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),

              // Level Circular Gold Badge
              Container(
                width: 58,
                height: 58,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFBBF24), Color(0xFFD97706)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFD97706).withOpacity(0.4),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      'LVL',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 9,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.8,
                      ),
                    ),
                    Text(
                      '$currentLevelId',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                        height: 1.0,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Chapter Progress Bar
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: levelInChapter / totalInChapter,
                    backgroundColor: Colors.grey.shade200,
                    valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF10B981)),
                    minHeight: 7,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Lvl $levelInChapter of $totalInChapter',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Big Tactile 3D PLAY Button
          GestureDetector(
            onTap: () => _launchLevel(currentLevelId),
            child: Container(
              width: double.infinity,
              height: 54,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
                borderRadius: BorderRadius.circular(27),
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF047857).withOpacity(0.9),
                    offset: const Offset(0, 4),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    offset: const Offset(0, 6),
                    blurRadius: 8,
                  ),
                ],
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.play_arrow_rounded, color: Colors.white, size: 30),
                  SizedBox(width: 4),
                  Text(
                    'PLAY',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 2.0,
                      shadows: [
                        Shadow(
                          color: Colors.black38,
                          offset: Offset(1, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChaptersModeCard(int currentLevelId, int unlockedMaxLevel) {
    return GestureDetector(
      onTap: _openChaptersAndLevels,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFF0F2B5C), Color(0xFF1E3A8A)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(color: const Color(0xFF38BDF8), width: 1.8),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 46,
              height: 46,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(color: Colors.white, width: 1.5),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF38BDF8).withOpacity(0.4),
                    blurRadius: 6,
                  ),
                ],
              ),
              child: const Icon(
                Icons.auto_stories_rounded,
                color: Colors.white,
                size: 24,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Chapters & Levels',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.3,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '1,000 Chapters • 6,000 Levels',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF38BDF8), Color(0xFF0284C7)],
                ),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white, width: 1),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'SELECT',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 0.8,
                    ),
                  ),
                  SizedBox(width: 2),
                  Icon(Icons.chevron_right_rounded, color: Colors.white, size: 16),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTimerModeCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF2E1065), Color(0xFF4C1D95)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFF59E0B), width: 1.8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 12,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFF59E0B), Color(0xFFEF4444)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: Colors.white, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFEF4444).withOpacity(0.4),
                      blurRadius: 6,
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.timer_rounded,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Timer Challenge',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Speed Run: 90s, 60s, or 30s!',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: _openTimerChallenge,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFFEF4444), Color(0xFFDC2626)],
                    ),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white, width: 1),
                  ),
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'PLAY',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 11,
                          fontWeight: FontWeight.w900,
                          letterSpacing: 0.8,
                        ),
                      ),
                      SizedBox(width: 2),
                      Icon(Icons.chevron_right_rounded, color: Colors.white, size: 16),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 10),
          // 3 interactive difficulty chips
          Row(
            children: [
              Expanded(
                child: _buildQuickDifficultyChip(
                  '90s Easy',
                  const Color(0xFF10B981),
                  TimerDifficulty.easy,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickDifficultyChip(
                  '60s Med',
                  const Color(0xFFF59E0B),
                  TimerDifficulty.medium,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _buildQuickDifficultyChip(
                  '30s Hard',
                  const Color(0xFFEF4444),
                  TimerDifficulty.hard,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDifficultyChip(String label, Color color, TimerDifficulty diff) {
    return GestureDetector(
      onTap: () {
        widget.gameState.loadLevel(widget.gameState.currentLevel.id, difficulty: diff);
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => GameScreen(gameState: widget.gameState),
          ),
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color, width: 1.2),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 11,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFreeCoinsButton() {
    return GestureDetector(
      onTap: _showRewardedAd,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFD97706), Color(0xFFB45309)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFFDE68A), width: 1.5),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.2),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.card_giftcard_rounded, color: Color(0xFFFEF3C7), size: 22),
            const SizedBox(width: 10),
            const Text(
              'Free Reward: +100 Coins',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w900,
                fontSize: 14,
                letterSpacing: 0.5,
              ),
            ),
            const SizedBox(width: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.play_circle_filled_rounded, color: Color(0xFFB45309), size: 14),
                  SizedBox(width: 3),
                  Text(
                    'WATCH',
                    style: TextStyle(
                      color: Color(0xFFB45309),
                      fontWeight: FontWeight.w900,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
