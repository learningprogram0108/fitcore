import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../domain/tdee_calculator.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});
  @override State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  // 示範資料
  final double _weight = 80.0;
  final int    _height = 178;
  final int    _age    = 28;
  final String _goal   = 'maintain';

  late double _bmr;
  late double _tdee;

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    _bmr  = TdeeCalculator.bmr(
      weightKg: _weight, heightCm: _height, ageYears: _age, isMale: true,
    );
    _tdee = TdeeCalculator.tdee(bmr: _bmr, activityLevel: 'moderate');
  }

  @override
  Widget build(BuildContext context) {
    final protein  = TdeeCalculator.proteinTarget(weightKg: _weight, goal: _goal);
    final calTarget = TdeeCalculator.calorieTarget(tdee: _tdee, goal: _goal);

    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text('運動營養追蹤', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        const Text('基於 Eric Helms 營養金字塔 · 個人化計算',
          style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
        const SizedBox(height: 20),
        // TDEE 卡片
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('TDEE CALCULATOR', style: TextStyle(fontSize: 9,
              fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppTheme.textSecond)),
            const SizedBox(height: 12),
            Row(children: [
              _MacroCard('BMR',  '${_bmr.toStringAsFixed(0)} kcal', AppTheme.textSecond),
              const SizedBox(width: 8),
              _MacroCard('TDEE', '${_tdee.toStringAsFixed(0)} kcal', AppTheme.accent),
              const SizedBox(width: 8),
              _MacroCard('目標', '${calTarget.toStringAsFixed(0)} kcal', AppTheme.accentWarm),
            ]),
          ]),
        )),
        const SizedBox(height: 12),
        // 蛋白質建議
        Card(child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            const Text('蛋白質目標（1.6-2.2 g/kg）', style: TextStyle(fontSize: 9,
              fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppTheme.textSecond)),
            const SizedBox(height: 12),
            Row(children: [
              _MacroCard('最低', '${protein.min.toStringAsFixed(0)} g', AppTheme.textSecond),
              const SizedBox(width: 8),
              _MacroCard('建議', '${protein.recommended.toStringAsFixed(0)} g', AppTheme.accent),
              const SizedBox(width: 8),
              _MacroCard('上限', '${protein.max.toStringAsFixed(0)} g', AppTheme.accentBlue),
            ]),
            const SizedBox(height: 8),
            const Text('Leucine 門檻：每餐 ≥ 3g 以觸發 mTORC1 蛋白質合成',
              style: TextStyle(fontSize: 10, color: AppTheme.textSecond)),
          ]),
        )),
        const SizedBox(height: 12),
        // 今日記錄（佔位）
        const Card(child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('今日飲食記錄', style: TextStyle(fontSize: 9,
              fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppTheme.textSecond)),
            SizedBox(height: 12),
            Text('飲食記錄介面\n(即將實作)', textAlign: TextAlign.center,
              style: TextStyle(color: AppTheme.textSecond, fontSize: 11)),
          ]),
        )),
      ],
    );
  }
}

class _MacroCard extends StatelessWidget {
  const _MacroCard(this.label, this.value, this.color);
  final String label, value;
  final Color color;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textSecond)),
      ]),
    ),
  );
}
