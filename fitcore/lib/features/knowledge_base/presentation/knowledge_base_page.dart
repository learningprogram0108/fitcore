import 'package:flutter/material.dart';
import 'package:flutter_body_atlas/flutter_body_atlas.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import '../../../app/theme/app_theme.dart';
import '../../program/domain/movement_data.dart';
import '../domain/big_three_data.dart';
import '../domain/pt_rehab_data.dart';
import 'widgets/anatomy_view.dart';

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({super.key, this.initialExercise});
  final String? initialExercise;

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  // ── Tab 0: 動作知識庫 ────────────────────────────────────────
  late String _selectedExercise;
  String _searchQuery = '';
  final _searchCtrl = TextEditingController();

  // ── Tab 1: 健力三項知識庫 ────────────────────────────────────
  String _selectedChapterId = '';

  // ── Tab 2: 物理治療 ──────────────────────────────────────────
  String _ptChapterId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedExercise = widget.initialExercise ?? 'squat';

    if (BigThreeLibrary.chapters.isNotEmpty) {
      _selectedChapterId = BigThreeLibrary.chapters.first.id;
    }
    if (PtRehabLibrary.chapters.isNotEmpty) {
      _ptChapterId = PtRehabLibrary.chapters.first.id;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── 20 個動作列表 ───────────────────────────────────────────
  // 格式規範：名稱欄位使用「中文（English）」雙語格式，方便中英文搜尋
  static const _exercises = [
    ('squat',            '🏋️', '槓鈴背蹲舉（High-Bar Back Squat）',    '下肢推 · Day 1'),
    ('bulgarian',        '🦵', '保加利亞分腿蹲（Bulgarian Split Squat）', '單側下肢推 · Day 1'),
    ('farmers_walk',     '🚶', "農夫走路（Farmer's Walk）",              '攜重行走 · Day 1'),
    ('calf_raise',       '🦶', '站姿提踵（Standing Calf Raise）',       '小腿特化 · Day 1'),
    ('copenhagen',       '🌀', '哥本哈根側平舉（Copenhagen Adduction）', '內收肌群 · Day 1'),
    ('bench',            '💪', '槓鈴臥推（Barbell Bench Press）',        '水平推 · Day 2'),
    ('pullup',           '🔽', '正手寬握引體向上（Pronated Pull-Up）',   '垂直拉 · Day 2'),
    ('ohp',              '🏔️', '槓鈴肩推（Overhead Press）',            '垂直推 · Day 2'),
    ('face_pull',        '🎯', '滑輪面拉（Cable Face Pull）',            '後三角 · Day 2'),
    ('triceps_pushdown', '🔧', '滑輪三頭下壓（Cable Triceps Pushdown）', '三頭特化 · Day 2'),
    ('hex_deadlift',     '🔩', '六角槓硬舉（Hex Bar Deadlift）',         '全身後鏈 · Day 3'),
    ('zercher',          '💡', '澤奇深蹲（Zercher Squat）',              '核心前載 · Day 3'),
    ('nordic',           '🎿', '北歐腿彎舉（Nordic Hamstring Curl）',    '離心腿後 · Day 3'),
    ('rdl',              '⚖️', '單腿羅馬尼亞硬舉（Single-Leg RDL）',     '單側後鏈 · Day 3'),
    ('leg_curl',         '🪑', '坐姿腿彎舉（Seated Leg Curl）',          '拉長腿後 · Day 3'),
    ('inverted_row',     '📐', '仰臥划船（Inverted Row）',               '水平拉 · Day 4'),
    ('incline_press',    '📈', '啞鈴上斜臥推（Dumbbell Incline Press）', '胸上部 · Day 4'),
    ('lat_pulldown',     '⬇️', '寬握滑輪下拉（Wide-Grip Lat Pulldown）', '背部寬度 · Day 4'),
    ('dips',             '⬆️', '雙槓撐體（Dips）',                       '胸下推 · Day 4'),
    ('trx_plank',        '🏗️', 'TRX 平板撐（TRX Plank）',              '深層核心 · Day 4'),
    // ── 進階動作庫 ──────────────────────────────────────────────
    ('pallof_press',      '🌀', '帕羅夫推舉（Pallof Press）',                  '抗旋轉核心 · 進階'),
    ('pushup_plus',       '👐', '進階伏地挺身（Push-Up Plus）',                '閉鏈水平推 · 肩胛穩定'),
    ('deadlift',          '🔑', '傳統槓鈴硬舉（Conventional Deadlift）',       '後鏈主動作 · 進階庫'),
    ('sumo_deadlift',     '🥊', '相撲硬舉（Sumo Deadlift）',                  '下肢推拉 · 進階庫'),
    ('cossack_squat',     '🌐', '哥薩克蹲（Cossack Squat）',                  '多維深蹲 · 進階庫'),
    ('single_arm_row',    '🚣', '單臂啞鈴划船（Single-Arm DB Row）',           '單側水平拉 · 進階庫'),
    ('turkish_getup',     '🕯️', '土耳其起立（Turkish Get-Up）',                '功能整合 · 壺鈴'),
    ('hip_thrust',        '🍑', '槓鈴臀推（Barbell Hip Thrust）',             '臀肌特化 · 進階庫'),
    ('hanging_leg_raise', '🪝', '懸垂舉腿（Hanging Leg Raise）',              '懸吊核心 · 進階庫'),
    ('landmine_press',    '📡', '單臂地雷管斜推（Single-Arm Landmine Press）', '斜向推力 · 地雷管'),
    ('reverse_sled',      '🏃', '倒退負重雪橇（Reverse Sled Drag）',          '四頭特化 · 體能訓練'),
  ];

  List<(String, String, String, String)> get _filteredExercises {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return _exercises;
    return _exercises
        .where((e) => e.$3.toLowerCase().contains(q) || e.$4.toLowerCase().contains(q))
        .toList();
  }

  // ── Markdown 樣式表（委派頂層函式，讓子 Widget 也能直接呼叫）──
  MarkdownStyleSheet get _mdStyle => _kbMdStyle();

  // ── Build ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: TabBar(
            controller: _tabController,
            labelStyle: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
            unselectedLabelStyle: const TextStyle(fontSize: 13),
            tabs: const [
              Tab(text: '動作知識庫'),
              Tab(text: '健力三項'),
              Tab(text: '物理治療'),
            ],
          ),
        ),
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMovementTab(),
              _buildBigThreeTab(),
              _buildPtTab(),
            ],
          ),
        ),
      ],
    );
  }

  // ── Tab 0: 動作知識庫 ────────────────────────────────────────
  Widget _buildMovementTab() {
    final movementData = MovementLibrary.find(_selectedExercise);
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: _ExerciseList(
            exercises: _filteredExercises,
            selected: _selectedExercise,
            onSelect: (id) => setState(() => _selectedExercise = id),
            searchCtrl: _searchCtrl,
            onSearch: (q) => setState(() => _searchQuery = q),
          ),
        ),
        if (movementData != null) ...[
          const Divider(height: 1, color: AppTheme.border),
          Expanded(
            flex: 3,
            child: _MovementGuidePanel(
              data: movementData,
              muscles: _muscleMap[_selectedExercise],
            ),
          ),
        ],
      ],
    );
  }

  // ── Tab 1: 健力三項 (手風琴布局) ─────────────────────────────
  Widget _buildBigThreeTab() {
    final chapter = BigThreeLibrary.findChapter(_selectedChapterId);
    return Column(
      children: [
        // 標題 + Chip 選擇列
        Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('健力三項', style: Theme.of(context).textTheme.titleLarge),
              const Text('深蹲 · 臥推 · 硬舉 終極指南',
                  style: TextStyle(fontSize: 10, color: AppTheme.textSecond)),
              const SizedBox(height: 10),
              _ChapterChipRow(
                items: BigThreeLibrary.chapters
                    .map((c) => (c.id, c.emoji, c.title))
                    .toList(),
                selectedId: _selectedChapterId,
                onSelected: (id) => setState(() => _selectedChapterId = id),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
        // 選中章節標題卡
        if (chapter != null)
          _ChapterHeaderCard(
            emoji: chapter.emoji,
            title: chapter.title,
            subtitle: chapter.subtitle,
          ),
        // 章節 Section 手風琴
        Expanded(
          child: chapter == null
              ? const Center(
                  child: Text('請選擇章節',
                      style: TextStyle(color: AppTheme.textSecond)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  itemCount: chapter.sections.length,
                  itemBuilder: (_, i) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: _KbSectionTile(
                      title: chapter.sections[i].title,
                      content: chapter.sections[i].content,
                      index: i,
                      mdStyle: _mdStyle,
                    ),
                  ),
                ),
        ),
      ],
    );
  }

  // ── Tab 2: 物理治療 (手風琴布局) ─────────────────────────────
  Widget _buildPtTab() {
    final chapter = PtRehabLibrary.findChapter(_ptChapterId);
    return Column(
      children: [
        // 標題 + Chip 選擇列
        Container(
          padding: const EdgeInsets.fromLTRB(14, 14, 14, 0),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('物理治療', style: Theme.of(context).textTheme.titleLarge),
              const Text('功能重建 · Rebuilding Milo 系列',
                  style: TextStyle(fontSize: 10, color: AppTheme.textSecond)),
              const SizedBox(height: 10),
              _ChapterChipRow(
                items: PtRehabLibrary.chapters
                    .map((c) => (c.id, c.emoji, c.title))
                    .toList(),
                selectedId: _ptChapterId,
                onSelected: (id) => setState(() => _ptChapterId = id),
              ),
              const SizedBox(height: 2),
            ],
          ),
        ),
        // 選中章節標題卡
        if (chapter != null)
          _ChapterHeaderCard(
            emoji: chapter.emoji,
            title: chapter.title,
            subtitle: chapter.subtitle,
          ),
        // 章節 Section 手風琴（PT 版含圖片佔位）
        Expanded(
          child: chapter == null
              ? const Center(
                  child: Text('請選擇章節',
                      style: TextStyle(color: AppTheme.textSecond)))
              : ListView.builder(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 24),
                  itemCount: chapter.sections.length,
                  itemBuilder: (_, i) {
                    final s = chapter.sections[i];
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: _KbSectionTile(
                        title: s.title,
                        content: s.content,
                        index: i,
                        mdStyle: _mdStyle,
                        diagramLabel: s.diagramLabel,
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

// 頂層 Markdown 樣式函式（知識庫統一樣式，供所有子元件共用）
MarkdownStyleSheet _kbMdStyle() => MarkdownStyleSheet(
      p: const TextStyle(fontSize: 13, height: 1.75, color: Color(0xFFCCCCCC)),
      strong: const TextStyle(fontWeight: FontWeight.w800, color: Colors.white),
      em: const TextStyle(color: Color(0xFFDDDDDD), fontStyle: FontStyle.italic),
      blockquotePadding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      blockquoteDecoration: BoxDecoration(
        border: const Border(left: BorderSide(color: AppTheme.accent, width: 3)),
        color: const Color(0xFF1A2010),
        borderRadius: BorderRadius.circular(4),
      ),
      blockquote: TextStyle(
        color: AppTheme.accent.withValues(alpha: 0.9),
        fontSize: 12,
        height: 1.6,
      ),
      listBullet: const TextStyle(color: AppTheme.accent, fontSize: 13),
      h3: const TextStyle(
          color: Colors.white, fontSize: 13, fontWeight: FontWeight.w700),
      h4: const TextStyle(
          color: Colors.white, fontSize: 12, fontWeight: FontWeight.w700),
      code: const TextStyle(
          backgroundColor: Color(0xFF222222),
          color: Color(0xFF88CC88),
          fontSize: 11),
      tableHead: const TextStyle(
          color: Colors.white, fontWeight: FontWeight.w700, fontSize: 11),
      tableBody: const TextStyle(color: Color(0xFFCCCCCC), fontSize: 11),
      tableBorder: TableBorder.all(color: AppTheme.border, width: 0.5),
    );

// ════════════════════════════════════════════════════════════
//  解剖圖肌群資料（flutter_body_atlas Muscle enum 對應）
// ════════════════════════════════════════════════════════════

/// 單一動作的三層肌群資料（供 AnatomyView 著色）
class _ExerciseMuscles {
  _ExerciseMuscles({
    required this.primary,
    required this.secondary,
    this.tertiary = const [],
  });
  final List<Muscle> primary;
  final List<Muscle> secondary;
  final List<Muscle> tertiary;
}

/// 20 個動作 → 三層肌群映射
/// 使用 flutter_body_atlas-0.1.4 確認可用的 Muscle enum 值
/// 不存在 erectorSpinae / rhomboids / teresMajor → 以最接近可用值替代
final _muscleMap = <String, _ExerciseMuscles>{
  // ─── Day 1：下肢 ───────────────────────────────────────────────
  'squat': _ExerciseMuscles(
    primary: [
      Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
      Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
      Muscle.vastusMedialisLeft,  Muscle.vastusMedialisRight,
      Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
    ],
    secondary: [
      Muscle.bicepsFemorisLeft,  Muscle.bicepsFemorisRight,
      Muscle.semitendinosusLeft, Muscle.semitendinosusRight,
    ],
    tertiary: [
      Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
      Muscle.rectusAbdominis1,
    ],
  ),
  'bulgarian': _ExerciseMuscles(
    primary: [
      Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
      Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
      Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
    ],
    secondary: [
      Muscle.gluteusMedius1Left, Muscle.gluteusMedius1Right,
      Muscle.gastrocnemiusLeft,  Muscle.gastrocnemiusRight,
    ],
    tertiary: [
      Muscle.adductorMagnusLeft, Muscle.adductorMagnusRight,
    ],
  ),
  'farmers_walk': _ExerciseMuscles(
    primary: [
      Muscle.trapeziusUpperLeft,  Muscle.trapeziusUpperRight,
      Muscle.trapeziusMiddleLeft, Muscle.trapeziusMiddleRight,
    ],
    secondary: [
      Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
      Muscle.latissimusDorsiLeft, Muscle.latissimusDorsiRight,
    ],
    tertiary: [Muscle.rectusAbdominis1],
  ),
  'calf_raise': _ExerciseMuscles(
    primary: [Muscle.gastrocnemiusLeft, Muscle.gastrocnemiusRight],
    secondary: [],
    tertiary: [Muscle.tibialisAnteriorLeft, Muscle.tibialisAnteriorRight],
  ),
  'copenhagen': _ExerciseMuscles(
    primary: [
      Muscle.adductorMagnusLeft, Muscle.adductorMagnusRight,
      Muscle.adductorLongusLeft, Muscle.adductorLongusRight,
    ],
    secondary: [Muscle.externalObliqueLeft, Muscle.externalObliqueRight],
    tertiary: [Muscle.rectusAbdominis1],
  ),
  // ─── Day 2：上肢 ───────────────────────────────────────────────
  'bench': _ExerciseMuscles(
    primary: [Muscle.pectoralisMajorLeft, Muscle.pectoralisMajorRight],
    secondary: [
      Muscle.anteriorDeltoidLeft,              Muscle.anteriorDeltoidRight,
      Muscle.tricepsBrachiiCaputLateraleLeft,  Muscle.tricepsBrachiiCaputLateraleRight,
    ],
  ),
  'pullup': _ExerciseMuscles(
    primary: [Muscle.latissimusDorsiLeft, Muscle.latissimusDorsiRight],
    secondary: [
      Muscle.bicepsBrachiiCaputLongumLeft, Muscle.bicepsBrachiiCaputLongumRight,
      Muscle.trapeziusMiddleLeft,          Muscle.trapeziusMiddleRight,
    ],
    tertiary: [Muscle.posteriorDeltoidLeft, Muscle.posteriorDeltoidRight],
  ),
  'ohp': _ExerciseMuscles(
    primary: [Muscle.anteriorDeltoidLeft, Muscle.anteriorDeltoidRight],
    secondary: [
      Muscle.tricepsBrachiiCaputLateraleLeft, Muscle.tricepsBrachiiCaputLateraleRight,
      Muscle.lateralDeltoidLeft,              Muscle.lateralDeltoidRight,
    ],
    tertiary: [Muscle.rectusAbdominis1],
  ),
  'face_pull': _ExerciseMuscles(
    primary: [
      Muscle.posteriorDeltoidLeft, Muscle.posteriorDeltoidRight,
      Muscle.infraspinatusLeft,    Muscle.infraspinatusRight,
    ],
    secondary: [Muscle.trapeziusMiddleLeft, Muscle.trapeziusMiddleRight],
  ),
  'triceps_pushdown': _ExerciseMuscles(
    primary: [
      Muscle.tricepsBrachiiCaputLateraleLeft,  Muscle.tricepsBrachiiCaputLateraleRight,
      Muscle.tricepsBrachiiCaputLongumLeft,    Muscle.tricepsBrachiiCaputLongumRight,
      Muscle.tricepsBrachiiCaputMedialeLeft,   Muscle.tricepsBrachiiCaputMedialeRight,
    ],
    secondary: [],
  ),
  // ─── Day 3：後鏈 ───────────────────────────────────────────────
  'hex_deadlift': _ExerciseMuscles(
    primary: [
      Muscle.gluteusMaximusLeft,  Muscle.gluteusMaximusRight,
      Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
      Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
    ],
    secondary: [
      Muscle.bicepsFemorisLeft,   Muscle.bicepsFemorisRight,
      Muscle.semitendinosusLeft,  Muscle.semitendinosusRight,
      Muscle.latissimusDorsiLeft, Muscle.latissimusDorsiRight,
    ],
    tertiary: [Muscle.externalObliqueLeft, Muscle.externalObliqueRight],
  ),
  'zercher': _ExerciseMuscles(
    primary: [
      Muscle.rectusFemorisLeft,   Muscle.rectusFemorisRight,
      Muscle.vastusLateralisLeft, Muscle.vastusLateralisRight,
      Muscle.externalObliqueLeft, Muscle.externalObliqueRight,
      Muscle.rectusAbdominis1,
    ],
    secondary: [Muscle.gluteusMaximusLeft, Muscle.gluteusMaximusRight],
    tertiary: [Muscle.trapeziusUpperLeft,  Muscle.trapeziusUpperRight],
  ),
  'nordic': _ExerciseMuscles(
    primary: [
      Muscle.bicepsFemorisLeft,    Muscle.bicepsFemorisRight,
      Muscle.semitendinosusLeft,   Muscle.semitendinosusRight,
      Muscle.semimembranosus1Left, Muscle.semimembranosus1Right,
    ],
    secondary: [Muscle.gastrocnemiusLeft, Muscle.gastrocnemiusRight],
  ),
  'rdl': _ExerciseMuscles(
    primary: [
      Muscle.gluteusMaximusLeft, Muscle.gluteusMaximusRight,
      Muscle.bicepsFemorisLeft,  Muscle.bicepsFemorisRight,
    ],
    secondary: [
      Muscle.semitendinosusLeft, Muscle.semitendinosusRight,
      Muscle.gluteusMedius1Left, Muscle.gluteusMedius1Right,
    ],
  ),
  'leg_curl': _ExerciseMuscles(
    primary: [
      Muscle.bicepsFemorisLeft,    Muscle.bicepsFemorisRight,
      Muscle.semitendinosusLeft,   Muscle.semitendinosusRight,
      Muscle.semimembranosus1Left, Muscle.semimembranosus1Right,
    ],
    secondary: [Muscle.gastrocnemiusLeft, Muscle.gastrocnemiusRight],
  ),
  // ─── Day 4：上肢 ───────────────────────────────────────────────
  'inverted_row': _ExerciseMuscles(
    primary: [
      Muscle.trapeziusMiddleLeft,  Muscle.trapeziusMiddleRight,
      Muscle.posteriorDeltoidLeft, Muscle.posteriorDeltoidRight,
      Muscle.latissimusDorsiLeft,  Muscle.latissimusDorsiRight,
    ],
    secondary: [
      Muscle.bicepsBrachiiCaputLongumLeft, Muscle.bicepsBrachiiCaputLongumRight,
    ],
  ),
  'incline_press': _ExerciseMuscles(
    primary: [
      Muscle.pectoralisMajorLeft,  Muscle.pectoralisMajorRight,
      Muscle.anteriorDeltoidLeft,  Muscle.anteriorDeltoidRight,
    ],
    secondary: [
      Muscle.tricepsBrachiiCaputLateraleLeft, Muscle.tricepsBrachiiCaputLateraleRight,
    ],
  ),
  'lat_pulldown': _ExerciseMuscles(
    primary: [Muscle.latissimusDorsiLeft, Muscle.latissimusDorsiRight],
    secondary: [
      Muscle.bicepsBrachiiCaputLongumLeft, Muscle.bicepsBrachiiCaputLongumRight,
      Muscle.trapeziusMiddleLeft,          Muscle.trapeziusMiddleRight,
    ],
  ),
  'dips': _ExerciseMuscles(
    primary: [
      Muscle.pectoralisMajorLeft, Muscle.pectoralisMajorRight,
      Muscle.anteriorDeltoidLeft, Muscle.anteriorDeltoidRight,
    ],
    secondary: [
      Muscle.tricepsBrachiiCaputLateraleLeft, Muscle.tricepsBrachiiCaputLateraleRight,
      Muscle.tricepsBrachiiCaputLongumLeft,   Muscle.tricepsBrachiiCaputLongumRight,
    ],
  ),
  'trx_plank': _ExerciseMuscles(
    primary: [
      Muscle.rectusAbdominis1,
      Muscle.rectusAbdominis2Left, Muscle.rectusAbdominis2Right,
      Muscle.externalObliqueLeft,  Muscle.externalObliqueRight,
    ],
    secondary: [],
  ),

  // ── 進階動作庫 ──────────────────────────────────────────────
  'pallof_press': _ExerciseMuscles(
    primary: [
      Muscle.externalObliqueLeft,    Muscle.externalObliqueRight,
      Muscle.rectusAbdominis1,
      Muscle.rectusAbdominis2Left,   Muscle.rectusAbdominis2Right,
    ],
    secondary: [
      Muscle.anteriorDeltoidLeft,    Muscle.anteriorDeltoidRight,
    ],
    tertiary: [
      Muscle.gluteusMedius1Left,     Muscle.gluteusMedius1Right,
    ],
  ),

  'pushup_plus': _ExerciseMuscles(
    primary: [
      Muscle.pectoralisMajorLeft,    Muscle.pectoralisMajorRight,
      Muscle.anteriorDeltoidLeft,    Muscle.anteriorDeltoidRight,
    ],
    secondary: [
      Muscle.tricepsBrachiiCaputLateraleLeft, Muscle.tricepsBrachiiCaputLateraleRight,
      Muscle.rectusAbdominis1,
    ],
  ),

  'deadlift': _ExerciseMuscles(
    primary: [
      Muscle.gluteusMaximusLeft,     Muscle.gluteusMaximusRight,
      Muscle.bicepsFemorisLeft,      Muscle.bicepsFemorisRight,
      Muscle.semimembranosus1Left,   Muscle.semimembranosus1Right,
      Muscle.semitendinosusLeft,     Muscle.semitendinosusRight,
    ],
    secondary: [
      Muscle.latissimusDorsiLeft,    Muscle.latissimusDorsiRight,
      Muscle.rectusFemorisLeft,      Muscle.rectusFemorisRight,
    ],
    tertiary: [
      Muscle.externalObliqueLeft,    Muscle.externalObliqueRight,
    ],
  ),

  'sumo_deadlift': _ExerciseMuscles(
    primary: [
      Muscle.rectusFemorisLeft,      Muscle.rectusFemorisRight,
      Muscle.vastusLateralisLeft,    Muscle.vastusLateralisRight,
      Muscle.gluteusMaximusLeft,     Muscle.gluteusMaximusRight,
      Muscle.adductorMagnusLeft,     Muscle.adductorMagnusRight,
    ],
    secondary: [
      Muscle.semitendinosusLeft,     Muscle.semitendinosusRight,
      Muscle.bicepsFemorisLeft,      Muscle.bicepsFemorisRight,
    ],
  ),

  'cossack_squat': _ExerciseMuscles(
    primary: [
      Muscle.rectusFemorisLeft,      Muscle.rectusFemorisRight,
      Muscle.vastusLateralisLeft,    Muscle.vastusLateralisRight,
      Muscle.gluteusMaximusLeft,     Muscle.gluteusMaximusRight,
      Muscle.adductorMagnusLeft,     Muscle.adductorMagnusRight,
      Muscle.adductorLongusLeft,     Muscle.adductorLongusRight,
    ],
    secondary: [
      Muscle.gluteusMedius1Left,     Muscle.gluteusMedius1Right,
      Muscle.gastrocnemiusLeft,      Muscle.gastrocnemiusRight,
    ],
  ),

  'single_arm_row': _ExerciseMuscles(
    primary: [
      Muscle.latissimusDorsiLeft,    Muscle.latissimusDorsiRight,
      Muscle.posteriorDeltoidLeft,   Muscle.posteriorDeltoidRight,
      Muscle.trapeziusMiddleLeft,    Muscle.trapeziusMiddleRight,
    ],
    secondary: [
      Muscle.bicepsBrachiiCaputLongumLeft, Muscle.bicepsBrachiiCaputLongumRight,
    ],
    tertiary: [
      Muscle.externalObliqueLeft,    Muscle.externalObliqueRight,
    ],
  ),

  'turkish_getup': _ExerciseMuscles(
    primary: [
      Muscle.anteriorDeltoidLeft,    Muscle.anteriorDeltoidRight,
      Muscle.lateralDeltoidLeft,     Muscle.lateralDeltoidRight,
    ],
    secondary: [
      Muscle.gluteusMaximusLeft,     Muscle.gluteusMaximusRight,
      Muscle.externalObliqueLeft,    Muscle.externalObliqueRight,
      Muscle.rectusAbdominis1,
    ],
  ),

  'hip_thrust': _ExerciseMuscles(
    primary: [
      Muscle.gluteusMaximusLeft,     Muscle.gluteusMaximusRight,
    ],
    secondary: [
      Muscle.adductorMagnusLeft,     Muscle.adductorMagnusRight,
      Muscle.bicepsFemorisLeft,      Muscle.bicepsFemorisRight,
      Muscle.semitendinosusLeft,     Muscle.semitendinosusRight,
    ],
  ),

  'hanging_leg_raise': _ExerciseMuscles(
    primary: [
      Muscle.rectusAbdominis1,
      Muscle.rectusAbdominis2Left,   Muscle.rectusAbdominis2Right,
      Muscle.externalObliqueLeft,    Muscle.externalObliqueRight,
    ],
    secondary: [
      Muscle.rectusFemorisLeft,      Muscle.rectusFemorisRight,
    ],
  ),

  'landmine_press': _ExerciseMuscles(
    primary: [
      Muscle.pectoralisMajorLeft,    Muscle.pectoralisMajorRight,
      Muscle.anteriorDeltoidLeft,    Muscle.anteriorDeltoidRight,
    ],
    secondary: [
      Muscle.tricepsBrachiiCaputLateraleLeft, Muscle.tricepsBrachiiCaputLateraleRight,
      Muscle.externalObliqueLeft,    Muscle.externalObliqueRight,
    ],
  ),

  'reverse_sled': _ExerciseMuscles(
    primary: [
      Muscle.rectusFemorisLeft,      Muscle.rectusFemorisRight,
      Muscle.vastusLateralisLeft,    Muscle.vastusLateralisRight,
      Muscle.vastusMedialisLeft,     Muscle.vastusMedialisRight,
    ],
    secondary: [
      Muscle.gluteusMaximusLeft,     Muscle.gluteusMaximusRight,
      Muscle.gastrocnemiusLeft,      Muscle.gastrocnemiusRight,
    ],
  ),
};

// ════════════════════════════════════════════════════════════
//  共用子元件：Chip 選擇列 + 章節標題卡 + Section 手風琴
// ════════════════════════════════════════════════════════════

/// 橫向可滾動的章節 ChoiceChip 列
class _ChapterChipRow extends StatelessWidget {
  const _ChapterChipRow({
    required this.items,
    required this.selectedId,
    required this.onSelected,
  });
  final List<(String, String, String)> items; // (id, emoji, title)
  final String selectedId;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: items.map((item) {
          final isSelected = item.$1 == selectedId;
          return Padding(
            padding: const EdgeInsets.only(right: 8, bottom: 10),
            child: ChoiceChip(
              label: Text(
                '${item.$2}  ${item.$3}',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight:
                      isSelected ? FontWeight.w700 : FontWeight.w400,
                  color: isSelected ? Colors.black : AppTheme.textSecond,
                ),
              ),
              selected: isSelected,
              selectedColor: AppTheme.accent,
              backgroundColor: AppTheme.surface2,
              side: BorderSide(
                color: isSelected ? AppTheme.accent : AppTheme.border,
              ),
              onSelected: (_) => onSelected(item.$1),
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            ),
          );
        }).toList(),
      ),
    );
  }
}

/// 選中章節的標題卡片（emoji + 標題 + 副標題）
class _ChapterHeaderCard extends StatelessWidget {
  const _ChapterHeaderCard({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });
  final String emoji, title, subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 10, 12, 0),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            AppTheme.accent.withValues(alpha: 0.15),
            AppTheme.accent.withValues(alpha: 0.04),
          ],
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Text(emoji, style: const TextStyle(fontSize: 26)),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Colors.white)),
                const SizedBox(height: 2),
                Text(subtitle,
                    style: const TextStyle(
                        fontSize: 10, color: AppTheme.textSecond)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 通用 Section 手風琴磚（BigThree 和 PT 共用）
class _KbSectionTile extends StatelessWidget {
  const _KbSectionTile({
    required this.title,
    required this.content,
    required this.index,
    required this.mdStyle,
    this.diagramLabel,
  });
  final String title, content;
  final int index;
  final MarkdownStyleSheet mdStyle;
  final String? diagramLabel;

  static const _accentColors = [
    Color(0xFF4A7A4A), Color(0xFF4A5A7A), Color(0xFF7A4A4A),
    Color(0xFF7A5A4A), Color(0xFF4A6A6A), Color(0xFF6A4A7A),
    Color(0xFF5A7A5A), Color(0xFF7A6A4A),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _accentColors[index % _accentColors.length];
    return Theme(
      data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
      child: ExpansionTile(
        initiallyExpanded: false,
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
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(6),
          ),
          alignment: Alignment.center,
          child: Text(
            '${index + 1}',
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        children: [
          if (diagramLabel != null)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
              child: _DiagramPlaceholder(label: diagramLabel!),
            ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
            child: MarkdownBody(
              data: content,
              styleSheet: mdStyle,
              softLineBreak: true,
            ),
          ),
        ],
      ),
    );
  }
}

/// 圖片佔位卡（無實際圖片時顯示視覺錨點）
class _DiagramPlaceholder extends StatelessWidget {
  const _DiagramPlaceholder({required this.label});
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1E1A),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.accent.withValues(alpha: 0.3)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppTheme.accent.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.straighten_rounded,
                color: AppTheme.accent, size: 22),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Colors.white)),
                const SizedBox(height: 3),
                const Text('（動作示意圖）',
                    style: TextStyle(fontSize: 10, color: AppTheme.textSecond)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Tab 0 子元件：動作知識庫
// ════════════════════════════════════════════════════════════

class _ExerciseList extends StatelessWidget {
  const _ExerciseList({
    required this.exercises,
    required this.selected,
    required this.onSelect,
    required this.searchCtrl,
    required this.onSearch,
  });
  final List<(String, String, String, String)> exercises;
  final String selected;
  final void Function(String) onSelect;
  final TextEditingController searchCtrl;
  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
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
            TextField(
              controller: searchCtrl,
              onChanged: onSearch,
              decoration: InputDecoration(
                hintText: '搜尋動作...',
                prefixIcon: const Icon(Icons.search, size: 16),
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
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
        Expanded(
          child: ListView.builder(
            itemCount: exercises.length,
            itemBuilder: (_, i) {
              final e = exercises[i];
              return ListTile(
                leading: Text(e.$2, style: const TextStyle(fontSize: 18)),
                title: Text(e.$3,
                    style: const TextStyle(
                        fontSize: 11, fontWeight: FontWeight.w600)),
                subtitle: Text(e.$4,
                    style: const TextStyle(
                        fontSize: 9, color: AppTheme.textSecond)),
                selected: selected == e.$1,
                selectedTileColor: const Color(0xFF1B2410),
                selectedColor: AppTheme.accent,
                onTap: () => onSelect(e.$1),
                dense: true,
                visualDensity: VisualDensity.compact,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MovementGuidePanel extends StatelessWidget {
  const _MovementGuidePanel({required this.data, this.muscles});
  final MovementData data;
  final _ExerciseMuscles? muscles;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Text(data.name, style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 12),

        _GuideSection(
          icon: '🔴',
          title: '解剖聚焦',
          child: MarkdownBody(
              data: data.anatomyFocus,
              styleSheet: _kbMdStyle(),
              softLineBreak: true),
        ),

        // ── 人體解剖圖（flutter_body_atlas）────────────────────────
        if (muscles != null) ...[
          const SizedBox(height: 10),
          SizedBox(
            height: 260,
            child: AnatomyView(
              primaryMuscles: muscles!.primary,
              secondaryMuscles: muscles!.secondary,
              tertiaryMuscles: muscles!.tertiary,
            ),
          ),
        ],
        const SizedBox(height: 10),

        _GuideSection(
          icon: '⚙️',
          title: '力學特徵',
          child: MarkdownBody(
              data: data.mechanics,
              styleSheet: _kbMdStyle(),
              softLineBreak: true),
        ),
        const SizedBox(height: 14),

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
                      style: const TextStyle(fontSize: 11, height: 1.5)),
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
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.center,
          child: Text('${index + 1}',
              style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w800, color: color)),
        ),
        title: Text(phase.title,
            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: MarkdownBody(
                data: phase.content,
                styleSheet: _kbMdStyle(),
                softLineBreak: true),
          ),
        ],
      ),
    );
  }
}
