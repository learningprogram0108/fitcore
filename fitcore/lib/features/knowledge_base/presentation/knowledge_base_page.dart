import 'package:flutter/material.dart';
import 'package:flutter_body_atlas/flutter_body_atlas.dart';
import '../../../app/theme/app_theme.dart';
import 'widgets/anatomy_view.dart';

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({super.key, this.initialExercise});
  final String? initialExercise;

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  String _selectedExercise = 'squat';
  AnatomicalPlane _plane = AnatomicalPlane.sagittal;

  // ── 動作 → 肌群映射（使用 flutter_body_atlas Muscle enum）────
  // Muscle enum 包含左右側個別肌肉，前後視圖皆可高亮
  static final _muscleMap = {
    'squat': const _ExerciseMuscles(
      // 矢狀面：膝伸展（股四頭肌）+ 髖伸展（臀大肌）
      primary: [
        Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
        Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
        Muscle.vastusMedialisLeft,  Muscle.vastusMedialisRight,
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      ],
      // 額狀面：骨盆穩定（臀中肌）+ 核心
      secondary: [
        Muscle.gluteusMedius1Left,  Muscle.gluteusMedius1Right,
        Muscle.gluteusMedius2Left,  Muscle.gluteusMedius2Right,
        Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
        Muscle.gastrocnemiusLeft,   Muscle.gastrocnemiusRight,
      ],
      // 協同穩定
      tertiary: [
        Muscle.tibialisAnteriorLeft,  Muscle.tibialisAnteriorRight,
        Muscle.adductorMagnusLeft,    Muscle.adductorMagnusRight,
      ],
      primaryLabel   : '股四頭肌 · 臀大肌',
      secondaryLabel : '臀中肌 · 腓腸肌 · 腹外斜肌',
      tertiaryLabel  : '脛骨前肌 · 大收肌',
      planes: {
        AnatomicalPlane.sagittal:   '髖伸展 · 膝伸展 · 踝背屈',
        AnatomicalPlane.frontal:    '髖外展穩定 · 膝外翻控制',
        AnatomicalPlane.transverse: '髖外旋 · 軀幹抗旋轉',
      },
    ),

    'deadlift': const _ExerciseMuscles(
      // 後鏈：臀大肌 + 腿後腱 + 背闊肌
      primary: [
        Muscle.gluteusMaximusLeft,      Muscle.gluteusMaximusRight,
        Muscle.bicepsFemorisLeft,       Muscle.bicepsFemorisRight,
        Muscle.semitendinosusLeft,      Muscle.semitendinosusRight,
        Muscle.semimembranosus1Left,    Muscle.semimembranosus1Right,
        Muscle.latissimusDorsiLeft,     Muscle.latissimusDorsiRight,
      ],
      secondary: [
        Muscle.rectusFemorisLeft,       Muscle.rectusFemorisRight,
        Muscle.trapeziusUpperLeft,      Muscle.trapeziusUpperRight,
        Muscle.trapeziusMiddleLeft,     Muscle.trapeziusMiddleRight,
      ],
      tertiary: [
        Muscle.rectusAbdominis1,
        Muscle.externalObliqueLeft,     Muscle.externalObliqueRight,
      ],
      primaryLabel   : '臀大肌 · 腿後腱群 · 背闊肌',
      secondaryLabel : '股四頭肌 · 斜方肌',
      tertiaryLabel  : '腹直肌 · 腹外斜肌',
      planes: {
        AnatomicalPlane.sagittal:   '髖伸展 · 脊柱伸展（等長）',
        AnatomicalPlane.frontal:    '骨盆穩定 · 肩胛內縮',
        AnatomicalPlane.transverse: '抗旋轉 · 肩胛面穩定',
      },
    ),

    'bench': const _ExerciseMuscles(
      // 胸肌 + 三頭肌
      primary: [
        Muscle.pectoralisMajorLeft,              Muscle.pectoralisMajorRight,
        Muscle.tricepsBrachiiCaputLateraleLeft,   Muscle.tricepsBrachiiCaputLateraleRight,
        Muscle.tricepsBrachiiCaputLongumLeft,     Muscle.tricepsBrachiiCaputLongumRight,
        Muscle.tricepsBrachiiCaputMedialeLeft,    Muscle.tricepsBrachiiCaputMedialeRight,
      ],
      secondary: [
        Muscle.anteriorDeltoidLeft,  Muscle.anteriorDeltoidRight,
      ],
      tertiary: [
        Muscle.rectusAbdominis1,
        Muscle.trapeziusLowerLeft,   Muscle.trapeziusLowerRight,
      ],
      primaryLabel   : '胸大肌 · 三頭肌（三頭）',
      secondaryLabel : '前三角肌',
      tertiaryLabel  : '腹直肌 · 下斜方肌',
      planes: {
        AnatomicalPlane.sagittal:   '肘伸展 · 肩水平屈曲',
        AnatomicalPlane.frontal:    '肩內收',
        AnatomicalPlane.transverse: '水平內收 · 肩胛穩定',
      },
    ),
  };

  _ExerciseMuscles get _currentMuscles =>
      _muscleMap[_selectedExercise] ?? _muscleMap['squat']!;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 720;
    return Row(
      children: [
        // 左：動作列表
        if (isDesktop) ...[
          SizedBox(
            width: 248,
            child: _ExerciseList(
              selected: _selectedExercise,
              onSelect: (id) => setState(() => _selectedExercise = id),
            ),
          ),
          const VerticalDivider(width: 1),
        ],
        // 中：解剖圖 + 平面選擇
        Expanded(
          child: Column(
            children: [
              _ExerciseHeader(exercise: _selectedExercise),
              // 解剖平面選擇器
              _PlaneSelector(
                current: _plane,
                onChanged: (p) => setState(() => _plane = p),
              ),
              // 解剖圖（flutter_body_atlas BodyAtlasView<MuscleInfo>）
              Expanded(
                child: AnatomyView(
                  primaryMuscles: _currentMuscles.primary,
                  secondaryMuscles: _currentMuscles.secondary,
                  tertiaryMuscles: _currentMuscles.tertiary,
                  selectedPlane: _plane,
                  onMuscleTapped: (muscleInfo) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(muscleInfo.displayName),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // 右：動作細節
        if (isDesktop) ...[
          const VerticalDivider(width: 1),
          SizedBox(
            width: 288,
            child: _DetailPanel(muscles: _currentMuscles, plane: _plane),
          ),
        ],
      ],
    );
  }
}

class _ExerciseList extends StatelessWidget {
  const _ExerciseList({required this.selected, required this.onSelect});
  final String selected;
  final void Function(String) onSelect;

  static const _exercises = [
    ('squat',    '🏋️', '背蹲舉（高槓）',  '下肢推 · 三大項'),
    ('deadlift', '🔩',  '硬舉',           '全身後鏈 · 三大項'),
    ('bench',    '💪',  '臥推',           '上肢推 · 三大項'),
  ];

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text('動作知識庫', style: Theme.of(context).textTheme.titleLarge),
              const Text(
                '解剖學 · 生物力學 · 動作分析',
                style: TextStyle(fontSize: 10, color: AppTheme.textSecond),
              ),
            ]),
          ),
          ...(_exercises.map((e) => ListTile(
                leading: Text(e.$2, style: const TextStyle(fontSize: 20)),
                title: Text(e.$3,
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                subtitle: Text(e.$4,
                    style: const TextStyle(fontSize: 9, color: AppTheme.textSecond)),
                selected: selected == e.$1,
                selectedTileColor: const Color(0xFF1B2410),
                selectedColor: AppTheme.accent,
                onTap: () => onSelect(e.$1),
                dense: true,
                visualDensity: VisualDensity.compact,
              ))),
        ],
      );
}

class _ExerciseHeader extends StatelessWidget {
  const _ExerciseHeader({required this.exercise});
  final String exercise;

  static const _titles = {
    'squat':    ('背蹲舉（高槓）', 'Barbell Back Squat · High-Bar'),
    'deadlift': ('硬舉',           'Conventional Deadlift · Hip Hinge'),
    'bench':    ('臥推',           'Barbell Bench Press · Horizontal Push'),
  };

  @override
  Widget build(BuildContext context) {
    final info = _titles[exercise] ?? ('動作', '');
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 14, 20, 10),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(info.$1, style: Theme.of(context).textTheme.headlineMedium),
              Text(info.$2,
                  style: const TextStyle(fontSize: 11, color: AppTheme.textSecond)),
            ]),
          ),
        ],
      ),
    );
  }
}

class _PlaneSelector extends StatelessWidget {
  const _PlaneSelector({required this.current, required this.onChanged});
  final AnatomicalPlane current;
  final void Function(AnatomicalPlane) onChanged;

  @override
  Widget build(BuildContext context) => Container(
        height: 44,
        decoration: const BoxDecoration(
          color: AppTheme.surface1,
          border: Border(bottom: BorderSide(color: AppTheme.border)),
        ),
        child: Row(
          children: AnatomicalPlane.values
              .map((p) => Expanded(
                    child: InkWell(
                      onTap: () => onChanged(p),
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: p == current ? AppTheme.accent : Colors.transparent,
                              width: 2,
                            ),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              p.label,
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: p == current ? AppTheme.accent : AppTheme.textSecond,
                              ),
                            ),
                            Text(p.subtitle,
                                style: const TextStyle(
                                    fontSize: 8, color: AppTheme.textDisabled)),
                          ],
                        ),
                      ),
                    ),
                  ))
              .toList(),
        ),
      );
}

class _DetailPanel extends StatelessWidget {
  const _DetailPanel({required this.muscles, required this.plane});
  final _ExerciseMuscles muscles;
  final AnatomicalPlane plane;

  @override
  Widget build(BuildContext context) => ListView(
        padding: const EdgeInsets.all(14),
        children: [
          // 平面動作分類
          const Text('動作平面分類',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppTheme.textSecond)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: AppTheme.surface2,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppTheme.border),
            ),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Chip(
                label: Text(plane.label,
                    style:
                        const TextStyle(fontSize: 10, fontWeight: FontWeight.w700)),
                backgroundColor: AppTheme.accentDim,
                side: BorderSide.none,
              ),
              const SizedBox(height: 6),
              Text(
                muscles.planes[plane] ?? plane.action,
                style: const TextStyle(fontSize: 11, height: 1.6),
              ),
            ]),
          ),
          const SizedBox(height: 16),
          // 肌群啟動分佈
          const Text('肌群啟動分佈',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppTheme.textSecond)),
          const SizedBox(height: 8),
          _MuscleRow(AppTheme.muscPrimary, '主動肌群', muscles.primaryLabel, 0.88),
          const SizedBox(height: 6),
          _MuscleRow(AppTheme.muscSecond, '輔助肌群', muscles.secondaryLabel, 0.55),
          const SizedBox(height: 6),
          _MuscleRow(AppTheme.muscTertiary, '協同穩定', muscles.tertiaryLabel, 0.22),
        ],
      );
}

class _MuscleRow extends StatelessWidget {
  const _MuscleRow(this.color, this.title, this.muscles, this.ratio);
  final Color color;
  final String title, muscles;
  final double ratio;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(children: [
          Container(
            width: 10,
            height: 32,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(3)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(title,
                  style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
              Text(muscles,
                  style: const TextStyle(fontSize: 9, color: AppTheme.textSecond)),
              const SizedBox(height: 3),
              LinearProgressIndicator(
                value: ratio,
                color: color,
                backgroundColor: AppTheme.border2,
                borderRadius: BorderRadius.circular(2),
              ),
            ]),
          ),
          const SizedBox(width: 8),
          Text('${(ratio * 100).toInt()}%',
              style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
        ]),
      );
}

// ── 動作肌群資料結構 ──────────────────────────────────────
// 使用 flutter_body_atlas 的 Muscle enum（含左右側）進行 SVG 高亮
// primaryLabel / secondaryLabel / tertiaryLabel 用於詳情面板文字顯示
class _ExerciseMuscles {
  const _ExerciseMuscles({
    required this.primary,
    required this.secondary,
    required this.tertiary,
    required this.primaryLabel,
    required this.secondaryLabel,
    required this.tertiaryLabel,
    required this.planes,
  });

  final List<Muscle> primary;
  final List<Muscle> secondary;
  final List<Muscle> tertiary;
  final String primaryLabel;
  final String secondaryLabel;
  final String tertiaryLabel;
  final Map<AnatomicalPlane, String> planes;
}
