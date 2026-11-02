import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import '../core/services/storage_service.dart';
import '../models/chapter_model.dart';
import '../widgets/background_scenery_widget.dart';

class ChapterSelectScreen extends StatefulWidget {
  final int currentLevelId;
  final Function(int levelId) onSelectLevel;

  const ChapterSelectScreen({
    super.key,
    required this.currentLevelId,
    required this.onSelectLevel,
  });

  @override
  State<ChapterSelectScreen> createState() => _ChapterSelectScreenState();
}

class _ChapterSelectScreenState extends State<ChapterSelectScreen> {
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _jumpController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Auto-scroll near current chapter after build
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToCurrentChapter();
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _jumpController.dispose();
    super.dispose();
  }

  void _scrollToCurrentChapter() {
    final chapterIndex = ((widget.currentLevelId - 1) ~/ ChapterData.levelsPerChapter)
        .clamp(0, ChapterData.totalChapters - 1);
    if (_scrollController.hasClients && chapterIndex > 0) {
      // Estimated height per chapter card ~ 190.0
      final offset = (chapterIndex * 190.0).clamp(
        0.0,
        _scrollController.position.maxScrollExtent,
      );
      _scrollController.animateTo(
        offset,
        duration: const Duration(milliseconds: 500),
        curve: Curves.easeOutCubic,
      );
    }
  }

  void _showJumpDialog(int unlockedMaxLevel) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: const Row(
          children: [
            Icon(Icons.search_rounded, color: Color(0xFF2563EB)),
            SizedBox(width: 8),
            Text(
              'Jump to Level',
              style: TextStyle(fontWeight: FontWeight.w900),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter any level between 1 and ${ChapterData.totalLevels}:',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 13),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _jumpController,
              keyboardType: TextInputType.number,
              autofocus: true,
              decoration: InputDecoration(
                hintText: 'e.g. ${widget.currentLevelId}',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(16)),
                prefixIcon: const Icon(Icons.tag_rounded),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              _jumpController.clear();
              Navigator.pop(ctx);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2563EB),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            onPressed: () {
              final text = _jumpController.text.trim();
              final targetLevel = int.tryParse(text);
              if (targetLevel != null &&
                  targetLevel >= 1 &&
                  targetLevel <= ChapterData.totalLevels) {
                Navigator.pop(ctx);
                _jumpController.clear();
                if (targetLevel <= unlockedMaxLevel) {
                  widget.onSelectLevel(targetLevel);
                  Navigator.pop(context);
                } else {
                  // Scroll to that chapter so user can see it
                  final chapterIndex = ((targetLevel - 1) ~/ ChapterData.levelsPerChapter)
                      .clamp(0, ChapterData.totalChapters - 1);
                  final offset = (chapterIndex * 190.0).clamp(
                    0.0,
                    _scrollController.position.maxScrollExtent,
                  );
                  _scrollController.animateTo(
                    offset,
                    duration: const Duration(milliseconds: 600),
                    curve: Curves.easeInOutCubic,
                  );
                }
              }
            },
            child: const Text('Go'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final unlockedMaxLevel = StorageService.getUnlockedLevel();
    final completedLevels = StorageService.getCompletedLevels();

    return Scaffold(
      body: BackgroundSceneryWidget(
        theme: 'forest',
        child: SafeArea(
          child: Column(
            children: [
              // Header Bar
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10.0),
                child: Row(
                  children: [
                    // Back button
                    Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF2563EB),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.2),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white, size: 20),
                        onPressed: () => Navigator.pop(context),
                      ),
                    ),
                    const SizedBox(width: 12),

                    // Title
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Chapters & Levels',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                              letterSpacing: 0.5,
                              shadows: [
                                Shadow(color: Colors.black54, blurRadius: 6),
                              ],
                            ),
                          ),
                          Text(
                            '${ChapterData.totalLevels} Levels • ${ChapterData.totalChapters} Chapters',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white.withOpacity(0.9),
                              shadows: const [
                                Shadow(color: Colors.black45, blurRadius: 4),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Jump to Level search icon
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.92),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFF38BDF8), width: 1.5),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.15),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      child: IconButton(
                        icon: const Icon(Icons.search_rounded, color: Color(0xFF0284C7), size: 22),
                        tooltip: 'Search Level',
                        onPressed: () => _showJumpDialog(unlockedMaxLevel),
                      ),
                    ),
                  ],
                ),
              ),

              // Active Level Shortcut Pill
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
                child: GestureDetector(
                  onTap: _scrollToCurrentChapter,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1E3A8A).withOpacity(0.85),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFF60A5FA), width: 1.5),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Icon(Icons.play_circle_fill_rounded, color: Color(0xFFFFD54F), size: 20),
                            const SizedBox(width: 8),
                            Text(
                              'Playing Level ${widget.currentLevelId}',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                        const Row(
                          children: [
                            Text(
                              'Scroll to Current',
                              style: TextStyle(
                                color: Color(0xFF93C5FD),
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(Icons.arrow_downward_rounded, color: Color(0xFF93C5FD), size: 16),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 6),

              // Chapters & Levels List
              Expanded(
                child: ListView.builder(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 4, 16, 20),
                  itemCount: ChapterData.chapters.length,
                  itemBuilder: (context, index) {
                    final chapter = ChapterData.chapters[index];
                    final isUnlocked = unlockedMaxLevel >= chapter.startLevel;

                    // Calculate completed levels in this chapter
                    int chapterCompletedCount = 0;
                    for (int l = chapter.startLevel; l <= chapter.endLevel; l++) {
                      if (completedLevels.contains(l.toString())) {
                        chapterCompletedCount++;
                      }
                    }

                    return Container(
                      margin: const EdgeInsets.only(bottom: 14),
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.94),
                        borderRadius: BorderRadius.circular(22),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.18),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Chapter Title Row
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    width: 36,
                                    height: 36,
                                    decoration: BoxDecoration(
                                      color: _getChapterThemeColor(chapter.theme).withOpacity(0.15),
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getChapterIcon(chapter.theme),
                                      color: _getChapterThemeColor(chapter.theme),
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Chapter ${chapter.id}: ${chapter.title}',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w900,
                                          fontSize: 16,
                                          color: AppColors.darkText,
                                        ),
                                      ),
                                      Text(
                                        chapter.subtitle,
                                        style: TextStyle(
                                          color: Colors.grey.shade600,
                                          fontSize: 11,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),

                              // Chapter Status Pill
                              if (!isUnlocked)
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.grey.shade200,
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: const Row(
                                    children: [
                                      Icon(Icons.lock_rounded, size: 14, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Text(
                                        'Locked',
                                        style: TextStyle(
                                          fontSize: 11,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w700,
                                        ),
                                      ),
                                    ],
                                  ),
                                )
                              else
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: chapterCompletedCount == chapter.totalLevels
                                        ? const Color(0xFF10B981).withOpacity(0.15)
                                        : const Color(0xFF0284C7).withOpacity(0.12),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '$chapterCompletedCount/${chapter.totalLevels}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w900,
                                      color: chapterCompletedCount == chapter.totalLevels
                                          ? const Color(0xFF059669)
                                          : const Color(0xFF0284C7),
                                    ),
                                  ),
                                ),
                            ],
                          ),
                          const SizedBox(height: 14),

                          // Level Pills Grid
                          Wrap(
                            spacing: 12,
                            runSpacing: 10,
                            children: List.generate(chapter.totalLevels, (i) {
                              final lvlId = chapter.startLevel + i;
                              final isLevelUnlocked = lvlId <= unlockedMaxLevel;
                              final isCurrent = lvlId == widget.currentLevelId;
                              final isDone = completedLevels.contains(lvlId.toString());

                              return GestureDetector(
                                onTap: isLevelUnlocked
                                    ? () {
                                        widget.onSelectLevel(lvlId);
                                        Navigator.pop(context);
                                      }
                                    : null,
                                child: Column(
                                  children: [
                                    Container(
                                      width: 48,
                                      height: 48,
                                      decoration: BoxDecoration(
                                        color: isCurrent
                                            ? const Color(0xFF2563EB)
                                            : isDone
                                                ? const Color(0xFF10B981)
                                                : isLevelUnlocked
                                                    ? Colors.white
                                                    : Colors.grey.shade200,
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: isCurrent
                                              ? const Color(0xFFFFD54F)
                                              : isDone
                                                  ? const Color(0xFF059669)
                                                  : isLevelUnlocked
                                                      ? const Color(0xFF38BDF8)
                                                      : Colors.grey.shade400,
                                          width: isCurrent ? 3 : 1.5,
                                        ),
                                        boxShadow: [
                                          if (isCurrent)
                                            BoxShadow(
                                              color: const Color(0xFF2563EB).withOpacity(0.5),
                                              blurRadius: 8,
                                              spreadRadius: 2,
                                            )
                                          else if (isLevelUnlocked)
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.08),
                                              blurRadius: 4,
                                            ),
                                        ],
                                      ),
                                      child: Center(
                                        child: isCurrent
                                            ? const Icon(
                                                Icons.play_arrow_rounded,
                                                color: Colors.white,
                                                size: 26,
                                              )
                                            : isDone
                                                ? const Icon(
                                                    Icons.check_rounded,
                                                    color: Colors.white,
                                                    size: 22,
                                                  )
                                                : isLevelUnlocked
                                                    ? Text(
                                                        '$lvlId',
                                                        style: const TextStyle(
                                                          fontSize: 15,
                                                          fontWeight: FontWeight.w900,
                                                          color: AppColors.darkText,
                                                        ),
                                                      )
                                                    : const Icon(
                                                        Icons.lock_rounded,
                                                        size: 16,
                                                        color: Colors.grey,
                                                      ),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      isCurrent ? 'PLAY' : 'Lvl $lvlId',
                                      style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: isCurrent ? FontWeight.w900 : FontWeight.w600,
                                        color: isCurrent ? const Color(0xFF1D4ED8) : Colors.grey.shade600,
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getChapterIcon(String theme) {
    switch (theme) {
      case 'sea':
        return Icons.water_rounded;
      case 'forest':
        return Icons.park_rounded;
      case 'autumn':
        return Icons.eco_rounded;
      case 'twilight':
        return Icons.nightlight_round;
      default:
        return Icons.map_rounded;
    }
  }

  Color _getChapterThemeColor(String theme) {
    switch (theme) {
      case 'sea':
        return const Color(0xFF0284C7);
      case 'forest':
        return const Color(0xFF059669);
      case 'autumn':
        return const Color(0xFFD97706);
      case 'twilight':
        return const Color(0xFF7C3AED);
      default:
        return const Color(0xFF2563EB);
    }
  }
}
