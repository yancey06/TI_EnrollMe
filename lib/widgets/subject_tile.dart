import 'package:flutter/material.dart';

class SubjectTile extends StatelessWidget {
  final String subjectName;
  final bool selected;
  final VoidCallback onTap;

  const SubjectTile({
    super.key,
    required this.subjectName,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(subjectName),
      tileColor: selected ? Colors.deepPurple[100] : null,
      trailing: selected ? const Icon(Icons.check, color: Colors.deepPurple) : null,
      onTap: onTap,
    );
  }
} 