import 'package:flutter/material.dart';

/// FitCore 設計系統 — 深色主題
/// 主色：石灰黃 #C8FF47（高對比，健身感）
/// 危險色：#FF4444（高 RPE、警告）
/// 次要色：#FF9500（輔助肌群、中等強度）
class AppTheme {
  AppTheme._();

  // ── 色彩代號 ────────────────────────────────────
  static const Color background   = Color(0xFF0B0B0B);
  static const Color surface1     = Color(0xFF141414);
  static const Color surface2     = Color(0xFF1C1C1C);
  static const Color surface3     = Color(0xFF242424);
  static const Color border       = Color(0xFF2B2B2B);
  static const Color border2      = Color(0xFF333333);

  static const Color accent       = Color(0xFFC8FF47); // 主色 lime
  static const Color accentDim    = Color(0x26C8FF47);
  static const Color accentWarm   = Color(0xFFFF6B35); // AI教練
  static const Color accentBlue   = Color(0xFF3DA9FF); // 協同穩定肌

  static const Color textPrimary  = Color(0xFFEFEFEF);
  static const Color textSecond   = Color(0xFF888888);
  static const Color textDisabled = Color(0xFF444444);

  // 肌群顏色
  static const Color muscPrimary  = Color(0xFFFF4444); // 主動肌
  static const Color muscSecond   = Color(0xFFFF9500); // 輔助肌
  static const Color muscTertiary = Color(0xFF3DA9FF); // 協同肌

  // RPE 顏色（7以下綠，8橙，9+紅）
  static Color rpeColor(double rpe) {
    if (rpe <= 7) return const Color(0xFF4CAF50);
    if (rpe <= 8) return const Color(0xFFFF9500);
    return const Color(0xFFFF4444);
  }

  static ThemeData dark() => ThemeData(
    brightness: Brightness.dark,
    useMaterial3: true,
    scaffoldBackgroundColor: background,
    colorScheme: const ColorScheme.dark(
      primary: accent,
      onPrimary: Colors.black,
      secondary: accentWarm,
      surface: surface1,
      onSurface: textPrimary,
      error: muscPrimary,
    ),
    // ── AppBar ──
    appBarTheme: const AppBarTheme(
      backgroundColor: surface1,
      foregroundColor: textPrimary,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
    ),
    // ── BottomNavigationBar ──
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: surface1,
      indicatorColor: accent,
      labelTextStyle: WidgetStateProperty.all(
        const TextStyle(fontSize: 10, fontWeight: FontWeight.w600),
      ),
    ),
    // ── Card ──
    cardTheme: CardThemeData(
      color: surface2,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: border),
      ),
    ),
    // ── Input ──
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: surface2,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: const BorderSide(color: accent, width: 1.5),
      ),
      labelStyle: const TextStyle(color: textSecond),
      hintStyle: const TextStyle(color: textDisabled),
    ),
    // ── ElevatedButton ──
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: accent,
        foregroundColor: Colors.black,
        textStyle: const TextStyle(fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      ),
    ),
    // ── Chip ──
    chipTheme: ChipThemeData(
      backgroundColor: surface2,
      selectedColor: accentDim,
      labelStyle: const TextStyle(fontSize: 11),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      side: const BorderSide(color: border),
    ),
    // ── Text ──
    textTheme: const TextTheme(
      displayLarge : TextStyle(fontSize: 32, fontWeight: FontWeight.w900, color: textPrimary),
      headlineMedium: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: textPrimary),
      titleLarge  : TextStyle(fontSize: 16, fontWeight: FontWeight.w700, color: textPrimary),
      titleMedium : TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: textPrimary),
      bodyLarge   : TextStyle(fontSize: 13, color: textPrimary),
      bodyMedium  : TextStyle(fontSize: 12, color: textPrimary),
      bodySmall   : TextStyle(fontSize: 11, color: textSecond),
      labelSmall  : TextStyle(fontSize: 9,  color: textDisabled, letterSpacing: 1.5),
    ),
    dividerColor: border,
  );
}
