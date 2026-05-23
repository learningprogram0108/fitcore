// 本週每肌群加權組數 Provider
// 合併 DB 歷史記錄 + 當前 Session（尚未 complete 的今日訓練）

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../core/database/app_database.dart';
import '../../program/domain/movement_data.dart';
import '../../program/domain/muscle_volume.dart';
import '../../program/domain/workout_session_notifier.dart';

final weeklyVolumeProvider =
    FutureProvider<Map<MuscleGroup, double>>((ref) async {
  final db      = ref.watch(appDatabaseProvider);
  final session = ref.watch(workoutSessionProvider);
  final weekStart = _thisWeekMonday();

  // 1. DB 歷史：本週已完成的訓練組數
  final dbCounts = await db.getWeeklySetCounts(weekStart);

  // 2. 合併當前 Session 中尚未寫入 DB 的組數
  final all = Map<String, int>.from(dbCounts);
  if (!session.isCompleted) {
    for (final entry in session.setsPerExercise.entries) {
      all[entry.key] = (all[entry.key] ?? 0) + entry.value.length;
    }
  }

  // 3. 加權計算
  return MuscleVolumeCalc.compute(
    all,
    (id) => MovementLibrary.find(id)?.muscleWeights,
  );
});

DateTime _thisWeekMonday() {
  final now = DateTime.now();
  final startOfDay = DateTime(now.year, now.month, now.day);
  return startOfDay.subtract(Duration(days: now.weekday - 1));
}
