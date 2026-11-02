import 'package:flutter/material.dart';

class AppColors {
  // Theme Backgrounds
  static const Color autumnTop = Color(0xFF6B4226);
  static const Color autumnBottom = Color(0xFFE28743);
  static const Color oceanTop = Color(0xFF0F4C81);
  static const Color oceanBottom = Color(0xFF2DD4BF);
  static const Color twilightTop = Color(0xFF2E1065);
  static const Color twilightBottom = Color(0xFF7C3AED);

  // UI Accents
  static const Color goldCoin = Color(0xFFFFB703);
  static const Color goldCoinDark = Color(0xFFFB8500);
  static const Color starYellow = Color(0xFFFFD166);
  static const Color ribbonBlue = Color(0xFF2563EB);
  static const Color ribbonPink = Color(0xFFE11D48);
  static const Color themeGreen = Color(0xFF10B981);
  static const Color cardBg = Colors.white;
  static const Color darkText = Color(0xFF1E293B);
  static const Color subtleText = Color(0xFF64748B);

  // Found Word Colors (Vibrant Pastel Highlights)
  static const List<Color> wordColors = [
    Color(0xFF38BDF8), // Cyan / Sky Blue
    Color(0xFFA855F7), // Purple / Violet
    Color(0xFF34D399), // Emerald / Mint Green
    Color(0xFFF97316), // Orange
    Color(0xFFEC4899), // Pink
    Color(0xFFFACC15), // Amber Yellow
    Color(0xFF06B6D4), // Teal
    Color(0xFF6366F1), // Indigo
  ];

  static Color getWordColor(int index) {
    return wordColors[index % wordColors.length];
  }
}
