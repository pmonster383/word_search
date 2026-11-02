import 'package:shared_preferences/shared_preferences.dart';

class StorageService {
  static const String _keyCoins = 'ws_coins';
  static const String _keyCurrentLevel = 'ws_current_level';
  static const String _keyUnlockedLevel = 'ws_unlocked_level';
  static const String _keySoundEnabled = 'ws_sound_enabled';
  static const String _keyVibrationEnabled = 'ws_vibration_enabled';
  static const String _keyCompletedLevels = 'ws_completed_levels';
  static const String _keyCurrentChapter = 'ws_current_chapter';

  static SharedPreferences? _prefs;

  static Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  static int getCoins() {
    return _prefs?.getInt(_keyCoins) ?? 200;
  }

  static Future<void> setCoins(int value) async {
    await _prefs?.setInt(_keyCoins, value);
  }

  static int getCurrentLevel() {
    return _prefs?.getInt(_keyCurrentLevel) ?? 1;
  }

  static Future<void> setCurrentLevel(int level) async {
    await _prefs?.setInt(_keyCurrentLevel, level);
  }

  static int getUnlockedLevel() {
    return _prefs?.getInt(_keyUnlockedLevel) ?? 1;
  }

  static Future<void> setUnlockedLevel(int level) async {
    await _prefs?.setInt(_keyUnlockedLevel, level);
  }

  static bool getSoundEnabled() {
    return _prefs?.getBool(_keySoundEnabled) ?? true;
  }

  static Future<void> setSoundEnabled(bool enabled) async {
    await _prefs?.setBool(_keySoundEnabled, enabled);
  }

  static bool getVibrationEnabled() {
    return _prefs?.getBool(_keyVibrationEnabled) ?? true;
  }

  static Future<void> setVibrationEnabled(bool enabled) async {
    await _prefs?.setBool(_keyVibrationEnabled, enabled);
  }

  static int getCurrentChapter() {
    return _prefs?.getInt(_keyCurrentChapter) ?? 1;
  }

  static Future<void> setCurrentChapter(int chapter) async {
    await _prefs?.setInt(_keyCurrentChapter, chapter);
  }

  static List<String> getCompletedLevels() {
    return _prefs?.getStringList(_keyCompletedLevels) ?? [];
  }

  static Future<void> addCompletedLevel(int levelId) async {
    final list = getCompletedLevels();
    if (!list.contains(levelId.toString())) {
      list.add(levelId.toString());
      await _prefs?.setStringList(_keyCompletedLevels, list);
    }
  }

  static Future<void> resetProgress() async {
    await _prefs?.clear();
  }
}
