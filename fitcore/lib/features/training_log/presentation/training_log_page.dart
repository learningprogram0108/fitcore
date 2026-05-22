import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../domain/one_rm_calculator.dart';
import 'widgets/exercise_card.dart';

/// 訓練日誌頁面
/// 三欄佈局（桌面）/ 單頁滾動（行動端）
class TrainingLogPage extends ConsumerStatefulWidget {
  const TrainingLogPage({super.key});

  @override
  ConsumerState<TrainingLogPage> createState() => _TrainingLogPageState();
}

class _TrainingLogPageState extends ConsumerState<TrainingLogPage> {
  final DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width >= 720;
    return Scaffold(
      body: isDesktop ? _desktopLayout() : _mobileLayout(),
    );
  }

  // ── 桌面三欄 ─────────────────────────────────────────
  Widget _desktopLayout() => Row(
    children: [
      // 左：月曆 + 訓練歷史
      SizedBox(width: 248, child: _leftPanel()),
      const VerticalDivider(width: 1),
      // 中：當日訓練組數輸入
      Expanded(child: _centerPanel()),
      const VerticalDivider(width: 1),
      // 右：進度圖表 + 統計
      SizedBox(width: 288, child: _rightPanel()),
    ],
  );

  Widget _mobileLayout() => _centerPanel();

  // ── 左側面板 ──────────────────────────────────────────
  Widget _leftPanel() => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      _PanelHeader(
        title: '訓練日誌',
        subtitle: '${_selectedDate.year}年 ${_selectedDate.month}月',
      ),
      // TODO: 月曆 Widget（CalendarView）
      const Expanded(
        child: Center(
          child: Text('月曆 & 歷史記錄\n(即將實作)', textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecond, fontSize: 11)),
        ),
      ),
    ],
  );

  // ── 中間面板（組數記錄）──────────────────────────────
  Widget _centerPanel() => Column(
    children: [
      // 日期標題
      Container(
        padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppTheme.border)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${_selectedDate.year}.${_selectedDate.month.toString().padLeft(2,'0')}.${_selectedDate.day.toString().padLeft(2,'0')} — Day 1',
                    style: Theme.of(context).textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 2),
                  const Text('Week 3 · 漸進超負荷週 · 下肢推力 + 核心',
                    style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
                ],
              ),
            ),
            ElevatedButton(
              onPressed: () {}, // TODO: 開始訓練計時器
              child: const Text('開始訓練'),
            ),
          ],
        ),
      ),
      // 動作卡片列表
      Expanded(
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            ExerciseCard(
              exerciseName: '背蹲舉（高槓）',
              prescribed: '4×6 @RPE 8',
              existingSets: const [
                LoggedSet(reps: 6, weightKg: 110, rpe: 7.5, isDone: true),
                LoggedSet(reps: 6, weightKg: 110, rpe: 8.0, isDone: true),
                LoggedSet(reps: 6, weightKg: 110, rpe: 8.5, isDone: true),
              ],
              targetSets: 4,
              onSetLogged: (set) {
                // TODO: 儲存到 SQLite
              },
            ),
            const SizedBox(height: 12),
            ExerciseCard(
              exerciseName: '保加利亞分腿蹲',
              prescribed: '3×10/邊 @RPE 7',
              existingSets: const [],
              targetSets: 3,
              onSetLogged: (set) {},
            ),
            const SizedBox(height: 12),
            ExerciseCard(
              exerciseName: '農夫走路',
              prescribed: '4×20m @RPE 7',
              existingSets: const [],
              targetSets: 4,
              onSetLogged: (set) {},
            ),
          ],
        ),
      ),
    ],
  );

  // ── 右側面板（圖表 + 統計）───────────────────────────
  Widget _rightPanel() => SingleChildScrollView(
    padding: const EdgeInsets.all(14),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('訓練總量', style: TextStyle(fontSize: 9,
          fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppTheme.textSecond)),
        const SizedBox(height: 10),
        // 統計卡片行
        const Row(children: [
          _StatCard('3', '已完成組'),
          SizedBox(width: 6),
          _StatCard('18', '總次數'),
          SizedBox(width: 6),
          _StatCard('1980', 'Volume\nkg'),
        ]),
        const SizedBox(height: 16),
        const Text('背蹲舉 — 歷史 1RM 趨勢', style: TextStyle(fontSize: 9,
          fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppTheme.textSecond)),
        const SizedBox(height: 8),
        // TODO: fl_chart 折線圖
        Container(
          height: 100,
          decoration: BoxDecoration(
            color: AppTheme.surface2,
            borderRadius: BorderRadius.circular(8),
          ),
          alignment: Alignment.center,
          child: const Text('1RM 趨勢圖\n(fl_chart)', textAlign: TextAlign.center,
            style: TextStyle(color: AppTheme.textSecond, fontSize: 11)),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('估算 1RM', style: TextStyle(fontSize: 9, color: AppTheme.textSecond)),
            Text(
              '~${OneRmCalculator.estimate(110, 6).toStringAsFixed(0)} kg',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppTheme.accent),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const Text('訓練備註', style: TextStyle(fontSize: 9,
          fontWeight: FontWeight.w700, letterSpacing: 1.5, color: AppTheme.textSecond)),
        const SizedBox(height: 8),
        const TextField(
          maxLines: 4,
          decoration: InputDecoration(
            hintText: '記錄今日感受、技術問題、恢復狀況…',
          ),
        ),
      ],
    ),
  );
}

class _PanelHeader extends StatelessWidget {
  const _PanelHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.fromLTRB(14, 16, 14, 12),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: AppTheme.border)),
    ),
    child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      Text(title, style: Theme.of(context).textTheme.titleLarge),
      Text(subtitle, style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
    ]),
  );
}

class _StatCard extends StatelessWidget {
  const _StatCard(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.accent)),
        Text(label, style: const TextStyle(fontSize: 8, color: AppTheme.textSecond),
          textAlign: TextAlign.center),
      ]),
    ),
  );
}
