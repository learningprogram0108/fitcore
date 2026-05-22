import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../app/theme/app_theme.dart';

class ProgramPage extends ConsumerWidget {
  const ProgramPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return const Column(
      children: [
        _TopBar(),
        _MesocycleTimeline(),
        Expanded(child: _ProgramBody()),
      ],
    );
  }
}

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
      Text(value, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: color)),
      Text(label, style: const TextStyle(fontSize: 8, color: AppTheme.textSecond)),
    ]),
  );
}

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
            style: TextStyle(fontSize: 9, fontWeight: FontWeight.w700,
              letterSpacing: 1.5, color: AppTheme.textSecond)),
          SizedBox(height: 8),
          Row(children: [
            _WeekBlock(label: 'Week 1', subtitle: '張力積累', isActive: false, isComplete: true),
            SizedBox(width: 8),
            _WeekBlock(label: 'Week 2', subtitle: '強度提升', isActive: false, isComplete: true),
            SizedBox(width: 8),
            _WeekBlock(label: 'Week 3', subtitle: '峰值衝刺', isActive: true,  isComplete: false),
            SizedBox(width: 8),
            _WeekBlock(label: 'Week 4 🔻', subtitle: '降量恢復', isActive: false, isComplete: false, isDeload: true),
          ]),
        ],
      ),
    );
  }
}

class _WeekBlock extends StatelessWidget {
  const _WeekBlock({
    required this.label, required this.subtitle,
    required this.isActive, required this.isComplete,
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
          padding: const EdgeInsets.fromLTRB(10, 5, 10, 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(label, style: TextStyle(
                fontSize: 9, fontWeight: FontWeight.w700,
                color: isDeload ? AppTheme.accentWarm :
                       isActive ? AppTheme.accent : AppTheme.textSecond,
              )),
              Text(subtitle, style: const TextStyle(fontSize: 8, color: AppTheme.textDisabled)),
            ],
          ),
        ),
        // 進度條
        Padding(
          padding: const EdgeInsets.fromLTRB(6, 0, 6, 6),
          child: Row(children: List.generate(4, (i) => Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.only(right: 2),
              decoration: BoxDecoration(
                color: isComplete ? AppTheme.accent
                     : isActive && i < 2 ? AppTheme.accent
                     : AppTheme.border2,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ))),
        ),
      ]),
    ),
  );
}

class _ProgramBody extends StatelessWidget {
  const _ProgramBody();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 720;
    if (isDesktop) {
      return const Row(
        children: [
          SizedBox(width: 260, child: _DayCardList()),
          VerticalDivider(width: 1),
          Expanded(child: _MovementDetail()),
          VerticalDivider(width: 1),
          SizedBox(width: 280, child: _ProgramInfo()),
        ],
      );
    }
    return const _DayCardList();
  }
}

class _DayCardList extends StatelessWidget {
  const _DayCardList();

  @override
  Widget build(BuildContext context) => ListView(
    padding: const EdgeInsets.all(12),
    children: const [
      _DayCard(day: 1, title: '下肢推力 + 核心', isToday: true,
        exercises: ['🏋️ 背蹲舉 — 4×6 @RPE 8',
                    '🦵 保加利亞分腿蹲 — 3×10',
                    '🚶 農夫走路 — 4×20m',
                    '🔘 立姿提踵 — 4×15']),
      SizedBox(height: 8),
      _DayCard(day: 2, title: '上肢推 + 水平拉', isToday: false,
        exercises: ['💪 臥推 — 4×6 @RPE 8',
                    '📐 啞鈴划船 — 4×10',
                    '🔧 北歐彎腿 — 3×6']),
      SizedBox(height: 8),
      _DayCard(day: 3, title: '下肢拉 + 爆發', isToday: false,
        exercises: ['🔩 硬舉 — 4×5 @RPE 8.5',
                    '🎯 羅馬尼亞硬舉 — 3×10',
                    '⚡ 壺鈴擺盪 — 4×15']),
      SizedBox(height: 8),
      _DayCard(day: 4, title: '垂直推拉 + 核心', isToday: false,
        exercises: ['🏔️ 過頭推舉 — 4×6',
                    '🔽 引體向上 — 4×AMRAP',
                    '🌀 Copenhagen Side — 3×12']),
    ],
  );
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.day, required this.title,
    required this.isToday, required this.exercises,
  });
  final int day;
  final String title;
  final bool isToday;
  final List<String> exercises;

  @override
  Widget build(BuildContext context) => Card(
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(10),
      side: BorderSide(
        color: isToday ? AppTheme.accent : AppTheme.border,
        width: isToday ? 1.5 : 1,
      ),
    ),
    child: Column(children: [
      // 標題
      Padding(
        padding: const EdgeInsets.fromLTRB(12, 10, 12, 8),
        child: Row(children: [
          Container(
            width: 28, height: 28,
            decoration: BoxDecoration(
              color: isToday ? AppTheme.accentDim : AppTheme.surface3,
              borderRadius: BorderRadius.circular(7),
            ),
            alignment: Alignment.center,
            child: Text('D$day', style: TextStyle(
              fontSize: 11, fontWeight: FontWeight.w800,
              color: isToday ? AppTheme.accent : AppTheme.textSecond,
            )),
          ),
          const SizedBox(width: 10),
          Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
            if (isToday)
              const Text('▶ 今日訓練', style: TextStyle(fontSize: 8, color: AppTheme.accent)),
          ])),
        ]),
      ),
      // 動作列表
      ...exercises.map((e) => Padding(
        padding: const EdgeInsets.fromLTRB(14, 2, 14, 2),
        child: Row(children: [
          Expanded(child: Text(e, style: const TextStyle(fontSize: 10))),
        ]),
      )),
      const SizedBox(height: 8),
    ]),
  );
}

class _MovementDetail extends StatelessWidget {
  const _MovementDetail();

  @override
  Widget build(BuildContext context) => const Center(
    child: Text('動作週期化進展\n(即將實作)', textAlign: TextAlign.center,
      style: TextStyle(color: AppTheme.textSecond, fontSize: 11)),
  );
}

class _ProgramInfo extends StatelessWidget {
  const _ProgramInfo();

  @override
  Widget build(BuildContext context) => const Center(
    child: Text('週期化原理\n降量週說明\nRIR 指引\n(即將實作)', textAlign: TextAlign.center,
      style: TextStyle(color: AppTheme.textSecond, fontSize: 11)),
  );
}
