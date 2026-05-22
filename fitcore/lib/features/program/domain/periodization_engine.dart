/// 週期化計算引擎
/// 基於知識庫「力量訓練理論與週期課表編排」
class PeriodizationEngine {
  PeriodizationEngine._();

  // ── 當前週判斷 ─────────────────────────────────────
  static int currentWeek(DateTime startDate) {
    final days = DateTime.now().difference(startDate).inDays;
    return (days ~/ 7) + 1;
  }

  static bool isDeloadWeek(DateTime startDate, {int totalWeeks = 4}) {
    final week = currentWeek(startDate);
    return week % totalWeeks == 0; // 每 4 週最後一週為降量週
  }

  // ── 週次目標組數/次數（線性週期）────────────────────
  /// 傳入 Week 1 基準值，自動計算各週調整
  /// 策略：次數遞減、RPE 遞增
  static SetScheme weeklyScheme({
    required int baseReps,
    required double baseRpe,
    required int baseSets,
    required int week,
    bool isDeload = false,
  }) {
    if (isDeload) {
      return SetScheme(
        sets: (baseSets * 0.65).round(),
        reps: baseReps - 1,
        rpe: (baseRpe - 2.0).clamp(5.0, 7.0),
      );
    }
    // 每週降 1 次，RPE 升 0.5
    return SetScheme(
      sets: baseSets,
      reps: (baseReps - (week - 1)).clamp(1, baseReps),
      rpe: (baseRpe + (week - 1) * 0.5).clamp(baseRpe, 9.5),
    );
  }

  // ── 重量建議（基於上週表現）────────────────────────
  /// 若上週平均 RPE < 目標 RPE：建議加重 2.5kg
  /// 若上週平均 RPE > 目標 RPE + 0.5：建議減重 2.5kg
  static double? weightAdjustment({
    required double lastWeekWeightKg,
    required double lastWeekActualRpe,
    required double targetRpe,
    double increment = 2.5,
  }) {
    final diff = lastWeekActualRpe - targetRpe;
    if (diff < -0.3)  return lastWeekWeightKg + increment; // 輕鬆，加重
    if (diff > 0.5)   return lastWeekWeightKg - increment; // 太重，減重
    return null; // 維持同重量
  }

  // ── 總訓練量計算 ────────────────────────────────────
  static double weeklyVolume({
    required double weightKg,
    required int sets,
    required int reps,
  }) => weightKg * sets * reps;

  // ── 疲勞管理：本週訓練頻率警告 ─────────────────────
  static FatigueStatus assessFatigue({
    required int sessionsThisWeek,
    required double avgRpe,
    required int consecutiveDays,
  }) {
    if (consecutiveDays >= 3) return FatigueStatus.rest;
    if (avgRpe > 8.5 && sessionsThisWeek >= 4) return FatigueStatus.warning;
    if (sessionsThisWeek >= 5) return FatigueStatus.warning;
    return FatigueStatus.ok;
  }
}

class SetScheme {
  const SetScheme({
    required this.sets,
    required this.reps,
    required this.rpe,
  });
  final int sets;
  final int reps;
  final double rpe;

  @override
  String toString() => '$sets×$reps @RPE ${rpe.toStringAsFixed(1)}';
}

enum FatigueStatus {
  ok,      // 正常
  warning, // 建議注意恢復
  rest,    // 建議休息
}
