import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:math' as math;
import 'dart:ui';

class EnrollmentSuccessScreen extends StatefulWidget {
  const EnrollmentSuccessScreen({super.key});

  @override
  State<EnrollmentSuccessScreen> createState() => _EnrollmentSuccessScreenState();
}

class _EnrollmentSuccessScreenState extends State<EnrollmentSuccessScreen> with TickerProviderStateMixin {
  late AnimationController _pageFlipController;
  late AnimationController _graduationCapController;
  late AnimationController _starsController;
  late AnimationController _textRevealController;
  late AnimationController _buttonSlideController;
  late AnimationController _floatingElementsController;
  late AnimationController _breathingController;
  late AnimationController _glowController;
  late AnimationController _orbitalController;
  
  late Animation<double> _pageFlipAnimation;
  late Animation<double> _graduationCapAnimation;
  late Animation<double> _textRevealAnimation;
  late Animation<Offset> _buttonSlideAnimation;
  late Animation<double> _breathingAnimation;
  late Animation<double> _glowAnimation;
  
  List<_StarParticle> _stars = [];
  List<_BookPage> _bookPages = [];
  List<_FloatingElement> _floatingElements = [];
  List<_OrbitalElement> _orbitalElements = [];

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _generateAnimatedElements();
    _startAnimationSequence();
  }

  void _initializeAnimations() {
    _pageFlipController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _graduationCapController = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    );
    _starsController = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    );
    _textRevealController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _buttonSlideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _floatingElementsController = AnimationController(
      duration: const Duration(seconds: 8),
      vsync: this,
    );
    _breathingController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _glowController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _orbitalController = AnimationController(
      duration: const Duration(seconds: 12),
      vsync: this,
    );

    _pageFlipAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _pageFlipController, curve: Curves.easeInOutCubic),
    );
    _graduationCapAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _graduationCapController, curve: Curves.elasticOut),
    );
    _textRevealAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _textRevealController, curve: Curves.easeOutExpo),
    );
    _buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 2.0),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _buttonSlideController, curve: Curves.elasticOut));
    _breathingAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _breathingController, curve: Curves.easeInOut),
    );
    _glowAnimation = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _glowController, curve: Curves.easeInOut),
    );
  }

  void _generateAnimatedElements() {
    _generateStars();
    _generateBookPages();
    _generateFloatingElements();
    _generateOrbitalElements();
  }

  void _startAnimationSequence() async {
    // Start continuous animations immediately
    _starsController.repeat();
    _floatingElementsController.repeat();
    _breathingController.repeat(reverse: true);
    _glowController.repeat(reverse: true);
    _orbitalController.repeat();
    
    // Staggered entrance animations
    await Future.delayed(const Duration(milliseconds: 300));
    _pageFlipController.forward();
    await Future.delayed(const Duration(milliseconds: 600));
    _graduationCapController.forward();
    await Future.delayed(const Duration(milliseconds: 400));
    _textRevealController.forward();
    await Future.delayed(const Duration(milliseconds: 800));
    _buttonSlideController.forward();
  }

  void _generateStars() {
    final random = math.Random();
    _stars = List.generate(60, (index) {
      return _StarParticle(
        x: random.nextDouble(),
        y: random.nextDouble(),
        size: 1.5 + random.nextDouble() * 3.5,
        speed: 0.2 + random.nextDouble() * 0.8,
        delay: random.nextDouble() * 3.0,
        twinkleSpeed: 0.5 + random.nextDouble() * 1.5,
      );
    });
  }

  void _generateBookPages() {
    final random = math.Random();
    _bookPages = List.generate(8, (index) {
      return _BookPage(
        x: 0.05 + random.nextDouble() * 0.9,
        y: 0.1 + random.nextDouble() * 0.8,
        width: 60.0 + random.nextDouble() * 50.0,
        height: 45.0 + random.nextDouble() * 35.0,
        rotation: (random.nextDouble() - 0.5) * 0.6,
        delay: index * 0.15,
        flipSpeed: 0.8 + random.nextDouble() * 0.4,
      );
    });
  }

  void _generateFloatingElements() {
    final random = math.Random();
    final icons = [Icons.menu_book, Icons.school, Icons.lightbulb, Icons.auto_stories, Icons.psychology];
    _floatingElements = List.generate(12, (index) {
      return _FloatingElement(
        icon: icons[random.nextInt(icons.length)],
        startX: random.nextDouble(),
        startY: random.nextDouble(),
        amplitude: 30 + random.nextDouble() * 40,
        frequency: 0.5 + random.nextDouble() * 1.0,
        size: 16 + random.nextDouble() * 12,
        opacity: 0.1 + random.nextDouble() * 0.15,
        delay: random.nextDouble() * 8.0,
      );
    });
  }

  void _generateOrbitalElements() {
    final random = math.Random();
    _orbitalElements = List.generate(5, (index) {
      return _OrbitalElement(
        radius: 120 + index * 40.0,
        speed: 0.3 + index * 0.1,
        size: 8 + random.nextDouble() * 6,
        opacity: 0.2 + random.nextDouble() * 0.3,
        angle: random.nextDouble() * 2 * math.pi,
      );
    });
  }

  @override
  void dispose() {
    _pageFlipController.dispose();
    _graduationCapController.dispose();
    _starsController.dispose();
    _textRevealController.dispose();
    _buttonSlideController.dispose();
    _floatingElementsController.dispose();
    _breathingController.dispose();
    _glowController.dispose();
    _orbitalController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF0F0C29), // Deep navy
              Color(0xFF24243e), // Dark purple
              Color(0xFF302b63), // Medium purple
              Color(0xFF24243e), // Dark purple
            ],
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Animated book pages background
            AnimatedBuilder(
              animation: _pageFlipController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _BookPagesPainter(_bookPages, _pageFlipAnimation.value),
                );
              },
            ),
            // Twinkling stars
            AnimatedBuilder(
              animation: _starsController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _StarsPainter(_stars, _starsController.value),
                );
              },
            ),
            // Floating elements
            AnimatedBuilder(
              animation: _floatingElementsController,
              builder: (context, child) {
                return CustomPaint(
                  size: MediaQuery.of(context).size,
                  painter: _FloatingElementsPainter(_floatingElements, _floatingElementsController.value),
                );
              },
            ),
            // Main content
            SafeArea(
              child: Center(
                child: FadeTransition(
                  opacity: _breathingController,
                  child: ScaleTransition(
                    scale: _breathingAnimation,
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Animated graduation cap with orbital elements
                          AnimatedBuilder(
                            animation: Listenable.merge([_graduationCapController, _glowController, _orbitalController]),
                            builder: (context, child) {
                              return Stack(
                                alignment: Alignment.center,
                                children: [
                                  // Orbital elements
                                  CustomPaint(
                                    size: const Size(300, 300),
                                    painter: _OrbitalElementsPainter(_orbitalElements, _orbitalController.value),
                                  ),
                                  // Main graduation cap
                                  Transform.scale(
                                    scale: _graduationCapAnimation.value,
                                    child: Transform.rotate(
                                      angle: (1 - _graduationCapAnimation.value) * 0.4,
                                      child: Container(
                                        padding: const EdgeInsets.all(36),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            colors: [
                                              Color(0xFF667eea).withOpacity(0.9),
                                              Color(0xFF764ba2).withOpacity(0.9),
                                            ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Color(0xFF667eea).withOpacity(0.4 * _glowAnimation.value),
                                              blurRadius: 40 * _glowAnimation.value,
                                              spreadRadius: 8 * _glowAnimation.value,
                                              offset: const Offset(0, 8),
                                            ),
                                          ],
                                        ),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Icon(
                                              Icons.school,
                                              color: Colors.white,
                                              size: 68,
                                            ),
                                            // Animated tassel
                                            Positioned(
                                              top: -12,
                                              right: -8,
                                              child: Transform.rotate(
                                                angle: _graduationCapAnimation.value * math.pi * 3,
                                                child: Container(
                                                  width: 10,
                                                  height: 24,
                                                  decoration: BoxDecoration(
                                                    color: const Color(0xFFFFD700),
                                                    borderRadius: BorderRadius.circular(5),
                                                    boxShadow: [
                                                      BoxShadow(
                                                        color: const Color(0xFFFFD700).withOpacity(0.6),
                                                        blurRadius: 8,
                                                        offset: const Offset(0, 2),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                          const SizedBox(height: 42),
                          // Animated text reveal with improved typography
                          AnimatedBuilder(
                            animation: _textRevealController,
                            builder: (context, child) {
                              return Transform.translate(
                                offset: Offset(0, 40 * (1 - _textRevealAnimation.value)),
                                child: Opacity(
                                  opacity: _textRevealAnimation.value,
                                  child: Column(
                                    children: [
                                      // Main congratulations text
                                      ShaderMask(
                                        shaderCallback: (bounds) => const LinearGradient(
                                          colors: [
                                            Color(0xFF667eea),
                                            Color(0xFF764ba2),
                                            Color(0xFFf093fb),
                                          ],
                                        ).createShader(bounds),
                                        child: Text(
                                          'Congratulations!',
                                          style: GoogleFonts.playfairDisplay(
                                            fontSize: 42,
                                            fontWeight: FontWeight.w900,
                                            color: Colors.white,
                                            letterSpacing: 1.5,
                                          ),
                                        ),
                                      ),
                                      const SizedBox(height: 18),
                                      // Completion message
                                      Text(
                                        'Your enrollment is complete.',
                                        style: GoogleFonts.poppins(
                                          fontSize: 24,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFE8EAF6),
                                        ),
                                      ),
                                      const SizedBox(height: 28),
                                      // Welcome card
                                      Container(
                                        padding: const EdgeInsets.all(24),
                                        margin: const EdgeInsets.symmetric(horizontal: 24),
                                        decoration: BoxDecoration(
                                          color: Colors.white.withOpacity(0.08),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: Colors.white.withOpacity(0.15),
                                            width: 1.5,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(0.1),
                                              blurRadius: 20,
                                              offset: const Offset(0, 10),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment: MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.auto_stories,
                                                  color: const Color(0xFF667eea),
                                                  size: 24,
                                                ),
                                                const SizedBox(width: 12),
                                                Text(
                                                  'Welcome to Tanauan Institute',
                                                  style: GoogleFonts.poppins(
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.w600,
                                                    color: const Color(0xFFE8EAF6),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            const SizedBox(height: 16),
                                            Text(
                                              'We wish you a successful and inspiring school year filled with knowledge, growth, and endless possibilities. Your academic journey begins now!',
                                              style: GoogleFonts.poppins(
                                                fontSize: 15,
                                                color: const Color(0xFFC5CAE9),
                                                height: 1.6,
                                              ),
                                              textAlign: TextAlign.center,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                          const SizedBox(height: 48),
                          // Animated button with enhanced styling
                          SlideTransition(
                            position: _buttonSlideAnimation,
                            child: Column(
                              children: [
                                Container(
                                  width: 260,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30),
                                    gradient: const LinearGradient(
                                      colors: [
                                        Color(0xFF667eea),
                                        Color(0xFF764ba2),
                                      ],
                                    ),
                                    boxShadow: [
                                      BoxShadow(
                                        color: const Color(0xFF667eea).withOpacity(0.4),
                                        blurRadius: 20,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    onPressed: () {
                                      Navigator.of(context).popUntil((route) => route.isFirst);
                                    },
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                          Icons.home_rounded,
                                          color: Colors.white,
                                          size: 22,
                                        ),
                                        const SizedBox(width: 12),
                                        Text(
                                          'Start Learning',
                                          style: GoogleFonts.poppins(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20),
                                Text(
                                  'Ready to explore your courses?',
                                  style: GoogleFonts.poppins(
                                    fontSize: 13,
                                    color: const Color(0xFFC5CAE9),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Enhanced particle classes
class _StarParticle {
  final double x, y, size, speed, delay, twinkleSpeed;
  _StarParticle({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.delay,
    required this.twinkleSpeed,
  });
}

class _BookPage {
  final double x, y, width, height, rotation, delay, flipSpeed;
  _BookPage({
    required this.x,
    required this.y,
    required this.width,
    required this.height,
    required this.rotation,
    required this.delay,
    required this.flipSpeed,
  });
}

class _FloatingElement {
  final IconData icon;
  final double startX, startY, amplitude, frequency, size, opacity, delay;
  _FloatingElement({
    required this.icon,
    required this.startX,
    required this.startY,
    required this.amplitude,
    required this.frequency,
    required this.size,
    required this.opacity,
    required this.delay,
  });
}

class _OrbitalElement {
  final double radius, speed, size, opacity, angle;
  _OrbitalElement({
    required this.radius,
    required this.speed,
    required this.size,
    required this.opacity,
    required this.angle,
  });
}

// Enhanced painters
class _StarsPainter extends CustomPainter {
  final List<_StarParticle> stars;
  final double progress;
  _StarsPainter(this.stars, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    for (final star in stars) {
      final adjustedProgress = math.max(0.0, (progress - star.delay) * star.twinkleSpeed);
      final opacity = (math.sin(adjustedProgress * math.pi * 2) + 1) / 2;
      
      final x = star.x * size.width;
      final y = star.y * size.height;
      
      // Main star
      paint.color = Colors.white.withOpacity(opacity * 0.9);
      canvas.drawCircle(Offset(x, y), star.size, paint);
      
      // Glow effect
      paint.color = const Color(0xFF667eea).withOpacity(opacity * 0.3);
      canvas.drawCircle(Offset(x, y), star.size * 2.5, paint);
      
      // Sparkle lines
      if (opacity > 0.7) {
        paint.color = Colors.white.withOpacity(opacity * 0.6);
        paint.strokeWidth = 1;
        canvas.drawLine(
          Offset(x - star.size * 2, y),
          Offset(x + star.size * 2, y),
          paint,
        );
        canvas.drawLine(
          Offset(x, y - star.size * 2),
          Offset(x, y + star.size * 2),
          paint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _StarsPainter oldDelegate) => true;
}

class _BookPagesPainter extends CustomPainter {
  final List<_BookPage> pages;
  final double progress;
  _BookPagesPainter(this.pages, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    
    for (int i = 0; i < pages.length; i++) {
      final page = pages[i];
      final pageProgress = math.max(0.0, math.min(1.0, (progress - page.delay) * page.flipSpeed));
      
      if (pageProgress <= 0) continue;
      
      final x = page.x * size.width;
      final y = page.y * size.height;
      
      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(page.rotation + pageProgress * 0.1);
      
      // Enhanced page flip effect
      final flipProgress = math.sin(pageProgress * math.pi);
      canvas.scale(1.0, flipProgress);
      
      // Page shadow
      paint.color = Colors.black.withOpacity(0.1 * pageProgress);
      final shadowRect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: const Offset(2, 2),
          width: page.width,
          height: page.height,
        ),
        const Radius.circular(8),
      );
      canvas.drawRRect(shadowRect, paint);
      
      // Main page
      paint.color = Colors.white.withOpacity(0.15 * pageProgress);
      final rect = RRect.fromRectAndRadius(
        Rect.fromCenter(
          center: Offset.zero,
          width: page.width,
          height: page.height,
        ),
        const Radius.circular(8),
      );
      canvas.drawRRect(rect, paint);
      
      // Page content lines
      paint.color = Colors.white.withOpacity(0.08 * pageProgress);
      paint.strokeWidth = 1;
      for (int j = 0; j < 5; j++) {
        final lineY = -page.height/2 + 12 + j * 8;
        canvas.drawLine(
          Offset(-page.width/2 + 8, lineY),
          Offset(page.width/2 - 8, lineY),
          paint,
        );
      }
      
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(covariant _BookPagesPainter oldDelegate) => true;
}

class _FloatingElementsPainter extends CustomPainter {
  final List<_FloatingElement> elements;
  final double progress;
  _FloatingElementsPainter(this.elements, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final textPainter = TextPainter(textDirection: TextDirection.ltr);
    
    for (final element in elements) {
      final adjustedProgress = math.max(0.0, (progress - element.delay) * element.frequency);
      final x = element.startX * size.width + math.sin(adjustedProgress * math.pi * 2) * element.amplitude;
      final y = element.startY * size.height + math.cos(adjustedProgress * math.pi * 2) * element.amplitude * 0.5;
      
      paint.color = Colors.white.withOpacity(element.opacity);
      
      // Draw floating icon
      textPainter.text = TextSpan(
        text: String.fromCharCode(element.icon.codePoint),
        style: TextStyle(
          fontSize: element.size,
          fontFamily: element.icon.fontFamily,
          color: Colors.white.withOpacity(element.opacity),
        ),
      );
      textPainter.layout();
      textPainter.paint(canvas, Offset(x - element.size/2, y - element.size/2));
    }
  }

  @override
  bool shouldRepaint(covariant _FloatingElementsPainter oldDelegate) => true;
}

class _OrbitalElementsPainter extends CustomPainter {
  final List<_OrbitalElement> elements;
  final double progress;
  _OrbitalElementsPainter(this.elements, this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    final center = Offset(size.width / 2, size.height / 2);
    
    for (final element in elements) {
      final angle = element.angle + progress * element.speed * 2 * math.pi;
      final x = center.dx + math.cos(angle) * element.radius;
      final y = center.dy + math.sin(angle) * element.radius;
      
      paint.color = const Color(0xFF667eea).withOpacity(element.opacity);
      canvas.drawCircle(Offset(x, y), element.size, paint);
      
      // Glow effect
      paint.color = const Color(0xFF667eea).withOpacity(element.opacity * 0.3);
      canvas.drawCircle(Offset(x, y), element.size * 2, paint);
    }
  }

  @override
  bool shouldRepaint(covariant _OrbitalElementsPainter oldDelegate) => true;
}