class UserRequest{

  final String username;
  final String email;
  final String password;
  final String role;

  UserRequest({
    required this.username,
    required this.email,
    required this.password,
    this.role = "user"
  });



}