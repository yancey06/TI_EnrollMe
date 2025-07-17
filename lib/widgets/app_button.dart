import 'package:flutter/material.dart';

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool filled;

  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.filled = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: filled
          ? ElevatedButton(
              onPressed: onPressed,
              child: Text(label),
            )
          : OutlinedButton(
              onPressed: onPressed,
              child: Text(label),
            ),
    );
  }
} 