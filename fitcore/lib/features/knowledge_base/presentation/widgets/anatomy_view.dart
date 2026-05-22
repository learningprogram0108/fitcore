import 'package:flutter/material.dart';
import 'package:flutter_body_atlas/flutter_body_atlas.dart';

import '../../../../app/theme/app_theme.dart';

/// 解剖圖視圖 Widget
/// 使用開源套件 flutter_body_atlas（BSD-3 授權）
/// SVG 高精度人體肌肉圖，支援前後視圖、點擊肌群、動態高亮
///
/// 三層肌群顏色系統：
///   primary  (紅) → 主動肌，該動作的主要作功肌群
///   secondary(橙) → 輔助肌群，協同穩定
///   tertiary (藍) → 協同穩定肌，次要穩定作用
class AnatomyView extends StatefulWidget {
  const AnatomyView({
    super.key,
    required this.primaryMuscles,
    required this.secondaryMuscles,
    this.tertiaryMuscles = const [],
    this.onMuscleTapped,
    this.selectedPlane = AnatomicalPlane.sagittal,
  });

  /// 主動肌（紅色）— 使用 flutter_body_atlas 的 Muscle enum
  final List<Muscle> primaryMuscles;

  /// 輔助肌群（橙色）
  final List<Muscle> secondaryMuscles;

  /// 協同穩定肌（藍色）
  final List<Muscle> tertiaryMuscles;

  /// 肌群被點擊時的回調（回傳 MuscleInfo）
  final void Function(MuscleInfo muscle)? onMuscleTapped;

  /// 目前選擇的解剖平面（用於標籤顯示）
  final AnatomicalPlane selectedPlane;

  @override
  State<AnatomyView> createState() => _AnatomyViewState();
}

class _AnatomyViewState extends State<AnatomyView> {
  AtlasView _currentView = AtlasView.front;
  MuscleInfo? _tappedMuscle;

  /// 建立 flutter_body_atlas 的 MuscleInfo 顏色映射
  /// colorMapping 的 key 是 MuscleInfo（由 MuscleCatalog 取得）
  Map<MuscleInfo, Color?> get _colorMapping {
    final map = <MuscleInfo, Color?>{};
    for (final m in widget.primaryMuscles) {
      final info = MuscleCatalog.byMuscle[m];
      if (info != null) map[info] = AppTheme.muscPrimary;
    }
    for (final m in widget.secondaryMuscles) {
      final info = MuscleCatalog.byMuscle[m];
      if (info != null) map[info] = AppTheme.muscSecond;
    }
    for (final m in widget.tertiaryMuscles) {
      final info = MuscleCatalog.byMuscle[m];
      if (info != null) map[info] = AppTheme.muscTertiary;
    }
    return map;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 前/後視圖切換 ──────────────────────────────
        _ViewToggle(
          currentView: _currentView,
          onChanged: (v) => setState(() => _currentView = v),
        ),
        const SizedBox(height: 8),
        // ── 解剖圖主體（flutter_body_atlas BodyAtlasView）──
        Expanded(
          child: BodyAtlasView<MuscleInfo>(
            view: _currentView == AtlasView.front
                ? AtlasAsset.musclesFront
                : AtlasAsset.musclesBack,
            resolver: const MuscleResolver(),
            colorMapping: _colorMapping,
            onTapElement: (muscleInfo) {
              setState(() => _tappedMuscle = muscleInfo);
              widget.onMuscleTapped?.call(muscleInfo);
            },
          ),
        ),
        // ── 肌群提示標籤 ──────────────────────────────
        if (_tappedMuscle != null)
          _MuscleTooltip(muscleInfo: _tappedMuscle!),
        const SizedBox(height: 8),
        // ── 圖例 ──────────────────────────────────────
        _MuscleLegend(
          primaryCount: widget.primaryMuscles.length,
          secondaryCount: widget.secondaryMuscles.length,
          tertiaryCount: widget.tertiaryMuscles.length,
        ),
      ],
    );
  }
}

// ── 前/後切換按鈕 ──────────────────────────────────────
class _ViewToggle extends StatelessWidget {
  const _ViewToggle({required this.currentView, required this.onChanged});
  final AtlasView currentView;
  final void Function(AtlasView) onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border),
      ),
      padding: const EdgeInsets.all(3),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _ToggleBtn('前視圖', AtlasView.front, currentView, onChanged),
          _ToggleBtn('後視圖', AtlasView.back, currentView, onChanged),
        ],
      ),
    );
  }
}

class _ToggleBtn extends StatelessWidget {
  const _ToggleBtn(this.label, this.view, this.current, this.onTap);
  final String label;
  final AtlasView view;
  final AtlasView current;
  final void Function(AtlasView) onTap;

  @override
  Widget build(BuildContext context) {
    final isOn = view == current;
    return GestureDetector(
      onTap: () => onTap(view),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
        decoration: BoxDecoration(
          color: isOn ? AppTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w700,
            color: isOn ? Colors.black : AppTheme.textSecond,
          ),
        ),
      ),
    );
  }
}

// ── 被點擊肌群的懸浮提示 ────────────────────────────────
class _MuscleTooltip extends StatelessWidget {
  const _MuscleTooltip({required this.muscleInfo});
  final MuscleInfo muscleInfo;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: AppTheme.surface3,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppTheme.border2),
      ),
      child: Text(
        muscleInfo.displayName,
        style: const TextStyle(fontSize: 11, color: AppTheme.textPrimary),
      ),
    );
  }
}

// ── 圖例（三色系統說明）────────────────────────────────
class _MuscleLegend extends StatelessWidget {
  const _MuscleLegend({
    required this.primaryCount,
    required this.secondaryCount,
    required this.tertiaryCount,
  });
  final int primaryCount;
  final int secondaryCount;
  final int tertiaryCount;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _LegendDot(AppTheme.muscPrimary, '主動肌 ($primaryCount)'),
          const SizedBox(width: 12),
          _LegendDot(AppTheme.muscSecond, '輔助肌 ($secondaryCount)'),
          const SizedBox(width: 12),
          if (tertiaryCount > 0)
            _LegendDot(AppTheme.muscTertiary, '協同 ($tertiaryCount)'),
        ],
      ),
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot(this.color, this.label);
  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(fontSize: 9, color: AppTheme.textSecond)),
        ],
      );
}

/// 解剖平面枚舉（矢狀面 / 額狀面 / 水平面）
enum AnatomicalPlane {
  sagittal(label: '矢狀面', subtitle: '屈曲 · 伸展', action: 'Hip Extension · Knee Extension'),
  frontal(label: '額狀面', subtitle: '外展 · 內收', action: 'Hip Abduction · Adduction'),
  transverse(
      label: '水平面', subtitle: '內旋 · 外旋', action: 'Hip External Rotation · Anti-Rotation');

  const AnatomicalPlane({required this.label, required this.subtitle, required this.action});
  final String label;
  final String subtitle;
  final String action;
}

/// 前後視圖枚舉
enum AtlasView { front, back }
