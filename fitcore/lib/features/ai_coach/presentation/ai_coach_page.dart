import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../../app/theme/app_theme.dart';
import '../data/gemini_api_client.dart';

// ── 安全儲存金鑰名稱 ──────────────────────────────────
const _kGeminiKeyName = 'gemini_api_key';

class AiCoachPage extends ConsumerStatefulWidget {
  const AiCoachPage({super.key});
  @override
  ConsumerState<AiCoachPage> createState() => _AiCoachPageState();
}

class _AiCoachPageState extends ConsumerState<AiCoachPage> {
  final _ctrl   = TextEditingController();
  final _scroll = ScrollController();
  final _storage = const FlutterSecureStorage();

  final _messages = <_ChatMsg>[];
  bool _isLoading = false;
  GeminiApiClient? _client;

  static const _quickPrompts = [
    '背蹲舉下蹲時如何保持軀幹直立？',
    '硬舉拉不起來，最常見的原因是什麼？',
    '如何根據體重設定每日蛋白質目標？',
    '訓練量太重，需要降量嗎？',
    '臀中肌無力會導致什麼代償？',
  ];

  @override
  void initState() {
    super.initState();
    _loadApiKey();
  }

  Future<void> _loadApiKey() async {
    final key = await _storage.read(key: _kGeminiKeyName);
    if (key != null && key.isNotEmpty && mounted) {
      setState(() => _client = GeminiApiClient(key));
    }
  }

  // ── 儲存 API 金鑰對話框 ────────────────────────────
  Future<void> _showApiKeyDialog() async {
    final ctrl = TextEditingController();
    final existing = await _storage.read(key: _kGeminiKeyName);
    ctrl.text = existing ?? '';

    if (!mounted) return;
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('設定 Gemini API 金鑰'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '前往 aistudio.google.com/app/apikey 取得免費金鑰\n（每天 1,500 次，完全免費）',
              style: TextStyle(fontSize: 12, color: AppTheme.textSecond),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: ctrl,
              obscureText: true,
              decoration: const InputDecoration(
                hintText: 'AIza...',
                labelText: 'Gemini API Key',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('取消'),
          ),
          FilledButton(
            onPressed: () async {
              final key = ctrl.text.trim();
              if (key.isNotEmpty) {
                // 儲存前先取得 navigator 引用，避免 async gap 後使用失效的 context
                final navigator = Navigator.of(ctx);
                await _storage.write(key: _kGeminiKeyName, value: key);
                if (mounted) setState(() => _client = GeminiApiClient(key));
                navigator.pop();
              }
            },
            child: const Text('儲存'),
          ),
        ],
      ),
    );
  }

  // ── 傳送訊息（串流回覆）────────────────────────────
  Future<void> _send(String text) async {
    if (text.trim().isEmpty) return;
    if (_client == null) {
      await _showApiKeyDialog();
      return;
    }

    final msg = text.trim();
    _ctrl.clear();
    setState(() {
      _messages.add(_ChatMsg(role: 'user', text: msg));
      _messages.add(const _ChatMsg(role: 'assistant', text: ''));
      _isLoading = true;
    });
    _scrollToBottom();

    String accumulated = '';
    try {
      await for (final chunk in _client!.sendMessageStream(msg)) {
        accumulated += chunk;
        if (!mounted) break;
        setState(() {
          _messages[_messages.length - 1] =
              _ChatMsg(role: 'assistant', text: accumulated);
        });
        _scrollToBottom();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _messages[_messages.length - 1] = _ChatMsg(
            role: 'assistant',
            text: '❌ 發生錯誤：$e\n\n請確認 API 金鑰是否正確。',
          );
        });
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scroll.hasClients) {
        _scroll.animateTo(
          _scroll.position.maxScrollExtent,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // ── 標題列 ──────────────────────────────────
        Container(
          padding: const EdgeInsets.fromLTRB(20, 16, 8, 12),
          decoration: const BoxDecoration(
            border: Border(bottom: BorderSide(color: AppTheme.border)),
          ),
          child: Row(children: [
            const Icon(Icons.auto_awesome, color: AppTheme.accentWarm, size: 20),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('AI 健身教練', style: Theme.of(context).textTheme.titleLarge),
                  Text(
                    _client == null
                        ? '尚未設定 API 金鑰 — 點右上角設定'
                        : 'Gemini 2.5 Flash Lite · 每日 500 次免費',
                    style: TextStyle(
                      fontSize: 10,
                      color: _client == null
                          ? AppTheme.accentWarm
                          : AppTheme.textSecond,
                    ),
                  ),
                ],
              ),
            ),
            // 重置對話按鈕
            if (_messages.isNotEmpty)
              IconButton(
                icon: const Icon(Icons.refresh_rounded, size: 18),
                tooltip: '重置對話',
                onPressed: () {
                  _client?.resetChat();
                  setState(() => _messages.clear());
                },
              ),
            // API 金鑰設定按鈕
            IconButton(
              icon: Icon(
                Icons.key_rounded,
                size: 18,
                color: _client == null ? AppTheme.accentWarm : null,
              ),
              tooltip: '設定 Gemini API 金鑰',
              onPressed: _showApiKeyDialog,
            ),
          ]),
        ),

        // ── 訊息列表 ────────────────────────────────
        Expanded(
          child: _messages.isEmpty
              ? _EmptyState(onTap: _send, hasKey: _client != null)
              : _MessageList(
                  messages: _messages,
                  scrollCtrl: _scroll,
                  isLoading: _isLoading,
                ),
        ),

        // ── 快速提問（首次）─────────────────────────
        if (_messages.isEmpty && _client != null)
          _QuickPrompts(
            prompts: _quickPrompts,
            onSelected: (p) {
              _ctrl.text = p;
              _send(p);
            },
          ),

        // ── 輸入列 ──────────────────────────────────
        _InputBar(
          ctrl: _ctrl,
          isLoading: _isLoading,
          onSend: () => _send(_ctrl.text),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _ctrl.dispose();
    _scroll.dispose();
    super.dispose();
  }
}

// ── 資料模型 ──────────────────────────────────────────
class _ChatMsg {
  const _ChatMsg({required this.role, required this.text});
  final String role;
  final String text;
}

// ── 空狀態 ────────────────────────────────────────────
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onTap, required this.hasKey});
  final void Function(String) onTap;
  final bool hasKey;

  @override
  Widget build(BuildContext context) => Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.auto_awesome, size: 48, color: AppTheme.accentWarm),
            const SizedBox(height: 12),
            Text('FitCore AI 教練',
                style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 4),
            Text(
              hasKey
                  ? '詢問任何關於訓練、生物力學、營養的問題'
                  : '請先點右上角 🔑 設定 Gemini API 金鑰（免費）',
              style: const TextStyle(
                  color: AppTheme.textSecond, fontSize: 12),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
}

// ── 訊息列表 ──────────────────────────────────────────
class _MessageList extends StatelessWidget {
  const _MessageList({
    required this.messages,
    required this.scrollCtrl,
    required this.isLoading,
  });
  final List<_ChatMsg> messages;
  final ScrollController scrollCtrl;
  final bool isLoading;

  @override
  Widget build(BuildContext context) => ListView.builder(
        controller: scrollCtrl,
        padding: const EdgeInsets.all(16),
        itemCount: messages.length + (isLoading && messages.last.text.isEmpty ? 1 : 0),
        itemBuilder: (ctx, i) {
          // 思考中指示器（只在 AI 氣泡還沒有文字時顯示）
          if (i == messages.length) {
            return const Padding(
              padding: EdgeInsets.only(top: 8),
              child: Row(children: [
                SizedBox(width: 8),
                SizedBox(
                  width: 16, height: 16,
                  child: CircularProgressIndicator(
                      strokeWidth: 2, color: AppTheme.accentWarm),
                ),
                SizedBox(width: 8),
                Text('思考中…',
                    style: TextStyle(
                        fontSize: 11, color: AppTheme.textSecond)),
              ]),
            );
          }

          final msg = messages[i];
          final isUser = msg.role == 'user';

          return Align(
            alignment:
                isUser ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.symmetric(
                  horizontal: 12, vertical: 9),
              constraints: BoxConstraints(
                  maxWidth:
                      MediaQuery.of(context).size.width * .82),
              decoration: BoxDecoration(
                color: isUser
                    ? AppTheme.accentDim
                    : AppTheme.surface2,
                borderRadius: BorderRadius.circular(12),
                border: isUser
                    ? Border.all(
                        color: AppTheme.accent.withValues(alpha: .3))
                    : Border.all(color: AppTheme.border),
              ),
              // AI 回覆使用 Markdown 渲染
              child: isUser
                  ? Text(msg.text,
                      style: const TextStyle(fontSize: 12, height: 1.6))
                  : MarkdownBody(
                      data: msg.text.isEmpty ? '▋' : msg.text,
                      styleSheet: MarkdownStyleSheet(
                        p: const TextStyle(fontSize: 12, height: 1.6),
                        code: const TextStyle(
                          fontSize: 11,
                          backgroundColor:
                              AppTheme.surface3,
                          fontFamily: 'monospace',
                        ),
                        codeblockDecoration: BoxDecoration(
                          color: AppTheme.surface3,
                          borderRadius: BorderRadius.circular(6),
                        ),
                      ),
                    ),
            ),
          );
        },
      );
}

// ── 快速提問 ──────────────────────────────────────────
class _QuickPrompts extends StatelessWidget {
  const _QuickPrompts({required this.prompts, required this.onSelected});
  final List<String> prompts;
  final void Function(String) onSelected;

  @override
  Widget build(BuildContext context) => SizedBox(
        height: 38,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          itemCount: prompts.length,
          separatorBuilder: (_, __) => const SizedBox(width: 8),
          itemBuilder: (_, i) => ActionChip(
            label:
                Text(prompts[i], style: const TextStyle(fontSize: 10)),
            onPressed: () => onSelected(prompts[i]),
            backgroundColor: AppTheme.surface2,
          ),
        ),
      );
}

// ── 輸入列 ────────────────────────────────────────────
class _InputBar extends StatelessWidget {
  const _InputBar({
    required this.ctrl,
    required this.isLoading,
    required this.onSend,
  });
  final TextEditingController ctrl;
  final bool isLoading;
  final VoidCallback onSend;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: AppTheme.border)),
        ),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: ctrl,
              decoration: const InputDecoration(hintText: '詢問任何訓練問題…'),
              maxLines: 3,
              minLines: 1,
              textInputAction: TextInputAction.send,
              onSubmitted: (_) => onSend(),
            ),
          ),
          const SizedBox(width: 8),
          IconButton.filled(
            onPressed: isLoading ? null : onSend,
            icon: isLoading
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2))
                : const Icon(Icons.send_rounded),
            style: IconButton.styleFrom(
              backgroundColor: AppTheme.accent,
              foregroundColor: Colors.black,
            ),
          ),
        ]),
      );
}
