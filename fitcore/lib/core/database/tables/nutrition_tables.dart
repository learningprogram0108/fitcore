import 'package:drift/drift.dart';

/// 每日營養記錄
class NutritionLogs extends Table {
  IntColumn get id          => integer().autoIncrement()();
  DateTimeColumn get date   => dateTime()();
  RealColumn get proteinG   => real().withDefault(const Constant(0))();
  RealColumn get carbG      => real().withDefault(const Constant(0))();
  RealColumn get fatG       => real().withDefault(const Constant(0))();
  RealColumn get totalKcal  => real().withDefault(const Constant(0))();
  // 補劑記錄（JSON）: {"creatine": true, "caffeine": 200, ...}
  TextColumn get supplements => text().withDefault(const Constant('{}'))();
  TextColumn get notes      => text().withDefault(const Constant(''))();
  BoolColumn get synced     => boolean().withDefault(const Constant(false))();
}
