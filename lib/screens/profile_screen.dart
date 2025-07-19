import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:ui';
import 'package:google_fonts/google_fonts.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/app_button.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../models/profile.dart';
import '../utils/dialogs.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';

class ProfileScreen extends StatefulWidget {
  ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> 
    with TickerProviderStateMixin {
  Profile? _profile;
  bool _editing = false;
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactController = TextEditingController();
  final TextEditingController _birthdayController = TextEditingController();
  final TextEditingController _guardianController = TextEditingController();
  int _selectedGrade = gradeLevels.first;
  
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _pulseController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    
    // Initialize animations
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _pulseController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.elasticOut));
    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    final user = AuthService.currentUser;
    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      });
      return;
    }
    _profile = UserService.getProfile(user.username) ??
        Profile(
          username: user.username,
          fullName: user.fullName ?? '',
          email: user.email ?? '',
          gradeLevel: gradeLevels.first,
        );
    _fullNameController.text = _profile!.fullName;
    _emailController.text = _profile!.email;
    _addressController.text = _profile!.address;
    _contactController.text = _profile!.contactNumber;
    _birthdayController.text = _profile!.birthday;
    _guardianController.text = _profile!.guardianName;
    _selectedGrade = _profile!.gradeLevel;
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    _pulseController.repeat(reverse: true);
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (_fullNameController.text.trim().isEmpty || _emailController.text.trim().isEmpty) {
      showAppSnackbar(context, 'Full name and email are required');
      return;
    }
    final updated = Profile(
      username: _profile!.username,
      fullName: _fullNameController.text.trim(),
      email: _emailController.text.trim(),
      gradeLevel: _selectedGrade,
      address: _addressController.text.trim(),
      contactNumber: _contactController.text.trim(),
      birthday: _birthdayController.text.trim(),
      guardianName: _guardianController.text.trim(),
    );
    UserService.saveProfile(updated);
    setState(() {
      _profile = updated;
      _editing = false;
    });
    showAppSnackbar(context, 'Profile updated');
  }

  void _logout() {
    AuthService.logout();
    Navigator.pushReplacementNamed(context, AppRoutes.login);
  }

  void _proceedToEnrollment() {
    if (_profile == null ||
        _profile!.fullName.trim().isEmpty ||
        _profile!.email.trim().isEmpty ||
        _profile!.address.trim().isEmpty ||
        _profile!.contactNumber.trim().isEmpty ||
        _profile!.birthday.trim().isEmpty ||
        _profile!.guardianName.trim().isEmpty) {
      showAppSnackbar(context, 'Please complete your profile before enrolling.', icon: Icons.warning_amber_rounded);
      return;
    }
    Navigator.pushReplacementNamed(context, AppRoutes.gradeSelection);
  }

  @override
  Widget build(BuildContext context) {
    if (_profile == null) {
      return Scaffold(
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
          child: const Center(
            child: CircularProgressIndicator(
              color: Color(0xFF3D5AFE),
            ),
          ),
        ),
      );
    }

    return Scaffold(
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
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                expandedHeight: 120,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                elevation: 0,
                flexibleSpace: FlexibleSpaceBar(
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.black.withOpacity(0.3),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                  title: FadeTransition(
                    opacity: _fadeAnimation,
                    child: Text(
                      'Profile',
                      style: GoogleFonts.poppins(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () => Navigator.of(context).maybePop(),
                  tooltip: 'Back',
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 16),
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(0.1),
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.logout_rounded, color: Colors.white),
                      onPressed: _logout,
                      tooltip: 'Logout',
                    ),
                  ),
                ],
              ),
              SliverToBoxAdapter(
                child: AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: _editing ? _buildEditingView() : _buildProfileView(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileView() {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: SlideTransition(
        position: _slideAnimation,
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            children: [
              const SizedBox(height: 20),
              // Profile Avatar with Pulse Animation
              AnimatedBuilder(
                animation: _pulseAnimation,
                builder: (context, child) {
                  return Transform.scale(
                    scale: _pulseAnimation.value,
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: const LinearGradient(
                          colors: [
                            Color(0xFF3D5AFE),
                            Color(0xFF00BFAE),
                            Color(0xFF00E5FF),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0xFF3D5AFE).withOpacity(0.4),
                            blurRadius: 30,
                            offset: const Offset(0, 10),
                          ),
                          BoxShadow(
                            color: const Color(0xFF00BFAE).withOpacity(0.3),
                            blurRadius: 20,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Container(
                        padding: const EdgeInsets.all(32),
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF1A1A2E),
                        ),
                        child: const Icon(
                          Icons.person_rounded,
                          size: 60,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  );
                },
              ),
              const SizedBox(height: 24),
              // Name and Grade
              Text(
                _profile!.fullName,
                style: GoogleFonts.poppins(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  height: 1.2,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3D5AFE), Color(0xFF00BFAE)],
                  ),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF3D5AFE).withOpacity(0.3),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Text(
                  'Grade ${_profile!.gradeLevel}',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 40),
              // Profile Information Cards
              _buildInfoCard(),
              const SizedBox(height: 32),
              // Action Buttons
              _buildActionButton(
                'Edit Profile',
                Icons.edit_rounded,
                () => setState(() => _editing = true),
                isPrimary: true,
              ),
              const SizedBox(height: 16),
              _buildActionButton(
                'Proceed to Enrollment',
                Icons.school_rounded,
                _proceedToEnrollment,
                isPrimary: false,
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoCard() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.1),
            Colors.white.withOpacity(0.05),
          ],
        ),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Container(
            padding: const EdgeInsets.all(24),
            child: Column(
              children: [
                _buildInfoRow(Icons.email_rounded, 'Email', _profile!.email),
                _buildInfoRow(Icons.location_on_rounded, 'Address', _profile!.address),
                _buildInfoRow(Icons.phone_rounded, 'Contact', _profile!.contactNumber),
                _buildInfoRow(Icons.cake_rounded, 'Birthday', _profile!.birthday),
                _buildInfoRow(Icons.supervisor_account_rounded, 'Guardian', _profile!.guardianName),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3D5AFE), Color(0xFF00BFAE)],
              ),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF3D5AFE).withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value.isNotEmpty ? value : '—',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(String text, IconData icon, VoidCallback onPressed, {bool isPrimary = true}) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: isPrimary
            ? const LinearGradient(
                colors: [Color(0xFF3D5AFE), Color(0xFF00BFAE)],
              )
            : null,
        border: isPrimary
            ? null
            : Border.all(
                color: Colors.white.withOpacity(0.3),
                width: 1,
              ),
        boxShadow: isPrimary
            ? [
                BoxShadow(
                  color: const Color(0xFF3D5AFE).withOpacity(0.4),
                  blurRadius: 16,
                  offset: const Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: onPressed,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  color: Colors.white,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Text(
                  text,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEditingView() {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Column(
        children: [
          const SizedBox(height: 20),
          // Animated editing header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF3D5AFE), Color(0xFF00BFAE)],
              ),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Editing Profile',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 32),
          // Form fields with enhanced styling
          _buildEnhancedTextField('Full Name', _fullNameController, Icons.person_rounded),
          _buildEnhancedTextField('Email', _emailController, Icons.email_rounded, TextInputType.emailAddress),
          _buildEnhancedDropdown(),
          _buildEnhancedTextField('Address', _addressController, Icons.location_on_rounded),
          _buildEnhancedTextField('Contact Number', _contactController, Icons.phone_rounded, TextInputType.phone),
          _buildEnhancedTextField('Birthday', _birthdayController, Icons.cake_rounded, TextInputType.datetime, true),
          _buildEnhancedTextField('Guardian Name', _guardianController, Icons.supervisor_account_rounded),
          const SizedBox(height: 32),
          // Action buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton('Cancel', Icons.close_rounded, () => setState(() => _editing = false), isPrimary: false),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildActionButton('Save', Icons.check_rounded, _saveProfile, isPrimary: true),
              ),
            ],
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildEnhancedTextField(String label, TextEditingController controller, IconData icon, [TextInputType? keyboardType, bool isBirthday = false]) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          GestureDetector(
            onTap: isBirthday
                ? () async {
                    FocusScope.of(context).unfocus();
                    DateTime? picked = await showDatePicker(
                      context: context,
                      initialDate: controller.text.isNotEmpty
                          ? DateTime.tryParse(controller.text) ?? DateTime(2007, 1, 1)
                          : DateTime(2007, 1, 1),
                      firstDate: DateTime(1990),
                      lastDate: DateTime.now(),
                      builder: (context, child) {
                        return Theme(
                          data: ThemeData.dark().copyWith(
                            colorScheme: const ColorScheme.dark(
                              primary: Color(0xFF3D5AFE),
                              onPrimary: Colors.white,
                              surface: Color(0xFF22223B),
                              onSurface: Colors.white,
                            ),
                            dialogBackgroundColor: const Color(0xFF1A1A2E),
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (picked != null) {
                      controller.text = " ".isEmpty ? '' : picked.toIso8601String().split('T').first;
                      setState(() {});
                    }
                  }
                : null,
            child: AbsorbPointer(
              absorbing: isBirthday,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: LinearGradient(
                    colors: [
                      Colors.white.withOpacity(0.1),
                      Colors.white.withOpacity(0.05),
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.2),
                  ),
                ),
                child: TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                  readOnly: isBirthday,
                  decoration: InputDecoration(
                    prefixIcon: Icon(icon, color: const Color(0xFF3D5AFE)),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    hintStyle: GoogleFonts.poppins(
                      color: Colors.white54,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEnhancedDropdown() {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Grade Level',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              gradient: LinearGradient(
                colors: [
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.05),
                ],
              ),
              border: Border.all(
                color: Colors.white.withOpacity(0.2),
              ),
            ),
            child: DropdownButtonFormField<int>(
              value: _selectedGrade,
              items: gradeLevels
                  .map((g) => DropdownMenuItem(
                        value: g,
                        child: Text(
                          'Grade $g',
                          style: GoogleFonts.poppins(color: Colors.white),
                        ),
                      ))
                  .toList(),
              onChanged: (val) {
                if (val != null) setState(() => _selectedGrade = val);
              },
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.school_rounded, color: Color(0xFF3D5AFE)),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              ),
              dropdownColor: const Color(0xFF1A1A2E),
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}