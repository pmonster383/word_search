# Word Search Adventure (Flutter)

A complete mobile word search puzzle game built with Flutter, matching the gameplay, visual aesthetics, animations, and progression mechanisms demonstrated in the reference video.

## ✨ Modules & Architecture

### 1. Game Engine (`lib/game_engine/`)
- **`GridGenerator`**: Generates dynamic $N \times M$ grids (6x6, 7x7) with random filler letters and placement of target words across 8 orientations (horizontal, vertical, diagonal, forward & reverse).
- **`SelectionTracker`**: Converts touch/pan events to grid coordinates, snaps drag vectors to 8 directions, calculates live straight-line paths, and validates selected words against remaining target words.
- **Word Highlight System**: Features real-time drag capsule indicators and persistent vibrant pastel capsules for found words, matching the game in the video.
- **Floating Word Bubble**: Displays the uppercase letters currently being dragged right above the touch point.

### 2. Level & Chapter Progression (`lib/models/`)
- **Themed Levels**:
  - Chapter 1: *Sea* (Beach Fun, Ocean Giants, Tropical Birds, Seashell Hunt, Coral Reef, Sunset Cruise)
  - Chapter 2: *Landscape Forest* (Woodland Life, Morning Walk, Forest Blooms, Mountain Path, Zen Lifestyle, Halloween Night)
  - Chapter 3: *Golden Autumn* (Has Four Legs, Sweet Treats, Cozy Evening, Solar System, Night Sky, Winter Dreams)
  - Chapter 4: *Twilight Realm* (Starry Nights, Cosmic Wonders)
- **Covered / Mystery Word Mode**:
  - As seen in Level 12 of the reference video, target words can be partially masked (e.g. `G**WL` with an animated fluttering butterfly!).
  - Finding the covered word grants bonus coins (+50 coins) and special celebratory feedback.

### 3. Rewards & Boosters (`lib/widgets/power_ups_bar.dart`)
- **Coins Wallet**: Interactive coin display (`231 +`) with tap-to-earn options.
- **Magic Wand (200 Coins)**: Instantly reveals and highlights a full hidden word on the grid.
- **Magnifying Glass (100 Coins)**: Reveals the initial letter of a remaining word with an illuminated glow.
- **Shuffle / Rotate View**: Rotates the board perspective by 90° to spot words from fresh angles.
- **Chapter Rewards**: Big stack of coins (+75) on chapter completion, with a **DOUBLE** option via rewarded ad.

### 4. Player Experience & UI (`lib/widgets/` & `lib/screens/`)
- **Scenic Backgrounds**: Rich multi-layered scenic canvas painters (Golden Autumn Forest road, Azure Sea & limestone cliffs, Twilight Stars).
- **Audio & Haptics**: Integrated `AudioService` with light/medium/heavy haptic feedbacks and system sound effects.
- **Celebration Feedback**: Floating animated toasts ("Awesome!", "Incredible!", "Splendid!") and victory ribbons ("Level Completed!").
- **Settings Dialog**: Sound effects toggle, Haptic vibration toggle, How to Play guide, and Reset Game Progress.
- **Rate Us Dialog**: Interactive 5-star rating popup matching the video.

### 5. Local Persistence (`lib/core/services/storage_service.dart`)
- Uses `shared_preferences` to persist:
  - Current level and highest unlocked level
  - Player's coin balance
  - Completed levels list
  - Sound and vibration preferences

### 6. Monetization (`lib/widgets/`)
- **Ad Banner**: Standard 50dp banner widget placed along the bottom.
- **Rewarded Video Ad**: 5-second countdown simulated rewarded ad with reward granting callbacks, ready to plug into Google Mobile Ads SDK (`google_mobile_ads`).

---

## 🚀 How to Run the App

1. Ensure Flutter is installed and in your PATH.
2. From the project directory:
   ```bash
   flutter pub get
   flutter run
   ```
   Or specify a target:
   ```bash
   flutter run -d chrome
   flutter run -d windows
   flutter run -d <android-device-id>
   ```
