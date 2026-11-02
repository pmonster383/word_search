import 'package:flutter/services.dart';

class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  bool soundEnabled = true;
  bool vibrationEnabled = true;

  void playLetterSelect() {
    if (vibrationEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  void playWordFound() {
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    if (vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void playLevelComplete() {
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    if (vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
  }

  void playCoinCollect() {
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    if (vibrationEnabled) {
      HapticFeedback.lightImpact();
    }
  }

  void playPowerUp() {
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.click);
    }
    if (vibrationEnabled) {
      HapticFeedback.mediumImpact();
    }
  }

  void playTimeAlert() {
    if (vibrationEnabled) {
      HapticFeedback.selectionClick();
    }
  }

  void playTimeUp() {
    if (soundEnabled) {
      SystemSound.play(SystemSoundType.alert);
    }
    if (vibrationEnabled) {
      HapticFeedback.heavyImpact();
    }
  }
}
