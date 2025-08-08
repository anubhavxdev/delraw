import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';

import '../../core/app_export.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _taglineController;
  late AnimationController _loadingController;

  late Animation<double> _logoFadeAnimation;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _taglineFadeAnimation;
  late Animation<double> _taglineSlideAnimation;
  late Animation<double> _loadingAnimation;

  bool _isInitialized = false;
  double _loadingProgress = 0.0;

  @override
  void initState() {
    super.initState();
    _setupAnimations();
    _initializeApp();
  }

  void _setupAnimations() {
    // Logo animation controller
    _logoController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Tagline animation controller
    _taglineController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    // Loading animation controller
    _loadingController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    // Logo animations
    _logoFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.easeInOut),
    ));

    _logoScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _logoController,
      curve: const Interval(0.0, 0.8, curve: Curves.elasticOut),
    ));

    // Tagline animations
    _taglineFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeInOut),
    ));

    _taglineSlideAnimation = Tween<double>(
      begin: 30.0,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _taglineController,
      curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
    ));

    // Loading animation
    _loadingAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _loadingController,
      curve: Curves.easeInOut,
    ));
  }

  Future<void> _initializeApp() async {
    try {
      // Start logo animation immediately
      _logoController.forward();

      // Simulate loading static JSON data
      await _loadStaticData();

      // Start tagline animation after logo
      await Future.delayed(const Duration(milliseconds: 800));
      _taglineController.forward();

      // Start loading animation
      _loadingController.forward();

      // Complete initialization
      await _completeInitialization();

      setState(() {
        _isInitialized = true;
      });

      // Navigate after animations complete
      await Future.delayed(const Duration(milliseconds: 1000));
      _navigateToNextScreen();
    } catch (e) {
      // Handle initialization errors gracefully
      await Future.delayed(const Duration(milliseconds: 2000));
      _navigateToNextScreen();
    }
  }

  Future<void> _loadStaticData() async {
    // Simulate loading product catalog data
    for (int i = 0; i <= 100; i += 10) {
      await Future.delayed(const Duration(milliseconds: 50));
      setState(() {
        _loadingProgress = i / 100;
      });
    }
  }

  Future<void> _completeInitialization() async {
    // Simulate final initialization steps
    await Future.delayed(const Duration(milliseconds: 500));

    // Initialize Provider state management
    await Future.delayed(const Duration(milliseconds: 200));

    // Prepare cached supplier information
    await Future.delayed(const Duration(milliseconds: 300));

    // Setup navigation routes
    await Future.delayed(const Duration(milliseconds: 200));
  }

  void _navigateToNextScreen() {
    if (!mounted) return;

    // Check if user is first-time or returning
    // For demo purposes, navigate to login screen
    Navigator.pushReplacementNamed(context, '/login-screen');
  }

  @override
  void dispose() {
    _logoController.dispose();
    _taglineController.dispose();
    _loadingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnnotatedRegion<SystemUiOverlayStyle>(
        value: SystemUiOverlayStyle(
          statusBarColor: Colors.transparent,
          statusBarIconBrightness: Brightness.light,
          systemNavigationBarColor: AppTheme.primaryLight,
          systemNavigationBarIconBrightness: Brightness.light,
        ),
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: _buildGradientBackground(),
          child: SafeArea(
            child: Column(
              children: [
                Expanded(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        _buildAnimatedLogo(),
                        SizedBox(height: 4.h),
                        _buildAnimatedTagline(),
                      ],
                    ),
                  ),
                ),
                _buildLoadingSection(),
                SizedBox(height: 8.h),
              ],
            ),
          ),
        ),
      ),
    );
  }

  BoxDecoration _buildGradientBackground() {
    return BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          AppTheme.primaryLight,
          AppTheme.primaryVariantLight,
          AppTheme.primaryLight.withValues(alpha: 0.9),
        ],
        stops: const [0.0, 0.6, 1.0],
      ),
    );
  }

  Widget _buildAnimatedLogo() {
    return AnimatedBuilder(
      animation: _logoController,
      builder: (context, child) {
        return Transform.scale(
          scale: _logoScaleAnimation.value,
          child: Opacity(
            opacity: _logoFadeAnimation.value,
            child: Container(
              width: 25.w,
              height: 25.w,
              decoration: BoxDecoration(
                color: AppTheme.secondaryLight,
                borderRadius: BorderRadius.circular(4.w),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(
                  'D',
                  style: TextStyle(
                    fontSize: 12.w,
                    fontWeight: FontWeight.bold,
                    color: AppTheme.onSecondaryLight,
                    letterSpacing: 2,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildAnimatedTagline() {
    return AnimatedBuilder(
      animation: _taglineController,
      builder: (context, child) {
        return Transform.translate(
          offset: Offset(0, _taglineSlideAnimation.value),
          child: Opacity(
            opacity: _taglineFadeAnimation.value,
            child: Column(
              children: [
                Text(
                  'DELRAW',
                  style: TextStyle(
                    fontSize: 8.w,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    letterSpacing: 4,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Raw Materials. Refined Solutions.',
                  style: TextStyle(
                    fontSize: 3.5.w,
                    fontWeight: FontWeight.w400,
                    color: AppTheme.secondaryLight,
                    letterSpacing: 1,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Connecting Apparel Industry in Ludhiana',
                  style: TextStyle(
                    fontSize: 3.w,
                    fontWeight: FontWeight.w300,
                    color: Colors.white.withValues(alpha: 0.8),
                    letterSpacing: 0.5,
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildLoadingSection() {
    return AnimatedBuilder(
      animation: _loadingController,
      builder: (context, child) {
        return Opacity(
          opacity: _loadingAnimation.value,
          child: Column(
            children: [
              _buildLoadingIndicator(),
              SizedBox(height: 2.h),
              _buildLoadingText(),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLoadingIndicator() {
    return Container(
      width: 60.w,
      height: 0.5.h,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.2),
        borderRadius: BorderRadius.circular(1.h),
      ),
      child: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(1.h),
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            width: 60.w * _loadingProgress,
            height: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  AppTheme.secondaryLight,
                  AppTheme.secondaryVariantLight,
                ],
              ),
              borderRadius: BorderRadius.circular(1.h),
              boxShadow: [
                BoxShadow(
                  color: AppTheme.secondaryLight.withValues(alpha: 0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLoadingText() {
    return Column(
      children: [
        Text(
          _getLoadingText(),
          style: TextStyle(
            fontSize: 3.w,
            fontWeight: FontWeight.w400,
            color: Colors.white.withValues(alpha: 0.9),
            letterSpacing: 0.5,
          ),
          textAlign: TextAlign.center,
        ),
        if (_isInitialized) ...[
          SizedBox(height: 1.h),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CustomIconWidget(
                iconName: 'check_circle',
                color: AppTheme.successLight,
                size: 4.w,
              ),
              SizedBox(width: 2.w),
              Text(
                'Ready to connect suppliers',
                style: TextStyle(
                  fontSize: 2.5.w,
                  fontWeight: FontWeight.w500,
                  color: AppTheme.successLight,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  String _getLoadingText() {
    if (_loadingProgress < 0.3) {
      return 'Loading product catalog...';
    } else if (_loadingProgress < 0.6) {
      return 'Initializing supplier network...';
    } else if (_loadingProgress < 0.9) {
      return 'Setting up your workspace...';
    } else if (_isInitialized) {
      return 'Welcome to Delraw!';
    } else {
      return 'Almost ready...';
    }
  }
}
