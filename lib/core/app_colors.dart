import 'package:flutter/material.dart';

/// Blood red protest theme colors
class AppColors {
  // Primary blood red colors
  static const Color bloodRed = Color(0xFFB22222);
  static const Color darkBloodRed = Color(0xFF8B0000);
  static const Color lightBloodRed = Color(0xFFDC143C);

  // Light theme colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightOnBackground = Color(0xFF1A1A1A);
  static const Color lightOnSurface = Color(0xFF2D2D2D);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF121212);
  static const Color darkSurface = Color(0xFF1E1E1E);
  static const Color darkOnBackground = Color(0xFFFAFAFA);
  static const Color darkOnSurface = Color(0xFFE0E0E0);

  // Canvas preset colors
  static const List<Color> canvasColors = [
    Color(0xFFB22222), // Blood red
    Color(0xFF8B0000), // Dark red
    // Color(0xFF000000), // Black
    Color(0xFFFFFFFF), // White
    Color(0xFF1A1A1A), // Near black
    Color(0xFF2E7D32), // Green
    Color(0xFF1565C0), // Blue
    Color(0xFFF9A825), // Amber
    Color(0xFF6A1B9A), // Purple
    Color(0xFFE65100), // Deep orange
  ];

  // Text preset colors
  static const List<Color> textColors = [
    Color(0xFFFFFFFF), // White
    Color(0xFF000000), // Black
    Color(0xFFB22222), // Blood red
    Color(0xFFDC143C), // Crimson
    Color(0xFFF9A825), // Amber
    Color(0xFF2E7D32), // Green
    Color(0xFF1565C0), // Blue
    Color(0xFFE0E0E0), // Light gray
  ];
}
