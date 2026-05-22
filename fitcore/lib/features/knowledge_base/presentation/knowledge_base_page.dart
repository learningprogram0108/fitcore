import 'package:flutter/material.dart';
import 'package:flutter_body_atlas/flutter_body_atlas.dart';
import '../../../app/theme/app_theme.dart';
import '../../program/domain/movement_data.dart';
import 'widgets/anatomy_view.dart';

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({super.key, this.initialExercise});
  final String? initialExercise;

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  late String _selectedExercise;
  AnatomicalPlane _plane = AnatomicalPlane.sagittal;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedExercise = widget.initialExercise ?? 'squat';
  }

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── 20 個動作列表 ───────────────────────────────────────────
  static const _exercises = [
    ('squat',             '🏋️', '槓鈴背蹲舉（高背槓）',     '下肢推 · Day 1'),
    ('bulgarian',         '🦵', '保加利亞分腿蹲',           '單側下肢推 · Day 1'),
    ('farmers_walk',      '🚶', '農夫走路',                 '攜重行走 · Day 1'),
    ('calf_raise',        '🦶', '站姿提踵',                 '小腿特化 · Day 1'),
    ('copenhagen',        '🌀', '哥本哈根側平舉',           '內收肌群 · Day 1'),
    ('bench',             '💪', '槓鈴臥推',                 '水平推 · Day 2'),
    ('pullup',            '🔽', '正手寬握引體向上',          '垂直拉 · Day 2'),
    ('ohp',               '🏔️', '槓鈴肩推',                 '垂直推 · Day 2'),
    ('face_pull',         '🎯', '滑輪面拉',                 '後三角 · Day 2'),
    ('triceps_pushdown',  '🔧', '滑輪三頭下壓',             '三頭特化 · Day 2'),
    ('hex_deadlift',      '🔩', '六角槓硬舉',               '全身後鏈 · Day 3'),
    ('zercher',           '💡', '澤奇深蹲',                 '核心前載 · Day 3'),
    ('nordic',            '🎿', '北歐腿彎舉',               '離心腿後 · Day 3'),
    ('rdl',               '⚖️', '單腿羅馬尼亞硬舉',          '單側後鏈 · Day 3'),
    ('leg_curl',          '🪑', '坐姿腿彎舉',               '拉長腿後 · Day 3'),
    ('inverted_row',      '📐', '仰臥划船',                 '水平拉 · Day 4'),
    ('incline_press',     '📈', '啞鈴上斜臥推',             '胸上部 · Day 4'),
    ('lat_pulldown',      '⬇️', '寬握滑輪下拉',             '背部寬度 · Day 4'),
    ('dips',              '⬆️', '雙槓撐體',                 '胸下推 · Day 4'),
    ('trx_plank',         '🏗️', 'TRX 平板撐',              '深層核心 · Day 4'),
  ];

  // ── 肌群映射（20 個動作）────────────────────────────────────
  static final _muscleMap = <String, _ExerciseMuscles>{
    'squat': const _ExerciseMuscles(
      primary: [
        Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
        Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
        Muscle.vastusMedialisLeft,  Muscle.vastusMedialisRight,
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      ],
      secondary: [
        Muscle.gluteusMedius1Left,  Muscle.gluteusMedius1Right,
        Muscle.gluteusMedius2Left,  Muscle.gluteusMedius2Right,
        Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
        Muscle.gastrocnemiusLeft,   Muscle.gastrocnemiusRight,
      ],
      tertiary: [
        Muscle.tibialisAnteriorLeft,  Muscle.tibialisAnteriorRight,
        Muscle.adductorMagnusLeft,    Muscle.adductorMagnusRight,
      ],
      primaryLabel: '股四頭肌 · 臀大肌',
      secondaryLabel: '臀中肌 · 腓腸肌 · 腹外斜肌',
      tertiaryLabel: '脛骨前肌 · 大收肌',
      planes: {
        AnatomicalPlane.sagittal:   '髖伸展 · 膝伸展 · 踝背屈',
        AnatomicalPlane.frontal:    '髖外展穩定 · 膝外翻控制',
        AnatomicalPlane.transverse: '髖外旋 · 軀幹抗旋轉',
      },
    ),
    'bulgarian': const _ExerciseMuscles(
      primary: [
        Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
        Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
        Muscle.vastusMedialisLeft,  Muscle.vastusMedialisRight,
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      ],
      secondary: [
        Muscle.gluteusMedius1Left,  Muscle.gluteusMedius1Right,
        Muscle.gastrocnemiusLeft,   Muscle.gastrocnemiusRight,
      ],
      tertiary: [
        Muscle.adductorMagnusLeft,  Muscle.adductorMagnusRight,
      ],
      primaryLabel: '股四頭肌 · 臀大肌',
      secondaryLabel: '臀中肌 · 腓腸肌',
      tertiaryLabel: '大收肌',
      planes: {
        AnatomicalPlane.sagittal:   '膝伸展 · 髖伸展',
        AnatomicalPlane.frontal:    '骨盆側屈穩定 · 膝外翻控制',
        AnatomicalPlane.transverse: '單側抗旋轉',
      },
    ),
    'farmers_walk': const _ExerciseMuscles(
      primary: [
        Muscle.trapeziusUpperLeft,  Muscle.trapeziusUpperRight,
        Muscle.trapeziusMiddleLeft, Muscle.trapeziusMiddleRight,
        Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
        Muscle.latissimusDorsiLeft, Muscle.latissimusDorsiRight,
      ],
      secondary: [
        Muscle.rectusAbdominis1,
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      ],
      tertiary: [
        Muscle.gastrocnemiusLeft,   Muscle.gastrocnemiusRight,
        Muscle.tibialisAnteriorLeft, Muscle.tibialisAnteriorRight,
      ],
      primaryLabel: '斜方肌 · 闊背肌 · 腹斜肌',
      secondaryLabel: '腹直肌 · 臀大肌',
      tertiaryLabel: '腓腸肌 · 脛骨前肌',
      planes: {
        AnatomicalPlane.sagittal:   '脊柱中立延伸 · 等長核心收縮',
        AnatomicalPlane.frontal:    '骨盆側屈穩定 · 肩胛下壓',
        AnatomicalPlane.transverse: '軀幹抗旋轉 · 步態穩定',
      },
    ),
    'calf_raise': const _ExerciseMuscles(
      primary: [
        Muscle.gastrocnemiusLeft,   Muscle.gastrocnemiusRight,
      ],
      secondary: [
        Muscle.fibularisLongusLeft, Muscle.fibularisLongusRight,
      ],
      tertiary: [
        Muscle.tibialisAnteriorLeft, Muscle.tibialisAnteriorRight,
      ],
      primaryLabel: '腓腸肌',
      secondaryLabel: '腓骨長肌',
      tertiaryLabel: '脛骨前肌（離心對抗）',
      planes: {
        AnatomicalPlane.sagittal:   '踝關節蹠屈（Plantarflexion）',
        AnatomicalPlane.frontal:    '踝關節外翻穩定',
        AnatomicalPlane.transverse: '足底力線控制',
      },
    ),
    'copenhagen': const _ExerciseMuscles(
      primary: [
        Muscle.adductorMagnusLeft,  Muscle.adductorMagnusRight,
        Muscle.adductorLongusLeft,  Muscle.adductorLongusRight,
        Muscle.gracilisLeft,        Muscle.gracilisRight,
        Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
      ],
      secondary: [
        Muscle.rectusAbdominis1,
        Muscle.gluteusMedius1Left,  Muscle.gluteusMedius1Right,
      ],
      tertiary: [
        Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
      ],
      primaryLabel: '大收肌 · 長收肌 · 薄肌 · 腹外斜肌',
      secondaryLabel: '腹直肌 · 臀中肌',
      tertiaryLabel: '股直肌（側核心穩定）',
      planes: {
        AnatomicalPlane.sagittal:   '核心抗屈曲',
        AnatomicalPlane.frontal:    '髖內收 · 側核心抗剪力',
        AnatomicalPlane.transverse: '骨盆抗旋轉',
      },
    ),
    'bench': const _ExerciseMuscles(
      primary: [
        Muscle.pectoralisMajorLeft,                  Muscle.pectoralisMajorRight,
        Muscle.tricepsBrachiiCaputLateraleLeft,       Muscle.tricepsBrachiiCaputLateraleRight,
        Muscle.tricepsBrachiiCaputLongumLeft,         Muscle.tricepsBrachiiCaputLongumRight,
        Muscle.tricepsBrachiiCaputMedialeLeft,        Muscle.tricepsBrachiiCaputMedialeRight,
      ],
      secondary: [
        Muscle.anteriorDeltoidLeft,  Muscle.anteriorDeltoidRight,
      ],
      tertiary: [
        Muscle.rectusAbdominis1,
        Muscle.trapeziusLowerLeft,   Muscle.trapeziusLowerRight,
      ],
      primaryLabel: '胸大肌 · 三頭肌（三頭）',
      secondaryLabel: '前三角肌',
      tertiaryLabel: '腹直肌 · 下斜方肌',
      planes: {
        AnatomicalPlane.sagittal:   '肘伸展 · 肩水平屈曲',
        AnatomicalPlane.frontal:    '肩內收',
        AnatomicalPlane.transverse: '水平內收 · 肩胛穩定',
      },
    ),
    'pullup': const _ExerciseMuscles(
      primary: [
        Muscle.latissimusDorsiLeft,  Muscle.latissimusDorsiRight,
        Muscle.posteriorDeltoidLeft, Muscle.posteriorDeltoidRight,
      ],
      secondary: [
        Muscle.bicepsBrachiiCaputLongumLeft,  Muscle.bicepsBrachiiCaputLongumRight,
        Muscle.bicepsBrachiiCaputBreveLeft,   Muscle.bicepsBrachiiCaputBreveRight,
        Muscle.trapeziusMiddleLeft,           Muscle.trapeziusMiddleRight,
      ],
      tertiary: [
        Muscle.trapeziusLowerLeft,  Muscle.trapeziusLowerRight,
        Muscle.rectusAbdominis1,
      ],
      primaryLabel: '闊背肌 · 後三角肌',
      secondaryLabel: '肱二頭肌 · 中斜方肌',
      tertiaryLabel: '下斜方肌 · 腹直肌',
      planes: {
        AnatomicalPlane.sagittal:   '肩伸展 · 肘屈曲',
        AnatomicalPlane.frontal:    '肩胛後收與下沉',
        AnatomicalPlane.transverse: '軀幹抗旋轉',
      },
    ),
    'ohp': const _ExerciseMuscles(
      primary: [
        Muscle.anteriorDeltoidLeft,  Muscle.anteriorDeltoidRight,
        Muscle.lateralDeltoidLeft,   Muscle.lateralDeltoidRight,
        Muscle.tricepsBrachiiCaputLateraleLeft,  Muscle.tricepsBrachiiCaputLateraleRight,
        Muscle.tricepsBrachiiCaputLongumLeft,    Muscle.tricepsBrachiiCaputLongumRight,
      ],
      secondary: [
        Muscle.trapeziusUpperLeft,  Muscle.trapeziusUpperRight,
        Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
      ],
      tertiary: [
        Muscle.rectusAbdominis1,
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      ],
      primaryLabel: '前三角肌 · 側三角肌 · 肱三頭肌',
      secondaryLabel: '上斜方肌 · 腹外斜肌',
      tertiaryLabel: '腹直肌 · 臀大肌（核心鎖定）',
      planes: {
        AnatomicalPlane.sagittal:   '肩屈曲 · 肘伸展',
        AnatomicalPlane.frontal:    '肩胛上旋 · 肩胛後縮',
        AnatomicalPlane.transverse: '核心中線剛性',
      },
    ),
    'face_pull': const _ExerciseMuscles(
      primary: [
        Muscle.posteriorDeltoidLeft, Muscle.posteriorDeltoidRight,
        Muscle.trapeziusMiddleLeft,  Muscle.trapeziusMiddleRight,
        Muscle.infraspinatusLeft,    Muscle.infraspinatusRight,
      ],
      secondary: [
        Muscle.trapeziusLowerLeft,  Muscle.trapeziusLowerRight,
        Muscle.trapeziusUpperLeft,  Muscle.trapeziusUpperRight,
      ],
      tertiary: [],
      primaryLabel: '後三角肌 · 中斜方肌 · 棘下肌',
      secondaryLabel: '上/下斜方肌',
      tertiaryLabel: '',
      planes: {
        AnatomicalPlane.sagittal:   '肩水平外展 · 肘屈曲',
        AnatomicalPlane.frontal:    '肩胛後收',
        AnatomicalPlane.transverse: '肩關節外旋（External Rotation）',
      },
    ),
    'triceps_pushdown': const _ExerciseMuscles(
      primary: [
        Muscle.tricepsBrachiiCaputLateraleLeft,  Muscle.tricepsBrachiiCaputLateraleRight,
        Muscle.tricepsBrachiiCaputLongumLeft,    Muscle.tricepsBrachiiCaputLongumRight,
        Muscle.tricepsBrachiiCaputMedialeLeft,   Muscle.tricepsBrachiiCaputMedialeRight,
      ],
      secondary: [
        Muscle.anconeusLeft, Muscle.anconeusRight,
      ],
      tertiary: [],
      primaryLabel: '肱三頭肌（三頭全部）',
      secondaryLabel: '肘肌',
      tertiaryLabel: '',
      planes: {
        AnatomicalPlane.sagittal:   '肘伸展（孤立）',
        AnatomicalPlane.frontal:    '上臂固定 · 肩胛穩定',
        AnatomicalPlane.transverse: '前臂旋轉中立',
      },
    ),
    'hex_deadlift': const _ExerciseMuscles(
      primary: [
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
        Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
        Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
        Muscle.vastusMedialisLeft,  Muscle.vastusMedialisRight,
        Muscle.trapeziusLowerLeft,  Muscle.trapeziusLowerRight,
      ],
      secondary: [
        Muscle.bicepsFemorisLeft,     Muscle.bicepsFemorisRight,
        Muscle.semitendinosusLeft,    Muscle.semitendinosusRight,
        Muscle.trapeziusUpperLeft,    Muscle.trapeziusUpperRight,
      ],
      tertiary: [
        Muscle.externalObliqueLeft,   Muscle.externalObliqueRight,
        Muscle.rectusAbdominis1,
      ],
      primaryLabel: '臀大肌 · 股四頭肌 · 下斜方肌',
      secondaryLabel: '腿後腱群 · 上斜方肌',
      tertiaryLabel: '核心肌群',
      planes: {
        AnatomicalPlane.sagittal:   '髖伸展 · 膝伸展（雙主導）',
        AnatomicalPlane.frontal:    '肩胛後收下沉 · 骨盆穩定',
        AnatomicalPlane.transverse: '核心抗旋轉',
      },
    ),
    'zercher': const _ExerciseMuscles(
      primary: [
        Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
        Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
        Muscle.vastusMedialisLeft,  Muscle.vastusMedialisRight,
        Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
        Muscle.trapeziusUpperLeft,  Muscle.trapeziusUpperRight,
        Muscle.trapeziusMiddleLeft, Muscle.trapeziusMiddleRight,
      ],
      secondary: [
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
        Muscle.rectusAbdominis1,
      ],
      tertiary: [
        Muscle.bicepsBrachiiCaputLongumLeft,  Muscle.bicepsBrachiiCaputLongumRight,
        Muscle.bicepsBrachiiCaputBreveLeft,   Muscle.bicepsBrachiiCaputBreveRight,
      ],
      primaryLabel: '股四頭肌 · 腹斜肌 · 上/中斜方肌',
      secondaryLabel: '臀大肌 · 腹直肌',
      tertiaryLabel: '肱二頭肌（等長抗拉）',
      planes: {
        AnatomicalPlane.sagittal:   '膝伸展 · 核心抗屈曲',
        AnatomicalPlane.frontal:    '骨盆穩定',
        AnatomicalPlane.transverse: '核心抗旋轉',
      },
    ),
    'nordic': const _ExerciseMuscles(
      primary: [
        Muscle.bicepsFemorisLeft,     Muscle.bicepsFemorisRight,
        Muscle.semitendinosusLeft,    Muscle.semitendinosusRight,
        Muscle.semimembranosus1Left,  Muscle.semimembranosus1Right,
        Muscle.semimembranosus2Left,  Muscle.semimembranosus2Right,
      ],
      secondary: [
        Muscle.gastrocnemiusLeft,   Muscle.gastrocnemiusRight,
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      ],
      tertiary: [],
      primaryLabel: '腿後腱群（離心全程）',
      secondaryLabel: '腓腸肌 · 臀大肌',
      tertiaryLabel: '',
      planes: {
        AnatomicalPlane.sagittal:   '膝屈曲（離心） · 核心等長',
        AnatomicalPlane.frontal:    '骨盆水平穩定',
        AnatomicalPlane.transverse: '核心抗旋轉',
      },
    ),
    'rdl': const _ExerciseMuscles(
      primary: [
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
        Muscle.bicepsFemorisLeft,   Muscle.bicepsFemorisRight,
        Muscle.semitendinosusLeft,  Muscle.semitendinosusRight,
      ],
      secondary: [
        Muscle.gluteusMedius1Left,  Muscle.gluteusMedius1Right,
        Muscle.gluteusMedius2Left,  Muscle.gluteusMedius2Right,
      ],
      tertiary: [
        Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
        Muscle.rectusAbdominis1,
      ],
      primaryLabel: '臀大肌 · 腿後腱群',
      secondaryLabel: '臀中肌（單側骨盆穩定）',
      tertiaryLabel: '核心抗旋轉',
      planes: {
        AnatomicalPlane.sagittal:   '髖鉸鏈（伸展）',
        AnatomicalPlane.frontal:    '單側骨盆穩定',
        AnatomicalPlane.transverse: '臀中肌防骨盆翻轉',
      },
    ),
    'leg_curl': const _ExerciseMuscles(
      primary: [
        Muscle.bicepsFemorisLeft,     Muscle.bicepsFemorisRight,
        Muscle.semitendinosusLeft,    Muscle.semitendinosusRight,
        Muscle.semimembranosus1Left,  Muscle.semimembranosus1Right,
      ],
      secondary: [
        Muscle.gastrocnemiusLeft,   Muscle.gastrocnemiusRight,
      ],
      tertiary: [],
      primaryLabel: '腿後腱群（坐姿拉長位）',
      secondaryLabel: '腓腸肌',
      tertiaryLabel: '',
      planes: {
        AnatomicalPlane.sagittal:   '膝屈曲（坐姿拉長位）',
        AnatomicalPlane.frontal:    '骨盆固定穩定',
        AnatomicalPlane.transverse: '膝關節中立對齊',
      },
    ),
    'inverted_row': const _ExerciseMuscles(
      primary: [
        Muscle.trapeziusMiddleLeft,  Muscle.trapeziusMiddleRight,
        Muscle.posteriorDeltoidLeft, Muscle.posteriorDeltoidRight,
      ],
      secondary: [
        Muscle.bicepsBrachiiCaputLongumLeft,  Muscle.bicepsBrachiiCaputLongumRight,
        Muscle.bicepsBrachiiCaputBreveLeft,   Muscle.bicepsBrachiiCaputBreveRight,
        Muscle.latissimusDorsiLeft,           Muscle.latissimusDorsiRight,
      ],
      tertiary: [
        Muscle.rectusAbdominis1,
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      ],
      primaryLabel: '中斜方肌 · 後三角肌',
      secondaryLabel: '肱二頭肌 · 闊背肌',
      tertiaryLabel: '核心（等長平板）',
      planes: {
        AnatomicalPlane.sagittal:   '肩伸展 · 肘屈曲',
        AnatomicalPlane.frontal:    '肩胛後收',
        AnatomicalPlane.transverse: '核心等長抗旋轉',
      },
    ),
    'incline_press': const _ExerciseMuscles(
      primary: [
        Muscle.pectoralisMajorLeft,  Muscle.pectoralisMajorRight,
        Muscle.anteriorDeltoidLeft,  Muscle.anteriorDeltoidRight,
      ],
      secondary: [
        Muscle.tricepsBrachiiCaputLateraleLeft,  Muscle.tricepsBrachiiCaputLateraleRight,
        Muscle.tricepsBrachiiCaputMedialeLeft,   Muscle.tricepsBrachiiCaputMedialeRight,
      ],
      tertiary: [
        Muscle.trapeziusLowerLeft,  Muscle.trapeziusLowerRight,
      ],
      primaryLabel: '胸大肌（上部） · 前三角肌',
      secondaryLabel: '肱三頭肌',
      tertiaryLabel: '下斜方肌',
      planes: {
        AnatomicalPlane.sagittal:   '肩屈曲 · 肘伸展',
        AnatomicalPlane.frontal:    '肩胛後收鎖定',
        AnatomicalPlane.transverse: '水平內收（上斜角度）',
      },
    ),
    'lat_pulldown': const _ExerciseMuscles(
      primary: [
        Muscle.latissimusDorsiLeft,  Muscle.latissimusDorsiRight,
      ],
      secondary: [
        Muscle.bicepsBrachiiCaputLongumLeft,  Muscle.bicepsBrachiiCaputLongumRight,
        Muscle.bicepsBrachiiCaputBreveLeft,   Muscle.bicepsBrachiiCaputBreveRight,
        Muscle.trapeziusMiddleLeft,           Muscle.trapeziusMiddleRight,
      ],
      tertiary: [
        Muscle.trapeziusLowerLeft,  Muscle.trapeziusLowerRight,
        Muscle.posteriorDeltoidLeft, Muscle.posteriorDeltoidRight,
      ],
      primaryLabel: '闊背肌 · 大圓肌（近似）',
      secondaryLabel: '肱二頭肌 · 中斜方肌',
      tertiaryLabel: '下斜方肌 · 後三角肌',
      planes: {
        AnatomicalPlane.sagittal:   '肩伸展 · 肘屈曲',
        AnatomicalPlane.frontal:    '肩胛下沉後收',
        AnatomicalPlane.transverse: '核心抗旋轉',
      },
    ),
    'dips': const _ExerciseMuscles(
      primary: [
        Muscle.pectoralisMajorLeft,  Muscle.pectoralisMajorRight,
        Muscle.anteriorDeltoidLeft,  Muscle.anteriorDeltoidRight,
        Muscle.tricepsBrachiiCaputLateraleLeft,  Muscle.tricepsBrachiiCaputLateraleRight,
        Muscle.tricepsBrachiiCaputLongumLeft,    Muscle.tricepsBrachiiCaputLongumRight,
      ],
      secondary: [
        Muscle.tricepsBrachiiCaputMedialeLeft,  Muscle.tricepsBrachiiCaputMedialeRight,
      ],
      tertiary: [
        Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
      ],
      primaryLabel: '胸大肌（下部） · 前三角肌 · 肱三頭肌',
      secondaryLabel: '三頭肌內側頭（鎖定）',
      tertiaryLabel: '核心穩定',
      planes: {
        AnatomicalPlane.sagittal:   '肩屈曲 + 肘伸展（前傾特化胸肌）',
        AnatomicalPlane.frontal:    '肩胛穩定（前鋸肌鎖定）',
        AnatomicalPlane.transverse: '肩關節抗外旋',
      },
    ),
    'trx_plank': const _ExerciseMuscles(
      primary: [
        Muscle.rectusAbdominis1,
        Muscle.rectusAbdominis2Left,  Muscle.rectusAbdominis2Right,
        Muscle.rectusAbdominis3Left,  Muscle.rectusAbdominis3Right,
        Muscle.externalObliqueLeft,   Muscle.externalObliqueRight,
      ],
      secondary: [
        Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      ],
      tertiary: [],
      primaryLabel: '腹直肌 · 腹橫肌（深層） · 腹外斜肌',
      secondaryLabel: '臀大肌（骨盆鎖定）',
      tertiaryLabel: '',
      planes: {
        AnatomicalPlane.sagittal:   '核心抗伸展（TRX 不穩定）',
        AnatomicalPlane.frontal:    '側核心抗側屈',
        AnatomicalPlane.transverse: '深層核心抗旋轉',
      },
    ),
  };

  _ExerciseMuscles get _currentMuscles =>
      _muscleMap[_selectedExercise] ?? _muscleMap['squat']!;

  MovementData? get _currentMovementData =>
      MovementLibrary.find(_selectedExercise);

  List<(String, String, String, String)> get _filteredExercises {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return _exercises;
    return _exercises
        .where((e) => e.$3.toLowerCase().contains(q) || e.$4.toLowerCase().contains(q))
        .toList();
  }

  // 平面 → 肌群映射
  List<Muscle> get _anatomyPrimary => switch (_plane) {
    AnatomicalPlane.sagittal   => _currentMuscles.primary,
    AnatomicalPlane.frontal    => _currentMuscles.secondary,
    AnatomicalPlane.transverse => _currentMuscles.tertiary,
  };

  List<Muscle> get _anatomySecondary => switch (_plane) {
    AnatomicalPlane.sagittal   => _currentMuscles.secondary,
    AnatomicalPlane.frontal    => _currentMuscles.tertiary,
    AnatomicalPlane.transverse => const [],
  };

  List<Muscle> get _anatomyTertiary => switch (_plane) {
    AnatomicalPlane.sagittal   => _currentMuscles.tertiary,
    AnatomicalPlane.frontal    => const [],
    AnatomicalPlane.transverse => const [],
  };

  void _selectExercise(String id) {
    setState(() {
      _selectedExercise = id;
      _plane = AnatomicalPlane.sagittal;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 720;
    final movementData = _currentMovementData;

    if (isDesktop) {
      return Row(
        children: [
          // ── LEFT: 動作列表 + 搜尋 (200px) ──
          SizedBox(
            width: 200,
            child: _ExerciseList(
              exercises: _filteredExercises,
              selected: _selectedExercise,
              onSelect: _selectExercise,
              searchCtrl: _searchCtrl,
              onSearch: (q) => setState(() => _searchQuery = q),
            ),
          ),
          const VerticalDivider(width: 1),

          // ── CENTER: 動作指南 ──
          Expanded(
            child: movementData != null
                ? _MovementGuidePanel(data: movementData)
                : const Center(
                    child: Text('請選擇動作',
                        style: TextStyle(color: AppTheme.textSecond))),
          ),
          const VerticalDivider(width: 1),

          // ── RIGHT: 解剖圖 (320px) ──
          SizedBox(
            width: 320,
            child: _AnatomyPanel(
              muscles: _currentMuscles,
              plane: _plane,
              onPlaneChanged: (p) => setState(() => _plane = p),
              primaryMuscles: _anatomyPrimary,
              secondaryMuscles: _anatomySecondary,
              tertiaryMuscles: _anatomyTertiary,
            ),
          ),
        ],
      );
    }

    // Mobile: vertical scroll
    return Column(
      children: [
        _ExerciseList(
          exercises: _filteredExercises,
          selected: _selectedExercise,
          onSelect: _selectExercise,
          searchCtrl: _searchCtrl,
          onSearch: (q) => setState(() => _searchQuery = q),
          mobileMode: true,
        ),
        if (movementData != null)
          Expanded(child: _MovementGuidePanel(data: movementData)),
      ],
    );
  }
}

// ── 動作列表（左欄）─────────────────────────────────────────
class _ExerciseList extends StatelessWidget {
  const _ExerciseList({
    required this.exercises,
    required this.selected,
    required this.onSelect,
    required this.searchCtrl,
    required this.onSearch,
    this.mobileMode = false,
  });
  final List<(String, String, String, String)> exercises;
  final String selected;
  final void Function(String) onSelect;
  final TextEditingController searchCtrl;
  final void Function(String) onSearch;
  final bool mobileMode;

  @override
  Widget build(BuildContext context) {
    final listWidget = ListView.builder(
      itemCount: exercises.length,
      shrinkWrap: mobileMode,
      itemBuilder: (_, i) {
        final e = exercises[i];
        return ListTile(
          leading: Text(e.$2, style: const TextStyle(fontSize: 18)),
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
        );
      },
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 10),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('動作知識庫', style: Theme.of(context).textTheme.titleLarge),
            const Text('解剖學 · 生物力學 · 動作分析',
                style: TextStyle(fontSize: 10, color: AppTheme.textSecond)),
            const SizedBox(height: 10),
            // 搜尋框
            TextField(
              controller: searchCtrl,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: '搜尋動作...',
                prefixIcon: const Icon(Icons.search, size: 16),
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 8),
                filled: true,
                fillColor: AppTheme.surface3,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.border)),
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.border)),
              ),
            ),
          ]),
        ),
        mobileMode
            ? listWidget
            : Expanded(child: listWidget),
      ],
    );
  }
}

// ── 動作指南面板（中欄）─────────────────────────────────────
class _MovementGuidePanel extends StatelessWidget {
  const _MovementGuidePanel({required this.data});
  final MovementData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // 標題
        Text(data.name,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),

        // 解剖聚焦
        _GuideSection(
          icon: '🔴',
          title: '解剖聚焦',
          child: Text(data.anatomyFocus,
              style: const TextStyle(fontSize: 12, height: 1.5)),
        ),
        const SizedBox(height: 10),

        // 力學特徵
        _GuideSection(
          icon: '⚙️',
          title: '力學特徵',
          child: Text(data.mechanics,
              style: const TextStyle(fontSize: 12, height: 1.5)),
        ),
        const SizedBox(height: 14),

        // 動作指南（6 階段）
        const Text('MOVEMENT GUIDE',
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppTheme.textSecond)),
        const SizedBox(height: 8),
        ...data.phases.asMap().entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _PhaseCard(index: e.key, phase: e.value),
          ),
        ),

        const SizedBox(height: 14),

        // 核心提示詞
        const Text('核心提示詞',
            style: TextStyle(
                fontSize: 9,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.5,
                color: AppTheme.textSecond)),
        const SizedBox(height: 8),
        ...data.coreCues.map(
          (cue) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('▸  ',
                    style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppTheme.accent)),
                Expanded(
                  child: Text(cue,
                      style: const TextStyle(
                          fontSize: 11, height: 1.5)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _GuideSection extends StatelessWidget {
  const _GuideSection({
    required this.icon,
    required this.title,
    required this.child,
  });
  final String icon, title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(children: [
            Text(icon, style: const TextStyle(fontSize: 14)),
            const SizedBox(width: 6),
            Text(title,
                style: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppTheme.textSecond)),
          ]),
          const SizedBox(height: 6),
          child,
        ],
      ),
    );
  }
}

class _PhaseCard extends StatelessWidget {
  const _PhaseCard({required this.index, required this.phase});
  final int index;
  final MovementPhase phase;

  static const _colors = [
    Color(0xFF4A7A4A), Color(0xFF4A5A7A), Color(0xFF7A4A4A),
    Color(0xFF7A5A4A), Color(0xFF4A6A6A), Color(0xFF6A4A7A),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _colors[index % _colors.length];
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: index == 0,
        backgroundColor: const Color(0xFF181818),
        collapsedBackgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.4)),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: AppTheme.border),
        ),
        leading: Container(
          width: 24, height: 24,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.center,
          child: Text('${index + 1}',
              style: TextStyle(fontSize: 11, fontWeight: FontWeight.w800, color: color)),
        ),
        title: Text(phase.title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(phase.content,
                style: const TextStyle(
                    fontSize: 12, color: Color(0xFFBBBBBB), height: 1.6)),
          ),
        ],
      ),
    );
  }
}

// ── 解剖圖面板（右欄）────────────────────────────────────────
class _AnatomyPanel extends StatelessWidget {
  const _AnatomyPanel({
    required this.muscles,
    required this.plane,
    required this.onPlaneChanged,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    required this.tertiaryMuscles,
  });
  final _ExerciseMuscles muscles;
  final AnatomicalPlane plane;
  final void Function(AnatomicalPlane) onPlaneChanged;
  final List<Muscle> primaryMuscles;
  final List<Muscle> secondaryMuscles;
  final List<Muscle> tertiaryMuscles;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // 解剖平面選擇器
        _PlaneSelector(current: plane, onChanged: onPlaneChanged),

        // 解剖圖
        Expanded(
          child: AnatomyView(
            primaryMuscles: primaryMuscles,
            secondaryMuscles: secondaryMuscles,
            tertiaryMuscles: tertiaryMuscles,
            selectedPlane: plane,
            onMuscleTapped: (muscleInfo) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                    content: Text(muscleInfo.displayName),
                    duration: const Duration(seconds: 1)),
              );
            },
          ),
        ),

        // 肌群分佈橫條圖
        Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            children: [
              _MuscleRow(AppTheme.muscPrimary, '主動肌群',
                  muscles.primaryLabel, 0.88),
              const SizedBox(height: 6),
              _MuscleRow(AppTheme.muscSecond, '輔助肌群',
                  muscles.secondaryLabel, 0.55),
              if (muscles.tertiaryLabel.isNotEmpty) ...[
                const SizedBox(height: 6),
                _MuscleRow(AppTheme.muscTertiary, '協同穩定',
                    muscles.tertiaryLabel, 0.22),
              ],
              // 解剖平面說明
              const SizedBox(height: 10),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surface2,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppTheme.border),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(plane.label,
                        style: const TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: AppTheme.accent)),
                    const SizedBox(height: 4),
                    Text(muscles.planes[plane] ?? plane.action,
                        style: const TextStyle(
                            fontSize: 10, height: 1.5, color: AppTheme.textSecond)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ── 平面選擇器 ────────────────────────────────────────────────
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
                          color: p == current
                              ? AppTheme.accent
                              : Colors.transparent,
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
                            color: p == current
                                ? AppTheme.accent
                                : AppTheme.textSecond,
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

// ── 肌群分佈行 ────────────────────────────────────────────────
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
        width: 10, height: 32,
        decoration: BoxDecoration(
            color: color, borderRadius: BorderRadius.circular(3)),
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

// ── 動作肌群資料結構 ─────────────────────────────────────────
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
