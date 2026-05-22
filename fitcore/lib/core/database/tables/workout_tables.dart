import 'package:drift/drift.dart';

/// 訓練日誌：每次訓練 Session（一天一次或多次）
class WorkoutSessions extends Table {
  IntColumn get id        => integer().autoIncrement()();
  TextColumn get uuid     => text().withLength(min: 36, max: 36)();
  DateTimeColumn get date => dateTime()();
  TextColumn get notes    => text().withDefault(const Constant(''))();
  TextColumn get dayLabel => text().withDefault(const Constant(''))(); // e.g. "Day 1"
  IntColumn get weekNum   => integer().withDefault(const Constant(1))();
  BoolColumn get synced   => boolean().withDefault(const Constant(false))();
}

/// 訓練組數：每一組的具體記錄
class WorkoutSets extends Table {
  IntColumn get id          => integer().autoIncrement()();
  IntColumn get sessionId   => integer().references(WorkoutSessions, #id)();
  TextColumn get exercise   => text()(); // 動作名稱，e.g. "背蹲舉"
  IntColumn get setNumber   => integer()(); // 第幾組
  IntColumn get reps        => integer()(); // 次數
  RealColumn get weightKg   => real()();   // 重量 kg
  RealColumn get rpe        => real().withDefault(const Constant(0))(); // RPE 1-10
  IntColumn get rir         => integer().withDefault(const Constant(-1))(); // -1 = 未記錄
  RealColumn get estimated1rm => real().withDefault(const Constant(0))(); // 自動計算
  TextColumn get notes      => text().withDefault(const Constant(''))();
  DateTimeColumn get loggedAt => dateTime()();
}

/// 課表（4週 Mesocycle）
class Programs extends Table {
  IntColumn get id          => integer().autoIncrement()();
  TextColumn get name       => text()();
  IntColumn get weeksTotal  => integer().withDefault(const Constant(4))();
  DateTimeColumn get startDate => dateTime()();
  BoolColumn get isActive   => boolean().withDefault(const Constant(true))();
  TextColumn get notes      => text().withDefault(const Constant(''))();
}

/// 課表每天的訓練日定義
class ProgramDays extends Table {
  IntColumn get id          => integer().autoIncrement()();
  IntColumn get programId   => integer().references(Programs, #id)();
  IntColumn get dayNumber   => integer()(); // 1-4
  TextColumn get label      => text()();   // "下肢推力 + 核心"
  IntColumn get durationMin => integer().withDefault(const Constant(60))();
}

/// 課表每個動作的週期化配置
class ProgramExercises extends Table {
  IntColumn get id          => integer().autoIncrement()();
  IntColumn get programDayId => integer().references(ProgramDays, #id)();
  TextColumn get exercise   => text()();   // 動作名稱
  // 每週配置存 JSON: {"1":{"sets":4,"reps":8,"rpe":7}, "2":...}
  TextColumn get weeklyConfig => text()();
  IntColumn get sortOrder   => integer().withDefault(const Constant(0))();
}

/// 用戶個人資料
class UserProfiles extends Table {
  IntColumn get id              => integer().autoIncrement()();
  TextColumn get name           => text().withDefault(const Constant('訓練者'))();
  RealColumn get bodyWeightKg   => real().withDefault(const Constant(0))();
  IntColumn get heightCm        => integer().withDefault(const Constant(0))();
  IntColumn get trainingAgeYears => integer().withDefault(const Constant(1))();
  TextColumn get goal           => text().withDefault(const Constant('strength'))();
  // goal: 'strength' | 'hypertrophy' | 'recomp'
  DateTimeColumn get createdAt  => dateTime()();
}
