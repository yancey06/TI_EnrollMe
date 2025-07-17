import 'package:flutter/material.dart';

class ProfileCard extends StatelessWidget {
  final String fullName;
  final String email;
  final int gradeLevel;

  const ProfileCard({
    super.key,
    required this.fullName,
    required this.email,
    required this.gradeLevel,
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
            Text('Name: $fullName', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text('Email: $email'),
            const SizedBox(height: 8),
            Text('Grade Level: $gradeLevel'),
          ],
        ),
      ),
    );
  }
} 