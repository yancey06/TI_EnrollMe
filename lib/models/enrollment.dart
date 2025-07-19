import 'subject.dart';

class Enrollment {
  final String username;
  final int gradeLevel;
  final List<Subject> subjects;
  final String sectionName;
  final String adviser;

  Enrollment({
    required this.username,
    required this.gradeLevel,
    required this.subjects,
    required this.sectionName,
    required this.adviser,
  });
} 