# FitCore — 私人健身 APP

## 專案概述
私人化跨平台健身 APP（Android + Windows），基於個人知識庫（解剖學、生物力學、三大項指南、週期化課表、運動營養）。

**三個核心原則：離線優先 · 隱私優先 · 知識驅動**

---

## 技術棧

| 層級 | 技術 | 版本 |
|------|------|------|
| UI 框架 | Flutter (Dart) | 3.44+ |
| 狀態管理 | Riverpod 2 | ^2.6 |
| 本地資料庫 | Drift (SQLite ORM) | ^2.20 |
| 雲端同步 | Supabase | ^2.8 |
| 導覽 | GoRouter | ^14 |
| **解剖圖** | **flutter_body_atlas** | **^0.1.4** |
| AI 教練 | Google Gemini API (gemini-2.5-flash-lite) | ^0.4.6 |
| 圖表 | fl_chart | ^0.69 |
| Markdown | flutter_markdown | ^0.7 |

---

## 專案結構

```
fitcore/
├── lib/
│   ├── main.dart                    # 入口：Riverpod + Supabase 初始化
│   ├── app/
│   │   ├── app.dart                 # MaterialApp.router
│   │   ├── theme/app_theme.dart     # 深色主題、色彩系統、RPE 顏色
│   │   └── router/app_router.dart   # GoRouter + ShellRoute（桌面側邊/行動底部導覽）
│   ├── features/
│   │   ├── training_log/            # 訓練日誌
│   │   ├── program/                 # 課表管理與週期化
│   │   ├── nutrition/               # 運動營養追蹤
│   │   ├── ai_coach/                # Claude AI 教練
│   │   └── knowledge_base/          # 動作知識庫 + flutter_body_atlas 解剖圖
│   └── core/
│       ├── database/                # Drift schema + migration
│       ├── sync/                    # Supabase 同步（本地優先）
│       └── api/                     # Anthropic Claude API wrapper
├── knowledge_src/                   # 原始 .md 知識庫（不打包進 app）
├── assets/knowledge/                # 解析後的 JSON 知識庫（打包）
└── test/unit/                       # 計算邏輯單元測試
```

---

## 解剖圖系統（flutter_body_atlas）

**套件**：`flutter_body_atlas: ^0.1.4`（BSD-3 授權，開源 SVG 高精度解剖圖）

**三層肌群顏色**：
- 🔴 主動肌（`#FF4444`）：動作主要作功肌群
- 🟠 輔助肌群（`#FF9500`）：協同穩定
- 🔵 協同穩定肌（`#3DA9FF`）：次要穩定

**三解剖平面分類**：
- 矢狀面 → 屈曲 / 伸展（膝伸展、髖伸展）
- 額狀面 → 外展 / 內收（骨盆穩定、膝外翻控制）
- 水平面 → 內旋 / 外旋（髖外旋、軀幹抗旋轉）

**使用方式**：
```dart
BodyAtlasView<MuscleId>(
  view: AtlasAsset.musclesFront,
  resolver: const MuscleResolver(),
  colorMapping: {MuscleId.quadriceps: AppTheme.muscPrimary},
  onTapElement: (muscle) => ...,
)
```

---

## 計算引擎

### 1RM 估算（`one_rm_calculator.dart`）
- ≤5 次：Brzycki 公式（更準確）
- >5 次：Epley 公式

### TDEE 計算（`tdee_calculator.dart`）
- BMR：Mifflin-St Jeor 方程式
- 蛋白質：1.6-2.2 g/kg（減脂期 2.0-2.6 g/kg）
- EA（能量可利用性）：< 30 kcal/kg → RED-S 警告

### 週期化引擎（`periodization_engine.dart`）
- 每週遞減次數 + 遞增 RPE（線性週期）
- 降量週自動檢測（每 4 週第 4 週）
- 根據上週實際 RPE 建議重量調整

---

## AI 教練整合

```
System Prompt = 健身知識庫（硬寫在 GeminiApiClient._systemPrompt）
              + 用戶資料（體重、課表、本週記錄）

User Message = 用戶問題

→ gemini-1.5-flash → 繁體中文串流回覆（逐字輸出）
```

**免費配額**：每日 500 次 · 15 RPM · 250K TPM（[aistudio.google.com](https://aistudio.google.com/app/apikey)）

**API 金鑰存放**：`flutter_secure_storage`（key: `gemini_api_key`，不寫死在程式碼中）

---

## 資料安全
- SQLite 本地優先，不強制雲端
- Supabase API 金鑰存於 `flutter_secure_storage`
- Gemini API 金鑰存於 `flutter_secure_storage`（key: `gemini_api_key`）
- `.gitignore` 已排除所有敏感檔案

---

## 開發指令

```bash
# 安裝依賴
flutter pub get

# 生成 Drift schema 和 Riverpod 程式碼
dart run build_runner build --delete-conflicting-outputs

# 執行測試
flutter test

# 執行 Android
flutter run -d android

# 執行 Windows
flutter run -d windows
```

---

## 知識庫模組對應

| 知識庫 .md 檔案 | 對應功能 |
|----------------|---------|
| 當前課表/4天週期化課表.md | 課表管理初始資料 |
| 當前課表/Day 1-4 Movement Bible.md | 動作知識庫 + AI Coach |
| 運動營養/營養金字塔.md | TDEE 計算基準 |
| 力量訓練理論/哲學流派.md | AI Coach 背景知識 |
| 三大項終極指南/*.md | flutter_body_atlas 肌群映射 |
| Anatomy & Biomechanics/*.md | 個體化解剖差異邏輯 |
