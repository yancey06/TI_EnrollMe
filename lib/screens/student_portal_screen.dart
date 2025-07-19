import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/auth_service.dart';
import '../services/user_service.dart';
import '../services/enrollment_service.dart';
import '../models/profile.dart';
import '../models/enrollment.dart';
import '../models/subject.dart';

class StudentPortalScreen extends StatefulWidget {
  const StudentPortalScreen({super.key});

  @override
  State<StudentPortalScreen> createState() => _StudentPortalScreenState();
}

class _StudentPortalScreenState extends State<StudentPortalScreen> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late TabController _tabController;

  final List<Tab> _tabs = const [
    Tab(icon: Icon(Icons.dashboard_rounded), text: 'Dashboard'),
    Tab(icon: Icon(Icons.person_rounded), text: 'Profile'),
    Tab(icon: Icon(Icons.assignment_turned_in_rounded), text: 'Enrollment'),
    Tab(icon: Icon(Icons.menu_book_rounded), text: 'Subjects'),
    Tab(icon: Icon(Icons.schedule_rounded), text: 'Schedule'),
    Tab(icon: Icon(Icons.campaign_rounded), text: 'News'),
    Tab(icon: Icon(Icons.event_rounded), text: 'Calendar'),
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
    _tabController = TabController(length: _tabs.length, vsync: this, initialIndex: _selectedIndex);
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _onNavTap(_tabController.index);
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _tabController.dispose();
    super.dispose();
  }

  void _onNavTap(int index) {
    if (_selectedIndex != index) {
      setState(() => _selectedIndex = index);
      _tabController.index = index;
      _animationController.reset();
      _animationController.forward();
    }
  }

  void _onDrawerTap(int index) {
    Navigator.of(context).pop();
    _onNavTap(index);
  }

  void _onLogout() {
    Navigator.of(context).pop();
    AuthService.logout();
    Navigator.of(context).pushNamedAndRemoveUntil('/login', (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    final user = AuthService.currentUser;
    final profile = user != null ? UserService.getProfile(user.username) : null;
    final enrollment = user != null ? EnrollmentService.getEnrollment(user.username) : null;
    final pages = <Widget>[
      _ModernDashboardTab(profile: profile, enrollment: enrollment),
      _ProfileTab(profile: profile),
      _EnrollmentTab(enrollment: enrollment),
      _SubjectsTab(enrollment: enrollment),
      _ScheduleTab(enrollment: enrollment),
      _AnnouncementsTab(),
      _CalendarTab(),
    ];
    return Scaffold(
      extendBody: true,
      appBar: AppBar(
        backgroundColor: const Color(0xFF16213E),
        elevation: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: SizedBox(
                width: 32,
                height: 32,
                child: Image.asset(
                  'lib/screens/ti_logo.png',
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                ),
              ),
            ),
            Text('Student Portal', style: GoogleFonts.poppins(fontWeight: FontWeight.w700, color: Colors.white)),
          ],
        ),
        bottom: TabBar(
          controller: _tabController,
          tabs: _tabs,
          isScrollable: true,
          indicatorColor: const Color(0xFF00BFAE),
          labelColor: const Color(0xFF00BFAE),
          unselectedLabelColor: Colors.white70,
          labelStyle: GoogleFonts.poppins(fontWeight: FontWeight.w600),
        ),
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF16213E),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              DrawerHeader(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF3D5AFE), Color(0xFF00BFAE)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person_rounded, size: 40, color: Color(0xFF00BFAE)),
                    ),
                    const SizedBox(height: 12),
                    Text(profile?.fullName ?? 'Student', style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 18)),
                    Text(profile?.email ?? '', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13)),
                  ],
                ),
              ),
              ListTile(
                leading: const Icon(Icons.dashboard_rounded, color: Color(0xFF00BFAE)),
                title: Text('Dashboard', style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () => _onDrawerTap(0),
                selected: _selectedIndex == 0,
              ),
              ListTile(
                leading: const Icon(Icons.person_rounded, color: Color(0xFF00BFAE)),
                title: Text('Profile', style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () => _onDrawerTap(1),
                selected: _selectedIndex == 1,
              ),
              ListTile(
                leading: const Icon(Icons.assignment_turned_in_rounded, color: Color(0xFF00BFAE)),
                title: Text('Enrollment', style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () => _onDrawerTap(2),
                selected: _selectedIndex == 2,
              ),
              ListTile(
                leading: const Icon(Icons.menu_book_rounded, color: Color(0xFF00BFAE)),
                title: Text('Subjects', style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () => _onDrawerTap(3),
                selected: _selectedIndex == 3,
              ),
              ListTile(
                leading: const Icon(Icons.schedule_rounded, color: Color(0xFF00BFAE)),
                title: Text('Schedule', style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () => _onDrawerTap(4),
                selected: _selectedIndex == 4,
              ),
              ListTile(
                leading: const Icon(Icons.campaign_rounded, color: Color(0xFF00BFAE)),
                title: Text('News', style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () => _onDrawerTap(5),
                selected: _selectedIndex == 5,
              ),
              ListTile(
                leading: const Icon(Icons.event_rounded, color: Color(0xFF00BFAE)),
                title: Text('Calendar', style: GoogleFonts.poppins(color: Colors.white)),
                onTap: () => _onDrawerTap(6),
                selected: _selectedIndex == 6,
              ),
              const Spacer(),
              ListTile(
                leading: const Icon(Icons.logout_rounded, color: Colors.redAccent),
                title: Text('Logout', style: GoogleFonts.poppins(color: Colors.redAccent)),
                onTap: _onLogout,
              ),
            ],
          ),
        ),
      ),
      body: FadeTransition(
        opacity: _fadeAnimation,
        child: TabBarView(
          controller: _tabController,
          physics: const NeverScrollableScrollPhysics(),
          children: pages,
        ),
      ),
    );
  }
}

class _ModernDashboardTab extends StatelessWidget {
  final Profile? profile;
  final Enrollment? enrollment;
  const _ModernDashboardTab({this.profile, this.enrollment});

  @override
  Widget build(BuildContext context) {
    final todaySchedule = (enrollment?.subjects?.isNotEmpty == true) ? enrollment!.subjects[0] : null;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: SafeArea(
        child: CustomScrollView(
          slivers: [
            _buildHeroHeader(),
            SliverPadding(
              padding: const EdgeInsets.all(24),
              sliver: SliverList(
                delegate: SliverChildListDelegate([
                  _buildStatsOverview(),
                  const SizedBox(height: 24),
                  _buildTodayScheduleCard(todaySchedule),
                  const SizedBox(height: 24),
                  _buildAnnouncementsSection(),
                  const SizedBox(height: 24),
                  _buildQuickActions(context),
                  const SizedBox(height: 100), // Bottom padding for nav
                ]),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroHeader() {
    return SliverAppBar(
      expandedHeight: 200,
      floating: false,
      pinned: true,
      backgroundColor: Colors.transparent,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFF3D5AFE), Color(0xFF00BFAE)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 60, 24, 24),
            child: Row(
              children: [
                Hero(
                  tag: 'profile_avatar',
                  child: Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 12,
                          offset: const Offset(0, 6),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 42,
                      backgroundColor: Colors.white,
                      child: Icon(Icons.person_rounded, size: 50, color: Color(0xFF00BFAE)),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Welcome back,',
                        style: GoogleFonts.poppins(
                          color: Colors.white70,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        profile?.fullName ?? 'Student',
                        style: GoogleFonts.poppins(
                          color: Colors.white,
                          fontWeight: FontWeight.w700,
                          fontSize: 24,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 8),
                      _buildGradeBadge(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildGradeBadge() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.school_rounded, color: Colors.white, size: 16),
          const SizedBox(width: 6),
          Text(
            'Grade ${enrollment?.gradeLevel ?? '-'}',
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview() {
    return Row(
      children: [
        Expanded(child: _statCard('Subjects', '${enrollment?.subjects.length ?? 0}', Icons.menu_book_rounded)),
        const SizedBox(width: 16),
        Expanded(child: _statCard('Attendance', '95%', Icons.check_circle_rounded)),
        const SizedBox(width: 16),
        Expanded(child: _statCard('Avg Grade', '92', Icons.trending_up_rounded)),
      ],
    );
  }

  Widget _statCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          Icon(icon, color: Color(0xFF00BFAE), size: 32),
          const SizedBox(height: 12),
          Text(
            value,
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTodayScheduleCard(Subject? subject) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF16213E), Color(0xFF1A1A2E)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF00BFAE).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFF00BFAE).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(Icons.schedule_rounded, color: Color(0xFF00BFAE), size: 24),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  'Today\'s Schedule',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          subject != null
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      subject.name,
                      style: GoogleFonts.poppins(
                        color: Color(0xFF00BFAE),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Icon(Icons.person_rounded, color: Colors.white70, size: 16),
                        const SizedBox(width: 8),
                        Text(
                          subject.teacher,
                          style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
                        ),
                        const Spacer(),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '8:00 - 9:00',
                            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              : Text(
                  'No classes scheduled for today',
                  style: GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
                ),
        ],
      ),
    );
  }

  Widget _buildAnnouncementsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Latest Updates',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            Builder(
              builder: (context) => TextButton(
                onPressed: () {
                  final state = context.findAncestorStateOfType<_StudentPortalScreenState>();
                  state?._onNavTap(5); // Announcements tab index
                },
                child: Text(
                  'View All',
                  style: GoogleFonts.poppins(color: Color(0xFF00BFAE), fontSize: 14),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 140,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: [
              _announcementCard('Welcome Back! 🎉', 'Classes start June 10'),
              _announcementCard('PTC Meeting 📋', 'July 5 - Parent Conference'),
              _announcementCard('Holiday Break 🏖️', 'June 12 - Independence Day'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _announcementCard(String title, String body) {
    return Container(
      width: 240,
      margin: const EdgeInsets.only(right: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: GoogleFonts.poppins(
              color: Color(0xFF00BFAE),
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            body,
            style: GoogleFonts.poppins(color: Colors.white70, fontSize: 14),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const Spacer(),
          Align(
            alignment: Alignment.bottomRight,
            child: Icon(Icons.arrow_forward_rounded, color: Color(0xFF00BFAE), size: 20),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.w700,
            fontSize: 18,
          ),
        ),
        const SizedBox(height: 16),
        GridView.count(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          children: [
            _quickActionCard(context, Icons.menu_book_rounded, 'View Subjects', 'Explore your courses', 3),
            _quickActionCard(context, Icons.schedule_rounded, 'Class Schedule', 'Check timetable', 4),
            _quickActionCard(context, Icons.campaign_rounded, 'Announcements', 'Stay updated', 5),
            _quickActionCard(context, Icons.event_rounded, 'School Calendar', 'Important dates', 6),
          ],
        ),
      ],
    );
  }

  Widget _quickActionCard(BuildContext context, IconData icon, String title, String subtitle, int tabIndex) {
    return GestureDetector(
      onTap: () {
        final state = context.findAncestorStateOfType<_StudentPortalScreenState>();
        state?._onNavTap(tabIndex);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: Colors.white.withOpacity(0.1)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: Color(0xFF00BFAE), size: 28),
            const SizedBox(height: 12),
            Text(
              title,
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: GoogleFonts.poppins(color: Colors.white60, fontSize: 12),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced Profile Tab with better visual hierarchy
class _ProfileTab extends StatefulWidget {
  final Profile? profile;
  const _ProfileTab({this.profile});
  
  @override
  State<_ProfileTab> createState() => _ProfileTabState();
}

class _ProfileTabState extends State<_ProfileTab> with TickerProviderStateMixin {
  bool _editing = false;
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _addressController;
  late TextEditingController _contactController;
  late TextEditingController _birthdayController;
  late TextEditingController _guardianController;
  String? _profileImagePath;
  String? _errorMsg;
  late AnimationController _slideController;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    final p = widget.profile;
    _nameController = TextEditingController(text: p?.fullName ?? '');
    _emailController = TextEditingController(text: p?.email ?? '');
    _addressController = TextEditingController(text: p?.address ?? '');
    _contactController = TextEditingController(text: p?.contactNumber ?? '');
    _birthdayController = TextEditingController(text: p?.birthday ?? '');
    _guardianController = TextEditingController(text: p?.guardianName ?? '');
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _slideController, curve: Curves.easeOut));
    _slideController.forward();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _contactController.dispose();
    _birthdayController.dispose();
    _guardianController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  void _saveProfile() {
    if (widget.profile == null) return;
    setState(() => _errorMsg = null);
    
    if (_nameController.text.trim().isEmpty || 
        _emailController.text.trim().isEmpty || 
        !_emailController.text.contains('@')) {
      setState(() => _errorMsg = 'Please enter valid name and email.');
      return;
    }
    
    setState(() => _editing = false);
    widget.profile!.fullName = _nameController.text.trim();
    widget.profile!.email = _emailController.text.trim();
    widget.profile!.address = _addressController.text.trim();
    widget.profile!.contactNumber = _contactController.text.trim();
    widget.profile!.birthday = _birthdayController.text.trim();
    widget.profile!.guardianName = _guardianController.text.trim();
    UserService.saveProfile(widget.profile!);
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Profile updated successfully!', style: GoogleFonts.poppins()),
        backgroundColor: const Color(0xFF00BFAE),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.profile;
    
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: SafeArea(
        child: p == null
            ? const Center(child: CircularProgressIndicator(color: Color(0xFF00BFAE)))
            : SlideTransition(
                position: _slideAnimation,
                child: CustomScrollView(
                  slivers: [
                    SliverAppBar(
                      backgroundColor: Colors.transparent,
                      elevation: 0,
                      floating: true,
                      flexibleSpace: _buildProfileHeader(),
                      expandedHeight: 200,
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.all(24),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          if (_errorMsg != null) _buildErrorCard(),
                          _editing ? _buildEditForm() : _buildProfileInfo(p),
                          const SizedBox(height: 100),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  Widget _buildProfileHeader() {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF3D5AFE), Color(0xFF00BFAE)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Hero(
              tag: 'profile_avatar',
              child: Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.3),
                          blurRadius: 20,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundColor: Colors.white,
                      backgroundImage: _profileImagePath != null ? AssetImage(_profileImagePath!) : null,
                      child: _profileImagePath == null
                          ? Icon(Icons.person_rounded, size: 70, color: Color(0xFF00BFAE))
                          : null,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: () {
                        setState(() => _profileImagePath = 'mock_profile_image.png');
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Profile picture updated!', style: GoogleFonts.poppins())),
                        );
                      },
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: const Color(0xFF00BFAE),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 3),
                        ),
                        child: const Icon(Icons.camera_alt_rounded, color: Colors.white, size: 20),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              widget.profile?.fullName ?? 'Student',
              style: GoogleFonts.poppins(
                fontSize: 24,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildErrorCard() {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.withOpacity(0.3)),
      ),
      child: Row(
        children: [
          Icon(Icons.error_rounded, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(child: Text(_errorMsg!, style: GoogleFonts.poppins(color: Colors.red))),
        ],
      ),
    );
  }

  Widget _buildProfileInfo(Profile p) {
    return Column(
      children: [
        _buildInfoCard([
          _infoRow('Full Name', p.fullName),
          _infoRow('Email', p.email),
          _infoRow('Grade Level', 'Grade ${p.gradeLevel}'),
        ]),
        const SizedBox(height: 16),
        _buildInfoCard([
          _infoRow('Address', p.address),
          _infoRow('Contact', p.contactNumber),
          _infoRow('Birthday', p.birthday),
          _infoRow('Guardian', p.guardianName),
        ]),
        const SizedBox(height: 24),
        _buildActionButtons(),
      ],
    );
  }

  Widget _buildInfoCard(List<Widget> children) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.white.withOpacity(0.1), Colors.white.withOpacity(0.05)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.1)),
      ),
      child: Column(children: children),
    );
  }

  Widget _infoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              label,
              style: GoogleFonts.poppins(
                color: Colors.white60,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              value.isNotEmpty ? value : '—',
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEditForm() {
    return Column(
      children: [
        _buildInputField('Full Name', _nameController),
        _buildInputField('Email', _emailController, keyboardType: TextInputType.emailAddress),
        _buildInputField('Address', _addressController),
        _buildInputField('Contact', _contactController, keyboardType: TextInputType.phone),
        _buildInputField('Birthday', _birthdayController),
        _buildInputField('Guardian', _guardianController),
        const SizedBox(height: 24),
        _buildEditActions(),
      ],
    );
  }

  Widget _buildInputField(String label, TextEditingController controller, {TextInputType? keyboardType}) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(color: Colors.white),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: const TextStyle(color: Colors.white70),
          filled: true,
          fillColor: Colors.white10,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10), borderSide: BorderSide.none),
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFAE)),
            onPressed: () => setState(() => _editing = true),
            child: Text('Edit Profile', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ),
      ],
    );
  }

  Widget _buildEditActions() {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white24),
            onPressed: () => setState(() => _editing = false),
            child: Text('Cancel', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF00BFAE)),
            onPressed: _saveProfile,
            child: Text('Save', style: GoogleFonts.poppins(color: Colors.white)),
          ),
        ),
      ],
    );
  }
}

// --- Enrollment Tab ---
class _EnrollmentTab extends StatelessWidget {
  final Enrollment? enrollment;
  const _EnrollmentTab({this.enrollment});
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: enrollment == null
              ? Text('Not enrolled.', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.assignment_turned_in_rounded, size: 60, color: Color(0xFF00BFAE)),
                      const SizedBox(height: 20),
                      Text('Enrollment',
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      Text('Grade: ${enrollment!.gradeLevel}',
                        style: GoogleFonts.poppins(fontSize: 18, color: Color(0xFF00BFAE), fontWeight: FontWeight.w600)),
                      if (enrollment!.sectionName.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Section: ${enrollment!.sectionName}', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),
                        Text('Adviser: ${enrollment!.adviser}', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),
                      ],
                      const SizedBox(height: 12),
                      Text('Subjects:', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),
                      const SizedBox(height: 8),
                      ...enrollment!.subjects.map((s) => Text(s.name, style: GoogleFonts.poppins(color: Colors.white, fontSize: 15))),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// --- Subjects Tab ---
class _SubjectsTab extends StatelessWidget {
  final Enrollment? enrollment;
  const _SubjectsTab({this.enrollment});

  void _showSubjectDetails(BuildContext context, Subject subject) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.book_rounded, color: Color(0xFF00BFAE), size: 32),
                const SizedBox(width: 12),
                Expanded(child: Text(subject.name, style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white))),
              ],
            ),
            const SizedBox(height: 16),
            Text('Teacher: ${subject.teacher}', style: GoogleFonts.poppins(color: Colors.white70)),
            const SizedBox(height: 10),
            Text('Syllabus:', style: GoogleFonts.poppins(color: Color(0xFF00BFAE), fontWeight: FontWeight.w600)),
            const SizedBox(height: 4),
            Text('This is a mock syllabus/description for ${subject.name}. Topics, requirements, and grading will be shown here.', style: GoogleFonts.poppins(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: enrollment == null
              ? Text('No enrolled subjects.', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.menu_book_rounded, size: 60, color: Color(0xFF00BFAE)),
                      const SizedBox(height: 20),
                      Text('Subjects & Schedule',
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      const SizedBox(height: 16),
                      ...enrollment!.subjects.map((s) => InkWell(
                        onTap: () => _showSubjectDetails(context, s),
                        child: ListTile(
                          leading: Icon(Icons.book_rounded, color: Color(0xFF00BFAE)),
                          title: Text(s.name, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                          subtitle: Text('Teacher: ${s.teacher}', style: GoogleFonts.poppins(color: Colors.white70)),
                        ),
                      )),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// --- Schedule Tab ---
class _ScheduleTab extends StatelessWidget {
  final Enrollment? enrollment;
  const _ScheduleTab({this.enrollment});

  List<Map<String, dynamic>> getSchedule(Enrollment? enrollment) {
    if (enrollment == null) return [];
    final subjects = enrollment.subjects;
    final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
    return List.generate(subjects.length, (i) => {
      'subject': subjects[i].name,
      'teacher': subjects[i].teacher,
      'day': days[i % days.length],
      'start': '${8 + i}:00',
      'end': '${9 + i}:00',
      'room': 'R${101 + i}',
    });
  }

  void _showClassDetails(BuildContext context, Map<String, dynamic> s) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF16213E),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(Icons.menu_book_rounded, color: Color(0xFF00BFAE), size: 32),
                const SizedBox(width: 12),
                Text(s['subject'], style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 16),
            Text('Day: ${s['day']}', style: GoogleFonts.poppins(color: Colors.white70)),
            Text('Time: ${s['start']} - ${s['end']}', style: GoogleFonts.poppins(color: Colors.white70)),
            Text('Room: ${s['room']}', style: GoogleFonts.poppins(color: Colors.white70)),
            Text('Teacher: ${s['teacher']}', style: GoogleFonts.poppins(color: Colors.white70)),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final schedule = getSchedule(enrollment);
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: SafeArea(
        child: Center(
          child: schedule.isEmpty
              ? Text('No schedule available.', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 18))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.schedule_rounded, size: 60, color: Color(0xFF00BFAE)),
                      const SizedBox(height: 20),
                      Text('Weekly Schedule',
                        style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white),
                      ),
                      if (enrollment != null && enrollment!.sectionName.isNotEmpty) ...[
                        const SizedBox(height: 8),
                        Text('Section: ${enrollment!.sectionName}', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),
                        Text('Adviser: ${enrollment!.adviser}', style: GoogleFonts.poppins(fontSize: 16, color: Colors.white70)),
                      ],
                      const SizedBox(height: 16),
                      Table(
                        border: TableBorder.all(color: Colors.white24),
                        defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                        children: [
                          TableRow(
                            decoration: BoxDecoration(color: Colors.white10),
                            children: const [
                              Padding(padding: EdgeInsets.all(8), child: Text('Day', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Subject', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Time', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Room', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                              Padding(padding: EdgeInsets.all(8), child: Text('Teacher', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold))),
                            ],
                          ),
                          ...schedule.map((s) => TableRow(
                            children: [
                              InkWell(
                                onTap: () => _showClassDetails(context, s),
                                child: Padding(padding: EdgeInsets.all(8), child: Text(s['day'], style: TextStyle(color: Colors.white))),
                              ),
                              InkWell(
                                onTap: () => _showClassDetails(context, s),
                                child: Padding(padding: EdgeInsets.all(8), child: Text(s['subject'], style: TextStyle(color: Colors.white))),
                              ),
                              InkWell(
                                onTap: () => _showClassDetails(context, s),
                                child: Padding(padding: EdgeInsets.all(8), child: Text('${s['start']} - ${s['end']}', style: TextStyle(color: Colors.white))),
                              ),
                              InkWell(
                                onTap: () => _showClassDetails(context, s),
                                child: Padding(padding: EdgeInsets.all(8), child: Text(s['room'], style: TextStyle(color: Colors.white))),
                              ),
                              InkWell(
                                onTap: () => _showClassDetails(context, s),
                                child: Padding(padding: EdgeInsets.all(8), child: Text(s['teacher'], style: TextStyle(color: Colors.white70))),
                              ),
                            ],
                          )),
                        ],
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

// --- Announcements Tab ---
class _AnnouncementsTab extends StatefulWidget {
  @override
  State<_AnnouncementsTab> createState() => _AnnouncementsTabState();
}

class _AnnouncementsTabState extends State<_AnnouncementsTab> {
  // Mock announcements
  final List<Map<String, String>> announcements = const [
    {
      'title': 'Welcome Back! 🎉',
      'body': 'Classes start on June 10. Please check your schedule.'
    },
    {
      'title': 'Parent-Teacher Conference',
      'body': 'PTC will be held on July 5. See you there!'
    },
    {
      'title': 'Holiday Notice',
      'body': 'No classes on June 12 (Independence Day).'
    },
  ];

  // Local state for read/unread and expanded/collapsed
  late List<bool> _read;
  late List<bool> _expanded;

  @override
  void initState() {
    super.initState();
    _read = List.generate(announcements.length, (i) => false);
    _expanded = List.generate(announcements.length, (i) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: SafeArea(
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: announcements.length,
          itemBuilder: (context, i) {
            final ann = announcements[i];
            final isRead = _read[i];
            final isExpanded = _expanded[i];
            return Card(
              color: isRead ? Colors.white.withOpacity(0.04) : Color(0xFF00BFAE).withOpacity(0.13),
              margin: const EdgeInsets.only(bottom: 18),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  setState(() => _expanded[i] = !_expanded[i]);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.campaign_rounded, color: Color(0xFF00BFAE)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(ann['title']!, style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700)),
                          ),
                          if (!isRead)
                            Container(
                              margin: const EdgeInsets.only(left: 8),
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                              decoration: BoxDecoration(
                                color: Color(0xFF00BFAE),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text('Unread', style: GoogleFonts.poppins(color: Colors.white, fontSize: 12)),
                            ),
                        ],
                      ),
                      AnimatedCrossFade(
                        firstChild: const SizedBox.shrink(),
                        secondChild: Padding(
                          padding: const EdgeInsets.only(top: 10, left: 4, right: 4),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(ann['body']!, style: GoogleFonts.poppins(color: Colors.white70)),
                              const SizedBox(height: 10),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton.icon(
                                  onPressed: isRead
                                      ? null
                                      : () => setState(() => _read[i] = true),
                                  icon: Icon(Icons.check_circle_rounded, color: isRead ? Colors.grey : Color(0xFF00BFAE)),
                                  label: Text('Mark as Read', style: GoogleFonts.poppins(color: isRead ? Colors.grey : Color(0xFF00BFAE))),
                                ),
                              ),
                            ],
                          ),
                        ),
                        crossFadeState: isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
                        duration: const Duration(milliseconds: 250),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- Calendar Tab ---
class _CalendarTab extends StatelessWidget {
  // Mock events
  final List<Map<String, dynamic>> events = const [
    {'date': '2025-06-09', 'title': 'First Day of Classes'},
    {'date': '2025-06-12', 'title': 'Independence Day (No Classes)'},
    {'date': '2025-07-04', 'title': 'Parent-Teacher Conference'},
    {'date': '2025-07-21', 'title': 'Midterm Exams'},
    {'date': '2025-08-15', 'title': 'Foundation Day'},
    {'date': '2025-08-29', 'title': 'Buwan ng Wika Celebration'},
    {'date': '2025-09-09', 'title': 'Science Fair'},
    {'date': '2025-10-06', 'title': 'World Teachers Day'},
    {'date': '2025-10-24', 'title': 'Semestral Break Starts'},
    {'date': '2025-11-03', 'title': 'Classes Resume'},
    {'date': '2025-12-15', 'title': 'Christmas Party'},
    {'date': '2025-12-19', 'title': 'Start of Christmas Break'},
    {'date': '2026-01-05', 'title': 'Classes Resume (2026)'},
    {'date': '2026-02-13', 'title': 'Valentine’s Day Program'},
    {'date': '2026-03-09', 'title': 'Final Exams'},
    {'date': '2026-03-24', 'title': 'Recognition Day'},
    {'date': '2026-03-27', 'title': 'Graduation Day'},
  ];

  void _showEventDetails(BuildContext context, Map<String, dynamic> event) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF16213E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Row(
          children: [
            Icon(Icons.event_rounded, color: Color(0xFF00BFAE)),
            const SizedBox(width: 10),
            Expanded(child: Text(event['title'], style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w700))),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Date: ${event['date']}', style: GoogleFonts.poppins(color: Colors.white70)),
            if (event['description'] != null)
              Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Text(event['description'], style: GoogleFonts.poppins(color: Colors.white)),
              ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text('Close', style: GoogleFonts.poppins(color: Color(0xFF00BFAE))),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final today = DateTime.now();
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF1A1A2E), Color(0xFF16213E), Color(0xFF0F3460)],
        ),
      ),
      child: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Row(
              children: [
                Icon(Icons.event_rounded, color: Color(0xFF00BFAE), size: 32),
                const SizedBox(width: 12),
                Text('School Calendar', style: GoogleFonts.poppins(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
              ],
            ),
            const SizedBox(height: 24),
            ...events.map((e) {
              final eventDate = DateTime.parse(e['date']);
              final isToday = eventDate.year == today.year && eventDate.month == today.month && eventDate.day == today.day;
              return Card(
                color: isToday ? Color(0xFF00BFAE).withOpacity(0.18) : Colors.white.withOpacity(0.07),
                margin: const EdgeInsets.only(bottom: 16),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                child: ListTile(
                  leading: Icon(Icons.calendar_today_rounded, color: isToday ? Color(0xFF00BFAE) : Colors.white70),
                  title: Text(e['title'], style: GoogleFonts.poppins(color: Colors.white, fontWeight: FontWeight.w600)),
                  subtitle: Text(e['date'], style: GoogleFonts.poppins(color: Colors.white70)),
                  trailing: isToday ? Text('Today', style: GoogleFonts.poppins(color: Color(0xFF00BFAE), fontWeight: FontWeight.bold)) : null,
                  onTap: () => _showEventDetails(context, e),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}