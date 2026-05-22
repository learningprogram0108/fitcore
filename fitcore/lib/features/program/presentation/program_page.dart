import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../app/theme/app_theme.dart';
import '../domain/movement_data.dart';
import '../domain/workout_session_notifier.dart';
import 'exercise_detail_page.dart';

// ── 資料結構 ────────────────────────────────────────────────
class _ExerciseEntry {
  const _ExerciseEntry({
    required this.emoji,
    required this.name,
    required this.movementId,
    required this.prescription,
    this.note = '',
    this.isOptional = false,
  });
  final String emoji;
  final String name;
  final String movementId;
  final String prescription;
  final String note;
  /// 標記為可選（如奇偶週輪替動作）
  final bool isOptional;

  _ExerciseEntry copyWith({
    String? emoji,
    String? name,
    String? movementId,
    String? prescription,
    String? note,
    bool? isOptional,
  }) =>
      _ExerciseEntry(
        emoji: emoji ?? this.emoji,
        name: name ?? this.name,
        movementId: movementId ?? this.movementId,
        prescription: prescription ?? this.prescription,
        note: note ?? this.note,
        isOptional: isOptional ?? this.isOptional,
      );
}

class _DayData {
  const _DayData({
    required this.dayNum,
    required this.title,
    required this.focus,
    required this.exercises,
    required this.coachNotes,
  });
  final int dayNum;
  final String title, focus;
  final List<_ExerciseEntry> exercises;
  final List<String> coachNotes;

  _DayData copyWith({List<_ExerciseEntry>? exercises}) => _DayData(
        dayNum: dayNum,
        title: title,
        focus: focus,
        exercises: exercises ?? this.exercises,
        coachNotes: coachNotes,
      );
}

// ── 預設課表資料（Movement Bible 完整版）────────────────────
const List<_DayData> _defaultDays = [
  _DayData(
    dayNum: 1,
    title: '下肢推力 + 核心',
    focus: '矢狀面主導 · 漸進超負荷',
    exercises: [
      _ExerciseEntry(
        emoji: '🏋️',
        name: '槓鈴背蹲舉（高背槓）',
        movementId: 'squat',
        prescription: '4×6 @RPE 8',
        note: '高槓位，深度至股骨平行',
      ),
      _ExerciseEntry(
        emoji: '🦵',
        name: '保加利亞分腿蹲',
        movementId: 'bulgarian',
        prescription: '3×10 each',
        note: '後腳放置椅上，前腳踩穩',
      ),
      _ExerciseEntry(
        emoji: '🚶',
        name: '農夫走路',
        movementId: 'farmers_walk',
        prescription: '4×20m',
        note: '核心鎖緊，肩胛下壓',
      ),
      _ExerciseEntry(
        emoji: '🦶',
        name: '站姿提踵',
        movementId: 'calf_raise',
        prescription: '4×15',
        note: '底部死停2秒消除彈性',
      ),
      _ExerciseEntry(
        emoji: '🌀',
        name: '哥本哈根側平舉',
        movementId: 'copenhagen',
        prescription: '3×12 each',
        note: '內收肌群特化，額狀面抗剪力',
      ),
    ],
    coachNotes: [
      '瓦氏法：深吸氣→撐腹→下蹲→呼氣鎖定後推起',
      '膝蓋追蹤第2-3趾，避免膝外翻',
      'Week 3 峰值週：組間休息 3 分鐘',
    ],
  ),
  _DayData(
    dayNum: 2,
    title: '上肢推拉 + 手臂',
    focus: '水平推拉平衡 · 肩胛穩定',
    exercises: [
      _ExerciseEntry(
        emoji: '💪',
        name: '槓鈴臥推',
        movementId: 'bench',
        prescription: '4×6 @RPE 8',
        note: '肩胛下壓後縮，軟暫停觸胸',
      ),
      _ExerciseEntry(
        emoji: '🔽',
        name: '正手寬握引體向上',
        movementId: 'pullup',
        prescription: '4×AMRAP',
        note: '全ROM，主動懸掛啟動上背',
      ),
      _ExerciseEntry(
        emoji: '🏔️',
        name: '槓鈴肩推',
        movementId: 'ohp',
        prescription: '3×6 @RPE 8',
        note: '站姿，前臂垂直，藏頭進窗',
      ),
      _ExerciseEntry(
        emoji: '🎯',
        name: '滑輪面拉',
        movementId: 'face_pull',
        prescription: '3×15 @RPE 7',
        note: '大拇指朝後，W字型頂峰收縮',
      ),
      _ExerciseEntry(
        emoji: '🔧',
        name: '滑輪三頭下壓',
        movementId: 'triceps_pushdown',
        prescription: '3×12 @RPE 7',
        note: '上臂死貼肋骨，底部擠壓2秒',
      ),
    ],
    coachNotes: [
      '臥推：大拇指扣握，腿部驅動力傳遞至槓鈴',
      '推拉比例 1:1，面拉保護肩關節長期健康',
      'RIR 目標：前3組 RIR 2，最後組 RIR 1',
    ],
  ),
  _DayData(
    dayNum: 3,
    title: '下肢後鏈 + 核心',
    focus: '後側鏈主導 · 髖伸展力量',
    exercises: [
      _ExerciseEntry(
        emoji: '🔩',
        name: '六角槓硬舉',
        movementId: 'hex_deadlift',
        prescription: '4×5 @RPE 8.5',
        note: '雙腿蹬地，背部鋼板不彎曲',
      ),
      _ExerciseEntry(
        emoji: '💡',
        name: '澤奇深蹲',
        movementId: 'zercher',
        prescription: '3×6 @RPE 7',
        note: '前載荷核心特化，用胸骨撞天花板',
      ),
      _ExerciseEntry(
        emoji: '🎿',
        name: '北歐腿彎舉（奇數週）',
        movementId: 'nordic',
        prescription: '3×5 離心',
        note: '奇數週 · 純離心，3-5秒下放',
        isOptional: true,
      ),
      _ExerciseEntry(
        emoji: '⚖️',
        name: '單腿羅馬尼亞硬舉（偶數週）',
        movementId: 'rdl',
        prescription: '3×8 each',
        note: '偶數週 · 後腳如長槍向後刺',
        isOptional: true,
      ),
      _ExerciseEntry(
        emoji: '🪑',
        name: '坐姿腿彎舉',
        movementId: 'leg_curl',
        prescription: '3×12 @RPE 7',
        note: '拉長位肌肥大，3秒慢速回放',
      ),
    ],
    coachNotes: [
      '硬舉起始：想像「雙腿踩穿地板」而非用腰拉',
      '澤奇深蹲：維持上背剛性，防止含胸代償',
      'Nordic 或 RDL 擇一（奇/偶週輪替），記錄週次',
    ],
  ),
  _DayData(
    dayNum: 4,
    title: '上肢輔助 + 核心終結',
    focus: '深層核心 · 上背厚度 · 動作收尾',
    exercises: [
      _ExerciseEntry(
        emoji: '📐',
        name: '仰臥划船',
        movementId: 'inverted_row',
        prescription: '3×12',
        note: '身體化鋼板，胸口貼槓1秒',
      ),
      _ExerciseEntry(
        emoji: '📈',
        name: '啞鈴上斜臥推',
        movementId: 'incline_press',
        prescription: '3×10 @RPE 7',
        note: '30度角，肘45度，軟暫停底部',
      ),
      _ExerciseEntry(
        emoji: '⬇️',
        name: '寬握滑輪下拉',
        movementId: 'lat_pulldown',
        prescription: '4×10',
        note: '大腿墊死壓，手肘砸地板',
      ),
      _ExerciseEntry(
        emoji: '⬆️',
        name: '雙槓撐體',
        movementId: 'dips',
        prescription: '3×10',
        note: '前傾30度，特化胸下緣力臂',
      ),
      _ExerciseEntry(
        emoji: '🏗️',
        name: 'TRX 平板撐',
        movementId: 'trx_plank',
        prescription: '3×45s',
        note: '不穩定面深層核心，抗晃動',
      ),
    ],
    coachNotes: [
      'Day 4 是輔助日：控制強度 RPE ≤ 7.5',
      'TRX平板撐：前臂向下壓碎地板，根除翼狀肩胛',
      '本週最後訓練日：完成後做 10 分鐘靜態伸展',
    ],
  ),
];

// ── 課表頁面 ─────────────────────────────────────────────────
class ProgramPage extends ConsumerStatefulWidget {
  const ProgramPage({super.key});

  @override
  ConsumerState<ProgramPage> createState() => _ProgramPageState();
}

class _ProgramPageState extends ConsumerState<ProgramPage> {
  int _selectedDay = 0;
  late List<_DayData> _mutableDays;

  @override
  void initState() {
    super.initState();
    _mutableDays = List.from(_defaultDays);
  }

  void _replaceExercise(int dayIdx, int exIdx, String newMovementId) {
    final data = MovementLibrary.find(newMovementId);
    if (data == null) return;
    final oldEntry = _mutableDays[dayIdx].exercises[exIdx];
    final newEntry = oldEntry.copyWith(
      name: data.name,
      movementId: newMovementId,
      note: data.anatomyFocus.split('/').first.trim(),
    );
    final newExercises =
        List<_ExerciseEntry>.from(_mutableDays[dayIdx].exercises);
    newExercises[exIdx] = newEntry;
    setState(() {
      _mutableDays[dayIdx] = _mutableDays[dayIdx].copyWith(exercises: newExercises);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _TopBar(),
        const _MesocycleTimeline(),
        Expanded(
          child: _ProgramBody(
            days: _mutableDays,
            selectedDay: _selectedDay,
            onDaySelected: (i) => setState(() => _selectedDay = i),
            onReplaceExercise: _replaceExercise,
          ),
        ),
      ],
    );
  }
}

// ── 頂部資訊欄 ───────────────────────────────────────────────
class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(24, 16, 24, 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.border)),
    ),
    child: Row(children: [
      Expanded(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text('4天全身功能性肌力週期化',
              style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 2),
          const Text('Mesocycle 1 · Week 3/4 · 漸進超負荷週',
              style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
        ]),
      ),
      const _WeekBadge('3', '當前週', AppTheme.accent),
      const SizedBox(width: 8),
      const _WeekBadge('21', '訓練天', AppTheme.accentWarm),
    ]),
  );
}

class _WeekBadge extends StatelessWidget {
  const _WeekBadge(this.value, this.label, this.color);
  final String value, label;
  final Color color;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
    decoration: BoxDecoration(
      color: AppTheme.surface2,
      borderRadius: BorderRadius.circular(8),
    ),
    child: Column(children: [
      Text(value,
          style: TextStyle(
              fontSize: 18, fontWeight: FontWeight.w800, color: color)),
      Text(label,
          style: const TextStyle(fontSize: 8, color: AppTheme.textSecond)),
    ]),
  );
}

// ── Mesocycle 週期概覽 ────────────────────────────────────────
class _MesocycleTimeline extends StatelessWidget {
  const _MesocycleTimeline();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 12),
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: AppTheme.border)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('MESOCYCLE 週期概覽',
              style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.5,
                  color: AppTheme.textSecond)),
          SizedBox(height: 8),
          Row(children: [
            _WeekBlock(label: 'Week 1', subtitle: '張力積累',
                isActive: false, isComplete: true),
            SizedBox(width: 8),
            _WeekBlock(label: 'Week 2', subtitle: '強度提升',
                isActive: false, isComplete: true),
            SizedBox(width: 8),
            _WeekBlock(label: 'Week 3', subtitle: '峰值衝刺',
                isActive: true, isComplete: false),
            SizedBox(width: 8),
            _WeekBlock(label: 'Week 4 🔻', subtitle: '降量恢復',
                isActive: false, isComplete: false, isDeload: true),
          ]),
        ],
      ),
    );
  }
}

class _WeekBlock extends StatelessWidget {
  const _WeekBlock({
    required this.label,
    required this.subtitle,
    required this.isActive,
    required this.isComplete,
    this.isDeload = false,
  });
  final String label, subtitle;
  final bool isActive, isComplete, isDeload;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFF1B2910) : AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isActive ? AppTheme.accent : AppTheme.border,
          width: isActive ? 1.5 : 1,
        ),
      ),
      child: Column(children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 5, 8, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 9,
                  fontWeight: FontWeight.w700,
                  color: isDeload
                      ? AppTheme.accentWarm
                      : isActive
                          ? AppTheme.accent
                          : AppTheme.textSecond,
                ),
              ),
              Text(
                subtitle,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 8, color: AppTheme.textDisabled),
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
          child: Row(
            children: List.generate(4, (i) => Expanded(
              child: Container(
                height: 4,
                margin: const EdgeInsets.only(right: 2),
                decoration: BoxDecoration(
                  color: isComplete
                      ? AppTheme.accent
                      : isActive && i < 2
                          ? AppTheme.accent
                          : AppTheme.border2,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            )),
          ),
        ),
      ]),
    ),
  );
}

// ── 主體佈局 ─────────────────────────────────────────────────
class _ProgramBody extends StatelessWidget {
  const _ProgramBody({
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
    required this.onReplaceExercise,
  });
  final List<_DayData> days;
  final int selectedDay;
  final void Function(int) onDaySelected;
  final void Function(int dayIdx, int exIdx, String newId) onReplaceExercise;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 720;
    final day = days[selectedDay];
    if (isDesktop) {
      return Row(
        children: [
          SizedBox(
            width: 260,
            child: _DayCardList(
              days: days,
              selectedDay: selectedDay,
              onDaySelected: onDaySelected,
            ),
          ),
          const VerticalDivider(width: 1),
          Expanded(
            child: _MovementDetail(
              day: day,
              dayIdx: selectedDay,
              onReplaceExercise: onReplaceExercise,
            ),
          ),
          const VerticalDivider(width: 1),
          SizedBox(width: 280, child: _ProgramInfo(day: day)),
        ],
      );
    }
    return _DayCardList(
      days: days,
      selectedDay: selectedDay,
      onDaySelected: onDaySelected,
    );
  }
}

// ── Day Card 列表 ─────────────────────────────────────────────
class _DayCardList extends StatelessWidget {
  const _DayCardList({
    required this.days,
    required this.selectedDay,
    required this.onDaySelected,
  });
  final List<_DayData> days;
  final int selectedDay;
  final void Function(int) onDaySelected;

  @override
  Widget build(BuildContext context) => ListView.separated(
    padding: const EdgeInsets.all(12),
    itemCount: days.length,
    separatorBuilder: (_, __) => const SizedBox(height: 8),
    itemBuilder: (_, i) => _DayCard(
      day: days[i],
      isToday: i == 0,
      isSelected: i == selectedDay,
      onTap: () => onDaySelected(i),
    ),
  );
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day,
    required this.isToday,
    required this.isSelected,
    required this.onTap,
  });
  final _DayData day;
  final bool isToday, isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final borderColor = isSelected
        ? AppTheme.accent
        : isToday
            ? AppTheme.accent.withAlpha(150)
            : AppTheme.border;
    final borderWidth = isSelected ? 2.0 : (isToday ? 1.5 : 1.0);

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Card(
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
          side: BorderSide(color: borderColor, width: borderWidth),
        ),
        color: isSelected ? const Color(0xFF1B2910) : null,
        child: Column(children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
            child: Row(children: [
              Container(
                width: 28, height: 28,
                decoration: BoxDecoration(
                  color: isSelected || isToday
                      ? AppTheme.accentDim
                      : AppTheme.surface3,
                  borderRadius: BorderRadius.circular(7),
                ),
                alignment: Alignment.center,
                child: Text(
                  'D${day.dayNum}',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: (isSelected || isToday)
                        ? AppTheme.accent
                        : AppTheme.textSecond,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(day.title,
                        style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                    if (isToday)
                      const Text('▶ 今日訓練',
                          style: TextStyle(fontSize: 8, color: AppTheme.accent)),
                    Text(day.focus,
                        style: const TextStyle(fontSize: 8, color: AppTheme.textDisabled)),
                  ],
                ),
              ),
              if (isSelected)
                const Icon(Icons.chevron_right, size: 14, color: AppTheme.accent),
            ]),
          ),
          ...day.exercises.map(
            (e) => Padding(
              padding: const EdgeInsets.fromLTRB(14, 2, 14, 2),
              child: Row(children: [
                Text(e.emoji, style: const TextStyle(fontSize: 10)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    '${e.name} — ${e.prescription}',
                    style: const TextStyle(fontSize: 10),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ]),
            ),
          ),
          const SizedBox(height: 8),
        ]),
      ),
    );
  }
}

// ── 動作詳情面板（中欄）────────────────────────────────────────
class _MovementDetail extends ConsumerWidget {
  const _MovementDetail({
    required this.day,
    required this.dayIdx,
    required this.onReplaceExercise,
  });
  final _DayData day;
  final int dayIdx;
  final void Function(int dayIdx, int exIdx, String newId) onReplaceExercise;

  bool _isComplete(WorkoutSessionState session) {
    final required = day.exercises.where((e) => !e.isOptional);
    final optional = day.exercises.where((e) => e.isOptional);
    final requiredDone = required.every((e) => session.hasAnySets(e.movementId));
    final optionalOk = optional.isEmpty ||
        optional.any((e) => session.hasAnySets(e.movementId));
    return requiredDone && optionalOk;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final session = ref.watch(workoutSessionProvider);
    final isDesktop = MediaQuery.of(context).size.width >= 720;
    final complete = _isComplete(session);

    return Column(
      children: [
        Expanded(
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Text(
                'Day ${day.dayNum}  ${day.title}',
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 2),
              Text(day.focus,
                  style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
              const SizedBox(height: 20),

              _SectionLabel('訓練動作（Week 3 · ${day.exercises.length} 個動作）'),
              const SizedBox(height: 8),

              ...day.exercises.asMap().entries.map(
                (e) => _ExerciseRow(
                  exercise: e.value,
                  exIdx: e.key,
                  dayIdx: dayIdx,
                  session: session,
                  isDesktop: isDesktop,
                  onNavigate: () => _navigateToDetail(context, e.value),
                  onReplace: () => _showReplace(context, e.key),
                ),
              ),

              const SizedBox(height: 20),
              const _SectionLabel('教練提示'),
              const SizedBox(height: 8),
              ...day.coachNotes.map((note) => _BulletNote(note: note)),
            ],
          ),
        ),

        // ── 完成今日訓練 按鈕 ──
        Container(
          padding: const EdgeInsets.fromLTRB(16, 10, 16, 16),
          decoration: const BoxDecoration(
            border: Border(top: BorderSide(color: AppTheme.border)),
          ),
          child: session.isCompleted
              ? const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.check_circle, color: AppTheme.accent, size: 18),
                    SizedBox(width: 8),
                    Text('今日訓練已完成並寫入日誌',
                        style: TextStyle(color: AppTheme.accent, fontWeight: FontWeight.w600)),
                  ],
                )
              : SizedBox(
                  width: double.infinity,
                  child: FilledButton.icon(
                    style: FilledButton.styleFrom(
                      backgroundColor: complete
                          ? AppTheme.accent
                          : AppTheme.surface3,
                      foregroundColor: complete
                          ? Colors.black
                          : AppTheme.textDisabled,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    icon: Icon(complete
                        ? Icons.emoji_events
                        : Icons.lock_outline,
                        size: 18),
                    label: Text(
                      complete
                          ? '✓ 完成今日訓練 — 寫入日誌'
                          : '完成所有動作後解鎖',
                      style: const TextStyle(fontWeight: FontWeight.w700),
                    ),
                    onPressed: complete ? () => _completeSession(context, ref) : null,
                  ),
                ),
        ),
      ],
    );
  }

  void _navigateToDetail(BuildContext context, _ExerciseEntry exercise) {
    context.go(
      '/program/exercise/${exercise.movementId}',
      extra: ExerciseExtra(
        name: exercise.name,
        prescription: exercise.prescription,
        dayNum: dayIdx + 1,
      ),
    );
  }

  void _showReplace(BuildContext context, int exIdx) {
    showDialog(
      context: context,
      builder: (_) => _ReplaceExerciseDialog(
        onSelected: (newId) {
          Navigator.of(context, rootNavigator: true).pop();
          onReplaceExercise(dayIdx, exIdx, newId);
        },
      ),
    );
  }

  Future<void> _completeSession(BuildContext context, WidgetRef ref) async {
    final notifier = ref.read(workoutSessionProvider.notifier);
    await notifier.completeSession(dayNum: dayIdx + 1, weekNum: 3);
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('🎉 訓練已記錄至日誌'),
          backgroundColor: Color(0xFF2A4A10),
        ),
      );
      context.go('/log');
    }
  }
}

// ── 訓練動作行 ────────────────────────────────────────────────
class _ExerciseRow extends StatelessWidget {
  const _ExerciseRow({
    required this.exercise,
    required this.exIdx,
    required this.dayIdx,
    required this.session,
    required this.isDesktop,
    required this.onNavigate,
    required this.onReplace,
  });
  final _ExerciseEntry exercise;
  final int exIdx, dayIdx;
  final WorkoutSessionState session;
  final bool isDesktop;
  final VoidCallback onNavigate;
  final VoidCallback onReplace;

  @override
  Widget build(BuildContext context) {
    final loggedCount = session.totalSets(exercise.movementId);
    final hasData = loggedCount > 0;

    return Container(
      margin: const EdgeInsets.only(bottom: 6),
      child: InkWell(
        borderRadius: BorderRadius.circular(8),
        onTap: isDesktop
            ? () => _showDesktopOptions(context)
            : onNavigate,
        onLongPress: isDesktop ? null : onReplace,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
          decoration: BoxDecoration(
            color: hasData
                ? const Color(0xFF141E0A)
                : AppTheme.surface2,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: hasData
                  ? AppTheme.accent.withAlpha(120)
                  : exercise.isOptional
                      ? AppTheme.border.withAlpha(100)
                      : AppTheme.border,
            ),
          ),
          child: Row(children: [
            Text(exercise.emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 10),
            Expanded(
              child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Row(children: [
                  Expanded(
                    child: Text(exercise.name,
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                  ),
                  if (exercise.isOptional)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: AppTheme.surface3,
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text('輪替',
                          style: TextStyle(fontSize: 8, color: AppTheme.textDisabled)),
                    ),
                ]),
                Text(exercise.note,
                    style: const TextStyle(fontSize: 9, color: AppTheme.textSecond)),
              ]),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppTheme.accentDim,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                exercise.prescription,
                style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accent),
              ),
            ),
            const SizedBox(width: 8),
            // 已記錄組數
            SizedBox(
              width: 48,
              child: hasData
                  ? Row(mainAxisSize: MainAxisSize.min, children: [
                      const Icon(Icons.check_circle, color: AppTheme.accent, size: 13),
                      const SizedBox(width: 3),
                      Text('$loggedCount 組',
                          style: const TextStyle(
                              fontSize: 9,
                              color: AppTheme.accent,
                              fontWeight: FontWeight.w600)),
                    ])
                  : const Icon(Icons.chevron_right, size: 16, color: AppTheme.textDisabled),
            ),
          ]),
        ),
      ),
    );
  }

  void _showDesktopOptions(BuildContext context) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: const Color(0xFF181818),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(exercise.name,
                style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
            Text(exercise.prescription,
                style: const TextStyle(fontSize: 11, color: AppTheme.textSecond)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.fitness_center, color: AppTheme.accent),
              title: const Text('▶ 進入訓練記錄',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('記錄組數、重量、RPE',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                onNavigate();
              },
            ),
            const Divider(color: AppTheme.border, height: 1),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: AppTheme.accentWarm),
              title: const Text('🔄 更換動作',
                  style: TextStyle(fontWeight: FontWeight.w600)),
              subtitle: const Text('從知識庫選擇替代動作',
                  style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
              onTap: () {
                Navigator.of(context, rootNavigator: true).pop();
                onReplace();
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ── 動作替換 Dialog ───────────────────────────────────────────
class _ReplaceExerciseDialog extends StatefulWidget {
  const _ReplaceExerciseDialog({required this.onSelected});
  final void Function(String movementId) onSelected;

  @override
  State<_ReplaceExerciseDialog> createState() => _ReplaceExerciseDialogState();
}

class _ReplaceExerciseDialogState extends State<_ReplaceExerciseDialog> {
  final _searchCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchCtrl.dispose();
    super.dispose();
  }

  List<MovementData> get _filtered {
    final q = _query.toLowerCase();
    if (q.isEmpty) return MovementLibrary.all.toList();
    return MovementLibrary.all
        .where((d) =>
            d.name.toLowerCase().contains(q) || d.id.contains(q))
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF181818),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text('🔄 更換動作',
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
      content: SizedBox(
        width: 380,
        height: 420,
        child: Column(
          children: [
            TextField(
              controller: _searchCtrl,
              autofocus: true,
              decoration: InputDecoration(
                hintText: '搜尋動作名稱...',
                prefixIcon: const Icon(Icons.search, size: 18),
                filled: true,
                fillColor: AppTheme.surface3,
                isDense: true,
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: const BorderSide(color: AppTheme.border)),
              ),
              onChanged: (v) => setState(() => _query = v),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.builder(
                itemCount: _filtered.length,
                itemBuilder: (_, i) {
                  final d = _filtered[i];
                  return ListTile(
                    dense: true,
                    title: Text(d.name,
                        style: const TextStyle(fontSize: 12)),
                    subtitle: Text(
                      d.anatomyFocus.split('/').first.trim(),
                      style: const TextStyle(
                          fontSize: 10, color: AppTheme.textSecond),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    onTap: () => widget.onSelected(d.id),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BulletNote extends StatelessWidget {
  const _BulletNote({required this.note});
  final String note;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.only(bottom: 6),
    child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text('·  ',
          style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.accent)),
      Expanded(
        child: Text(note, style: const TextStyle(fontSize: 11, height: 1.5)),
      ),
    ]),
  );
}

// ── 右側週期化資訊面板 ────────────────────────────────────────
class _ProgramInfo extends StatelessWidget {
  const _ProgramInfo({required this.day});
  final _DayData day;

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(14),
    children: [
      const _SectionLabel('週期化狀態'),
      const SizedBox(height: 8),
      const _InfoCard(children: [
        _InfoRow('當前週', 'Week 3 / 4', AppTheme.accent),
        _InfoRow('週期類型', '峰值衝刺週', AppTheme.accentWarm),
        _InfoRow('目標 RPE', '8 – 8.5', AppTheme.muscPrimary),
        _InfoRow('下週', '降量週 🔻', AppTheme.textSecond),
      ]),
      const SizedBox(height: 16),
      const _SectionLabel('RIR 留力指引'),
      const SizedBox(height: 8),
      const _InfoCard(children: [
        _RirRow('RIR 4+', '熱身 / 準備組', AppTheme.border2),
        _RirRow('RIR 3', '輕鬆訓練', AppTheme.textDisabled),
        _RirRow('RIR 2', '主要工作組目標', AppTheme.muscTertiary),
        _RirRow('RIR 1', '衝刺（最後組）', AppTheme.muscSecond),
        _RirRow('RIR 0', '力竭（測試用）', AppTheme.muscPrimary),
      ]),
      const SizedBox(height: 16),
      const _SectionLabel('Week 4 降量週'),
      const SizedBox(height: 8),
      Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: AppTheme.surface2,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppTheme.border),
        ),
        child: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Volume -40%  ·  Intensity 維持',
                style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.accentWarm)),
            SizedBox(height: 6),
            Text(
              '降量週目的是神經系統恢復與超量恢復。'
              '組數減少但重量不降，讓身體適應後達到更高峰值。',
              style: TextStyle(fontSize: 10, height: 1.6),
            ),
          ],
        ),
      ),
    ],
  );
}

// ── 共用小元件 ───────────────────────────────────────────────
class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.children});
  final List<Widget> children;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.all(10),
    decoration: BoxDecoration(
      color: AppTheme.surface2,
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: AppTheme.border),
    ),
    child: Column(children: children),
  );
}

class _InfoRow extends StatelessWidget {
  const _InfoRow(this.label, this.value, this.valueColor);
  final String label, value;
  final Color valueColor;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(children: [
      Expanded(
        child: Text(label,
            style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
      ),
      Text(value,
          style: TextStyle(
              fontSize: 10, fontWeight: FontWeight.w700, color: valueColor)),
    ]),
  );
}

class _RirRow extends StatelessWidget {
  const _RirRow(this.rir, this.desc, this.color);
  final String rir, desc;
  final Color color;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 3),
    child: Row(children: [
      Container(
        width: 40,
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          color: color.withAlpha(40),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(rir,
            textAlign: TextAlign.center,
            style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700, color: color)),
      ),
      const SizedBox(width: 8),
      Expanded(
        child: Text(desc,
            style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
      ),
    ]),
  );
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) => Text(
    text,
    style: const TextStyle(
      fontSize: 9,
      fontWeight: FontWeight.w700,
      letterSpacing: 1.5,
      color: AppTheme.textSecond,
    ),
  );
}
