import 'dart:io';
import 'package:drift/drift.dart';
import 'package:intl/intl.dart';
import 'package:path_provider/path_provider.dart';

import '../../../core/database/app_database.dart';

class CsvExportService {
  CsvExportService._();

  static const _header =
      '日期,星期,Day,動作ID,組數,重量(kg),次數,RPE,RIR,估算1RM(kg)\n';

  static const _weekdays = ['', '週一', '週二', '週三', '週四', '週五', '週六', '週日'];

  static final _dateFmt = DateFormat('yyyy-MM-dd');

  /// 從資料庫建立 CSV 字串
  static Future<String> buildCsv(AppDatabase db) async {
    // Join workoutSessions + workoutSets
    final sets = await (db.select(db.workoutSets)
          ..orderBy([
            (t) => OrderingTerm(expression: t.loggedAt),
          ]))
        .get();

    // 建立 session 查詢表
    final sessions = await db.select(db.workoutSessions).get();
    final sessionMap = {for (final s in sessions) s.id: s};

    final buf = StringBuffer(_header);

    for (final s in sets) {
      final session = sessionMap[s.sessionId];
      if (session == null) continue;

      final date = _dateFmt.format(session.date);
      final weekday = _weekdays[session.date.weekday];
      final day = session.dayLabel;
      final exercise = _escapeCsv(s.exercise);
      final setNum = s.setNumber;
      final weight = s.weightKg.toStringAsFixed(1);
      final reps = s.reps;
      final rpe = s.rpe.toStringAsFixed(1);
      final rir = s.rir < 0 ? '' : s.rir.toString();
      final orm = s.estimated1rm.toStringAsFixed(1);

      buf.write(
          '$date,$weekday,$day,$exercise,$setNum,$weight,$reps,$rpe,$rir,$orm\n');
    }

    return buf.toString();
  }

  /// 儲存至本地 Documents 目錄
  static Future<File> saveLocally(String csvContent) async {
    final dir = await getApplicationDocumentsDirectory();
    final now = DateTime.now();
    final stamp = DateFormat('yyyyMMdd_HHmm').format(now);
    final file = File('${dir.path}/fitcore_export_$stamp.csv');
    await file.writeAsString(csvContent, flush: true);
    return file;
  }

  static String _escapeCsv(String value) {
    if (value.contains(',') || value.contains('"') || value.contains('\n')) {
      return '"${value.replaceAll('"', '""')}"';
    }
    return value;
  }
}
