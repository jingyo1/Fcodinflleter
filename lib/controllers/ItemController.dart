import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../utils/api_client.dart';
import '../helpers/database_helper.dart';
import '../utils/PaginatedResponse.dart';
class ItemController {
  final ApiClient _apiClient;
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;
  
  ItemController({required ApiClient apiClient})
      : _apiClient = apiClient;

  /// 내 게시물 불러오기 (서버에서)
  Future<List<Map<String, dynamic>>> fetchMyPosts({
    int page = 0,
    int size = 20,
  }) async {
    print('headers: ${_apiClient.defaultHeaders}');
    final response = await _apiClient.get(
      '/posts/me',
      queryParams: {'page': '$page', 'size': '$size'},
    );
    final data = jsonDecode(response.body) as Map<String, dynamic>;
    final paginated = PaginatedResponse.fromJson(
      data,
      (json) => PostResponse.fromJson(json),
    );
    return paginated.content.map((e) => e.toJson()).toList();
  }

  /// 코디 이미지 업로드 (outfitId 기반)
  Future<bool> uploadImageSet({
    required int outfitId,
  }) async {
    final rows = await _dbHelper.getOutfits(status: 'Save');
    final row = rows.firstWhere((r) => r['id'] == outfitId, orElse: () => {});
    if (row.isEmpty) return false;

    final Map<String, String> imagesBase64 = {};
    final paths = {
      'top_image': row['top_path'] as String?,
      'bottom_image': row['bottom_path'] as String?,
      'jacket_image': row['jacket_path'] as String?,
      'shoes_image': row['shoes_path'] as String?,
    };

    for (final entry in paths.entries) {
      final key = entry.key;      
      final path = entry.value;   

      if (path != null && await File(path).exists()) {
        // 파일을 바이트로 읽어서 Base64로 인코딩
        final bytes = await File(path).readAsBytes();
        final base64Str = base64Encode(bytes);
        imagesBase64[key] = base64Str;
      }
    }

    final body = {
      'user_id': _apiClient.headers['X-User-Id'],

      'top_image': imagesBase64['top_image'],
      'bottom_image': imagesBase64['bottom_image'],
      'jacket_image': imagesBase64['jacket_image'],
      'shoes_image': imagesBase64['shoes_image'],
    };


    final uri = Uri.parse('${_apiClient.baseUrl}/uploads');
    final response = await http.post(
      uri,
      headers: _apiClient.headers,  
      body: jsonEncode(body),            
    );

    _apiClient.log(response);
    _apiClient.checkForError(response);

    return response.statusCode == 200 || response.statusCode == 201;
  }
  /// 게시물 삭제
Future<bool> deletePost(int postId) async {
  try {
    final response = await _apiClient.delete('/posts/$postId');
    if (response.statusCode >= 200 && response.statusCode < 300) {
      return true;
    } else {
      return false;
    }
  } catch (_) {
    return false;
  }
}
}