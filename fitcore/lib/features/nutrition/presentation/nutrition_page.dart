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

  // EA（能量可用性）計算欄位
  double _bodyFatPercent = 15.0;   // 體脂率 %
  double _caloriesIn     = 2500.0; // 今日攝入熱量
  double _exerciseCalories = 400.0; // 今日運動消耗

  double get _leanMass => _weight * (1 - _bodyFatPercent / 100);
  double get _ea => (_caloriesIn - _exerciseCalories) / _leanMass;

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
        // ── EA 能量可用性 Card ──
        _buildEaCard(),
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
  // ── EA 能量可用性 Card ──────────────────────────────────
  Widget _buildEaCard() {
    final ea = _ea;
    final Color eaColor;
    final String eaLabel;
    final String eaDetail;

    if (ea >= 45) {
      eaColor = const Color(0xFF7EC82A);
      eaLabel = '🟢 安全';
      eaDetail = '最佳肌肉合成環境，荷爾蒙水平正常';
    } else if (ea >= 30) {
      eaColor = const Color(0xFFFF9500);
      eaLabel = '🟡 注意';
      eaDetail = '荷爾蒙可能輕微受抑，留意疲勞與恢復';
    } else {
      eaColor = const Color(0xFFFF4444);
      eaLabel = '🔴 RED-S 警戒';
      eaDetail = '睪固酮↓ · 甲狀腺↓ · 皮質醇↑ · 骨密度↓';
    }

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('ENERGY AVAILABILITY（EA）',
                style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 1.5,
                    color: AppTheme.textSecond)),
            const SizedBox(height: 4),
            const Text('EA = (攝入熱量 − 運動消耗) ÷ 瘦體重',
                style: TextStyle(fontSize: 10, color: AppTheme.textSecond)),
            const SizedBox(height: 16),

            // 輸入欄
            _EaStepInput(
              label: '攝入熱量',
              unit: 'kcal',
              value: _caloriesIn.toInt(),
              step: 50,
              onChanged: (v) => setState(() => _caloriesIn = v.toDouble()),
            ),
            const SizedBox(height: 8),
            _EaStepInput(
              label: '運動消耗',
              unit: 'kcal',
              value: _exerciseCalories.toInt(),
              step: 50,
              onChanged: (v) => setState(() => _exerciseCalories = v.toDouble()),
            ),
            const SizedBox(height: 8),
            _EaStepInput(
              label: '體脂率',
              unit: '%',
              value: _bodyFatPercent.toInt(),
              step: 1,
              onChanged: (v) => setState(() => _bodyFatPercent = v.toDouble()),
            ),

            const SizedBox(height: 16),
            const Divider(height: 1),
            const SizedBox(height: 12),

            // EA 結果
            Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'EA = ${ea.toStringAsFixed(1)} kcal/kg FFM',
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: eaColor),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      eaDetail,
                      style: const TextStyle(
                          fontSize: 10, color: AppTheme.textSecond),
                    ),
                  ],
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: eaColor.withAlpha(30),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: eaColor.withAlpha(100)),
                  ),
                  child: Text(
                    eaLabel,
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: eaColor),
                  ),
                ),
              ],
            ),

            if (ea < 30) ...[
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A0A0A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF5A1A1A)),
                ),
                child: const Text(
                  '⚠️ 能量可用性低於 30 kcal/kg FFM，長期維持此狀態會觸發 RED-S（運動員能量缺乏症候群）。建議增加攝入熱量或降低運動消耗。',
                  style: TextStyle(
                      fontSize: 11,
                      color: Color(0xFFFF8888),
                      height: 1.5),
                ),
              ),
            ],

            const SizedBox(height: 12),
            // 閾值說明
            const _EaZoneRow('🟢 > 45 kcal/kg FFM', '安全（最佳肌肉合成）',
                Color(0xFF7EC82A)),
            const SizedBox(height: 4),
            const _EaZoneRow('🟡 30–45 kcal/kg FFM', '注意（荷爾蒙輕微受抑）',
                Color(0xFFFF9500)),
            const SizedBox(height: 4),
            const _EaZoneRow('🔴 < 30 kcal/kg FFM', 'RED-S 警戒',
                Color(0xFFFF4444)),
          ],
        ),
      ),
    );
  }
}

// ── EA 步進輸入 ──────────────────────────────────────────
class _EaStepInput extends StatelessWidget {
  const _EaStepInput({
    required this.label,
    required this.unit,
    required this.value,
    required this.step,
    required this.onChanged,
  });

  final String label;
  final String unit;
  final int value;
  final int step;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SizedBox(
          width: 72,
          child: Text(label,
              style: const TextStyle(
                  fontSize: 11, color: AppTheme.textSecond)),
        ),
        const Spacer(),
        _StepButton(
          icon: Icons.remove,
          onTap: () => onChanged(value - step),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 60,
          child: Text(
            '$value $unit',
            textAlign: TextAlign.center,
            style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Colors.white),
          ),
        ),
        const SizedBox(width: 8),
        _StepButton(
          icon: Icons.add,
          onTap: () => onChanged(value + step),
        ),
      ],
    );
  }
}

class _StepButton extends StatelessWidget {
  const _StepButton({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFF2A2A2A),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: Colors.white),
        ),
      );
}

class _EaZoneRow extends StatelessWidget {
  const _EaZoneRow(this.range, this.label, this.color);
  final String range, label;
  final Color color;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Text(range,
              style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
          const SizedBox(width: 8),
          Text(label,
              style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
        ],
      );
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
