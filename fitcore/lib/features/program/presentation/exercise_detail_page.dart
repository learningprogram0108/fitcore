import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../domain/movement_data.dart';
import '../domain/workout_session_notifier.dart';

// ── Route extra ──────────────────────────────────────────────
class ExerciseExtra {
  const ExerciseExtra({
    required this.name,
    required this.prescription,
    required this.dayNum,
  });
  final String name;
  final String prescription;
  final int dayNum;
}

// ── Page ─────────────────────────────────────────────────────
class ExerciseDetailPage extends ConsumerStatefulWidget {
  const ExerciseDetailPage({
    super.key,
    required this.movementId,
    this.extra,
  });

  final String movementId;
  final ExerciseExtra? extra;

  @override
  ConsumerState<ExerciseDetailPage> createState() =>
      _ExerciseDetailPageState();
}

class _ExerciseDetailPageState extends ConsumerState<ExerciseDetailPage> {
  // 每組的輸入控制器: [weightCtrl, repsCtrl, rpeCtrl]
  final List<_SetRowState> _rows = [];
  late final MovementData? _data;

  @override
  void initState() {
    super.initState();
    _data = MovementLibrary.find(widget.movementId);
    // 已記錄的組數預填
    final existing =
        ref.read(workoutSessionProvider).setsFor(widget.movementId);
    for (final s in existing) {
      _rows.add(_SetRowState(
        weight: s.weightKg.toString(),
        reps: s.reps.toString(),
        rpe: s.rpe.toString(),
        confirmed: true,
      ));
    }
    if (_rows.isEmpty) _rows.add(_SetRowState());
  }

  @override
  void dispose() {
    for (final r in _rows) {
      r.dispose();
    }
    super.dispose();
  }

  void _addRow() {
    setState(() => _rows.add(_SetRowState()));
  }

  void _removeRow(int index) {
    if (_rows.length <= 1) return;
    _rows[index].dispose();
    setState(() => _rows.removeAt(index));
  }

  void _confirmRow(int index) {
    final row = _rows[index];
    final w = double.tryParse(row.weightCtrl.text);
    final r = int.tryParse(row.repsCtrl.text);
    final rpe = double.tryParse(row.rpeCtrl.text);
    if (w == null || r == null || rpe == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('請填寫重量、次數及 RPE')),
      );
      return;
    }
    if (rpe < 0 || rpe > 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('RPE 必須在 0.0–10.0 之間')),
      );
      return;
    }
    setState(() => row.confirmed = true);
  }

  void _saveAndPop() {
    // 清除之前記錄，重新寫入本次所有已確認的組
    final notifier = ref.read(workoutSessionProvider.notifier);
    // 先移除舊有資料（簡化：reset後重add）
    final confirmedRows =
        _rows.where((r) => r.confirmed).toList();

    if (confirmedRows.isEmpty) {
      context.pop();
      return;
    }

    // 移除此動作舊組數
    final currentSets = ref
        .read(workoutSessionProvider)
        .setsFor(widget.movementId)
        .length;
    for (int i = currentSets - 1; i >= 0; i--) {
      notifier.removeSet(widget.movementId, i);
    }

    // 重新 addSet
    for (final row in confirmedRows) {
      final w = double.tryParse(row.weightCtrl.text) ?? 0;
      final r = int.tryParse(row.repsCtrl.text) ?? 0;
      final rpe = double.tryParse(row.rpeCtrl.text) ?? 0;
      notifier.addSet(widget.movementId,
          weightKg: w, reps: r, rpe: rpe);
    }

    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.extra?.name ?? _data?.name ?? widget.movementId;
    final prescription = widget.extra?.prescription ?? '';

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF141414),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(name,
                style: const TextStyle(
                    fontSize: 16, fontWeight: FontWeight.w700)),
            if (prescription.isNotEmpty)
              Text(prescription,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFF888888))),
          ],
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FilledButton.icon(
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFC8FF47),
                foregroundColor: Colors.black,
              ),
              icon: const Icon(Icons.check, size: 16),
              label: const Text('完成並返回',
                  style: TextStyle(fontWeight: FontWeight.w700)),
              onPressed: _saveAndPop,
            ),
          ),
        ],
      ),
      backgroundColor: const Color(0xFF0A0A0A),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _SetLoggingPanel(
              rows: _rows,
              onAddRow: _addRow,
              onRemoveRow: _removeRow,
              onConfirmRow: _confirmRow,
            ),
            const Divider(color: Color(0xFF2A2A2A), height: 1),
            if (_data != null) _MovementGuidePanel(data: _data),
          ],
        ),
      ),
    );
  }
}

// ── Set Logging Panel ────────────────────────────────────────
class _SetLoggingPanel extends StatelessWidget {
  const _SetLoggingPanel({
    required this.rows,
    required this.onAddRow,
    required this.onRemoveRow,
    required this.onConfirmRow,
  });

  final List<_SetRowState> rows;
  final VoidCallback onAddRow;
  final void Function(int) onRemoveRow;
  final void Function(int) onConfirmRow;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        const Padding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, 10),
          child: Text('📋 訓練記錄',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFFC8FF47),
                  letterSpacing: 1)),
        ),
        // Header
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: 16),
          child: Row(
            children: [
              SizedBox(width: 32, child: Text('組', style: _headerStyle)),
              SizedBox(width: 8),
              Expanded(
                  flex: 3,
                  child: Text('重量 (kg)', style: _headerStyle)),
              SizedBox(width: 8),
              Expanded(
                  flex: 2,
                  child: Text('次數', style: _headerStyle)),
              SizedBox(width: 8),
              Expanded(
                  flex: 2,
                  child: Text('RPE', style: _headerStyle)),
              SizedBox(width: 44),
            ],
          ),
        ),
        const SizedBox(height: 6),
        // Rows
        ...rows.asMap().entries.map((e) => _SetRowWidget(
              index: e.key,
              rowState: e.value,
              onRemove: () => onRemoveRow(e.key),
              onConfirm: () => onConfirmRow(e.key),
            )),
        // + 新增組數
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 20),
          child: OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Color(0xFF2A2A2A)),
              foregroundColor: const Color(0xFF888888),
            ),
            icon: const Icon(Icons.add, size: 16),
            label: const Text('新增組數'),
            onPressed: onAddRow,
          ),
        ),
      ],
    );
  }

  static const _headerStyle = TextStyle(
      fontSize: 10,
      color: Color(0xFF666666),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.5);
}

// ── Set Row State ────────────────────────────────────────────
class _SetRowState {
  _SetRowState({String weight = '', String reps = '', String rpe = '', this.confirmed = false})
      : weightCtrl = TextEditingController(text: weight),
        repsCtrl = TextEditingController(text: reps),
        rpeCtrl = TextEditingController(text: rpe);

  final TextEditingController weightCtrl;
  final TextEditingController repsCtrl;
  final TextEditingController rpeCtrl;
  bool confirmed;

  void dispose() {
    weightCtrl.dispose();
    repsCtrl.dispose();
    rpeCtrl.dispose();
  }
}

// ── Set Row Widget ───────────────────────────────────────────
class _SetRowWidget extends StatelessWidget {
  const _SetRowWidget({
    required this.index,
    required this.rowState,
    required this.onRemove,
    required this.onConfirm,
  });

  final int index;
  final _SetRowState rowState;
  final VoidCallback onRemove;
  final VoidCallback onConfirm;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 6),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: rowState.confirmed
            ? const Color(0xFF1A2A0A)
            : const Color(0xFF181818),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: rowState.confirmed
              ? const Color(0xFF4A8A0A)
              : const Color(0xFF2A2A2A),
        ),
      ),
      child: Row(
        children: [
          SizedBox(
            width: 28,
            child: Text(
              '${index + 1}',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: rowState.confirmed
                    ? const Color(0xFFC8FF47)
                    : const Color(0xFF666666),
              ),
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 3,
            child: _InputField(
              controller: rowState.weightCtrl,
              hint: '0.0',
              inputType: const TextInputType.numberWithOptions(decimal: true),
              enabled: !rowState.confirmed,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: _InputField(
              controller: rowState.repsCtrl,
              hint: '0',
              inputType: TextInputType.number,
              enabled: !rowState.confirmed,
            ),
          ),
          const SizedBox(width: 6),
          Expanded(
            flex: 2,
            child: _InputField(
              controller: rowState.rpeCtrl,
              hint: '7.0',
              inputType: const TextInputType.numberWithOptions(decimal: true),
              enabled: !rowState.confirmed,
            ),
          ),
          const SizedBox(width: 6),
          // 確認 / 刪除 按鈕
          if (!rowState.confirmed)
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.check_circle_outline,
                      color: Color(0xFFC8FF47), size: 20),
                  tooltip: '確認',
                  onPressed: onConfirm,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline,
                      color: Color(0xFF666666), size: 18),
                  tooltip: '刪除',
                  onPressed: onRemove,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                ),
              ],
            )
          else
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Icon(Icons.check_circle,
                  color: Color(0xFFC8FF47), size: 20),
            ),
        ],
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    required this.inputType,
    this.enabled = true,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType inputType;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      enabled: enabled,
      keyboardType: inputType,
      inputFormatters: [
        FilteringTextInputFormatter.allow(RegExp(r'[\d.]')),
      ],
      style: const TextStyle(fontSize: 14, color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Color(0xFF444444), fontSize: 13),
        isDense: true,
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        filled: true,
        fillColor: const Color(0xFF1E1E1E),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFFC8FF47), width: 1.5),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(6),
          borderSide: const BorderSide(color: Color(0xFF1A1A1A)),
        ),
      ),
    );
  }
}

// ── Movement Guide Panel ─────────────────────────────────────
class _MovementGuidePanel extends StatelessWidget {
  const _MovementGuidePanel({required this.data});
  final MovementData data;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const Text('📖 動作指南',
            style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: Color(0xFFC8FF47),
                letterSpacing: 1)),
        const SizedBox(height: 12),
        _GuideInfoCard(
          icon: '🔴',
          title: '解剖聚焦',
          content: data.anatomyFocus,
        ),
        const SizedBox(height: 8),
        _GuideInfoCard(
          icon: '⚙️',
          title: '力學特徵',
          content: data.mechanics,
        ),
        const SizedBox(height: 12),
        ...data.phases.asMap().entries.map(
          (e) => Padding(
            padding: const EdgeInsets.only(bottom: 6),
            child: _PhaseExpansion(
                index: e.key, phase: e.value, startExpanded: e.key == 0),
          ),
        ),
      ],
    );
  }
}

class _GuideInfoCard extends StatelessWidget {
  const _GuideInfoCard({
    required this.icon,
    required this.title,
    required this.content,
  });
  final String icon;
  final String title;
  final String content;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF181818),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(icon, style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 6),
              Text(title,
                  style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF888888),
                      fontWeight: FontWeight.w600)),
            ],
          ),
          const SizedBox(height: 6),
          Text(content,
              style: const TextStyle(fontSize: 13, color: Color(0xFFCCCCCC), height: 1.5)),
        ],
      ),
    );
  }
}

class _PhaseExpansion extends StatelessWidget {
  const _PhaseExpansion({
    required this.index,
    required this.phase,
    this.startExpanded = false,
  });
  final int index;
  final MovementPhase phase;
  final bool startExpanded;

  static const _phaseColors = [
    Color(0xFF4A7A4A),
    Color(0xFF4A5A7A),
    Color(0xFF7A4A4A),
    Color(0xFF7A5A4A),
    Color(0xFF4A6A6A),
    Color(0xFF6A4A7A),
  ];

  @override
  Widget build(BuildContext context) {
    final color = _phaseColors[index % _phaseColors.length];
    return Theme(
      data: Theme.of(context).copyWith(
        dividerColor: Colors.transparent,
      ),
      child: ExpansionTile(
        initiallyExpanded: startExpanded,
        backgroundColor: const Color(0xFF181818),
        collapsedBackgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: BorderSide(color: color.withValues(alpha: 0.4)),
        ),
        collapsedShape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Color(0xFF2A2A2A)),
        ),
        leading: Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
              color: color.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6)),
          alignment: Alignment.center,
          child: Text(
            '${index + 1}',
            style: TextStyle(
                fontSize: 11, fontWeight: FontWeight.w800, color: color),
          ),
        ),
        title: Text(
          phase.title,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
        ),
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 14),
            child: Text(
              phase.content,
              style: const TextStyle(
                  fontSize: 13, color: Color(0xFFBBBBBB), height: 1.6),
            ),
          ),
        ],
      ),
    );
  }
}
