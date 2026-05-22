import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Supabase 雲端同步服務
/// 本地優先：SQLite 主資料庫，Supabase 作為可選備份/同步
class SupabaseSync {
  SupabaseSync(this._client);
  final SupabaseClient _client;

  bool get isAvailable => Supabase.instance.client.auth.currentUser != null;

  /// 推送本地未同步的訓練記錄
  /// [sessions] 從 Drift DB 查詢的未同步 sessions
  Future<void> pushWorkoutSessions(List<Map<String, dynamic>> sessions) async {
    if (!isAvailable) return;
    try {
      await _client.from('workout_sessions').upsert(sessions);
    } catch (e) {
      // 同步失敗不影響本地使用
      // TODO: 加入 retry queue
    }
  }

  /// 推送營養記錄
  Future<void> pushNutritionLogs(List<Map<String, dynamic>> logs) async {
    if (!isAvailable) return;
    try {
      await _client.from('nutrition_logs').upsert(logs);
    } catch (e) {
      // silent fail
    }
  }

  /// 從雲端拉取最新資料（跨裝置同步）
  Future<List<Map<String, dynamic>>> pullWorkoutSessions({
    required DateTime since,
  }) async {
    if (!isAvailable) return [];
    try {
      return await _client
          .from('workout_sessions')
          .select()
          .gte('date', since.toIso8601String())
          .order('date', ascending: false);
    } catch (e) {
      return [];
    }
  }
}

final supabaseSyncProvider = Provider<SupabaseSync?>((ref) {
  try {
    return SupabaseSync(Supabase.instance.client);
  } catch (_) {
    return null; // Supabase 未初始化時返回 null
  }
});
