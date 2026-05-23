import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../app/theme/app_theme.dart';
import '../../../core/database/app_database.dart';
import '../../../core/services/google_drive_service.dart';
import '../../program/domain/muscle_volume.dart';
import '../domain/csv_export_service.dart';
import '../domain/one_rm_calculator.dart';
import '../domain/readiness_notifier.dart';
import '../domain/weekly_volume_provider.dart';
import 'widgets/exercise_card.dart';

/// 訓練日誌頁面
class TrainingLogPage extends ConsumerStatefulWidget {
  const TrainingLogPage({super.key});

  @override
  ConsumerState<TrainingLogPage> createState() => _TrainingLogPageState();
}

class _TrainingLogPageState extends ConsumerState<TrainingLogPage> {
  final DateTime _selectedDate = DateTime.now();

  // CNS 準備度表單（僅在展開時使用）
  bool _readinessExpanded = false;
  int _sleepRating = 3;
  double _energyLevel = 5.0;
  int _sorenessRating = 3;

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
                // ── 本週訓練量儀表板 ──
                _buildWeeklyVolumeCard(),

                // ── CNS 準備度評估 ──
                _buildReadinessCard(),

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

  // ── 本週訓練量儀表板 ──────────────────────────────────
  Widget _buildWeeklyVolumeCard() {
    final asyncVolume = ref.watch(weeklyVolumeProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Text('本週訓練量',
                  style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
              Spacer(),
              Text('WEEKLY VOLUME',
                  style: TextStyle(
                      fontSize: 9,
                      color: AppTheme.textSecond,
                      letterSpacing: 1)),
            ],
          ),
          const SizedBox(height: 2),
          const Text('0.5×輔助 + 1.0×主動 加權法',
              style:
                  TextStyle(fontSize: 10, color: AppTheme.textSecond)),
          const SizedBox(height: 12),
          asyncVolume.when(
            loading: () => const Center(
                child: Padding(
              padding: EdgeInsets.symmetric(vertical: 8),
              child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2)),
            )),
            error: (e, _) => Text('載入失敗: $e',
                style: const TextStyle(
                    color: Colors.redAccent, fontSize: 11)),
            data: (volume) => _VolumeBarList(volume: volume),
          ),
        ],
      ),
    );
  }

  // ── CNS 準備度評估 Card ──────────────────────────────
  Widget _buildReadinessCard() {
    final readiness = ref.watch(readinessProvider);
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surface2,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF2A2A2A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('CNS 準備度評估',
              style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: Colors.white)),
          const SizedBox(height: 2),
          const Text('每日評估一次，即可獲得今日 RPE 建議',
              style:
                  TextStyle(fontSize: 10, color: AppTheme.textSecond)),
          const SizedBox(height: 12),
          if (readiness.isToday) ...[
            // 已評估：顯示狀態 + 建議
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A2A0A),
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: const Color(0xFF4A8A0A)),
                  ),
                  child: Text(
                    readiness.levelLabel,
                    style: const TextStyle(
                        fontSize: 12, fontWeight: FontWeight.w700),
                  ),
                ),
                const Spacer(),
                Text(
                  '${readiness.score.toStringAsFixed(1)} / 10',
                  style: const TextStyle(
                      fontSize: 11, color: AppTheme.textSecond),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              readiness.rpeAdvice,
              style: const TextStyle(
                  fontSize: 12,
                  color: Color(0xFFBBBBBB),
                  height: 1.4),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: () => ref
                  .read(readinessProvider.notifier)
                  .reset(),
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: Size.zero,
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                foregroundColor: AppTheme.textSecond,
              ),
              child: const Text('重新評估',
                  style: TextStyle(fontSize: 11)),
            ),
          ] else if (_readinessExpanded) ...[
            // 展開表單
            _ReadinessFormContent(
              sleep: _sleepRating,
              energy: _energyLevel,
              soreness: _sorenessRating,
              onSleepChanged: (v) => setState(() => _sleepRating = v),
              onEnergyChanged: (v) =>
                  setState(() => _energyLevel = v),
              onSorenessChanged: (v) =>
                  setState(() => _sorenessRating = v),
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: FilledButton(
                style: FilledButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.black,
                ),
                onPressed: () {
                  ref.read(readinessProvider.notifier).assess(
                        sleep: _sleepRating,
                        energy: _energyLevel,
                        soreness: _sorenessRating,
                      );
                  setState(() => _readinessExpanded = false);
                },
                child: const Text('確認評估',
                    style: TextStyle(fontWeight: FontWeight.w700)),
              ),
            ),
          ] else ...[
            // 未評估：顯示按鈕
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: Color(0xFF4A8A0A)),
                  foregroundColor: AppTheme.accent,
                ),
                icon: const Icon(Icons.assessment_outlined, size: 16),
                label: const Text('評估今日狀態'),
                onPressed: () =>
                    setState(() => _readinessExpanded = true),
              ),
            ),
          ],
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

// ── 本週訓練量 — 9 大肌群橫條圖 ─────────────────────────
class _VolumeBarList extends StatelessWidget {
  const _VolumeBarList({required this.volume});
  final Map<MuscleGroup, double> volume;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: MuscleGroup.values.map((mg) {
        final sets = volume[mg] ?? 0.0;
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              SizedBox(
                width: 56,
                child: Text(
                  mg.label,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFFCCCCCC)),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: LayoutBuilder(builder: (context, constraints) {
                  final fraction =
                      (sets / MuscleVolumeCalc.junk).clamp(0.0, 1.0);
                  return Stack(
                    children: [
                      Container(
                        height: 10,
                        decoration: BoxDecoration(
                          color: const Color(0xFF222222),
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      FractionallySizedBox(
                        widthFactor: fraction,
                        child: Container(
                          height: 10,
                          decoration: BoxDecoration(
                            color: mg.zoneColor(sets),
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
              const SizedBox(width: 8),
              SizedBox(
                width: 38,
                child: Text(
                  sets > 0
                      ? sets.toStringAsFixed(sets % 1 == 0 ? 0 : 1)
                      : '—',
                  textAlign: TextAlign.right,
                  style: const TextStyle(
                      fontSize: 11, color: Color(0xFFBBBBBB)),
                ),
              ),
              const SizedBox(width: 6),
              SizedBox(
                width: 60,
                child: Text(
                  mg.zoneLabel(sets),
                  style: TextStyle(
                      fontSize: 9,
                      color: mg.zoneColor(sets),
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}

// ── CNS 準備度 — 表單輸入 ────────────────────────────────
class _ReadinessFormContent extends StatelessWidget {
  const _ReadinessFormContent({
    required this.sleep,
    required this.energy,
    required this.soreness,
    required this.onSleepChanged,
    required this.onEnergyChanged,
    required this.onSorenessChanged,
  });

  final int sleep;
  final double energy;
  final int soreness;
  final void Function(int) onSleepChanged;
  final void Function(double) onEnergyChanged;
  final void Function(int) onSorenessChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // 睡眠品質：1–5 星
        const Text('睡眠品質',
            style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
        const SizedBox(height: 4),
        Row(
          children: List.generate(5, (i) {
            final star = i + 1;
            return GestureDetector(
              onTap: () => onSleepChanged(star),
              child: Icon(
                Icons.star,
                size: 28,
                color: star <= sleep
                    ? const Color(0xFFFFCC00)
                    : const Color(0xFF333333),
              ),
            );
          }),
        ),

        const SizedBox(height: 12),

        // 精力狀態：1–10 滑桿
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('今日精力',
                style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
            Text(
              energy.toStringAsFixed(1),
              style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppTheme.accent),
            ),
          ],
        ),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: AppTheme.accent,
            thumbColor: AppTheme.accent,
            inactiveTrackColor: const Color(0xFF333333),
            overlayColor: AppTheme.accent.withAlpha(40),
          ),
          child: Slider(
            min: 1,
            max: 10,
            divisions: 9,
            value: energy,
            onChanged: onEnergyChanged,
          ),
        ),

        const SizedBox(height: 4),

        // 肌肉酸痛：1–5 星（1=無酸痛，5=非常酸痛）
        const Text('肌肉酸痛程度',
            style: TextStyle(fontSize: 11, color: AppTheme.textSecond)),
        const SizedBox(height: 4),
        Row(
          children: [
            ...List.generate(5, (i) {
              final star = i + 1;
              return GestureDetector(
                onTap: () => onSorenessChanged(star),
                child: Icon(
                  Icons.whatshot,
                  size: 26,
                  color: star <= soreness
                      ? const Color(0xFFFF6644)
                      : const Color(0xFF333333),
                ),
              );
            }),
            const SizedBox(width: 8),
            Text(
              soreness <= 1
                  ? '無酸痛'
                  : soreness <= 2
                      ? '輕微'
                      : soreness <= 3
                          ? '中等'
                          : soreness <= 4
                              ? '明顯'
                              : '非常酸',
              style: const TextStyle(
                  fontSize: 10, color: AppTheme.textSecond),
            ),
          ],
        ),
      ],
    );
  }
}
