import 'package:google_generative_ai/google_generative_ai.dart';

/// FitCore AI 教練 — Google Gemini 2.5 Flash Lite（免費方案）
/// 免費配額：15 RPM · 250K TPM · 500 次/天
/// API 金鑰取得：https://aistudio.google.com/app/apikey
class GeminiApiClient {
  static const modelName = 'gemini-2.5-flash-lite';

  // ── 系統提示（健身知識庫）────────────────────────────
  static const _systemPrompt = '''
你是 FitCore 的專業健身 AI 教練，請以繁體中文回覆所有問題。

【知識範疇】
• 三大項技術：背蹲舉（矢狀面膝伸展＋髖伸展）、硬舉（後鏈主導）、臥推（胸肌水平推）
• 生物力學：三解剖平面分析（矢狀/額狀/水平）、代償模式識別、個體解剖差異
• 週期化訓練：線性 Mesocycle（4 週）、RPE 1-10 量表、RIR 0-5 管理、自動降量週設計
• 動作輔助選擇：基於薄弱環節分析（蹲舉前傾 → 臀中肌/腰椎伸肌強化）
• 運動營養：
  - BMR 計算（Mifflin-St Jeor）
  - TDEE（BMR × 活動係數）
  - 蛋白質目標：1.6–2.2 g/kg（減脂期提升至 2.0–2.6 g/kg）
  - 能量可利用性（EA）：≥ 45 kcal/kg 最佳、< 30 kcal/kg 有 RED-S 風險
  - Leucine 門檻：每餐 ≥ 3g 觸發 mTORC1 蛋白質合成
• 恢復與超補償：睡眠品質、降量週頻率、HRV 指標

【回覆風格】
- 具體、可操作，避免泛泛而談
- 引用研究支持（Eric Helms、Mike Israetel、Brad Schoenfeld 等學者）
- 使用 Markdown 格式（**粗體**、列表、> 引言）讓內容易讀
- 回覆長度適中，重點放在即時可用的建議
- 非健身相關問題請禮貌拒絕，引導回訓練話題
''';

  final GenerativeModel _model;
  late ChatSession _chat;

  GeminiApiClient(String apiKey)
      : _model = GenerativeModel(
          model: modelName,
          apiKey: apiKey,
          systemInstruction: Content.system(_systemPrompt),
          generationConfig: GenerationConfig(
            temperature: 0.7,
            maxOutputTokens: 1024,
          ),
        ) {
    _chat = _model.startChat();
  }

  /// 串流回覆（逐字輸出，UX 更佳）
  Stream<String> sendMessageStream(String text) async* {
    await for (final response
        in _chat.sendMessageStream(Content.text(text))) {
      final chunk = response.text;
      if (chunk != null && chunk.isNotEmpty) yield chunk;
    }
  }

  /// 重置對話（清除上下文，開始新會話）
  void resetChat() => _chat = _model.startChat();
}
