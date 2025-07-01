class UserInfo {
  final int userid;
  final String username;

  UserInfo({
    required this.userid,
    required this.username,
  });

  factory UserInfo.fromJson(Map<String, dynamic> json) {
    return UserInfo(
      userid: json['id'] as int,
      username: json['username'] as String,
    );
  }
}