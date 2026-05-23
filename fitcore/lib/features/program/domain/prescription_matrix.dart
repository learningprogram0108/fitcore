import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

// ════════════════════════════════════════════════════════════
//  ExerciseCategory — 動作分組標籤（6 週週期矩陣的分類基礎）
// ════════════════════════════════════════════════════════════

enum ExerciseCategory {
  /// 大項核心複合動作：多關節、高神經徵召（深蹲、臥推、硬舉）
  mainCompound,

  /// 輔助複合動作：單側、多維度、修正力學弱點（分腿蹲、肩推、划船）
  auxiliaryCompound,

  /// 孤立動作：單關節、特定肌纖維長度特化（腿彎舉、三頭下壓）
  isolation,

  /// 功能性剛性核心：抗移動、保護動力鏈（農夫走路、TRX 平板撐）
  functionalCore,
}

String exerciseCategoryLabel(ExerciseCategory c) => switch (c) {
      ExerciseCategory.mainCompound      => 'MAIN_COMPOUND',
      ExerciseCategory.auxiliaryCompound => 'AUXILIARY_COMPOUND',
      ExerciseCategory.isolation         => 'ISOLATION',
      ExerciseCategory.functionalCore    => 'FUNCTIONAL_CORE',
    };

// ════════════════════════════════════════════════════════════
//  PrescriptionData — 單週單分類的處方資料
// ════════════════════════════════════════════════════════════

class PrescriptionData {
  const PrescriptionData({
    required this.sets,
    required this.reps,
    this.rpe,
    required this.rpeLabel,
    required this.load,
  });

  final int sets;
  final String reps;      // '12' 或 '40秒'
  final double? rpe;      // FUNCTIONAL_CORE 為 null
  final String rpeLabel;  // 'RPE 7.0' 或 '中等張力'
  final String load;      // '≈ 65% (15RM)' 或 '自重或輕量控制'

  /// 單行顯示：e.g. '3×12 @RPE 7.0'
  String get shortDisplay {
    final rpeStr = rpe != null ? ' @RPE $rpe' : ' · $rpeLabel';
    return '$sets×$reps$rpeStr';
  }

  /// 雙行顯示（課表動作行）：處方 + 負荷估算
  String get display => '$shortDisplay\n$load';
}

// ════════════════════════════════════════════════════════════
//  6 週課表矩陣（Weeks 1–3 肌肥大區塊 / Weeks 4–6 最大肌力區塊）
//  來源：6週重量配置與阻力訓練進階矩陣.md
// ════════════════════════════════════════════════════════════

const Map<ExerciseCategory, List<PrescriptionData>> kPrescriptionMatrix = {
  // ── MAIN_COMPOUND ──────────────────────────────────────────
  ExerciseCategory.mainCompound: [
    PrescriptionData(sets: 3, reps: '12', rpe: 7.0, rpeLabel: 'RPE 7.0', load: '≈ 65% (15RM)'),  // W1
    PrescriptionData(sets: 3, reps: '10', rpe: 7.5, rpeLabel: 'RPE 7.5', load: '≈ 71% (13RM)'),  // W2
    PrescriptionData(sets: 4, reps: '8',  rpe: 8.0, rpeLabel: 'RPE 8.0', load: '≈ 78% (10RM)'),  // W3
    PrescriptionData(sets: 4, reps: '5',  rpe: 8.5, rpeLabel: 'RPE 8.5', load: '≈ 83% (6.5RM)'), // W4
    PrescriptionData(sets: 4, reps: '4',  rpe: 9.0, rpeLabel: 'RPE 9.0', load: '≈ 86% (5RM)'),   // W5
    PrescriptionData(sets: 5, reps: '3',  rpe: 9.5, rpeLabel: 'RPE 9.5', load: '≈ 90% (3.5RM)'), // W6
  ],

  // ── AUXILIARY_COMPOUND ────────────────────────────────────
  ExerciseCategory.auxiliaryCompound: [
    PrescriptionData(sets: 3, reps: '12', rpe: 7.5, rpeLabel: 'RPE 7.5', load: '≈ 67.5% (14RM)'), // W1
    PrescriptionData(sets: 3, reps: '10', rpe: 8.0, rpeLabel: 'RPE 8.0', load: '≈ 75% (12RM)'),   // W2
    PrescriptionData(sets: 3, reps: '10', rpe: 8.5, rpeLabel: 'RPE 8.5', load: '≈ 76.5% (11RM)'), // W3
    PrescriptionData(sets: 3, reps: '8',  rpe: 8.0, rpeLabel: 'RPE 8.0', load: '≈ 75% (10RM)'),   // W4
    PrescriptionData(sets: 2, reps: '8',  rpe: 8.5, rpeLabel: 'RPE 8.5', load: '≈ 76.5% (9.5RM)'),// W5
    PrescriptionData(sets: 2, reps: '6',  rpe: 9.0, rpeLabel: 'RPE 9.0', load: '≈ 83% (7RM)'),    // W6
  ],

  // ── ISOLATION ─────────────────────────────────────────────
  ExerciseCategory.isolation: [
    PrescriptionData(sets: 3, reps: '15', rpe: 8.0, rpeLabel: 'RPE 8.0', load: '≈ 60% (17RM)'),   // W1
    PrescriptionData(sets: 3, reps: '12', rpe: 8.5, rpeLabel: 'RPE 8.5', load: '≈ 67.5% (14RM)'), // W2
    PrescriptionData(sets: 4, reps: '12', rpe: 9.0, rpeLabel: 'RPE 9.0', load: '≈ 70% (13RM)'),   // W3
    PrescriptionData(sets: 2, reps: '12', rpe: 8.0, rpeLabel: 'RPE 8.0', load: '≈ 67.5% (14RM)'), // W4
    PrescriptionData(sets: 2, reps: '10', rpe: 8.0, rpeLabel: 'RPE 8.0', load: '≈ 71% (12RM)'),   // W5
    PrescriptionData(sets: 2, reps: '10', rpe: 8.0, rpeLabel: 'RPE 8.0', load: '≈ 71% (12RM)'),   // W6
  ],

  // ── FUNCTIONAL_CORE ───────────────────────────────────────
  ExerciseCategory.functionalCore: [
    PrescriptionData(sets: 3, reps: '40秒', rpeLabel: '中等張力',   load: '自重或輕量控制'),   // W1
    PrescriptionData(sets: 3, reps: '50秒', rpeLabel: '中等張力',   load: '中度阻力抗伸展'),   // W2
    PrescriptionData(sets: 3, reps: '60秒', rpeLabel: '中高張力',   load: '長時間抗旋轉鎖定'), // W3
    PrescriptionData(sets: 3, reps: '30秒', rpeLabel: '高剛性對抗', load: '高負重抗側屈'),     // W4
    PrescriptionData(sets: 2, reps: '30秒', rpeLabel: '極致剛性',   load: '高負重農夫走路'),   // W5
    PrescriptionData(sets: 2, reps: '30秒', rpeLabel: '極限剛性',   load: '極限等長中軸死鎖'), // W6
  ],
};

/// 查詢指定分類在指定週次的處方
PrescriptionData prescriptionFor(ExerciseCategory cat, int week) =>
    kPrescriptionMatrix[cat]![(week - 1).clamp(0, 5)];

// ════════════════════════════════════════════════════════════
//  週次區塊標籤
// ════════════════════════════════════════════════════════════

String weekBlockLabel(int week) => switch (week) {
      1 => '肌肥大累積期',
      2 => '肌肥大推進期',
      3 => '肌肥大頂峰週',
      4 => '最大肌力轉化',
      5 => '肌力超負荷期',
      _ => '神經極致釋放',
    };

// ════════════════════════════════════════════════════════════
//  ProgramWeekNotifier — 當前週次狀態（持久化至 SharedPreferences）
// ════════════════════════════════════════════════════════════

class ProgramWeekNotifier extends StateNotifier<int> {
  ProgramWeekNotifier() : super(1) {
    _load();
  }

  static const _key = 'program_current_week';

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) state = (prefs.getInt(_key) ?? 1).clamp(1, 6);
  }

  Future<void> setWeek(int week) async {
    final clamped = week.clamp(1, 6);
    state = clamped;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_key, clamped);
  }

  void advance() => setWeek(state + 1);
  void retreat() => setWeek(state - 1);
}

final programWeekProvider =
    StateNotifierProvider<ProgramWeekNotifier, int>(
        (ref) => ProgramWeekNotifier());
