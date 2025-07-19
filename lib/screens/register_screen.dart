import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:math' as math;
import '../widgets/custom_text_field.dart';
import '../widgets/app_button.dart';
import '../services/auth_service.dart';
import '../utils/dialogs.dart';
import '../utils/app_routes.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen>
    with TickerProviderStateMixin {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  
  bool _loading = false;
  bool _obscurePassword = true;
  bool _agreedToTerms = false;
  
  // Focus states
  bool _fullNameHasFocus = false;
  bool _usernameHasFocus = false;
  bool _emailHasFocus = false;
  bool _passwordHasFocus = false;
  
  // Animation controllers
  late AnimationController _fadeController;
  late AnimationController _slideController;
  late AnimationController _scaleController;
  late AnimationController _rotationController;
  late AnimationController _pulseController;
  late AnimationController _shimmerController;
  late AnimationController _particleController;
  
  // Animations
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _rotationAnimation;
  late Animation<double> _pulseAnimation;
  late Animation<double> _shimmerAnimation;
  late Animation<double> _particleAnimation;
  
  // Focus nodes
  final FocusNode _fullNameFocus = FocusNode();
  final FocusNode _usernameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passwordFocus = FocusNode();
  
  // Password strength
  double _passwordStrength = 0.0;
  String _passwordStrengthText = '';
  Color _passwordStrengthColor = Colors.red;

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _startAnimations();
    _setupFocusListeners();
    _passwordController.addListener(_checkPasswordStrength);
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    
    _rotationController = AnimationController(
      duration: const Duration(seconds: 20),
      vsync: this,
    );
    
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    
    _shimmerController = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    
    _particleController = AnimationController(
      duration: const Duration(seconds: 10),
      vsync: this,
    );

    // Setup animations
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    ));
    
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController,
      curve: Curves.easeOutCubic,
    ));
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _scaleController,
      curve: Curves.elasticOut,
    ));
    
    _rotationAnimation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(_rotationController);
    
    _pulseAnimation = Tween<double>(
      begin: 0.8,
      end: 1.2,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    _shimmerAnimation = Tween<double>(
      begin: -2,
      end: 2,
    ).animate(CurvedAnimation(
      parent: _shimmerController,
      curve: Curves.linear,
    ));
    
    _particleAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(_particleController);
  }

  void _startAnimations() {
    _fadeController.forward();
    _slideController.forward();
    _scaleController.forward();
    _rotationController.repeat();
    _pulseController.repeat(reverse: true);
    _shimmerController.repeat();
    _particleController.repeat();
  }

  void _setupFocusListeners() {
    _fullNameFocus.addListener(() {
      setState(() {
        _fullNameHasFocus = _fullNameFocus.hasFocus;
      });
    });
    
    _usernameFocus.addListener(() {
      setState(() {
        _usernameHasFocus = _usernameFocus.hasFocus;
      });
    });
    
    _emailFocus.addListener(() {
      setState(() {
        _emailHasFocus = _emailFocus.hasFocus;
      });
    });
    
    _passwordFocus.addListener(() {
      setState(() {
        _passwordHasFocus = _passwordFocus.hasFocus;
      });
    });
  }

  void _checkPasswordStrength() {
    final password = _passwordController.text;
    double strength = 0.0;
    String strengthText = '';
    Color strengthColor = Colors.red;

    if (password.isEmpty) {
      strength = 0.0;
      strengthText = '';
    } else if (password.length < 6) {
      strength = 0.25;
      strengthText = 'Weak';
      strengthColor = Colors.red;
    } else if (password.length < 8) {
      strength = 0.5;
      strengthText = 'Fair';
      strengthColor = Colors.orange;
    } else if (password.length >= 8 && 
               password.contains(RegExp(r'[A-Z]')) &&
               password.contains(RegExp(r'[a-z]')) &&
               password.contains(RegExp(r'[0-9]'))) {
      strength = 0.75;
      strengthText = 'Good';
      strengthColor = const Color(0xFF6366F1);
    } else if (password.length >= 8 && 
               password.contains(RegExp(r'[A-Z]')) &&
               password.contains(RegExp(r'[a-z]')) &&
               password.contains(RegExp(r'[0-9]')) &&
               password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
      strength = 1.0;
      strengthText = 'Strong';
      strengthColor = const Color(0xFF10B981);
    } else {
      strength = 0.6;
      strengthText = 'Fair';
      strengthColor = Colors.orange;
    }

    setState(() {
      _passwordStrength = strength;
      _passwordStrengthText = strengthText;
      _passwordStrengthColor = strengthColor;
    });
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Email is required';
    }
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(value)) {
      return 'Please enter a valid email';
    }
    return null;
  }

  String? _validateUsername(String? value) {
    if (value == null || value.isEmpty) {
      return 'Username is required';
    }
    if (value.length < 3) {
      return 'Username must be at least 3 characters';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password is required';
    }
    if (value.length < 6) {
      return 'Password must be at least 6 characters';
    }
    return null;
  }

  String? _validateFullName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Full name is required';
    }
    if (value.length < 2) {
      return 'Please enter your full name';
    }
    return null;
  }

  void _register() {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (!_agreedToTerms) {
      showAppSnackbar(context, 'Please agree to the terms and conditions');
      return;
    }

    HapticFeedback.lightImpact();
    setState(() => _loading = true);

    final username = _usernameController.text.trim();
    final password = _passwordController.text;
    final fullName = _fullNameController.text.trim();
    final email = _emailController.text.trim();

    try {
      final success = AuthService.register(
        username,
        password,
        fullName: fullName,
        email: email,
      );

      if (mounted) {
        setState(() => _loading = false);
        if (success) {
          HapticFeedback.lightImpact();
          showAppSnackbar(context, 'Registration successful! Please login.');
          Navigator.pushReplacementNamed(context, AppRoutes.login);
        } else {
          HapticFeedback.vibrate();
          showAppSnackbar(context, 'Username already exists');
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() => _loading = false);
        HapticFeedback.vibrate();
        showAppSnackbar(context, 'Registration failed. Please try again.');
      }
    }
  }

  Widget _buildAnimatedBackground() {
    return AnimatedBuilder(
      animation: _particleAnimation,
      builder: (context, child) {
        return Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                const Color(0xFF0F0C29),
                const Color(0xFF24243e),
                const Color(0xFF302B63),
                const Color(0xFF0F0C29),
              ],
              stops: const [0.0, 0.3, 0.7, 1.0],
            ),
          ),
          child: Stack(
            children: [
              // Animated particles
              ...List.generate(20, (index) {
                final offset = Offset(
                  (math.sin(_particleAnimation.value * 2 * math.pi + index) * 50) + 
                  (index % 5) * 80.0,
                  (math.cos(_particleAnimation.value * 2 * math.pi + index * 0.5) * 30) + 
                  (index % 4) * 100.0,
                );
                return Positioned(
                  left: offset.dx,
                  top: offset.dy,
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _pulseAnimation.value * 0.5,
                        child: Container(
                          width: 4,
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.3),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.white.withOpacity(0.2),
                                blurRadius: 10,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                );
              }),
              // Gradient overlay
              Container(
                decoration: BoxDecoration(
                  gradient: RadialGradient(
                    center: const Alignment(0.3, -0.5),
                    radius: 1.5,
                    colors: [
                      const Color(0xFF6366F1).withOpacity(0.3),
                      const Color(0xFF8B5CF6).withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGlassmorphicContainer({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: Colors.white.withOpacity(0.2),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 20),
          ),
          BoxShadow(
            color: Colors.white.withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, -10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(32),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.15),
                Colors.white.withOpacity(0.05),
              ],
            ),
          ),
          child: child,
        ),
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _rotationAnimation,
      builder: (context, child) {
        return Stack(
          alignment: Alignment.center,
          children: [
            // Outer rotating ring
            Transform.rotate(
              angle: _rotationAnimation.value,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: const Color(0xFF6366F1).withOpacity(0.3),
                    width: 2,
                  ),
                ),
              ),
            ),
            // Inner pulsing circle
            AnimatedBuilder(
              animation: _pulseAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _pulseAnimation.value,
                  child: Container(
                    width: 90,
                    height: 90,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFF6366F1),
                          const Color(0xFF8B5CF6),
                          const Color(0xFF00BFAE),
                        ],
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF6366F1).withOpacity(0.6),
                          blurRadius: 30,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.person_add,
                      color: Colors.white,
                      size: 50,
                    ),
                  ),
                );
              },
            ),
          ],
        );
      },
    );
  }

  Widget _buildShimmerText(String text, {double fontSize = 32, FontWeight fontWeight = FontWeight.bold}) {
    return AnimatedBuilder(
      animation: _shimmerAnimation,
      builder: (context, child) {
        return ShaderMask(
          shaderCallback: (bounds) {
            return LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withOpacity(0.6),
                Colors.white,
                const Color(0xFF6366F1),
                Colors.white,
                Colors.white.withOpacity(0.6),
              ],
              stops: [
                0.0,
                math.max(0.0, _shimmerAnimation.value - 0.3),
                _shimmerAnimation.value,
                math.min(1.0, _shimmerAnimation.value + 0.3),
                1.0,
              ],
            ).createShader(bounds);
          },
          child: Text(
            text,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: fontWeight,
              color: Colors.white,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPremiumTextField({
    required String label,
    required TextEditingController controller,
    required FocusNode focusNode,
    required bool hasFocus,
    bool obscureText = false,
    IconData? icon,
    TextInputType? keyboardType,
    String? Function(String?)? validator,
    Widget? suffixWidget,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: hasFocus 
                ? const Color(0xFF6366F1) 
                : Colors.white.withOpacity(0.2),
              width: hasFocus ? 2 : 1,
            ),
            boxShadow: hasFocus ? [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.3),
                blurRadius: 20,
                spreadRadius: 2,
              ),
            ] : [],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.1),
                    Colors.white.withOpacity(0.05),
                  ],
                ),
              ),
              child: TextFormField(
                controller: controller,
                focusNode: focusNode,
                obscureText: obscureText,
                keyboardType: keyboardType,
                validator: validator,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
                decoration: InputDecoration(
                  labelText: label,
                  labelStyle: TextStyle(
                    color: hasFocus 
                      ? const Color(0xFF6366F1) 
                      : Colors.white.withOpacity(0.7),
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  prefixIcon: icon != null ? Icon(
                    icon,
                    color: hasFocus 
                      ? const Color(0xFF6366F1) 
                      : Colors.white.withOpacity(0.7),
                  ) : null,
                  suffixIcon: suffixWidget,
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: 20,
                  ),
                  errorStyle: TextStyle(
                    color: Colors.red.shade300,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPasswordStrengthIndicator() {
    if (_passwordController.text.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.only(top: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 4,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(2),
                    color: Colors.white.withOpacity(0.2),
                  ),
                  child: FractionallySizedBox(
                    alignment: Alignment.centerLeft,
                    widthFactor: _passwordStrength,
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(2),
                        color: _passwordStrengthColor,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 300),
                child: Text(
                  _passwordStrengthText,
                  key: ValueKey(_passwordStrengthText),
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: _passwordStrengthColor,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTermsCheckbox() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      margin: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            child: Transform.scale(
              scale: 1.1,
              child: Theme(
                data: Theme.of(context).copyWith(
                  checkboxTheme: CheckboxThemeData(
                    fillColor: MaterialStateProperty.resolveWith<Color?>(
                      (Set<MaterialState> states) {
                        if (states.contains(MaterialState.selected)) {
                          return const Color(0xFF6366F1);
                        }
                        return Colors.transparent;
                      },
                    ),
                    checkColor: MaterialStateProperty.all(Colors.white),
                    side: BorderSide(
                      color: Colors.white.withOpacity(0.7),
                      width: 2,
                    ),
                  ),
                ),
                child: Checkbox(
                  value: _agreedToTerms,
                  onChanged: (value) {
                    HapticFeedback.selectionClick();
                    setState(() => _agreedToTerms = value ?? false);
                  },
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(4),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                setState(() => _agreedToTerms = !_agreedToTerms);
              },
              child: Text.rich(
                TextSpan(
                  text: 'I agree to the ',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withOpacity(0.8),
                  ),
                  children: [
                    TextSpan(
                      text: 'Terms and Conditions',
                      style: TextStyle(
                        color: const Color(0xFF6366F1),
                        fontWeight: FontWeight.w600,
                        decoration: TextDecoration.underline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPremiumButton() {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Container(
          width: double.infinity,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF6366F1).withOpacity(0.5),
                blurRadius: 20,
                spreadRadius: 2,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              borderRadius: BorderRadius.circular(20),
              onTap: _loading ? null : _register,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF6366F1),
                      const Color(0xFF8B5CF6),
                      const Color(0xFF00BFAE),
                    ],
                  ),
                ),
                child: Center(
                  child: _loading
                      ? SizedBox(
                          width: 28,
                          height: 28,
                          child: CircularProgressIndicator(
                            valueColor: const AlwaysStoppedAnimation<Color>(Colors.white),
                            strokeWidth: 3,
                          ),
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.person_add,
                              color: Colors.white,
                              size: 24,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Create Account',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _slideController.dispose();
    _scaleController.dispose();
    _rotationController.dispose();
    _pulseController.dispose();
    _shimmerController.dispose();
    _particleController.dispose();
    _usernameController.dispose();
    _passwordController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _fullNameFocus.dispose();
    _usernameFocus.dispose();
    _emailFocus.dispose();
    _passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Animated background
          _buildAnimatedBackground(),
          
          // Main content
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: FadeTransition(
                  opacity: _fadeAnimation,
                  child: SlideTransition(
                    position: _slideAnimation,
                    child: ScaleTransition(
                      scale: _scaleAnimation,
                      child: _buildGlassmorphicContainer(
                        child: Container(
                          constraints: const BoxConstraints(maxWidth: 420),
                          padding: const EdgeInsets.all(40.0),
                          child: Form(
                            key: _formKey,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                // Add at the top of the main content column, before the animated logo and welcome text
                                Padding(
                                  padding: const EdgeInsets.only(bottom: 24.0),
                                  child: Text(
                                    'Tanauan Institute Enrollment System',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white.withOpacity(0.95),
                                      letterSpacing: 1.2,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.2),
                                          blurRadius: 8,
                                          offset: const Offset(0, 2),
                                        ),
                                      ],
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                // Animated Logo
                                _buildAnimatedLogo(),
                                const SizedBox(height: 40),
                                
                                // Welcome Text with Shimmer
                                _buildShimmerText('Join Us Today'),
                                const SizedBox(height: 12),
                                Text(
                                  'Create your account to get started',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: Colors.white.withOpacity(0.8),
                                    fontWeight: FontWeight.w400,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                const SizedBox(height: 50),
                                
                                // Full Name Field
                                _buildPremiumTextField(
                                  label: 'Full Name',
                                  controller: _fullNameController,
                                  focusNode: _fullNameFocus,
                                  hasFocus: _fullNameHasFocus,
                                  icon: Icons.person_outline,
                                  validator: _validateFullName,
                                ),
                                const SizedBox(height: 20),
                                
                                // Username Field
                                _buildPremiumTextField(
                                  label: 'Username',
                                  controller: _usernameController,
                                  focusNode: _usernameFocus,
                                  hasFocus: _usernameHasFocus,
                                  icon: Icons.alternate_email,
                                  validator: _validateUsername,
                                ),
                                const SizedBox(height: 20),
                                
                                // Email Field
                                _buildPremiumTextField(
                                  label: 'Email',
                                  controller: _emailController,
                                  focusNode: _emailFocus,
                                  hasFocus: _emailHasFocus,
                                  icon: Icons.email_outlined,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 20),
                                
                                // Password Field
                                _buildPremiumTextField(
                                  label: 'Password',
                                  controller: _passwordController,
                                  focusNode: _passwordFocus,
                                  hasFocus: _passwordHasFocus,
                                  obscureText: _obscurePassword,
                                  icon: Icons.lock_outline,
                                  validator: _validatePassword,
                                  suffixWidget: IconButton(
                                    icon: Icon(
                                      _obscurePassword 
                                        ? Icons.visibility_off_outlined 
                                        : Icons.visibility_outlined,
                                      color: _passwordHasFocus 
                                        ? const Color(0xFF6366F1) 
                                        : Colors.white.withOpacity(0.7),
                                    ),
                                    onPressed: () {
                                      HapticFeedback.selectionClick();
                                      setState(() => _obscurePassword = !_obscurePassword);
                                    },
                                  ),
                                ),
                                _buildPasswordStrengthIndicator(),
                                const SizedBox(height: 20),
                                // Terms Checkbox
                                _buildTermsCheckbox(),
                                const SizedBox(height: 24),
                                // Register Button
                                _buildPremiumButton(),
                                const SizedBox(height: 24),
                                // Sign In Link
                                TextButton(
                                  onPressed: () {
                                    HapticFeedback.selectionClick();
                                    Navigator.pushReplacementNamed(context, AppRoutes.login);
                                  },
                                  style: TextButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                                  ),
                                  child: Text.rich(
                                    TextSpan(
                                      text: 'Already have an account? ',
                                      style: TextStyle(color: Colors.white.withOpacity(0.8)),
                                      children: [
                                        TextSpan(
                                          text: 'Sign In',
                                          style: TextStyle(
                                            color: const Color(0xFF6366F1),
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
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
}