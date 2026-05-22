import 'package:drift/drift.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../core/database/app_database.dart';

// ── 單組記錄 ────────────────────────────────────────────────
class LoggedSet {
  const LoggedSet({
    required this.weightKg,
    required this.reps,
    required this.rpe,
  });
  final double weightKg;
  final int reps;
  final double rpe;

  /// Epley / Brzycki 1RM 估算
  double get estimated1rm {
    if (reps <= 0) return weightKg;
    if (reps == 1) return weightKg;
    if (reps <= 5) {
      // Brzycki（高準確度，低次數）
      return weightKg * (36 / (37 - reps));
    } else {
      // Epley
      return weightKg * (1 + reps / 30);
    }
  }

  int get rir => (10 - rpe).round().clamp(0, 10);
}

// ── 當日 Session 狀態 ────────────────────────────────────────
class WorkoutSessionState {
  const WorkoutSessionState({
    this.setsPerExercise = const {},
    this.isCompleted = false,
  });

  final Map<String, List<LoggedSet>> setsPerExercise;
  final bool isCompleted;

  List<LoggedSet> setsFor(String movementId) =>
      setsPerExercise[movementId] ?? const [];

  int totalSets(String movementId) => setsFor(movementId).length;

  bool hasAnySets(String movementId) => setsFor(movementId).isNotEmpty;

  WorkoutSessionState copyWith({
    Map<String, List<LoggedSet>>? setsPerExercise,
    bool? isCompleted,
  }) =>
      WorkoutSessionState(
        setsPerExercise: setsPerExercise ?? this.setsPerExercise,
        isCompleted: isCompleted ?? this.isCompleted,
      );
}

// ── StateNotifier ────────────────────────────────────────────
class WorkoutSessionNotifier
    extends StateNotifier<WorkoutSessionState> {
  WorkoutSessionNotifier(this._db) : super(const WorkoutSessionState());

  final AppDatabase _db;
  static const _uuid = Uuid();

  // 新增一組
  void addSet(
    String movementId, {
    required double weightKg,
    required int reps,
    required double rpe,
  }) {
    final newSet = LoggedSet(weightKg: weightKg, reps: reps, rpe: rpe);
    final current = Map<String, List<LoggedSet>>.from(
        state.setsPerExercise.map((k, v) => MapEntry(k, List<LoggedSet>.from(v))));
    current[movementId] = [...(current[movementId] ?? []), newSet];
    state = state.copyWith(setsPerExercise: current);
  }

  // 移除某動作的第 index 組
  void removeSet(String movementId, int index) {
    final current = Map<String, List<LoggedSet>>.from(
        state.setsPerExercise.map((k, v) => MapEntry(k, List<LoggedSet>.from(v))));
    final sets = List<LoggedSet>.from(current[movementId] ?? []);
    if (index >= 0 && index < sets.length) {
      sets.removeAt(index);
      current[movementId] = sets;
      state = state.copyWith(setsPerExercise: current);
    }
  }

  // 完成今日訓練 → 寫入 DB
  Future<void> completeSession({
    required int dayNum,
    required int weekNum,
  }) async {
    if (state.isCompleted) return;

    // 1. 建立 WorkoutSession
    final sessionId = await _db.into(_db.workoutSessions).insert(
      WorkoutSessionsCompanion.insert(
        uuid: _uuid.v4(),
        date: DateTime.now(),
        dayLabel: Value('Day $dayNum'),
        weekNum: Value(weekNum),
      ),
    );

    // 2. 逐動作逐組寫入 WorkoutSets
    for (final entry in state.setsPerExercise.entries) {
      final movementId = entry.key;
      final sets = entry.value;
      for (int i = 0; i < sets.length; i++) {
        final s = sets[i];
        await _db.into(_db.workoutSets).insert(
          WorkoutSetsCompanion.insert(
            sessionId: sessionId,
            exercise: movementId,
            setNumber: i + 1,
            reps: s.reps,
            weightKg: s.weightKg,
            rpe: Value(s.rpe),
            rir: Value(s.rir),
            estimated1rm: Value(s.estimated1rm),
            loggedAt: DateTime.now(),
          ),
        );
      }
    }

    state = state.copyWith(isCompleted: true);
  }

  // 重置（開始新的一天）
  void resetSession() {
    state = const WorkoutSessionState();
  }
}

// ── Provider ────────────────────────────────────────────────
final workoutSessionProvider =
    StateNotifierProvider<WorkoutSessionNotifier, WorkoutSessionState>(
  (ref) => WorkoutSessionNotifier(ref.watch(appDatabaseProvider)),
);
