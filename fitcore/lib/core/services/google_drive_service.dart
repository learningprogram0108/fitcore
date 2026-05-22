import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:googleapis/drive/v3.dart' as drive;
import 'package:http/http.dart' as http;

// ── Google OAuth HTTP Client ────────────────────────────────
class _GoogleAuthClient extends http.BaseClient {
  _GoogleAuthClient(this._headers);
  final Map<String, String> _headers;
  final _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) {
    request.headers.addAll(_headers);
    return _inner.send(request);
  }
}

// ── Google Drive Service ─────────────────────────────────────
class GoogleDriveService {
  static const _scopes = ['https://www.googleapis.com/auth/drive.file'];
  static const _folderName = 'FitCore';

  final GoogleSignIn _googleSignIn = GoogleSignIn(scopes: _scopes);

  bool get isSignedIn => _googleSignIn.currentUser != null;

  /// 觸發 OAuth 流程
  Future<bool> signIn() async {
    try {
      final account = await _googleSignIn.signIn();
      return account != null;
    } catch (e) {
      return false;
    }
  }

  Future<void> signOut() => _googleSignIn.signOut();

  /// 上傳 CSV 至 Google Drive 的 FitCore 資料夾
  /// 回傳檔案的 webViewLink（可為 null）
  Future<String?> uploadCsv({
    required String fileName,
    required String csvContent,
  }) async {
    final account = _googleSignIn.currentUser;
    if (account == null) return null;

    final auth = await account.authHeaders;
    final client = _GoogleAuthClient(auth);
    final driveApi = drive.DriveApi(client);

    try {
      // 找或建立 FitCore 資料夾
      final folderId = await _ensureFolder(driveApi);

      // 上傳 CSV
      final media = drive.Media(
        Stream.value(utf8.encode(csvContent)),
        csvContent.length,
        contentType: 'text/csv; charset=utf-8',
      );

      final file = drive.File()
        ..name = fileName
        ..parents = [folderId]
        ..mimeType = 'text/csv';

      final result = await driveApi.files.create(
        file,
        uploadMedia: media,
        $fields: 'id,webViewLink',
      );

      return result.webViewLink;
    } catch (e) {
      return null;
    } finally {
      client.close();
    }
  }

  Future<String> _ensureFolder(drive.DriveApi api) async {
    // 搜尋現有 FitCore 資料夾
    const query =
        "name='$_folderName' and mimeType='application/vnd.google-apps.folder' and trashed=false";
    final list =
        await api.files.list(q: query, spaces: 'drive', $fields: 'files(id)');

    if (list.files != null && list.files!.isNotEmpty) {
      return list.files!.first.id!;
    }

    // 建立新資料夾
    final folder = drive.File()
      ..name = _folderName
      ..mimeType = 'application/vnd.google-apps.folder';
    final created = await api.files.create(folder, $fields: 'id');
    return created.id!;
  }
}

// ── Provider ────────────────────────────────────────────────
final googleDriveServiceProvider = Provider<GoogleDriveService>(
  (_) => GoogleDriveService(),
);
