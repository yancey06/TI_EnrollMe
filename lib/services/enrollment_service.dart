import '../models/enrollment.dart';

class EnrollmentService {
  static final List<Enrollment> _enrollments = [];

  static Enrollment? getEnrollment(String username) {
    try {
      return _enrollments.firstWhere((e) => e.username == username);
    } catch (e) {
      return null;
    }
  }

  static void saveEnrollment(Enrollment enrollment) {
    _enrollments.removeWhere((e) => e.username == enrollment.username);
    _enrollments.add(enrollment);
  }
} 