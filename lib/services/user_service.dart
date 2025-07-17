import '../models/profile.dart';

class UserService {
  static final List<Profile> _profiles = [];

  static Profile? getProfile(String username) {
    try {
      return _profiles.firstWhere((p) => p.username == username);
    } catch (e) {
      return null;
    }
  }

  static void saveProfile(Profile profile) {
    _profiles.removeWhere((p) => p.username == profile.username);
    _profiles.add(profile);
  }
} 