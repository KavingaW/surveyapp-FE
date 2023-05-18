class UserRequest{

  final String username;
  final String email;
  final String password;
  final Set<String> role;

  UserRequest({
    required this.username,
    required this.email,
    required this.password,
    required this.role
  });

  // UserRequest.empty()
  //     : username = '',
  //       email = '',
  //       password = '',
  //       role = '';
  //
  // factory User.fromJson(Map<String, dynamic> json) {
  //   return User(
  //     id: json['id'],
  //     username: json['username'],
  //     email: json['email'],
  //   );
  // }
  //
  Map<String, dynamic> toJson(UserRequest user) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['username'] = user.username;
    data['email'] = user.email;
    data['password'] = user.password;
    data['roles'] = ["user"];
    return data;
  }

}