import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/subject_data.dart';
import '../models/subject.dart';
import '../utils/app_routes.dart';
import '../utils/section_data.dart';

class SubjectSelectionScreen extends StatefulWidget {
  const SubjectSelectionScreen({super.key});

  @override
  State<SubjectSelectionScreen> createState() => _SubjectSelectionScreenState();
}

class _SubjectSelectionScreenState extends State<SubjectSelectionScreen> {
  int? _gradeLevel;
  late List<Subject> _subjects;
  Section? _section;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final args = ModalRoute.of(context)?.settings.arguments;
    if (args is Map && args['gradeLevel'] != null && args['section'] != null) {
      _gradeLevel = args['gradeLevel'] as int;
      _section = args['section'] as Section;
      _subjects = List<Subject>.from(gradeSubjects[_gradeLevel!] ?? []);
    } else {
      _gradeLevel = null;
      _section = null;
      _subjects = [];
    }
  }

  void _onConfirm() {
    if (_gradeLevel != null && _section != null) {
      Navigator.pushNamed(
        context,
        AppRoutes.summary,
        arguments: {
          'gradeLevel': _gradeLevel,
          'subjects': _subjects,
          'section': _section,
        },
      );
    }
  }

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
        title: Text('Select Subjects', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
        centerTitle: true,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Add TI logo at the top
                Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 12),
                  child: Center(
                    child: SizedBox(
                      width: 56,
                      height: 56,
                      child: Image.asset(
                        'lib/screens/ti_logo.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),
                Text(
                  'Subjects for Grade ${_gradeLevel ?? ''}',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                if (_section != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Section ${_section!.name}',
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF00BFAE),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Adviser: ${_section!.teacher}',
                    style: GoogleFonts.poppins(
                      fontSize: 15,
                      color: Colors.white70,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                ..._subjects.map((subject) => Container(
                  margin: const EdgeInsets.only(bottom: 18),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    gradient: const LinearGradient(
                      colors: [Color(0xFF3D5AFE), Color(0xFF00BFAE)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF3D5AFE).withOpacity(0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                    leading: CircleAvatar(
                      backgroundColor: Colors.white.withOpacity(0.12),
                      child: Text(
                        subject.code,
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    title: Text(
                      subject.name,
                      style: GoogleFonts.poppins(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    subtitle: Text(
                      'Teacher: ${subject.teacher}',
                      style: GoogleFonts.poppins(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ),
                )),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      elevation: 8,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: const Color(0xFF3D5AFE),
                      foregroundColor: Colors.white,
                      textStyle: GoogleFonts.poppins(
                        fontWeight: FontWeight.w600,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: _onConfirm,
                    child: const Text('Confirm'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
} 