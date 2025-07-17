class User {
  final String username;
  final String password;
  String? fullName;
  String? email;

  User({
    required this.username,
    required this.password,
    this.fullName,
    this.email,
  });
} 