import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const Color primary = Color(0xFF6C63FF);
  static const Color primaryLight = Color(0xFF9D97FF);
  static const Color primaryDark = Color(0xFF3D35CC);

  static const Color secondary = Color(0xFF00D9A3);
  static const Color secondaryLight = Color(0xFF5DFFCE);
  static const Color secondaryDark = Color(0xFF00A87E);

  static const Color accent = Color(0xFFFF6B6B);

  // Neutrals – Dark theme
  static const Color surface = Color(0xFF1A1A2E);
  static const Color surfaceVariant = Color(0xFF242444);
  static const Color surfaceHighest = Color(0xFF2E2E52);
  static const Color onSurface = Color(0xFFF0F0FF);
  static const Color onSurfaceMuted = Color(0xFFAAABBE);

  // Neutrals – Light theme
  static const Color surfaceLight = Color(0xFFF8F8FF);
  static const Color surfaceVariantLight = Color(0xFFEEEEFF);
  static const Color onSurfaceLight = Color(0xFF1A1A2E);
  static const Color onSurfaceMutedLight = Color(0xFF6B6B8A);

  // Semantic
  static const Color success = Color(0xFF00D9A3);
  static const Color warning = Color(0xFFFFB84D);
  static const Color error = Color(0xFFFF6B6B);
  static const Color info = Color(0xFF4DAFFF);

  // Goal category colours
  static const Color health = Color(0xFF00D9A3);
  static const Color career = Color(0xFF6C63FF);
  static const Color relationships = Color(0xFFFF6B9D);
  static const Color finance = Color(0xFFFFB84D);
  static const Color personal = Color(0xFF4DAFFF);

  // Chart
  static const List<Color> chartPalette = [
    primary,
    secondary,
    accent,
    warning,
    info,
  ];
}
