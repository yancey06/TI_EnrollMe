import 'package:flutter/material.dart';

class EnrollmentCard extends StatelessWidget {
  final int gradeLevel;
  final List<String> subjects;

  const EnrollmentCard({
    super.key,
    required this.gradeLevel,
    required this.subjects,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(16.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Grade Level: $gradeLevel', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Subjects:'),
            ...subjects.map((s) => Text('- $s')).toList(),
          ],
        ),
      ),
    );
  }
} 