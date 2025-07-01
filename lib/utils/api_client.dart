import 'dart:convert';
import 'package:http/http.dart' as http;
import '../utils/User_class.dart';
/// ApiClient: HTTP 요청 공통 처리
class ApiClient {
  final String baseUrl="http://192.168.219.108:8080/api";
  final Map<String, String> defaultHeaders;
  bool isLogin=false;
  /// 기본 헤더 (Content-Type, X-User-Id 등)
  Map<String, String> get headers => defaultHeaders;
  late UserInfo userInfo=UserInfo(userid: 0, username: '게스트');
  
  ApiClient({
    String? userId,
  }) : defaultHeaders = {
         'Content-Type': 'application/json',
         if (userId != null) 'X-User-Id': userId,
       };

  void updateUserinfo(int userid, String username) {
    userInfo = UserInfo(userid: userid, username: username);
  }
  /// 로그인시에만 작동한다
  void updateHeader(String key, String value) {
    defaultHeaders[key] = value;
    isLogin=true;
  }
  UserInfo getUserInfo()
  {
    return userInfo;
  }
  bool islogin()
  {
    return isLogin;
  }
  /// GET 요청
  Future<http.Response> get(String path, { Map<String, dynamic>? queryParams }) {
    final uri = Uri.parse(baseUrl + path).replace(queryParameters: queryParams);
    return http.get(uri, headers: defaultHeaders)
      .then((res) { log(res); checkForError(res); return res; });
  }

  /// POST 요청
  Future<http.Response> post(
    String path, {
    Object? body,
  }) async {
    final uri = Uri.parse(baseUrl + path);
    final payload = body is String ? body : jsonEncode(body);
    final response = await http.post(uri, headers: defaultHeaders, body: payload);
    log(response);
    checkForError(response);
    return response;
  }

  /// DELETE 요청
  Future<http.Response> delete(String path) async {
    final uri = Uri.parse(baseUrl + path);
    final response = await http.delete(uri, headers: defaultHeaders);
    
    log(response);
    checkForError(response);
    return response;
  }

  // 로깅
  void log(http.Response response) {
    print('API ${response.request?.method} ' 
        '${response.request?.url} [${response.statusCode}]');
  }

  // 에러 체크
  void checkForError(http.Response response) {
    if (response.statusCode >= 400) {
      throw ApiException(
        statusCode: response.statusCode,
        body: response.body,
      );
    }
  }
}

/// API 예외
class ApiException implements Exception {
  final int statusCode;
  final String body;

  ApiException({required this.statusCode, required this.body});

  @override
  String toString() => 'ApiException: HTTP $statusCode\n$body';
}
