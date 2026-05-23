# FitCore — 私人化智慧健身 APP

> 離線優先 · 隱私優先 · 知識驅動
>
> Flutter 跨平台應用（Windows + Android），整合週期化課表、訓練日誌、AI 教練、運動營養與解剖學知識庫。

---

## 功能概覽

### 📋 訓練日誌
- 每日訓練組數記錄（重量 / 次數 / RPE）
- 估算 1RM 趨勢圖（Brzycki / Epley 公式）
- 一鍵匯出訓練日誌 CSV，可選同步至 Google Drive
- 本地 SQLite 優先儲存，完整離線支援
- **本週訓練量儀表板**：9 大肌群（胸、背、股四頭、臀腿後、前/中後三角、三頭、二頭、核心）加權組數橫條圖，依 Helms 金字塔分為維持 / 黃金成長 / 垃圾容量三區間
- **CNS 準備度評估**：每日睡眠品質、精力、肌肉酸痛三維度評分，自動輸出 🟢/🟡/🔴 狀態與 RPE 建議

### 🗓️ 週期化課表
- 4 天訓練分配（下肢推力、水平推拉、後鏈、上肢混合）
- 點擊動作進入訓練記錄頁，內含 Movement Bible 六階段動作指南
- **磷酸肌酸休息建議**：確認每組後依次數與 RPE 自動顯示磷酸原 / 無氧糖解 / 代謝系統能量分析及建議休息時長
- 動作替換功能（桌面點擊選單 / 手機長壓底部彈出）
- 完成當日所有動作後一鍵寫入日誌資料庫

### 📚 動作知識庫
- 20 個核心動作，完整來自 Movement Bible
- 解剖聚焦、力學特徵、六階段執行指南、核心提示詞
- flutter_body_atlas 解剖圖（前/後視角，三層肌群高亮）
- 三解剖平面分類（矢狀面 / 額狀面 / 水平面）
- 即時搜尋過濾

### 🔥 運動營養
- TDEE 計算（Mifflin-St Jeor BMR）
- 三大營養素目標（蛋白質 1.6–2.6 g/kg）
- **EA 能量可用性（Energy Availability）警戒**：即時計算 EA = (攝入熱量 − 運動消耗) ÷ 瘦體重，< 30 kcal/kg FFM 自動顯示 RED-S 警告（睪固酮↓ · 甲狀腺↓ · 骨密度↓）

### 🤖 AI 教練
- Google Gemini 2.5 Flash Lite 驅動
- 串流即時回覆，繁體中文輸出
- 整合個人體重、課表與本週記錄作為上下文
- API 金鑰以 flutter_secure_storage 本地加密存放

---

## 技術棧

| 層級 | 技術 | 版本 |
|------|------|------|
| UI 框架 | Flutter (Dart) | 3.44+ |
| 狀態管理 | Riverpod 2 | ^2.6 |
| 本地資料庫 | Drift (SQLite ORM) | ^2.20 |
| 雲端同步 | Supabase | ^2.8 |
| 導覽路由 | GoRouter | ^14 |
| 解剖圖 | flutter_body_atlas | ^0.1.4 |
| AI 教練 | Google Gemini API | ^0.4.6 |
| 圖表 | fl_chart | ^0.69 |
| Markdown | flutter_markdown | ^0.7 |
| Google Drive | googleapis + google_sign_in | ^13 / ^6 |

---

## 專案結構

```
fitcore/
├── lib/
│   ├── main.dart                          # 入口：Riverpod + Supabase 初始化
│   ├── app/
│   │   ├── app.dart                       # MaterialApp.router
│   │   ├── theme/app_theme.dart           # 深色主題、色彩系統
│   │   └── router/app_router.dart         # GoRouter + ShellRoute
│   ├── features/
│   │   ├── training_log/                  # 訓練日誌 + CSV 匯出
│   │   │   ├── domain/
│   │   │   │   ├── csv_export_service.dart
│   │   │   │   ├── one_rm_calculator.dart
│   │   │   │   ├── readiness_notifier.dart    # CNS 準備度狀態管理
│   │   │   │   └── weekly_volume_provider.dart # 本週肌群訓練量計算
│   │   │   └── presentation/
│   │   │       ├── training_log_page.dart
│   │   │       └── widgets/exercise_card.dart
│   │   ├── program/                       # 課表管理
│   │   │   ├── domain/
│   │   │   │   ├── movement_data.dart     # 20 個動作 Movement Bible 資料
│   │   │   │   ├── muscle_volume.dart     # MuscleGroup enum + Helms 加權計算
│   │   │   │   ├── workout_session_notifier.dart
│   │   │   │   └── periodization_engine.dart
│   │   │   └── presentation/
│   │   │       ├── program_page.dart
│   │   │       └── exercise_detail_page.dart  # 含磷酸肌酸休息建議
│   │   ├── knowledge_base/                # 動作知識庫 + 解剖圖
│   │   ├── nutrition/                     # 運動營養追蹤
│   │   └── ai_coach/                      # Gemini AI 教練
│   └── core/
│       ├── database/                      # Drift schema + migration
│       ├── services/
│       │   └── google_drive_service.dart  # Google Drive OAuth + 上傳
│       └── api/                           # Gemini API wrapper
├── assets/
│   ├── knowledge/                         # JSON 知識庫（打包進 app）
│   └── images/
└── test/
```

---

## 快速開始

### 環境需求
- Flutter SDK 3.22+
- Dart SDK 3.4+
- Windows 10+ 或 Android 6.0+

### 安裝與執行

```bash
# 複製專案
git clone https://github.com/learningprogram0108/fitcore.git
cd fitcore

# 安裝依賴
flutter pub get

# 生成 Drift ORM 程式碼
dart run build_runner build --delete-conflicting-outputs

# 執行（Windows）
flutter run -d windows

# 執行（Android）
flutter run -d android
```

### API 金鑰設定

首次啟動後，在 AI 教練頁面輸入 Gemini API 金鑰（免費申請：[aistudio.google.com](https://aistudio.google.com/app/apikey)）。
金鑰以 `flutter_secure_storage` 加密儲存於裝置本地，不寫入程式碼或雲端。

---

## 資料安全

- SQLite 本地優先，不強制雲端同步
- Supabase / Gemini API 金鑰存於 `flutter_secure_storage`
- Google Drive 以 OAuth 2.0 授權，不儲存任何憑證於程式碼
- `.gitignore` 已排除所有敏感檔案

---

## 訓練動作（Movement Bible）

| Day | 動作 |
|-----|------|
| Day 1 — 下肢推力 + 核心 | 槓鈴背蹲舉、保加利亞分腿蹲、農夫走路、站姿提踵、哥本哈根側平舉 |
| Day 2 — 水平推拉 + 輔助 | 槓鈴臥推、正手引體向上、槓鈴肩推、滑輪面拉、滑輪三頭下壓 |
| Day 3 — 後鏈主導 | 六角槓硬舉、澤奇深蹲、北歐腿彎舉 / 單腿 RDL（週輪替）、坐姿腿彎舉 |
| Day 4 — 上肢混合 + 核心 | 仰臥划船、啞鈴上斜臥推、寬握滑輪下拉、雙槓撐體、TRX 平板撐 |

---

## 授權

本專案為個人私用健身工具，僅供學習參考。
解剖圖元件使用 [flutter_body_atlas](https://pub.dev/packages/flutter_body_atlas)（BSD-3 授權）。
