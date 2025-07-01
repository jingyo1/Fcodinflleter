import 'dart:convert';
import '../utils/api_client.dart';
import '../utils/PaginatedResponse.dart';
///서버와 통신하는 컨트롤러
class SocialController {
  final ApiClient _apiClient;
  SocialController({required ApiClient apiClient}) : _apiClient = apiClient;


Future<List<Map<String, dynamic>>> fetchPosts({
  int page = 0,
  int size = 20,
  required String sort,
}) async {
  final response = await _apiClient.get(
    '/posts',
    queryParams: {
      'page': '$page',
      'size': '$size',
      'orderByKey': sort,
    },
  );
  final data = jsonDecode(response.body) as Map<String, dynamic>;
  final paginated = PaginatedResponse.fromJson(
    data,
    (json) => PostResponse.fromJson(json),
  );
  return paginated.content.map((e) => e.toJson()).toList();
}
  // 소셜내에서 좋아요시 추가
  Future<void> toggleLike(int postId) async {
    await _apiClient.post('/posts/$postId/like');
  }
bool isLogin() {
  return _apiClient.isLogin; 
}
}


