import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/google_drive_service.dart';
import '../domain/csv_export_service.dart';
import '../domain/one_rm_calculator.dart';
import 'widgets/exercise_card.dart';

/// 訓練日誌頁面
class TrainingLogPage extends ConsumerStatefulWidget {
  const TrainingLogPage({super.key});

  @override
  ConsumerState<TrainingLogPage> createState() => _TrainingLogPageState();
}

class _TrainingLogPageState extends ConsumerState<TrainingLogPage> {
  final DateTime _selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          // ── 日期標題列 ──
          Container(
            padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: AppTheme.border)),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${_selectedDate.year}.${_selectedDate.month.toString().padLeft(2, '0')}.${_selectedDate.day.toString().padLeft(2, '0')} — Day 1',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 2),
                      const Text('Week 3 · 漸進超負荷週 · 下肢推力 + 核心',
                          style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
                    ],
                  ),
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: const Text('開始訓練'),
                ),
              ],
            ),
          ),

          // ── 動作卡片 + 統計 + 匯出（整合滾動列表）──
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                // 動作卡片
                ExerciseCard(
                  exerciseName: '背蹲舉（高槓）',
                  prescribed: '4×6 @RPE 8',
                  existingSets: const [
                    LoggedSet(reps: 6, weightKg: 110, rpe: 7.5, isDone: true),
                    LoggedSet(reps: 6, weightKg: 110, rpe: 8.0, isDone: true),
                    LoggedSet(reps: 6, weightKg: 110, rpe: 8.5, isDone: true),
                  ],
                  targetSets: 4,
                  onSetLogged: (set) {},
                ),
                const SizedBox(height: 12),
                ExerciseCard(
                  exerciseName: '保加利亞分腿蹲',
                  prescribed: '3×10/邊 @RPE 7',
                  existingSets: const [],
                  targetSets: 3,
                  onSetLogged: (set) {},
                ),
                const SizedBox(height: 12),
                ExerciseCard(
                  exerciseName: '農夫走路',
                  prescribed: '4×20m @RPE 7',
                  existingSets: const [],
                  targetSets: 4,
                  onSetLogged: (set) {},
                ),

                // ── 統計區塊 ──
                const SizedBox(height: 24),
                const Text('訓練總量',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppTheme.textSecond)),
                const SizedBox(height: 10),
                const Row(children: [
                  _StatCard('3', '已完成組'),
                  SizedBox(width: 6),
                  _StatCard('18', '總次數'),
                  SizedBox(width: 6),
                  _StatCard('1980', 'Volume\nkg'),
                ]),

                // ── 1RM 趨勢 ──
                const SizedBox(height: 16),
                const Text('背蹲舉 — 歷史 1RM 趨勢',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppTheme.textSecond)),
                const SizedBox(height: 8),
                Container(
                  height: 100,
                  decoration: BoxDecoration(
                    color: AppTheme.surface2,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.center,
                  child: const Text('1RM 趨勢圖\n(fl_chart)',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppTheme.textSecond, fontSize: 11)),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('估算 1RM',
                        style: TextStyle(fontSize: 9, color: AppTheme.textSecond)),
                    Text(
                      '~${OneRmCalculator.estimate(110, 6).toStringAsFixed(0)} kg',
                      style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.accent),
                    ),
                  ],
                ),

                // ── 導出 CSV ──
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1E2A10),
                      foregroundColor: AppTheme.accent,
                      side: const BorderSide(color: AppTheme.accent, width: 1),
                    ),
                    icon: const Icon(Icons.upload_file, size: 16),
                    label: const Text('導出訓練日誌 CSV',
                        style: TextStyle(fontWeight: FontWeight.w700)),
                    onPressed: _exportCsv,
                  ),
                ),

                // ── 訓練備註 ──
                const SizedBox(height: 20),
                const Text('訓練備註',
                    style: TextStyle(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.5,
                        color: AppTheme.textSecond)),
                const SizedBox(height: 8),
                const TextField(
                  maxLines: 4,
                  decoration: InputDecoration(
                    hintText: '記錄今日感受、技術問題、恢復狀況…',
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── 導出 CSV + Google Drive ────────────────────────────
  Future<void> _exportCsv() async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final db = ref.read(appDatabaseProvider);
      final csv = await CsvExportService.buildCsv(db);
      final file = await CsvExportService.saveLocally(csv);

      if (!mounted) return;

      messenger.showSnackBar(SnackBar(
        content: Text('CSV 已儲存：${file.path}'),
        duration: const Duration(seconds: 4),
      ));

      // 詢問是否上傳 Google Drive
      final uploadToGdrive = await showDialog<bool>(
        context: context,
        builder: (_) => AlertDialog(
          backgroundColor: const Color(0xFF181818),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          title: const Text('上傳至 Google Drive？'),
          content: const Text(
            '將 CSV 上傳至 Google Drive 的 FitCore 資料夾',
            style: TextStyle(color: AppTheme.textSecond),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(false),
              child: const Text('僅本地儲存'),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: AppTheme.accent,
                foregroundColor: Colors.black,
              ),
              onPressed: () => Navigator.of(context, rootNavigator: true).pop(true),
              child: const Text('上傳 Drive'),
            ),
          ],
        ),
      );

      if (uploadToGdrive != true || !mounted) return;

      final drive = ref.read(googleDriveServiceProvider);
      if (!drive.isSignedIn) {
        final ok = await drive.signIn();
        if (!ok) {
          if (mounted) {
            messenger.showSnackBar(
              const SnackBar(content: Text('Google 登入失敗')),
            );
          }
          return;
        }
      }

      final url = await drive.uploadCsv(
        fileName: file.uri.pathSegments.last,
        csvContent: csv,
      );

      if (mounted) {
        messenger.showSnackBar(SnackBar(
          content: Text(url != null
              ? '已上傳至 Google Drive ✓'
              : '上傳失敗，請稍後再試'),
          backgroundColor: url != null
              ? const Color(0xFF2A4A10)
              : null,
        ));
      }
    } catch (e) {
      if (mounted) {
        messenger.showSnackBar(
          SnackBar(content: Text('導出失敗：$e')),
        );
      }
    }
  }

}

class _StatCard extends StatelessWidget {
  const _StatCard(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Expanded(
    child: Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(children: [
        Text(value, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, color: AppTheme.accent)),
        Text(label, style: const TextStyle(fontSize: 8, color: AppTheme.textSecond),
          textAlign: TextAlign.center),
      ]),
    ),
  );
}
