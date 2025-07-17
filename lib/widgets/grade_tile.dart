import 'package:flutter/material.dart';

class GradeTile extends StatelessWidget {
  final int gradeLevel;
  final bool selected;
  final VoidCallback onTap;

  const GradeTile({
    super.key,
    required this.gradeLevel,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text('Grade $gradeLevel'),
      tileColor: selected ? Colors.deepPurple[100] : null,
      trailing: selected ? const Icon(Icons.check, color: Colors.deepPurple) : null,
      onTap: onTap,
    );
  }
} 