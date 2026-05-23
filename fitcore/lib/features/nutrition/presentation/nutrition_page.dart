import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../domain/tdee_calculator.dart';

class NutritionPage extends StatefulWidget {
  const NutritionPage({super.key});
  @override State<NutritionPage> createState() => _NutritionPageState();
}

class _NutritionPageState extends State<NutritionPage> {
  // ── 個人資料（可調整）──────────────────────────────────
  bool   _isMale        = true;
  double _weight        = 80.0;
  int    _height        = 178;
  int    _age           = 28;
  String _activityLevel = 'moderate';
  String _goal          = 'maintain';

  // ── TDEE 計算結果 ───────────────────────────────────────
  late double _bmr;
  late double _tdee;

  // ── EA 能量可用性欄位 ───────────────────────────────────
  double _bodyFatPercent   = 15.0;
  double _caloriesIn       = 2500.0;
  double _exerciseCalories = 400.0;

  double get _leanMass => _weight * (1 - _bodyFatPercent / 100);
  double get _ea       => (_caloriesIn - _exerciseCalories) / _leanMass;

  // ── 活動量選項 ─────────────────────────────────────────
  static const _activityOptions = [
    ('sedentary',   '久坐',   '少動或不運動'),
    ('light',       '輕度',   '每週 1–3 天'),
    ('moderate',    '中度',   '每週 3–5 天'),
    ('active',      '高度',   '每週 6–7 天'),
    ('very_active', '極高',   '體力勞動/雙練'),
  ];

  @override
  void initState() {
    super.initState();
    _recalculate();
  }

  void _recalculate() {
    _bmr  = TdeeCalculator.bmr(
      weightKg: _weight, heightCm: _height, ageYears: _age, isMale: _isMale,
    );
    _tdee = TdeeCalculator.tdee(bmr: _bmr, activityLevel: _activityLevel);
  }

  @override
  Widget build(BuildContext context) {
    final protein   = TdeeCalculator.proteinTarget(weightKg: _weight, goal: _goal);
    final calTarget = TdeeCalculator.calorieTarget(tdee: _tdee, goal: _goal);

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text('運動營養追蹤', style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 4),
        const Text('基於 Eric Helms 營養金字塔 · 個人化計算',
          style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
        const SizedBox(height: 16),

        // ── 個人資料 Card ──────────────────────────────────
        _buildProfileCard(),
        const SizedBox(height: 12),

        // ── TDEE 卡片 ──────────────────────────────────────
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

        // ── 蛋白質建議 ─────────────────────────────────────
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

        // ── EA 能量可用性 Card ─────────────────────────────
        _buildEaCard(),
        const SizedBox(height: 12),

        // ── 今日記錄（佔位）───────────────────────────────
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

  // ── 個人資料 Card ────────────────────────────────────────
  Widget _buildProfileCard() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('個人資料', style: TextStyle(
              fontSize: 9, fontWeight: FontWeight.w700,
              letterSpacing: 1.5, color: AppTheme.textSecond)),
            const SizedBox(height: 14),

            // 性別
            Row(children: [
              const SizedBox(width: 72,
                child: Text('性別', style: TextStyle(fontSize: 11, color: AppTheme.textSecond))),
              const Spacer(),
              ToggleButtons(
                isSelected: [_isMale, !_isMale],
                onPressed: (i) => setState(() { _isMale = i == 0; _recalculate(); }),
                borderRadius: BorderRadius.circular(8),
                selectedColor: Colors.black,
                fillColor: AppTheme.accent,
                color: AppTheme.textSecond,
                constraints: const BoxConstraints(minWidth: 52, minHeight: 32),
                children: const [
                  Text('男', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  Text('女', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                ],
              ),
            ]),
            const SizedBox(height: 10),

            // 體重
            _ProfileStepInput(
              label: '體重', unit: 'kg',
              value: _weight.toInt(), step: 1, min: 40, max: 200,
              onChanged: (v) => setState(() { _weight = v.toDouble(); _recalculate(); }),
            ),
            const SizedBox(height: 8),

            // 身高
            _ProfileStepInput(
              label: '身高', unit: 'cm',
              value: _height, step: 1, min: 140, max: 220,
              onChanged: (v) => setState(() { _height = v; _recalculate(); }),
            ),
            const SizedBox(height: 8),

            // 年齡
            _ProfileStepInput(
              label: '年齡', unit: '歲',
              value: _age, step: 1, min: 15, max: 80,
              onChanged: (v) => setState(() { _age = v; _recalculate(); }),
            ),
            const SizedBox(height: 12),

            // 活動量
            const Text('活動量',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _activityOptions.map((opt) {
                  final selected = _activityLevel == opt.$1;
                  return Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: ChoiceChip(
                      label: Text(opt.$2,
                        style: TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600,
                          color: selected ? Colors.black : AppTheme.textSecond,
                        )),
                      tooltip: opt.$3,
                      selected: selected,
                      selectedColor: AppTheme.accent,
                      backgroundColor: AppTheme.surface2,
                      side: BorderSide(color: selected ? AppTheme.accent : AppTheme.border),
                      onSelected: (_) => setState(() { _activityLevel = opt.$1; _recalculate(); }),
                    ),
                  );
                }).toList(),
              ),
            ),
            const SizedBox(height: 12),

            // 目標
            Row(children: [
              const SizedBox(width: 72,
                child: Text('目標', style: TextStyle(fontSize: 11, color: AppTheme.textSecond))),
              const Spacer(),
              ToggleButtons(
                isSelected: [_goal == 'bulk', _goal == 'maintain', _goal == 'cut'],
                onPressed: (i) => setState(() => _goal = ['bulk', 'maintain', 'cut'][i]),
                borderRadius: BorderRadius.circular(8),
                selectedColor: Colors.black,
                fillColor: AppTheme.accent,
                color: AppTheme.textSecond,
                constraints: const BoxConstraints(minWidth: 52, minHeight: 32),
                children: const [
                  Text('增肌', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  Text('維持', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  Text('減脂', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                ],
              ),
            ]),
          ],
        ),
      ),
    );
  }

  // ── EA 能量可用性 Card ───────────────────────────────────
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
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('ENERGY AVAILABILITY（EA）',
              style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
                  letterSpacing: 1.5, color: AppTheme.textSecond)),
          const SizedBox(height: 4),
          const Text('EA = (攝入熱量 − 運動消耗) ÷ 瘦體重',
              style: TextStyle(fontSize: 10, color: AppTheme.textSecond)),
          const SizedBox(height: 16),

          _EaStepInput(label: '攝入熱量', unit: 'kcal',
            value: _caloriesIn.toInt(), step: 50,
            onChanged: (v) => setState(() => _caloriesIn = v.toDouble())),
          const SizedBox(height: 8),
          _EaStepInput(label: '運動消耗', unit: 'kcal',
            value: _exerciseCalories.toInt(), step: 50,
            onChanged: (v) => setState(() => _exerciseCalories = v.toDouble())),
          const SizedBox(height: 8),
          _EaStepInput(label: '體脂率', unit: '%',
            value: _bodyFatPercent.toInt(), step: 1,
            onChanged: (v) => setState(() => _bodyFatPercent = v.toDouble())),

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          Row(children: [
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('EA = ${ea.toStringAsFixed(1)} kcal/kg FFM',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: eaColor)),
              const SizedBox(height: 2),
              Text(eaDetail,
                  style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
            ]),
            const Spacer(),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: eaColor.withAlpha(30),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: eaColor.withAlpha(100)),
              ),
              child: Text(eaLabel,
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: eaColor)),
            ),
          ]),

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
                style: TextStyle(fontSize: 11, color: Color(0xFFFF8888), height: 1.5),
              ),
            ),
          ],

          const SizedBox(height: 12),
          const _EaZoneRow('🟢 > 45 kcal/kg FFM', '安全（最佳肌肉合成）', Color(0xFF7EC82A)),
          const SizedBox(height: 4),
          const _EaZoneRow('🟡 30–45 kcal/kg FFM', '注意（荷爾蒙輕微受抑）', Color(0xFFFF9500)),
          const SizedBox(height: 4),
          const _EaZoneRow('🔴 < 30 kcal/kg FFM', 'RED-S 警戒', Color(0xFFFF4444)),
        ]),
      ),
    );
  }
}

// ── 個人資料步進輸入 ─────────────────────────────────────
class _ProfileStepInput extends StatelessWidget {
  const _ProfileStepInput({
    required this.label, required this.unit,
    required this.value, required this.step,
    required this.onChanged,
    this.min = 0, this.max = 9999,
  });
  final String label, unit;
  final int value, step, min, max;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 72,
        child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecond))),
      const Spacer(),
      _StepButton(icon: Icons.remove,
        onTap: () { if (value - step >= min) onChanged(value - step); }),
      const SizedBox(width: 8),
      SizedBox(width: 72,
        child: Text('$value $unit',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white))),
      const SizedBox(width: 8),
      _StepButton(icon: Icons.add,
        onTap: () { if (value + step <= max) onChanged(value + step); }),
    ]);
  }
}

// ── EA 步進輸入 ──────────────────────────────────────────
class _EaStepInput extends StatelessWidget {
  const _EaStepInput({
    required this.label, required this.unit,
    required this.value, required this.step,
    required this.onChanged,
  });
  final String label, unit;
  final int value, step;
  final void Function(int) onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(children: [
      SizedBox(width: 72,
        child: Text(label, style: const TextStyle(fontSize: 11, color: AppTheme.textSecond))),
      const Spacer(),
      _StepButton(icon: Icons.remove, onTap: () => onChanged(value - step)),
      const SizedBox(width: 8),
      SizedBox(width: 60,
        child: Text('$value $unit',
          textAlign: TextAlign.center,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: Colors.white))),
      const SizedBox(width: 8),
      _StepButton(icon: Icons.add, onTap: () => onChanged(value + step)),
    ]);
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
          width: 28, height: 28,
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
  Widget build(BuildContext context) => Row(children: [
    Text(range, style: TextStyle(fontSize: 10, color: color, fontWeight: FontWeight.w600)),
    const SizedBox(width: 8),
    Text(label, style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
  ]);
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
        color: AppTheme.surface2, borderRadius: BorderRadius.circular(8)),
      child: Column(children: [
        Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w800, color: color)),
        const SizedBox(height: 2),
        Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textSecond)),
      ]),
    ),
  );
}
