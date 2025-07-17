import 'package:flutter/material.dart';
import 'utils/app_routes.dart';
// Screens (to be implemented)
import 'screens/login_screen.dart';
import 'screens/register_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/enrollment_screen.dart';
import 'screens/grade_selection_screen.dart';
import 'screens/subject_selection_screen.dart';
import 'screens/summary_screen.dart';
import 'screens/enrollment_success_screen.dart';
import 'screens/landing_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Enrollment System',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/landing',
      routes: {
        AppRoutes.login: (context) => const LoginScreen(),
        AppRoutes.register: (context) => const RegisterScreen(),
        AppRoutes.profile: (context) => ProfileScreen(),
        AppRoutes.enrollment: (context) => const EnrollmentScreen(),
        AppRoutes.gradeSelection: (context) => const GradeSelectionScreen(),
        AppRoutes.subjectSelection: (context) => const SubjectSelectionScreen(),
        AppRoutes.summary: (context) => const SummaryScreen(),
        '/enrollment-success': (context) => const EnrollmentSuccessScreen(),
        '/landing': (context) => const LandingScreen(),
      },
    );
  }
}
