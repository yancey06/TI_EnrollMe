import '../models/user.dart';

class AuthService {
  static final List<User> _users = [];
  static User? _currentUser;

  static User? get currentUser => _currentUser;

  static bool register(String username, String password, {String? fullName, String? email}) {
    if (_users.any((u) => u.username == username)) return false;
    _users.add(User(username: username, password: password, fullName: fullName, email: email));
    return true;
  }

  static bool login(String username, String password) {
    final user = _users.firstWhere(
      (u) => u.username == username && u.password == password,
      orElse: () => User(username: '', password: ''),
    );
    if (user.username.isNotEmpty) {
      _currentUser = user;
      return true;
    }
    return false;
  }

  static void logout() {
    _currentUser = null;
  }
} 