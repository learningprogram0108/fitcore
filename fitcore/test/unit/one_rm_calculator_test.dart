import 'package:flutter_test/flutter_test.dart';
import 'package:fitcore/features/training_log/domain/one_rm_calculator.dart';

void main() {
  group('OneRmCalculator', () {
    test('1 次 = 實際重量（無公式調整）', () {
      expect(OneRmCalculator.estimate(100, 1), 100.0);
    });

    test('Epley 公式：100kg × 10 次 ≈ 133kg', () {
      final result = OneRmCalculator.epley(100, 10);
      expect(result, closeTo(133.3, 0.5));
    });

    test('Brzycki 低次數更保守', () {
      final epley   = OneRmCalculator.epley(100, 3);
      final brzycki = OneRmCalculator.brzycki(100, 3);
      // 低次數 Brzycki 通常比 Epley 低
      expect(brzycki, lessThan(epley + 5));
    });

    test('estimate 在 ≤5 次使用 Brzycki', () {
      expect(OneRmCalculator.estimate(100, 5), OneRmCalculator.brzycki(100, 5));
    });

    test('estimate 在 >5 次使用 Epley', () {
      expect(OneRmCalculator.estimate(100, 6), OneRmCalculator.epley(100, 6));
    });

    test('RPE 到 %1RM 轉換（RPE 10, 1次 = 100%）', () {
      expect(OneRmCalculator.rpeToPercent1rm(10, 1), 100.0);
    });

    test('RPE 8, 5次 應為合理強度範圍', () {
      final pct = OneRmCalculator.rpeToPercent1rm(8, 5);
      expect(pct, inInclusiveRange(80.0, 95.0));
    });
  });
}
