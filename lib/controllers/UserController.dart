import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/User_class.dart';
import '../utils/api_client.dart';
//로그인 전체 관리하는 컨트롤러
class UserController {
  late UserInfo _currentUser;
  final ApiClient _apiClient;

  UserController({required ApiClient apiClient}) : _apiClient = apiClient;

Future<UserInfo> register({
  required String id,
  required String nickname,
  required String password,
}) async {
  try {
    final uri = Uri.parse('${_apiClient.baseUrl}/register');

    final response = await http.post(
      uri,
      headers: {
        ..._apiClient.headers,
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'userid': id,
        'username': nickname,
        'password': password,
      }),
    );

    _apiClient.log(response);
    _apiClient.checkForError(response);

    final data = jsonDecode(response.body) as Map<String, dynamic>;
    _currentUser = UserInfo.fromJson(data);

    // userId도 헤더로 갱신
    _apiClient.updateHeader('X-User-Id', _currentUser.userid.toString());
    _apiClient.updateUserinfo(_currentUser.userid,_currentUser.username);
    return _currentUser;
  } catch (e) {
    rethrow;
  }
}


  Future<UserInfo> login({
    required String userid,
    required String password,
  }) async {
    try {
      final response = await _apiClient.post(
        '/login',
        body: {'userid': userid, 'password': password},
      );
      final data = jsonDecode(response.body) as Map<String, dynamic>;
      _currentUser = UserInfo.fromJson(data);
      _apiClient.updateHeader('X-User-Id', _currentUser.userid.toString());
      _apiClient.updateUserinfo(_currentUser.userid,_currentUser.username);
      return _currentUser;
    } catch (e) {
      rethrow;
    }
  }
}
