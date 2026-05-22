import 'package:flutter/material.dart';
import '../../../../app/theme/app_theme.dart';

/// 動作訓練卡片（可展開的組數記錄表）
class ExerciseCard extends StatefulWidget {
  const ExerciseCard({
    super.key,
    required this.exerciseName,
    required this.prescribed,
    required this.existingSets,
    required this.targetSets,
    required this.onSetLogged,
  });

  final String exerciseName;
  final String prescribed;           // e.g. "4×6 @RPE 8"
  final List<LoggedSet> existingSets;
  final int targetSets;
  final void Function(LoggedSet) onSetLogged;

  @override
  State<ExerciseCard> createState() => _ExerciseCardState();
}

class _ExerciseCardState extends State<ExerciseCard> {
  final _repsCtrl   = TextEditingController();
  final _weightCtrl = TextEditingController();
  final _rpeCtrl    = TextEditingController();

  @override
  void dispose() {
    _repsCtrl.dispose();
    _weightCtrl.dispose();
    _rpeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final completedSets = widget.existingSets.where((s) => s.isDone).length;
    return Card(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── 動作標題列 ──────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(14, 10, 14, 8),
            child: Row(children: [
              Expanded(
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  Text(widget.exerciseName,
                    style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
                  Text(widget.prescribed,
                    style: const TextStyle(fontSize: 10, color: AppTheme.textSecond)),
                ]),
              ),
              // 完成進度
              Text(
                '$completedSets/${widget.targetSets} 組',
                style: TextStyle(
                  fontSize: 11, fontWeight: FontWeight.w600,
                  color: completedSets >= widget.targetSets
                      ? AppTheme.accent : AppTheme.textSecond,
                ),
              ),
            ]),
          ),
          // ── 已完成組數表格 ──────────────────────────
          if (widget.existingSets.isNotEmpty) ...[
            const Divider(height: 1),
            _SetTable(sets: widget.existingSets),
          ],
          // ── 新增組數輸入列 ───────────────────────────
          if (completedSets < widget.targetSets) ...[
            const Divider(height: 1),
            _NewSetRow(
              repsCtrl: _repsCtrl,
              weightCtrl: _weightCtrl,
              rpeCtrl: _rpeCtrl,
              setNumber: completedSets + 1,
              onLog: () {
                final reps   = int.tryParse(_repsCtrl.text)    ?? 0;
                final weight = double.tryParse(_weightCtrl.text) ?? 0;
                final rpe    = double.tryParse(_rpeCtrl.text)   ?? 0;
                if (reps > 0 && weight > 0) {
                  widget.onSetLogged(LoggedSet(
                    reps: reps, weightKg: weight, rpe: rpe, isDone: true,
                  ));
                  _repsCtrl.clear();
                  _rpeCtrl.clear();
                }
              },
            ),
          ],
        ],
      ),
    );
  }
}

// ── 已完成組數表格 ────────────────────────────────────
class _SetTable extends StatelessWidget {
  const _SetTable({required this.sets});
  final List<LoggedSet> sets;

  @override
  Widget build(BuildContext context) {
    return Table(
      columnWidths: const {
        0: FixedColumnWidth(32),  // 組號
        1: FlexColumnWidth(2),    // 重量
        2: FlexColumnWidth(1.5),  // 次數
        3: FlexColumnWidth(1.5),  // RPE
        4: FlexColumnWidth(2),    // 狀態
      },
      children: [
        // 表頭
        TableRow(
          decoration: const BoxDecoration(color: AppTheme.surface2),
          children: ['組', '重量 kg', '次數', 'RPE', '狀態']
              .map((h) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 8),
                child: Text(h, style: const TextStyle(
                    fontSize: 9, color: AppTheme.textSecond,
                    fontWeight: FontWeight.w600, letterSpacing: .5)),
              )).toList(),
        ),
        // 資料列
        for (var i = 0; i < sets.length; i++)
          TableRow(
            decoration: const BoxDecoration(
              border: Border(top: BorderSide(color: AppTheme.border)),
            ),
            children: [
              _cell('${i + 1}'),
              _cell('${sets[i].weightKg}'),
              _cell('${sets[i].reps}'),
              _rpeCell(sets[i].rpe),
              _doneCell(),
            ],
          ),
      ],
    );
  }

  Widget _cell(String t) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
    child: Text(t, style: const TextStyle(fontSize: 11)),
  );

  Widget _rpeCell(double rpe) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 7, horizontal: 8),
    child: Text(rpe.toString(),
      style: TextStyle(fontSize: 11, color: AppTheme.rpeColor(rpe), fontWeight: FontWeight.w600)),
  );

  Widget _doneCell() => const Padding(
    padding: EdgeInsets.symmetric(vertical: 7, horizontal: 8),
    child: Text('✓ 完成', style: TextStyle(fontSize: 10, color: AppTheme.accent)),
  );
}

// ── 輸入新組數 ────────────────────────────────────────
class _NewSetRow extends StatelessWidget {
  const _NewSetRow({
    required this.repsCtrl,
    required this.weightCtrl,
    required this.rpeCtrl,
    required this.setNumber,
    required this.onLog,
  });
  final TextEditingController repsCtrl, weightCtrl, rpeCtrl;
  final int setNumber;
  final VoidCallback onLog;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(8, 6, 8, 8),
    child: Row(children: [
      SizedBox(
        width: 28,
        child: Text('$setNumber', style: const TextStyle(fontSize: 11, color: AppTheme.textSecond),
          textAlign: TextAlign.center),
      ),
      const SizedBox(width: 4),
      _Input(ctrl: weightCtrl, hint: 'kg'),
      const SizedBox(width: 6),
      _Input(ctrl: repsCtrl, hint: '次'),
      const SizedBox(width: 6),
      _Input(ctrl: rpeCtrl, hint: 'RPE'),
      const SizedBox(width: 8),
      ElevatedButton(
        onPressed: onLog,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: const Text('記錄', style: TextStyle(fontSize: 11)),
      ),
    ]),
  );
}

class _Input extends StatelessWidget {
  const _Input({required this.ctrl, required this.hint});
  final TextEditingController ctrl;
  final String hint;

  @override
  Widget build(BuildContext context) => SizedBox(
    width: 56,
    child: TextField(
      controller: ctrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      textAlign: TextAlign.center,
      style: const TextStyle(fontSize: 12),
      decoration: InputDecoration(
        hintText: hint,
        contentPadding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
        isDense: true,
      ),
    ),
  );
}

// ── 資料模型 ──────────────────────────────────────────
class LoggedSet {
  const LoggedSet({
    required this.reps,
    required this.weightKg,
    required this.rpe,
    required this.isDone,
  });
  final int reps;
  final double weightKg;
  final double rpe;
  final bool isDone;
}
