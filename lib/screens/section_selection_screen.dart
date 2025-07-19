import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/section_data.dart';
import '../utils/app_routes.dart';

class SectionSelectionScreen extends StatefulWidget {
  final int gradeLevel;
  const SectionSelectionScreen({super.key, required this.gradeLevel});

  @override
  State<SectionSelectionScreen> createState() => _SectionSelectionScreenState();
}

class _SectionSelectionScreenState extends State<SectionSelectionScreen> {
  Section? _selectedSection;

  @override
  Widget build(BuildContext context) {
    final sections = gradeSections[widget.gradeLevel] ?? [];
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
          tooltip: 'Back',
        ),
        title: Text(
          'Select Section',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 20,
          ),
        ),
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
                  'Grade ${widget.gradeLevel}',
                  style: GoogleFonts.poppins(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                ),
                const SizedBox(height: 24),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 16,
                    crossAxisSpacing: 16,
                    childAspectRatio: 1.8,
                  ),
                  itemCount: sections.length,
                  itemBuilder: (context, index) {
                    final section = sections[index];
                    final selected = _selectedSection == section;
                    return GestureDetector(
                      onTap: () {
                        setState(() => _selectedSection = section);
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(18),
                          gradient: LinearGradient(
                            colors: selected
                                ? [Color(0xFF3D5AFE), Color(0xFF00BFAE)]
                                : [Colors.white.withOpacity(0.08), Colors.white.withOpacity(0.03)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          border: Border.all(
                            color: selected ? Color(0xFF00BFAE) : Colors.white.withOpacity(0.15),
                            width: 2,
                          ),
                          boxShadow: selected
                              ? [
                                  BoxShadow(
                                    color: Color(0xFF00BFAE).withOpacity(0.18),
                                    blurRadius: 12,
                                    offset: Offset(0, 4),
                                  ),
                                ]
                              : [],
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 12),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Section ${section.name}',
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              section.teacher,
                              style: GoogleFonts.poppins(
                                color: Colors.white70,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
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
                    onPressed: _selectedSection == null
                        ? null
                        : () {
                            Navigator.pushNamed(
                              context,
                              AppRoutes.subjectSelection,
                              arguments: {
                                'gradeLevel': widget.gradeLevel,
                                'section': _selectedSection,
                              },
                            );
                          },
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