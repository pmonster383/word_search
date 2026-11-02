import 'dart:math';
import 'chapter_model.dart';

class LevelModel {
  final int id;
  final int chapterId;
  final String categoryName;
  final List<String> words;
  final String? coveredWord;
  final int rows;
  final int cols;
  final String theme;

  const LevelModel({
    required this.id,
    required this.chapterId,
    required this.categoryName,
    required this.words,
    this.coveredWord,
    this.rows = 7,
    this.cols = 7,
    this.theme = 'forest',
  });
}

class LevelData {
  static const int totalLevels = 6000;

  static final List<LevelModel> levels = _buildAllLevels();

  static LevelModel getLevel(int id) {
    final clampedId = id.clamp(1, totalLevels);
    return levels[clampedId - 1];
  }

  static List<LevelModel> _buildAllLevels() {
    final list = <LevelModel>[];

    // 1. Initial 24 hand-curated levels (including Level 11, 12, 13 from reference video)
    final initialCurated = <LevelModel>[
      // Chapter 1: Sea & Coastal Life (Levels 1 - 6)
      const LevelModel(
        id: 1,
        chapterId: 1,
        categoryName: 'BEACH FUN',
        words: ['SAND', 'WAVE', 'SURF', 'SUN'],
        rows: 6,
        cols: 6,
        theme: 'sea',
      ),
      const LevelModel(
        id: 2,
        chapterId: 1,
        categoryName: 'OCEAN GIANTS',
        words: ['WHALE', 'SHARK', 'CORAL', 'TIDE', 'SEAL'],
        rows: 6,
        cols: 6,
        theme: 'sea',
      ),
      const LevelModel(
        id: 3,
        chapterId: 1,
        categoryName: 'TROPICAL BIRDS',
        words: ['PARROT', 'TOUCAN', 'EAGLE', 'SWAN', 'HAWK'],
        rows: 7,
        cols: 7,
        theme: 'sea',
      ),
      const LevelModel(
        id: 4,
        chapterId: 1,
        categoryName: 'SEASHELL HUNT',
        words: ['CONCH', 'CLAM', 'PEARL', 'CRAB', 'SNAIL'],
        rows: 7,
        cols: 7,
        theme: 'sea',
      ),
      const LevelModel(
        id: 5,
        chapterId: 1,
        categoryName: 'CORAL REEF',
        words: ['ANEMONE', 'CLOWN', 'DIVER', 'BLUE', 'WATER'],
        coveredWord: 'DIVER',
        rows: 7,
        cols: 7,
        theme: 'sea',
      ),
      const LevelModel(
        id: 6,
        chapterId: 1,
        categoryName: 'SUNSET CRUISE',
        words: ['ANCHOR', 'SAIL', 'ISLAND', 'BREEZE', 'HARBOR', 'VOYAGE'],
        rows: 7,
        cols: 7,
        theme: 'sea',
      ),

      // Chapter 2: Landscape Forest & Zen (Levels 7 - 12)
      const LevelModel(
        id: 7,
        chapterId: 2,
        categoryName: 'WOODLAND LIFE',
        words: ['PINE', 'DEER', 'MOSS', 'OAK', 'BARK'],
        rows: 7,
        cols: 7,
        theme: 'forest',
      ),
      const LevelModel(
        id: 8,
        chapterId: 2,
        categoryName: 'MORNING WALK',
        words: ['TRAIL', 'MIST', 'DAWN', 'ROBIN', 'LEAF'],
        rows: 7,
        cols: 7,
        theme: 'forest',
      ),
      const LevelModel(
        id: 9,
        chapterId: 2,
        categoryName: 'FOREST BLOOMS',
        words: ['FERN', 'VIOLET', 'DAISY', 'LILY', 'ROSE', 'TULIP'],
        rows: 7,
        cols: 7,
        theme: 'forest',
      ),
      const LevelModel(
        id: 10,
        chapterId: 2,
        categoryName: 'MOUNTAIN PATH',
        words: ['SUMMIT', 'PEAK', 'VALLEY', 'RIDGE', 'CLIFF', 'STREAM'],
        rows: 7,
        cols: 7,
        theme: 'forest',
      ),
      // Level 11 from reference video!
      const LevelModel(
        id: 11,
        chapterId: 2,
        categoryName: 'ZEN LIFESTYLE',
        words: ['HEAL', 'RELAX', 'CALM', 'PEACE', 'EASE', 'YOGA'],
        rows: 7,
        cols: 7,
        theme: 'forest',
      ),
      // Level 12 from reference video with covered word GROWL!
      const LevelModel(
        id: 12,
        chapterId: 2,
        categoryName: 'HALLOWEEN NIGHT',
        words: ['DARK', 'WITCH', 'GROWL', 'CANDY', 'MASK', 'GHOST'],
        coveredWord: 'GROWL',
        rows: 7,
        cols: 7,
        theme: 'forest',
      ),

      // Chapter 3: Cozy World & Beyond (Levels 13 - 18)
      // Level 13 from reference video!
      const LevelModel(
        id: 13,
        chapterId: 3,
        categoryName: 'HAS FOUR LEGS',
        words: ['SOFA', 'DONKEY', 'GOAT', 'DOG', 'TABLE', 'CHAIR'],
        rows: 7,
        cols: 7,
        theme: 'autumn',
      ),
      const LevelModel(
        id: 14,
        chapterId: 3,
        categoryName: 'SWEET TREATS',
        words: ['HONEY', 'COOKIE', 'WAFFLE', 'DONUT', 'CREAM', 'PASTRY'],
        rows: 7,
        cols: 7,
        theme: 'autumn',
      ),
      const LevelModel(
        id: 15,
        chapterId: 3,
        categoryName: 'COZY EVENING',
        words: ['BLANKET', 'FIRE', 'TEA', 'BOOK', 'CANDLE', 'SLIPPER'],
        coveredWord: 'CANDLE',
        rows: 7,
        cols: 7,
        theme: 'autumn',
      ),
      const LevelModel(
        id: 16,
        chapterId: 3,
        categoryName: 'SOLAR SYSTEM',
        words: ['MARS', 'VENUS', 'EARTH', 'SATURN', 'JUPITER', 'ORBIT'],
        rows: 7,
        cols: 7,
        theme: 'twilight',
      ),
      const LevelModel(
        id: 17,
        chapterId: 3,
        categoryName: 'NIGHT SKY',
        words: ['MOON', 'COMET', 'GALAXY', 'NEBULA', 'COSMOS', 'STAR'],
        rows: 7,
        cols: 7,
        theme: 'twilight',
      ),
      const LevelModel(
        id: 18,
        chapterId: 3,
        categoryName: 'WINTER DREAMS',
        words: ['SNOW', 'FROST', 'GLOVE', 'SCARF', 'CHILL', 'ICE'],
        rows: 7,
        cols: 7,
        theme: 'autumn',
      ),

      // Chapter 4: Twilight Realm (Levels 19 - 24)
      const LevelModel(
        id: 19,
        chapterId: 4,
        categoryName: 'COSMIC ODYSSEY',
        words: ['PLANET', 'ROCKET', 'CRATER', 'SOLAR', 'ORBIT'],
        rows: 7,
        cols: 7,
        theme: 'twilight',
      ),
      const LevelModel(
        id: 20,
        chapterId: 4,
        categoryName: 'CONSTELLATIONS',
        words: ['ORION', 'DRACO', 'PEGASUS', 'CYGNUS', 'LEO', 'URSA'],
        rows: 7,
        cols: 7,
        theme: 'twilight',
      ),
      const LevelModel(
        id: 21,
        chapterId: 4,
        categoryName: 'DEEP SPACE',
        words: ['PULSAR', 'QUASAR', 'GRAVITY', 'ECLIPSE', 'METEOR'],
        coveredWord: 'METEOR',
        rows: 7,
        cols: 7,
        theme: 'twilight',
      ),
      const LevelModel(
        id: 22,
        chapterId: 4,
        categoryName: 'NORTHERN LIGHTS',
        words: ['AURORA', 'GLOW', 'VIOLET', 'POLAR', 'SHIMMER', 'FROST'],
        rows: 7,
        cols: 7,
        theme: 'twilight',
      ),
      const LevelModel(
        id: 23,
        chapterId: 4,
        categoryName: 'STARGAZING',
        words: ['OPTICS', 'LENS', 'ZENITH', 'HORIZON', 'MIRROR', 'FINDER'],
        rows: 7,
        cols: 7,
        theme: 'twilight',
      ),
      const LevelModel(
        id: 24,
        chapterId: 4,
        categoryName: 'INFINITY',
        words: ['TIME', 'LIGHT', 'BEYOND', 'SPACE', 'ETERNAL', 'VOYAGER'],
        coveredWord: 'VOYAGER',
        rows: 7,
        cols: 7,
        theme: 'twilight',
      ),
    ];

    list.addAll(initialCurated);

    // 2. Generate Levels 25 to 600 with themed vocabulary banks
    for (int lvlId = 25; lvlId <= totalLevels; lvlId++) {
      final chapter = ChapterData.getChapterForLevel(lvlId);
      final categoryIndex = (lvlId - 25) % _categoryBanks.length;
      final bank = _categoryBanks[categoryIndex];

      // Deterministically pick 5 to 6 words based on levelId
      final random = Random(lvlId * 10007 + 73);
      final shuffledWords = List<String>.from(bank.words)..shuffle(random);
      final wordCount = (lvlId > 150) ? 6 : 5;
      final selectedWords = shuffledWords.take(wordCount).toList();

      // Covered word on every 5th or 6th level
      final isMysteryLevel = (lvlId % 6 == 0 || lvlId % 6 == 5);
      final coveredWord = isMysteryLevel ? selectedWords.first : null;

      final gridSize = (lvlId > 250) ? 8 : 7;

      list.add(LevelModel(
        id: lvlId,
        chapterId: chapter.id,
        categoryName: bank.name,
        words: selectedWords,
        coveredWord: coveredWord,
        rows: gridSize,
        cols: gridSize,
        theme: chapter.theme,
      ));
    }

    return list;
  }

  // Large curated thematic vocabulary banks
  static final List<_CategoryBank> _categoryBanks = [
    _CategoryBank('JUNGLE SAFARI', ['TIGER', 'MONKEY', 'JAGUAR', 'PANTHER', 'PARROT', 'VINE', 'CANOPY', 'PYTHON']),
    _CategoryBank('DESERT OASIS', ['CAMEL', 'DUNE', 'MIRAGE', 'CACTUS', 'PALM', 'SAHARA', 'NOMAD', 'HEAT']),
    _CategoryBank('ARCTIC WILDLIFE', ['WALRUS', 'PENGUIN', 'POLAR', 'SEAL', 'BELUGA', 'ORCA', 'TUNDRA', 'GLACIER']),
    _CategoryBank('RAINFOREST', ['TOUCAN', 'ORCHID', 'AMAZON', 'IGUANA', 'BAMBOO', 'FERN', 'MONKEY', 'FROG']),
    _CategoryBank('RIVER RAPIDS', ['SALMON', 'KAYAK', 'STREAM', 'OTTER', 'CANOE', 'DRIFT', 'CURRENT', 'WATER']),
    _CategoryBank('CANYON TRAILS', ['VALLEY', 'CLIFF', 'GORGE', 'EAGLE', 'PLATEAU', 'BOULDER', 'DESERT', 'RIDGE']),
    _CategoryBank('SPRING GARDEN', ['TULIP', 'DAISY', 'LILY', 'BLOSSOM', 'VIOLET', 'PETAL', 'SPROUT', 'BLOOM']),
    _CategoryBank('SUMMER BREEZE', ['SUNNY', 'BEACH', 'LEMON', 'ISLAND', 'SHADOW', 'MEADOW', 'PICNIC', 'WARM']),
    _CategoryBank('AUTUMN HARVEST', ['APPLE', 'PUMPKIN', 'ACORN', 'MAPLE', 'WALNUT', 'BARN', 'WHEAT', 'CIDER']),
    _CategoryBank('COFFEE SHOP', ['MOCHA', 'LATTE', 'ESPRESSO', 'BEAN', 'ROAST', 'CREAM', 'AROMA', 'SUGAR']),
    _CategoryBank('FRESH BAKERY', ['BREAD', 'BAGEL', 'CROISSANT', 'COOKIE', 'MUFFIN', 'PASTRY', 'CRUST', 'DOUGH']),
    _CategoryBank('ITALIAN CUISINE', ['PASTA', 'PIZZA', 'RISOTTO', 'BASIL', 'TOMATO', 'GARLIC', 'OLIVE', 'CHEESE']),
    _CategoryBank('EXOTIC SPICES', ['PEPPER', 'SAFFRON', 'GINGER', 'CINNAMON', 'NUTMEG', 'CLOVE', 'VANILLA', 'CURRY']),
    _CategoryBank('FRUITS & BERRIES', ['MANGO', 'CHERRY', 'PAPAYA', 'BERRY', 'ORANGE', 'MELON', 'PEACH', 'GRAPE']),
    _CategoryBank('VEGGIE GARDEN', ['CARROT', 'RADISH', 'POTATO', 'PEPPER', 'ONION', 'SPINACH', 'TOMATO', 'CELERY']),
    _CategoryBank('MUSIC & SOUND', ['GUITAR', 'PIANO', 'VIOLIN', 'FLUTE', 'DRUM', 'CELLO', 'HARP', 'TRUMPET']),
    _CategoryBank('PAINTING & ART', ['CANVAS', 'EASEL', 'BRUSH', 'PALETTE', 'COLOR', 'SKETCH', 'MURAL', 'STUDIO']),
    _CategoryBank('ANCIENT CASTLE', ['TOWER', 'KNIGHT', 'THRONE', 'SHIELD', 'SWORD', 'BANNER', 'ARMOR', 'CASTLE']),
    _CategoryBank('PIRATE HAVEN', ['ANCHOR', 'TREASURE', 'SAILOR', 'COMPASS', 'ISLAND', 'PARROT', 'CANNON', 'MAP']),
    _CategoryBank('MYTH & LEGEND', ['DRAGON', 'PHOENIX', 'GRIFFIN', 'HYDRA', 'TITAN', 'SPHINX', 'WIZARD', 'MYTH']),
    _CategoryBank('PRECIOUS GEMS', ['RUBY', 'DIAMOND', 'EMERALD', 'SAPPHIRE', 'TOPAZ', 'OPAL', 'GARNET', 'PEARL']),
    _CategoryBank('ANCIENT EGYPT', ['PHARAOH', 'PYRAMID', 'NILE', 'SPHINX', 'TOMB', 'SCARAB', 'SAND', 'TEMPLE']),
    _CategoryBank('SPEED & ENGINES', ['TURBO', 'MOTOR', 'PISTON', 'CLUTCH', 'WHEEL', 'BRAKE', 'ENGINE', 'SPEED']),
    _CategoryBank('AVIATION', ['PILOT', 'GLIDER', 'BOEING', 'RADAR', 'RUNWAY', 'HANGAR', 'FLIGHT', 'WINGS']),
    _CategoryBank('TRAIN JOURNEY', ['RAILWAY', 'ENGINE', 'CABOOSE', 'TUNNEL', 'STATION', 'TRACK', 'SIGNAL', 'WHISTLE']),
    _CategoryBank('SAILING SEAS', ['SCHOONER', 'FRIGATE', 'RUDDER', 'MAST', 'VOYAGE', 'CAPTAIN', 'OCEAN', 'HELM']),
    _CategoryBank('IN SCIENCE LAB', ['ATOM', 'PROTON', 'LASER', 'MICROSCOPE', 'BEAKER', 'OPTICS', 'RADAR', 'CELL']),
    _CategoryBank('ARCHITECTURE', ['ARCH', 'COLUMN', 'DOME', 'FACADE', 'PILLAR', 'BRIDGE', 'TOWER', 'PLAZA']),
    _CategoryBank('CITY LIFE', ['METRO', 'AVENUE', 'STREET', 'TRAFFIC', 'SUBWAY', 'PARK', 'SQUARE', 'LIGHTS']),
    _CategoryBank('OUTDOOR SPORTS', ['TENNIS', 'SOCCER', 'HOCKEY', 'RUGBY', 'CRICKET', 'GOLF', 'BOXING', 'ROWING']),
    _CategoryBank('CAMPING NIGHT', ['TENT', 'LANTERN', 'COMPASS', 'CANTEEN', 'FIRE', 'CABIN', 'FLASHLIGHT', 'TRAIL']),
    _CategoryBank('BEDROOM COMFORTS', ['PILLOW', 'QUILT', 'MIRROR', 'LAMP', 'CARPET', 'WARDROBE', 'ALARM', 'DREAM']),
    _CategoryBank('KITCHEN TOOLS', ['KETTLE', 'PAN', 'TOASTER', 'BLENDER', 'SPOON', 'WHISK', 'KNIFE', 'GRATER']),
    _CategoryBank('FARMYARD', ['ROOSTER', 'HORSE', 'SHEEP', 'TRACTOR', 'HAYSTACK', 'BARN', 'GOAT', 'DUCK']),
    _CategoryBank('VOLCANO ISLAND', ['LAVA', 'CRATER', 'MAGMA', 'ASHES', 'BASALT', 'SMOKE', 'ISLAND', 'VENT']),
    _CategoryBank('SNOWY SUMMITS', ['AVALANCHE', 'SKIING', 'GLACIER', 'BLIZZARD', 'PEAK', 'GOGGLES', 'PARKA', 'SLED']),
    _CategoryBank('MEDIEVAL QUEST', ['ARCHER', 'SPEAR', 'HELMET', 'CASTLE', 'VALOR', 'HERO', 'CROWN', 'CHALICE']),
    _CategoryBank('MAGIC SPELLS', ['POTION', 'WAND', 'CRYSTAL', 'AMULET', 'CHARM', 'MYSTIC', 'SCROLL', 'SPELL']),
    _CategoryBank('WEATHER WONDERS', ['THUNDER', 'LIGHTNING', 'CYCLONE', 'BREEZE', 'RAINBOW', 'DRIZZLE', 'STORM', 'MIST']),
    _CategoryBank('TROPICAL FRUITS', ['GUAVA', 'COCONUT', 'BANANA', 'MANGO', 'FIG', 'KIWI', 'PINEAPPLE', 'LIME']),
    _CategoryBank('DEEP OCEAN LIFE', ['OCTOPUS', 'JELLYFISH', 'LOBSTER', 'MANTA', 'STARFISH', 'CORAL', 'EEL', 'SHRIMP']),
    _CategoryBank('SEWING & FABRIC', ['NEEDLE', 'THREAD', 'COTTON', 'SILK', 'VELVET', 'WOOL', 'BUTTON', 'STITCH']),
    _CategoryBank('CLASSROOM', ['PENCIL', 'RULER', 'ERASER', 'DESK', 'GLOBE', 'CHALK', 'BOARD', 'NOTEBOOK']),
    _CategoryBank('EMOTIONS & JOY', ['HAPPINESS', 'DELIGHT', 'LAUGHTER', 'SMILE', 'CHEER', 'HOPE', 'PEACE', 'WARMTH']),
    _CategoryBank('PET FRIENDS', ['PUPPY', 'KITTEN', 'HAMSTER', 'RABBIT', 'PARROT', 'TURTLE', 'FERRET', 'GOLDFISH']),
    _CategoryBank('NIGHT SKY', ['METEOR', 'AURORA', 'ORBIT', 'SATELLITE', 'PLANET', 'SOLAR', 'COSMOS', 'GALAXY']),
    _CategoryBank('TREASURE HUNT', ['JEWEL', 'CHEST', 'GOLD', 'RUBY', 'SILVER', 'COINS', 'DIAMOND', 'RELIC']),
  ];
}

class _CategoryBank {
  final String name;
  final List<String> words;
  _CategoryBank(this.name, this.words);
}
