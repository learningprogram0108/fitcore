/// TDEE 計算引擎
/// 基於知識庫「運動營養與能量代謝系統」
class TdeeCalculator {
  TdeeCalculator._();

  // ── BMR（Mifflin-St Jeor 方程式）─────────────────────
  static double bmr({
    required double weightKg,
    required int heightCm,
    required int ageYears,
    required bool isMale,
  }) {
    if (isMale) {
      return 10 * weightKg + 6.25 * heightCm - 5 * ageYears + 5;
    } else {
      return 10 * weightKg + 6.25 * heightCm - 5 * ageYears - 161;
    }
  }

  // ── TDEE（BMR × 活動係數）────────────────────────────
  /// activityLevel:
  ///   'sedentary'   → 1.2  （久坐，無運動）
  ///   'light'       → 1.375（每週 1-3 次輕度）
  ///   'moderate'    → 1.55 （每週 3-5 次中度，符合 4 天力量訓練）
  ///   'active'      → 1.725（每週 6-7 次高強度）
  ///   'very_active' → 1.9  （每天 2 次或體力勞動）
  static double tdee({
    required double bmr,
    required String activityLevel,
  }) {
    const multipliers = {
      'sedentary': 1.2,
      'light': 1.375,
      'moderate': 1.55,
      'active': 1.725,
      'very_active': 1.9,
    };
    return bmr * (multipliers[activityLevel] ?? 1.55);
  }

  // ── 蛋白質建議（知識庫：1.6-2.2 g/kg）──────────────
  /// goal: 'bulk' | 'cut' | 'maintain'
  static ({double min, double max, double recommended}) proteinTarget({
    required double weightKg,
    required String goal,
    bool isCutting = false,
  }) {
    // 減脂期蛋白質需求更高（防止肌肉流失）
    final minFactor  = isCutting ? 2.0 : 1.6;
    final maxFactor  = isCutting ? 2.6 : 2.2;
    final recFactor  = isCutting ? 2.2 : 1.8;
    return (
      min: weightKg * minFactor,
      max: weightKg * maxFactor,
      recommended: weightKg * recFactor,
    );
  }

  // ── 熱量目標（基於目標）──────────────────────────────
  static double calorieTarget({
    required double tdee,
    required String goal,
  }) => switch (goal) {
    'bulk'     => tdee + 250,   // 適度熱量盈餘（最小化脂肪增加）
    'cut'      => tdee - 400,   // 適度熱量赤字（保留肌肉）
    'maintain' => tdee,
    _          => tdee,
  };

  // ── 碳水化合物建議（知識庫：3-7 g/kg）───────────────
  static ({double min, double max}) carbTarget({
    required double weightKg,
    required String trainingIntensity,
  }) => switch (trainingIntensity) {
    'low'    => (min: weightKg * 3, max: weightKg * 4),
    'medium' => (min: weightKg * 4, max: weightKg * 5),
    'high'   => (min: weightKg * 5, max: weightKg * 7),
    _        => (min: weightKg * 4, max: weightKg * 5),
  };

  // ── 能量可利用性（EA，知識庫關鍵指標）────────────────
  /// EA = (攝入熱量 - 運動消耗) / 體重(kg)
  /// > 45 kcal/kg → 健康範圍
  /// 30-45        → 輕度不足
  /// < 30         → 低 EA 風險（RED-S）
  static double energyAvailability({
    required double kcalIntake,
    required double exerciseKcal,
    required double weightKg,
  }) => (kcalIntake - exerciseKcal) / weightKg;

  static String eaStatus(double ea) {
    if (ea >= 45) return 'optimal';
    if (ea >= 30) return 'reduced';
    return 'low_risk'; // RED-S 警告
  }
}
