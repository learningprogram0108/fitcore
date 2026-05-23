// CNS 準備度日測系統
// 資料存記憶體（不寫 DB），每日評估一次即可

import 'package:flutter_riverpod/flutter_riverpod.dart';

class ReadinessState {
  const ReadinessState({
    this.sleep = 0,
    this.energy = 0,
    this.soreness = 0,
    this.assessedAt,
  });

  final int sleep;          // 1–5（睡眠品質星數）
  final double energy;      // 1–10（精力滑桿）
  final int soreness;       // 1–5（肌肉酸痛）
  final DateTime? assessedAt;

  bool get hasAssessed => assessedAt != null;

  bool get isToday =>
      assessedAt != null &&
      assessedAt!.year == DateTime.now().year &&
      assessedAt!.month == DateTime.now().month &&
      assessedAt!.day == DateTime.now().day;

  /// 0–10 綜合分（睡眠佔 2 倍、酸痛反向計分）
  double get score {
    if (!hasAssessed) return 0;
    return (sleep * 2 + energy + (6 - soreness) * 2) / 3;
  }

  String get level {
    if (!isToday) return 'unknown';
    if (score >= 7) return 'high';
    if (score >= 4) return 'medium';
    return 'low';
  }

  String get levelLabel => switch (level) {
    'high'    => '🟢 狀態極佳',
    'medium'  => '🟡 狀態中等',
    'low'     => '🔴 狀態偏低',
    _         => '尚未評估',
  };

  String get rpeAdvice => switch (level) {
    'high'    => '今日狀態極佳，可嘗試突破 PR',
    'medium'  => '維持計劃重量，不要強求突破',
    'low'     => '建議所有動作 RPE 目標下調 1 個層級',
    _         => '評估後即可查看建議',
  };

  ReadinessState copyWith({
    int? sleep,
    double? energy,
    int? soreness,
    DateTime? assessedAt,
  }) =>
      ReadinessState(
        sleep: sleep ?? this.sleep,
        energy: energy ?? this.energy,
        soreness: soreness ?? this.soreness,
        assessedAt: assessedAt ?? this.assessedAt,
      );
}

class ReadinessNotifier extends StateNotifier<ReadinessState> {
  ReadinessNotifier() : super(const ReadinessState());

  void assess({
    required int sleep,
    required double energy,
    required int soreness,
  }) {
    state = ReadinessState(
      sleep: sleep,
      energy: energy,
      soreness: soreness,
      assessedAt: DateTime.now(),
    );
  }

  void reset() => state = const ReadinessState();
}

final readinessProvider =
    StateNotifierProvider<ReadinessNotifier, ReadinessState>(
  (_) => ReadinessNotifier(),
);
