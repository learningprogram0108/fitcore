/// 1RM 估算計算器
/// 用於訓練日誌的即時強度反饋
class OneRmCalculator {
  OneRmCalculator._();

  /// Epley 公式（最廣泛使用）
  /// 1RM = weight × (1 + reps / 30)
  static double epley(double weightKg, int reps) {
    if (reps == 1) return weightKg;
    return weightKg * (1 + reps / 30);
  }

  /// Brzycki 公式（低次數更準確）
  /// 1RM = weight × (36 / (37 - reps))
  static double brzycki(double weightKg, int reps) {
    if (reps == 1) return weightKg;
    if (reps >= 37) return weightKg; // 避免除以零
    return weightKg * (36.0 / (37 - reps));
  }

  /// 建議使用：低次（≤5）用 Brzycki，高次（>5）用 Epley
  static double estimate(double weightKg, int reps) {
    if (reps <= 5) return brzycki(weightKg, reps);
    return epley(weightKg, reps);
  }

  /// 根據 1RM 計算特定百分比對應重量
  static double percentOf1rm(double oneRm, double percent) =>
      oneRm * percent / 100;

  /// 根據 RPE 和次數估算訓練強度（%1RM）
  /// 基於 Sheiko / RTS RPE 表
  static double rpeToPercent1rm(double rpe, int reps) {
    // 簡化 RPE 表（RPE 10 = 100% 1RM）
    // 每降一個 RPE ≈ 降 2.5%，每多一次 ≈ 降 2.5%
    const rpe10Percents = {
      1: 100.0, 2: 97.8, 3: 95.5, 4: 93.9,
      5: 92.2,  6: 90.7, 7: 89.2, 8: 87.8,
      9: 86.3,  10: 85.0,
    };
    final basePercent = rpe10Percents[reps.clamp(1, 10)] ?? 85.0;
    final rpeDiff = 10 - rpe; // e.g. RPE 8 → diff = 2
    return (basePercent - rpeDiff * 2.5).clamp(50.0, 100.0);
  }
}
