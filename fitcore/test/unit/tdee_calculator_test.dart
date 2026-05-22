import 'package:flutter_test/flutter_test.dart';
import 'package:fitcore/features/nutrition/domain/tdee_calculator.dart';

void main() {
  group('TdeeCalculator', () {
    test('BMR 計算（Mifflin-St Jeor 男性）', () {
      // 80kg, 178cm, 28歲, 男
      final bmr = TdeeCalculator.bmr(
        weightKg: 80, heightCm: 178, ageYears: 28, isMale: true,
      );
      // 10*80 + 6.25*178 - 5*28 + 5 = 800+1112.5-140+5 = 1777.5
      expect(bmr, closeTo(1777.5, 1.0));
    });

    test('TDEE 中度活動量 = BMR × 1.55', () {
      const bmr = 1777.5;
      final tdee = TdeeCalculator.tdee(bmr: bmr, activityLevel: 'moderate');
      expect(tdee, closeTo(bmr * 1.55, 1.0));
    });

    test('蛋白質建議範圍（80kg 維持）', () {
      final p = TdeeCalculator.proteinTarget(weightKg: 80, goal: 'maintain');
      expect(p.min,         closeTo(80 * 1.6, 1.0));
      expect(p.max,         closeTo(80 * 2.2, 1.0));
      expect(p.recommended, closeTo(80 * 1.8, 1.0));
    });

    test('減脂蛋白質建議更高', () {
      final maintain = TdeeCalculator.proteinTarget(weightKg: 80, goal: 'maintain');
      final cut      = TdeeCalculator.proteinTarget(weightKg: 80, goal: 'maintain', isCutting: true);
      expect(cut.recommended, greaterThan(maintain.recommended));
    });

    test('熱量目標 bulk = TDEE + 250', () {
      expect(TdeeCalculator.calorieTarget(tdee: 2500, goal: 'bulk'), 2750.0);
    });

    test('EA > 45 = optimal', () {
      // EA = (4000 - 300) / 80 = 46.25 kcal/kg → optimal
      final ea = TdeeCalculator.energyAvailability(
        kcalIntake: 4000, exerciseKcal: 300, weightKg: 80,
      );
      expect(TdeeCalculator.eaStatus(ea), 'optimal');
    });
  });
}
