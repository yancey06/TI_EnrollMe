import 'package:flutter/material.dart';

class EnrollmentScreen extends StatelessWidget {
  const EnrollmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
      ),
      body: const Center(child: Text('Enrollment Screen Placeholder')),
    );
  }
} 