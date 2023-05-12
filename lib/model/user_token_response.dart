class User {
  final String id;
  final String username;
  final String email;
  final String tokenType;
  final String role;
  final String accessToken;

  User({
    required this.id,
    required this.username,
    required this.email,
    required this.tokenType,
    required this.role,
    required this.accessToken,
  });

  //
  // User();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
      role: json['role'],
      accessToken: json['accessToken'],
      tokenType: json['tokenType'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'username': username,
        'email': email,
        'role': role,
        'accessToken': accessToken,
        'tokenType': tokenType
      };
}
