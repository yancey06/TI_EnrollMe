import 'subject.dart';

class Enrollment {
  final String username;
  final int gradeLevel;
  final List<Subject> subjects;

  Enrollment({
    required this.username,
    required this.gradeLevel,
    required this.subjects,
  });
} 