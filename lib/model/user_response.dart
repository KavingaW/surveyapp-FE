class User {
  final String id;
  final String username;
  final String email;

  User({
    required this.id,
    required this.username,
    required this.email,
  });

  String get _id => id;
  set id(String value) => id = value;

  String get _username => username;
  set username(String value) => username = value;

  String get _email => email;
  set email(String value) => email = value;

  //
  // User();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      username: json['username'],
      email: json['email'],
    );
  }

  Map<String, dynamic> toJson(User user) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = user.id;
    data['username'] = user.username;
    data['email'] = user.email;
    data['password'] = null;
    data['roles'] = null;
    return data;
  }
}
