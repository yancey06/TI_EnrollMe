import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../utils/app_routes.dart';
import 'dart:math' as math;

class LandingScreen extends StatefulWidget {
  const LandingScreen({super.key});

  @override
  State<LandingScreen> createState() => _LandingScreenState();
}

class _LandingScreenState extends State<LandingScreen> with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _particleController;
  late AnimationController _statsController;
  late AnimationController _floatingController;
  late AnimationController _pulseController;
  late AnimationController _rotationController;
  
  late Animation<double> _logoPulse;
  late Animation<double> _fadeIn;
  late Animation<Offset> _slideIn;
  late Animation<double> _particleAnimation;
  late Animation<double> _statsAnimation;
  late Animation<double> _floatingAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _rotationAnimation;
  
  final ScrollController _scrollController = ScrollController();
  bool _showScrollIndicator = true;

  @override
  void initState() {
    super.initState();
    
    // Initialize all animation controllers
    _logoController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);
    
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1800),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    )..repeat();
    
    _statsController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    _floatingController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..repeat(reverse: true);
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat(reverse: true);
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 30),
      vsync: this,
    )..repeat();
    
    // Initialize animations
    _logoPulse = Tween<double>(begin: 1.0, end: 1.12).animate(
      CurvedAnimation(parent: _logoController, curve: Curves.easeInOut),
    );
    
    _fadeIn = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeInOut),
    );
    
    _slideIn = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.elasticOut),
    );
    
    _particleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _particleController, curve: Curves.linear),
    );
    
    _statsAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _statsController, curve: Curves.elasticOut),
    );
    
    _floatingAnimation = Tween<double>(begin: -8.0, end: 8.0).animate(
      CurvedAnimation(parent: _floatingController, curve: Curves.easeInOut),
    );
    
    _pulseAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
    
    _rotationAnimation = Tween<double>(begin: 0.0, end: 2 * math.pi).animate(
      CurvedAnimation(parent: _rotationController, curve: Curves.linear),
    );
    
    // Start animations
    _fadeController.forward();
    _slideController.forward();
    
    // Delayed stats animation
    Future.delayed(const Duration(milliseconds: 800), () {
      _statsController.forward();
    });
    
    // Scroll listener for scroll indicator
    _scrollController.addListener(() {
      if (_scrollController.offset > 100 && _showScrollIndicator) {
        setState(() {
          _showScrollIndicator = false;
        });
      } else if (_scrollController.offset <= 100 && !_showScrollIndicator) {
        setState(() {
          _showScrollIndicator = true;
        });
      }
    });
  }

  @override
  void dispose() {
    _logoController.dispose();
    _fadeController.dispose();
    _slideController.dispose();
    _particleController.dispose();
    _statsController.dispose();
    _floatingController.dispose();
    _pulseController.dispose();
    _rotationController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.topLeft,
            radius: 1.5,
            colors: [
              Color(0xFF2D1B69),
              Color(0xFF1A1A2E),
              Color(0xFF16213E),
              Color(0xFF0F3460),
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated background particles
            _buildAnimatedBackground(),
            
            // Main content
            SafeArea(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  children: [
                    // Hero Section
                    _buildHeroSection(),
                    
                    // Stats Section
                    _buildStatsSection(),
                    
                    // Features Section
                    _buildFeaturesSection(),
                    
                    // About Section
                    _buildAboutSection(),
                    
                    // CTA Section
                    _buildCTASection(),
                    
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
            
            // Floating scroll indicator
            if (_showScrollIndicator) _buildScrollIndicator(),
          ],
        ),
      ),
    );
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return CustomPaint(
          painter: ParticlesPainter(_particleAnimation.value),
          size: Size.infinite,
        );
      },
    );
  }

  Widget _buildHeroSection() {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.9,
      child: Center(
        child: FadeTransition(
          opacity: _fadeIn,
          child: SlideTransition(
            position: _slideIn,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated floating elements
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value),
                      child: _buildFloatingElement(Icons.school_rounded, 0.0),
                    );
                  },
                ),
                
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, -_floatingAnimation.value * 0.7),
                      child: _buildFloatingElement(Icons.auto_stories_rounded, 120.0),
                    );
                  },
                ),
                
                AnimatedBuilder(
                  animation: _floatingAnimation,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, _floatingAnimation.value * 0.8),
                      child: _buildFloatingElement(Icons.psychology_rounded, 240.0),
                    );
                  },
                ),
                
                // Main Logo with advanced animations
                AnimatedBuilder(
                  animation: Listenable.merge([_logoPulse, _rotationAnimation]),
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _logoPulse.value,
                      child: Transform.rotate(
                        angle: _rotationAnimation.value * 0.1,
                        child: Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            gradient: const LinearGradient(
                              colors: [Color(0xFF3D5AFE), Color(0xFFEE3EC9), Color(0xFF00E5FF)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF3D5AFE).withOpacity(0.6),
                                blurRadius: 40,
                                offset: const Offset(0, 15),
                              ),
                              BoxShadow(
                                color: const Color(0xFFEE3EC9).withOpacity(0.4),
                                blurRadius: 60,
                                offset: const Offset(0, 25),
                              ),
                            ],
                          ),
                          child: const Icon(
                            Icons.school_rounded,
                            color: Colors.white,
                            size: 80,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 40),
                
                // Animated title with shader mask
                AnimatedBuilder(
                  animation: _rotationAnimation,
                  builder: (context, child) {
                    return ShaderMask(
                      shaderCallback: (bounds) => LinearGradient(
                        colors: const [Color(0xFF3D5AFE), Color(0xFFEE3EC9), Color(0xFF00E5FF), Color(0xFF3D5AFE)],
                        stops: const [0.0, 0.3, 0.7, 1.0],
                        transform: GradientRotation(_rotationAnimation.value * 0.5),
                      ).createShader(bounds),
                      child: Text(
                        'Tanauan Institute',
                        style: GoogleFonts.poppins(
                          fontSize: 48,
                          fontWeight: FontWeight.w900,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 20),
                
                // Subtitle with typewriter effect
                AnimatedBuilder(
                  animation: _fadeIn,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - _fadeIn.value) * 20),
                      child: Opacity(
                        opacity: _fadeIn.value,
                        child: Text(
                          'Enrollment System',
                          style: GoogleFonts.poppins(
                            fontSize: 28,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                            letterSpacing: 1.2,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 16),
                
                // Description with fade in
                AnimatedBuilder(
                  animation: _fadeIn,
                  builder: (context, child) {
                    return Transform.translate(
                      offset: Offset(0, (1 - _fadeIn.value) * 30),
                      child: Opacity(
                        opacity: _fadeIn.value * 0.9,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20),
                          child: Text(
                            'Empowering academic excellence through innovative digital solutions.\nJoin thousands of students in their journey towards success.',
                            style: GoogleFonts.poppins(
                              fontSize: 18,
                              color: Colors.white70,
                              height: 1.6,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                
                const SizedBox(height: 50),
                
                // Enhanced CTA button
                AnimatedBuilder(
                  animation: _pulseAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _pulseAnimation.value,
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(20),
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3D5AFE), Color(0xFF1E88E5)],
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3D5AFE).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: SizedBox(
                          width: 240,
                          height: 64,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.transparent,
                              shadowColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                            onPressed: () {
                              Navigator.pushReplacementNamed(context, AppRoutes.login);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Begin Your Journey',
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFloatingElement(IconData icon, double rotationOffset) {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Transform.rotate(
          angle: _rotationAnimation.value + (rotationOffset * math.pi / 180),
          child: Transform.translate(
            offset: Offset(
              math.cos(_rotationAnimation.value + rotationOffset) * 150,
              math.sin(_rotationAnimation.value + rotationOffset) * 80,
            ),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                gradient: LinearGradient(
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                border: Border.all(
                  color: Colors.white.withOpacity(0.2),
                  width: 1,
                ),
              ),
              child: Icon(
                icon,
                color: Colors.white.withOpacity(0.6),
                size: 32,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsSection() {
    return AnimatedBuilder(
      animation: _statsAnimation,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, (1 - _statsAnimation.value) * 50),
          child: Opacity(
            opacity: _statsAnimation.value,
            child: Container(
              margin: const EdgeInsets.all(20),
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.15),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: Colors.white.withOpacity(0.2)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem('104', 'Years of\nExcellence', Icons.star_rounded),
                  _buildStatItem('15K+', 'Successful\nGraduates', Icons.school_rounded),
                  _buildStatItem('98%', 'Employment\nRate', Icons.work_rounded),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatItem(String number, String label, IconData icon) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              colors: [Color(0xFF3D5AFE), Color(0xFFEE3EC9)],
            ),
          ),
          child: Icon(
            icon,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          number,
          style: GoogleFonts.poppins(
            fontSize: 32,
            fontWeight: FontWeight.w900,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 14,
            color: Colors.white70,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Text(
            'Why Choose Tanauan Institute?',
            style: GoogleFonts.poppins(
              fontSize: 32,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 40),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1.1,
            children: [
              _buildFeatureCard(
                Icons.psychology_rounded,
                'Innovation',
                'Cutting-edge teaching methods and modern facilities',
              ),
              _buildFeatureCard(
                Icons.groups_rounded,
                'Community',
                'Vibrant student life and strong alumni network',
              ),
              _buildFeatureCard(
                Icons.emoji_events_rounded,
                'Excellence',
                'Award-winning programs and outstanding faculty',
              ),
              _buildFeatureCard(
                Icons.public_rounded,
                'Global',
                'International partnerships and worldwide recognition',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureCard(IconData icon, String title, String description) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: const LinearGradient(
                colors: [Color(0xFF3D5AFE), Color(0xFFEE3EC9)],
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
              size: 28,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            title,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildAboutSection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.white.withOpacity(0.12),
            Colors.white.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.2)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 6,
                height: 32,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF3D5AFE), Color(0xFF1E88E5)],
                  ),
                  borderRadius: BorderRadius.circular(3),
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Text(
                  'About Tanauan Institute',
                  style: GoogleFonts.poppins(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Text(
            'Founded in 1920, Tanauan Institute stands as a beacon of educational excellence in Batangas, Philippines. For over a century, we have been nurturing minds, fostering innovation, and shaping the leaders of tomorrow.',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Our commitment to holistic development goes beyond academic achievement. We provide a comprehensive educational experience that combines rigorous academics with character building, leadership development, and community service.',
            style: GoogleFonts.poppins(
              color: Colors.white70,
              fontSize: 16,
              height: 1.8,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Icon(Icons.location_on_rounded, color: Color(0xFF3D5AFE), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Tanauan City, Batangas, Philippines',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: Color(0xFF00E676), size: 24),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  'Accredited by CHED & ISO 9001:2015 Certified',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCTASection() {
    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF3D5AFE), Color(0xFF1E88E5)],
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF3D5AFE).withOpacity(0.4),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            'Ready to Start Your Journey?',
            style: GoogleFonts.poppins(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            'Join thousands of students who have chosen excellence.\nYour future starts here.',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 32),
          SizedBox(
            width: 200,
            height: 56,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: const Color(0xFF3D5AFE),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                elevation: 8,
              ),
              onPressed: () {
                Navigator.pushReplacementNamed(context, AppRoutes.login);
              },
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Enroll Now',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward_rounded),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScrollIndicator() {
    return Positioned(
      bottom: 30,
      left: 0,
      right: 0,
      child: AnimatedBuilder(
        animation: _floatingAnimation,
        builder: (context, child) {
          return Transform.translate(
            offset: Offset(0, _floatingAnimation.value * 0.5),
            child: Column(
              children: [
                Text(
                  'Scroll to explore',
                  style: GoogleFonts.poppins(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 8),
                const Icon(
                  Icons.keyboard_arrow_down_rounded,
                  color: Colors.white70,
                  size: 32,
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class ParticlesPainter extends CustomPainter {
  final double animationValue;
  
  ParticlesPainter(this.animationValue);
  
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white.withOpacity(0.1)
      ..style = PaintingStyle.fill;
    
    // Draw animated particles
    for (int i = 0; i < 20; i++) {
      final double x = (size.width * 0.1) + (i * size.width * 0.04) + 
                      (math.sin(animationValue * 2 * math.pi + i) * 30);
      final double y = (size.height * 0.1) + (i * size.height * 0.04) + 
                      (math.cos(animationValue * 2 * math.pi + i) * 20);
      
      canvas.drawCircle(
        Offset(x % size.width, y % size.height),
        2.0 + math.sin(animationValue * 2 * math.pi + i) * 1.5,
        paint,
      );
    }
  }
  
  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}