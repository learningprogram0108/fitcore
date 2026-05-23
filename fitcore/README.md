# FitCore — 私人化智慧健身 APP

> 離線優先 · 隱私優先 · 知識驅動
>
> Flutter 跨平台應用（Windows + Android），整合 6 週週期化課表、訓練日誌、解剖學知識庫（31 個動作）、AI 教練與運動營養。

---

## 功能概覽

### 🗓️ 6 週週期化課表

- **6 週 Mesocycle**：前 3 週肌肥大區塊 → 後 3 週最大肌力區塊，無縫線性切換
- **動態處方矩陣**：4 大動作分類（MAIN_COMPOUND / AUXILIARY_COMPOUND / ISOLATION / FUNCTIONAL_CORE）× 6 週，自動根據當前週次計算組數、次數、RPE 與負荷強度
- **週次選擇器**：標題列 `← Week X/6 →` 切換，SharedPreferences 持久化記憶當前週次
- 4 天訓練分配（下肢推力、水平推拉、後鏈、上肢混合）
- 點擊動作進入 Movement Bible 六階段動作指南（Markdown 排版 + 解剖圖）
- 動作替換功能（長壓彈出搜尋替換，新動作自動套用當週處方）
- **磷酸肌酸休息建議**：確認每組後依次數與 RPE 自動分析能量系統及建議休息時長
- 完成當日所有動作後一鍵寫入日誌資料庫

### 📚 動作知識庫（31 個動作）

- 31 個完整動作，均含解剖聚焦、力學特徵、五階段執行指南、核心提示詞（ExpansionTile）
- **flutter_body_atlas** 解剖圖（前/後視角，三色肌群高亮）
- Markdown 閱讀性優化：**粗體解剖術語**、`> blockquote` 安全警告、列點執行要點
- 三解剖平面分類（矢狀面 / 額狀面 / 水平面）
- 即時搜尋過濾

### 📋 訓練日誌

- 每日訓練組數記錄（重量 / 次數 / RPE）
- 估算 1RM 趨勢圖（Brzycki / Epley 公式）
- 一鍵匯出訓練日誌 CSV，可選同步至 Google Drive
- 本地 SQLite 優先儲存，完整離線支援
- **本週訓練量儀表板**：9 大肌群加權組數橫條圖（Helms 金字塔：維持 / 黃金成長 / 垃圾容量）
- **CNS 準備度評估**：睡眠品質、精力、肌肉酸痛三維評分 → 🟢/🟡/🔴 狀態與 RPE 建議

### 🔥 運動營養

- TDEE 計算（Mifflin-St Jeor BMR）
- 三大營養素目標（蛋白質 1.6–2.6 g/kg）
- **EA 能量可用性（Energy Availability）警戒**：< 30 kcal/kg FFM 自動顯示 RED-S 警告

### 🤖 AI 教練

- Google Gemini 2.5 Flash Lite 驅動
- 串流即時回覆，繁體中文輸出
- 整合個人體重、課表與本週記錄作為上下文
- API 金鑰以 `flutter_secure_storage` 本地加密存放

---

## 6 週動態處方矩陣

| 週次 | 區塊屬性 | MAIN_COMPOUND | AUXILIARY_COMPOUND | ISOLATION | FUNCTIONAL_CORE |
|:---:|:------|:------|:------|:------|:------|
| **W1** | 肌肥大累積期 | 3×12 @RPE 7.0 / ≈65% | 3×12 @RPE 7.5 / ≈67.5% | 3×15 @RPE 8.0 / ≈60% | 3×40s 中等張力 |
| **W2** | 肌肥大推進期 | 3×10 @RPE 7.5 / ≈71% | 3×10 @RPE 8.0 / ≈75% | 3×12 @RPE 8.5 / ≈67.5% | 3×50s 中等張力 |
| **W3** | 肌肥大頂峰週 | 4×8 @RPE 8.0 / ≈78% | 3×10 @RPE 8.5 / ≈76.5% | 4×12 @RPE 9.0 / ≈70% | 3×60s 中高張力 |
| **W4** | 最大肌力轉化 | 4×5 @RPE 8.5 / ≈83% | 3×8 @RPE 8.0 / ≈75% | 2×12 @RPE 8.0 / ≈67.5% | 3×30s 高剛性對抗 |
| **W5** | 肌力超負荷期 | 4×4 @RPE 9.0 / ≈86% | 2×8 @RPE 8.5 / ≈76.5% | 2×10 @RPE 8.0 / ≈71% | 2×30s 極致剛性 |
| **W6** | 神經極致釋放 | 5×3 @RPE 9.5 / ≈90% | 2×6 @RPE 9.0 / ≈83% | 2×10 @RPE 8.0 / ≈71% | 2×30s 極限剛性 |

---

## 動作分類（31 個動作）

| 分類 | 動作 |
|------|------|
| **MAIN_COMPOUND**（大項核心複合） | 槓鈴背蹲舉、槓鈴臥推、六角槓硬舉、傳統硬舉、相撲硬舉 |
| **AUXILIARY_COMPOUND**（輔助複合） | 保加利亞分腿蹲、槓鈴肩推、正手引體向上、澤奇深蹲、單腿 RDL、仰臥划船、啞鈴上斜臥推、寬握滑輪下拉、雙槓撐體、窄握伏地挺身、哥薩克深蹲、單臂啞鈴划船、槓鈴臀推、地雷管推舉 |
| **ISOLATION**（孤立動作） | 站姿提踵、滑輪面拉、滑輪三頭下壓、北歐腿彎舉、坐姿腿彎舉、懸吊舉腿 |
| **FUNCTIONAL_CORE**（功能性剛性核心） | 農夫走路、哥本哈根側平舉、TRX 平板撐、Pallof Press、土耳其起身、反向雪橇 |

---

## 解剖圖系統（flutter_body_atlas）

三色肌群分層：
- 🔴 **主動肌**（`#FF4444`）：動作主要作功肌群
- 🟠 **輔助肌群**（`#FF9500`）：協同穩定
- 🔵 **協同穩定肌**（`#3DA9FF`）：次要穩定

三解剖平面分類：矢狀面（屈/伸）· 額狀面（外展/內收）· 水平面（內旋/外旋）

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
| AI 教練 | Google Gemini API (gemini-2.5-flash-lite) | ^0.4.6 |
| 圖表 | fl_chart | ^0.69 |
| Markdown | flutter_markdown | ^0.7 |
| Google Drive | googleapis + google_sign_in | ^13 / ^6 |
| 週次持久化 | shared_preferences | ^2.3 |

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
│   │   ├── program/                       # 課表管理與週期化
│   │   │   ├── domain/
│   │   │   │   ├── movement_data.dart     # 31 個動作 Movement Bible 資料
│   │   │   │   ├── prescription_matrix.dart   # 6 週處方矩陣 + ProgramWeekNotifier
│   │   │   │   ├── muscle_volume.dart     # MuscleGroup enum + Helms 加權計算
│   │   │   │   ├── workout_session_notifier.dart
│   │   │   │   └── periodization_engine.dart
│   │   │   └── presentation/
│   │   │       ├── program_page.dart      # 6 週動態課表 + 週次選擇器
│   │   │       └── exercise_detail_page.dart  # MarkdownBody + 解剖圖 + 磷酸肌酸
│   │   ├── knowledge_base/                # 動作知識庫 + flutter_body_atlas 解剖圖
│   │   │   ├── domain/
│   │   │   │   ├── big_three_data.dart    # 三大項知識
│   │   │   │   └── pt_rehab_data.dart     # 物理治療復健
│   │   │   └── presentation/
│   │   │       ├── knowledge_base_page.dart
│   │   │       └── widgets/anatomy_view.dart
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

# 執行測試
flutter test

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
- Google Drive 以 OAuth 2.0 授權（google_sign_in），不儲存任何憑證於程式碼
- `.gitignore` 已排除所有敏感檔案（.env、google-services.json、*.jks 等）

---

## 計算引擎

| 引擎 | 公式/邏輯 |
|------|---------|
| **1RM 估算** | ≤5 次 → Brzycki；>5 次 → Epley |
| **TDEE** | Mifflin-St Jeor BMR × 活動係數 |
| **蛋白質目標** | 1.6–2.2 g/kg（減脂期 2.0–2.6 g/kg） |
| **EA 警戒** | < 30 kcal/kg FFM → RED-S 紅燈 |
| **RIR 逆推** | RIR = 10 − RPE；目標 RM = 次數 + RIR |
| **訓練量加權** | Helms 金字塔：主動肌 1.0 × 組數；輔助肌 0.5 × 組數 |

---

## 授權

本專案為個人私用健身工具，僅供學習參考。  
解剖圖元件使用 [flutter_body_atlas](https://pub.dev/packages/flutter_body_atlas)（BSD-3 授權）。
