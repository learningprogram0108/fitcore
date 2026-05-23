import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../program/domain/movement_data.dart';

class KnowledgeBasePage extends StatefulWidget {
  const KnowledgeBasePage({super.key, this.initialExercise});
  final String? initialExercise;

  @override
  State<KnowledgeBasePage> createState() => _KnowledgeBasePageState();
}

class _KnowledgeBasePageState extends State<KnowledgeBasePage> {
  late String _selectedExercise;
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


  MovementData? get _currentMovementData =>
      MovementLibrary.find(_selectedExercise);

  List<(String, String, String, String)> get _filteredExercises {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return _exercises;
    return _exercises
        .where((e) => e.$3.toLowerCase().contains(q) || e.$4.toLowerCase().contains(q))
        .toList();
  }

  void _selectExercise(String id) {
    setState(() {
      _selectedExercise = id;
    });
  }

  @override
  Widget build(BuildContext context) {
    final movementData = _currentMovementData;
    return Column(
      children: [
        Expanded(
          flex: 2,
          child: _ExerciseList(
            exercises: _filteredExercises,
            selected: _selectedExercise,
            onSelect: _selectExercise,
            searchCtrl: _searchCtrl,
            onSearch: (q) => setState(() => _searchQuery = q),
          ),
        ),
        if (movementData != null) ...[
          const Divider(height: 1, color: AppTheme.border),
          Expanded(
            flex: 3,
            child: _MovementGuidePanel(data: movementData),
          ),
        ],
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
  });
  final List<(String, String, String, String)> exercises;
  final String selected;
  final void Function(String) onSelect;
  final TextEditingController searchCtrl;
  final void Function(String) onSearch;

  @override
  Widget build(BuildContext context) {
    final listWidget = ListView.builder(
      itemCount: exercises.length,
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
        Expanded(child: listWidget),
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
