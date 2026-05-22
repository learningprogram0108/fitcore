import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import 'app/app.dart';
import 'core/database/app_database.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Supabase 初始化（雲端同步）
  // 將金鑰存於 flutter_secure_storage，不寫死在程式碼中
  const storage = FlutterSecureStorage();
  final supabaseUrl = await storage.read(key: 'SUPABASE_URL') ?? '';
  final supabaseAnonKey = await storage.read(key: 'SUPABASE_ANON_KEY') ?? '';

  if (supabaseUrl.isNotEmpty) {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  // ── 本地 SQLite 資料庫初始化
  final db = AppDatabase();

  runApp(
    ProviderScope(
      overrides: [
        // 將資料庫注入 Riverpod
        appDatabaseProvider.overrideWithValue(db),
      ],
      child: const FitCoreApp(),
    ),
  );
}
