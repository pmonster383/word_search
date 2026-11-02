class ChapterModel {
  final int id;
  final String title;
  final String subtitle;
  final int startLevel;
  final int endLevel;
  final String theme;
  final int rewardCoins;

  const ChapterModel({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.startLevel,
    required this.endLevel,
    required this.theme,
    this.rewardCoins = 75,
  });

  int get totalLevels => endLevel - startLevel + 1;
}

class ChapterData {
  static const int totalChapters = 1000;
  static const int levelsPerChapter = 6;
  static const int totalLevels = totalChapters * levelsPerChapter; // 6000 Levels

  static final List<ChapterModel> chapters = _buildChapters();

  static List<ChapterModel> _buildChapters() {
    final themes = ['sea', 'forest', 'autumn', 'twilight'];
    final titles = [
      'Sea', 'Forest', 'Golden Autumn', 'Twilight Realm',
      'Emerald Bay', 'Pine Woods', 'Amber Foliage', 'Starlight Expanse',
      'Coral Lagoon', 'Whispering Pines', 'Harvest Valley', 'Celestial Veil',
      'Ocean Breeze', 'Secret Grove', 'Autumn Glow', 'Cosmic Nebula',
      'Tropical Reef', 'Cedar Ridge', 'Maple Glade', 'Aurora Borealis',
      'Sunlit Shore', 'Deep Redwood', 'Russet Orchard', 'Milky Way',
      'Crystal Cove', 'Misty Trail', 'Cider Hills', 'Solar Eclipse',
      'Azure Waters', 'Mossy Hollow', 'Golden Meadow', 'Starry Horizon',
      'Island Paradise', 'Ancient Willow', 'Pumpkin Patch', 'Supernova',
      'Sapphire Coast', 'Alpine Summit', 'Crimson Forest', 'Galaxy Core',
      'Tide Pool', 'Quiet Wilderness', 'Cozy Hearth', 'Northern Lights',
      'Dolphin Bay', 'Timberland', 'Autumn Breeze', 'Stellar Wind',
      'Pacific Crest', 'Highland Mist', 'Fallen Leaves', 'Infinite Void',
      'Seagull Haven', 'Wildflower Glade', 'Chestnut Ridge', 'Comet Tail',
      'Turquoise Shallows', 'Balsam Fir', 'Pecan Grove', 'Meteor Shower',
      'Sand Dollar Bay', 'Fern Canyon', 'Amber Sunset', 'Pulsar Beam',
      'Pelican Point', 'Birch Grove', 'Acorn Woods', 'Quasar Light',
      'Mariner Voyage', 'Shadowed Pines', 'Copper Canopy', 'Moonlit Ocean',
      'Coral Arch', 'Spring Willow', 'Autumn Twilight', 'Deep Cosmos',
      'Sunken Galleon', 'Evergreen Peak', 'Cinnamon Trail', 'Night Constellation',
      'Tropical Lagoon', 'Mountain Stream', 'Harvest Moon', 'Orbit Horizon',
      'Calm Waters', 'Zen Garden', 'Golden Woods', 'Nebula Cluster',
      'Hidden Beach', 'Enchanted Trail', 'Warm Hearth', 'Astral Sky',
      'Wave Rider', 'Deep Forest', 'Autumn Rain', 'Cosmic Glow',
      'Diamond Atoll', 'Silent Pines', 'Golden Twilight', 'Infinity Realm',
    ];

    final subtitles = [
      'Tropical Waters & Hidden Treasures',
      'Landscape Forest & Zen Trails',
      'Warm Foliage & Cozy Days',
      'Starry Nights & Cosmic Wonders',
      'Sunlit Waves & Secret Coasts',
      'Alpine Breezes & Mossy Paths',
      'Crisp Air & Golden Leaves',
      'Distant Galaxies & Stellar Glow',
      'Turquoise Seas & Hidden Coves',
      'Mountain Summits & Evergreen Trails',
    ];

    return List.generate(totalChapters, (index) {
      final id = index + 1;
      final start = index * levelsPerChapter + 1;
      final end = (index + 1) * levelsPerChapter;
      final theme = themes[index % themes.length];
      final baseTitle = titles[index % titles.length];
      final cycle = (index ~/ titles.length) + 1;
      final title = cycle == 1 ? baseTitle : '$baseTitle Part $cycle';
      final subtitle = subtitles[index % subtitles.length];
      final reward = (id % 5 == 0) ? 100 : 75;

      return ChapterModel(
        id: id,
        title: title,
        subtitle: subtitle,
        startLevel: start,
        endLevel: end,
        theme: theme,
        rewardCoins: reward,
      );
    });
  }

  static ChapterModel getChapterForLevel(int levelId) {
    final clamped = levelId.clamp(1, totalLevels);
    final chapterIndex = ((clamped - 1) ~/ levelsPerChapter).clamp(0, totalChapters - 1);
    return chapters[chapterIndex];
  }
}
