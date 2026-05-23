import 'package:flutter/material.dart';
import '../../../app/theme/app_theme.dart';
import '../../program/domain/movement_data.dart';
import '../domain/big_three_data.dart';

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
  String _selectedSectionId = '';

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _selectedExercise = widget.initialExercise ?? 'squat';

    // 預設選第一章第一節
    if (BigThreeLibrary.chapters.isNotEmpty) {
      _selectedChapterId = BigThreeLibrary.chapters.first.id;
      if (BigThreeLibrary.chapters.first.sections.isNotEmpty) {
        _selectedSectionId = BigThreeLibrary.chapters.first.sections.first.id;
      }
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _searchCtrl.dispose();
    super.dispose();
  }

  // ── 20 個動作列表 ───────────────────────────────────────────
  static const _exercises = [
    ('squat',            '🏋️', '槓鈴背蹲舉（高背槓）',    '下肢推 · Day 1'),
    ('bulgarian',        '🦵', '保加利亞分腿蹲',          '單側下肢推 · Day 1'),
    ('farmers_walk',     '🚶', '農夫走路',                '攜重行走 · Day 1'),
    ('calf_raise',       '🦶', '站姿提踵',                '小腿特化 · Day 1'),
    ('copenhagen',       '🌀', '哥本哈根側平舉',          '內收肌群 · Day 1'),
    ('bench',            '💪', '槓鈴臥推',                '水平推 · Day 2'),
    ('pullup',           '🔽', '正手寬握引體向上',         '垂直拉 · Day 2'),
    ('ohp',              '🏔️', '槓鈴肩推',                '垂直推 · Day 2'),
    ('face_pull',        '🎯', '滑輪面拉',                '後三角 · Day 2'),
    ('triceps_pushdown', '🔧', '滑輪三頭下壓',            '三頭特化 · Day 2'),
    ('hex_deadlift',     '🔩', '六角槓硬舉',              '全身後鏈 · Day 3'),
    ('zercher',          '💡', '澤奇深蹲',                '核心前載 · Day 3'),
    ('nordic',           '🎿', '北歐腿彎舉',              '離心腿後 · Day 3'),
    ('rdl',              '⚖️', '單腿羅馬尼亞硬舉',         '單側後鏈 · Day 3'),
    ('leg_curl',         '🪑', '坐姿腿彎舉',              '拉長腿後 · Day 3'),
    ('inverted_row',     '📐', '仰臥划船',                '水平拉 · Day 4'),
    ('incline_press',    '📈', '啞鈴上斜臥推',            '胸上部 · Day 4'),
    ('lat_pulldown',     '⬇️', '寬握滑輪下拉',            '背部寬度 · Day 4'),
    ('dips',             '⬆️', '雙槓撐體',                '胸下推 · Day 4'),
    ('trx_plank',        '🏗️', 'TRX 平板撐',             '深層核心 · Day 4'),
  ];

  List<(String, String, String, String)> get _filteredExercises {
    final q = _searchQuery.toLowerCase();
    if (q.isEmpty) return _exercises;
    return _exercises
        .where((e) => e.$3.toLowerCase().contains(q) || e.$4.toLowerCase().contains(q))
        .toList();
  }

  BigThreeSection? get _currentBigThreeSection {
    final chapter = BigThreeLibrary.findChapter(_selectedChapterId);
    if (chapter == null) return null;
    for (final s in chapter.sections) {
      if (s.id == _selectedSectionId) return s;
    }
    return null;
  }

  // ── Build ────────────────────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // TabBar
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
        // TabBarView
        Expanded(
          child: TabBarView(
            controller: _tabController,
            children: [
              _buildMovementTab(),
              _buildBigThreeTab(),
              _buildPtPlaceholder(),
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
            child: _MovementGuidePanel(data: movementData),
          ),
        ],
      ],
    );
  }

  // ── Tab 1: 健力三項知識庫 ────────────────────────────────────
  Widget _buildBigThreeTab() {
    final selectedSection = _currentBigThreeSection;
    return Row(
      children: [
        // 左側：章節樹（40%）
        SizedBox(
          width: MediaQuery.of(context).size.width * 0.40,
          child: _BigThreeChapterList(
            selectedChapterId: _selectedChapterId,
            selectedSectionId: _selectedSectionId,
            onSectionSelected: (chapterId, sectionId) {
              setState(() {
                _selectedChapterId = chapterId;
                _selectedSectionId = sectionId;
              });
            },
          ),
        ),
        // 分隔線
        const VerticalDivider(width: 1, thickness: 1, color: AppTheme.border),
        // 右側：章節內容（60%）
        Expanded(
          child: selectedSection != null
              ? _BigThreeSectionContent(section: selectedSection)
              : const Center(
                  child: Text('請選擇章節',
                      style: TextStyle(color: AppTheme.textSecond)),
                ),
        ),
      ],
    );
  }

  // ── Tab 2: 物理治療（佔位）───────────────────────────────────
  Widget _buildPtPlaceholder() {
    return Center(
      child: Container(
        margin: const EdgeInsets.all(32),
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppTheme.border),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('🏥', style: TextStyle(fontSize: 52)),
            const SizedBox(height: 20),
            Text('即將推出',
                style: Theme.of(context)
                    .textTheme
                    .titleLarge
                    ?.copyWith(color: AppTheme.accent)),
            const SizedBox(height: 10),
            const Text(
              '物理治療與功能重建知識庫',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            const Text(
              '資料整理中，請稍後',
              style: TextStyle(color: AppTheme.textSecond, fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Tab 0 子元件
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
  const _MovementGuidePanel({required this.data});
  final MovementData data;

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
          child: Text(data.anatomyFocus,
              style: const TextStyle(fontSize: 12, height: 1.5)),
        ),
        const SizedBox(height: 10),

        _GuideSection(
          icon: '⚙️',
          title: '力學特徵',
          child: Text(data.mechanics,
              style: const TextStyle(fontSize: 12, height: 1.5)),
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
            child: Text(phase.content,
                style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFFBBBBBB),
                    height: 1.6)),
          ),
        ],
      ),
    );
  }
}

// ════════════════════════════════════════════════════════════
//  Tab 1 子元件：健力三項知識庫
// ════════════════════════════════════════════════════════════

class _BigThreeChapterList extends StatelessWidget {
  const _BigThreeChapterList({
    required this.selectedChapterId,
    required this.selectedSectionId,
    required this.onSectionSelected,
  });
  final String selectedChapterId;
  final String selectedSectionId;
  final void Function(String chapterId, String sectionId) onSectionSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('健力三項', style: Theme.of(context).textTheme.titleLarge),
              const Text('深蹲 · 臥推 · 硬舉 終極指南',
                  style: TextStyle(fontSize: 10, color: AppTheme.textSecond)),
            ],
          ),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: BigThreeLibrary.chapters.length,
            itemBuilder: (_, i) {
              final chapter = BigThreeLibrary.chapters[i];
              final isChapterSelected = chapter.id == selectedChapterId;
              return Theme(
                data: Theme.of(context)
                    .copyWith(dividerColor: Colors.transparent),
                child: ExpansionTile(
                  initiallyExpanded: isChapterSelected,
                  leading: Text(chapter.emoji,
                      style: const TextStyle(fontSize: 16)),
                  title: Text(chapter.title,
                      style: const TextStyle(
                          fontSize: 11, fontWeight: FontWeight.w600)),
                  subtitle: Text(chapter.subtitle,
                      style: const TextStyle(
                          fontSize: 9, color: AppTheme.textSecond)),
                  children: chapter.sections.map((section) {
                    final isSectionSelected = section.id == selectedSectionId;
                    return ListTile(
                      dense: true,
                      visualDensity: VisualDensity.compact,
                      contentPadding:
                          const EdgeInsets.only(left: 52, right: 12),
                      title: Text(
                        section.title,
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: isSectionSelected
                              ? FontWeight.w600
                              : FontWeight.w400,
                          color: isSectionSelected ? AppTheme.accent : null,
                        ),
                      ),
                      selected: isSectionSelected,
                      selectedTileColor: const Color(0xFF1B2410),
                      onTap: () =>
                          onSectionSelected(chapter.id, section.id),
                    );
                  }).toList(),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _BigThreeSectionContent extends StatelessWidget {
  const _BigThreeSectionContent({required this.section});
  final BigThreeSection section;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(20),
      children: [
        Text(section.title,
            style: Theme.of(context).textTheme.headlineMedium),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: AppTheme.border),
          ),
          child: Text(
            section.content,
            style: const TextStyle(
                fontSize: 13, height: 1.75, color: Color(0xFFCCCCCC)),
          ),
        ),
      ],
    );
  }
}
