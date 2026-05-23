// 9 大肌群枚舉 + Helms 金字塔組數閾值工具
// 計算邏輯：主動肌 ×1.0、輔助肌 ×0.5（Volume Weighting Method）

import 'package:flutter/material.dart';

enum MuscleGroup {
  chest,          // 胸大肌
  back,           // 背部（闊背 / 大圓 / 斜方中下）
  quads,          // 股四頭肌
  posteriorChain, // 後側動力鏈（臀大肌 + 腿後肌群）
  frontDelt,      // 三角肌前束
  sideDelt,       // 三角肌中 / 後束
  triceps,        // 肱三頭肌
  biceps,         // 肱二頭肌
  core,           // 核心肌群
}

extension MuscleGroupExt on MuscleGroup {
  String get label => const {
    MuscleGroup.chest:          '胸大肌',
    MuscleGroup.back:           '背部',
    MuscleGroup.quads:          '股四頭',
    MuscleGroup.posteriorChain: '臀/腿後',
    MuscleGroup.frontDelt:      '前三角',
    MuscleGroup.sideDelt:       '中後三角',
    MuscleGroup.triceps:        '三頭',
    MuscleGroup.biceps:         '二頭',
    MuscleGroup.core:           '核心',
  }[this]!;

  /// 依 Helms 金字塔組數區間回傳顏色
  Color zoneColor(double sets) {
    if (sets >= 25) return const Color(0xFFFF4444); // 紅：垃圾容量
    if (sets >= 10) return const Color(0xFF7EC82A); // 綠：黃金成長
    if (sets >= 6)  return const Color(0xFFFF9500); // 橙：接近下限
    if (sets > 0)   return const Color(0xFF555555); // 灰：僅維持
    return const Color(0xFF333333);                 // 深灰：未訓練
  }

  /// 文字說明
  String zoneLabel(double sets) {
    if (sets >= 25) return '⚠️ 垃圾容量';
    if (sets >= 10) return '✅ 黃金成長';
    if (sets >= 6)  return '🟠 接近下限';
    if (sets > 0)   return '維持';
    return '—';
  }
}

/// 計算每週每肌群加權組數
/// 使用方式：傳入 {movementId → 本週組數} + 動作查詢函數
class MuscleVolumeCalc {
  // Helms 金字塔組數閾值
  static const double maintain = 6;
  static const double optimal  = 10;
  static const double ceiling  = 20;
  static const double junk     = 25;

  static Map<MuscleGroup, double> compute(
    Map<String, int> setsPerExercise,
    Map<MuscleGroup, double>? Function(String movementId) weightsLookup,
  ) {
    final result = <MuscleGroup, double>{};
    for (final entry in setsPerExercise.entries) {
      final weights = weightsLookup(entry.key);
      if (weights == null) continue;
      for (final mg in weights.entries) {
        result[mg.key] = (result[mg.key] ?? 0) + entry.value * mg.value;
      }
    }
    return result;
  }
}
