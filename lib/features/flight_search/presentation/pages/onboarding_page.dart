import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import 'search_page.dart';

final currentPageProvider = StateProvider<int>((ref) => 0);

class OnboardingData {
  final String title;
  final String subtitle;
  final Color startColor;
  final Color endColor;
  final String imagePath;

  OnboardingData({
    required this.title,
    required this.subtitle,
    required this.startColor,
    required this.endColor,
    required this.imagePath,
  });
}

class OnboardingPage extends ConsumerStatefulWidget {
  const OnboardingPage({super.key});

  @override
  ConsumerState<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends ConsumerState<OnboardingPage> with TickerProviderStateMixin {
  late PageController _pageController;
  late AnimationController _backgroundController;
  late AnimationController _illustrationController;
  late AnimationController _textController;
  late AnimationController _buttonController;

  late Animation<double> _backgroundAnimation;
  late Animation<Offset> _illustrationSlideAnimation;
  late Animation<double> _illustrationScaleAnimation;
  late Animation<double> _textFadeAnimation;
  late Animation<Offset> _textSlideAnimation;
  late Animation<double> _buttonScaleAnimation;

  final List<OnboardingData> _onboardingData = [
    OnboardingData(
      title: 'Search Flights Instantly',
      subtitle: 'Find the best flight deals in seconds',
      startColor: const Color(0xFF3AA6F9),
      endColor: const Color(0xFF6FB8F5),
      imagePath: 'assets/images/ob_img_1.png',
    ),
    OnboardingData(
      title: 'Compare Prices Easily',
      subtitle: 'Find the best deals on flights from multiple airlines in one place.',
      startColor: const Color(0xFF7C5CE0),
      endColor: const Color(0xFFA88BEB),
      imagePath: 'assets/images/ob_img_2.png',
    ),
    OnboardingData(
      title: 'Book with Confidence',
      subtitle: 'Secure your travel plans with our reliable booking process.',
      startColor: const Color(0xFFFF7A59),
      endColor: const Color(0xFFFFA585),
      imagePath: 'assets/images/ob_img_3.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final int currentPage = ref.watch(currentPageProvider);
    
    return Scaffold(
      body: AnimatedBuilder(
        animation: _backgroundAnimation,
        builder: (context, child) {
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  _onboardingData[currentPage].startColor,
                  _onboardingData[currentPage].endColor,
                ],
              ),
            ),
            child: PageView.builder(
              controller: _pageController,
              onPageChanged: (index) {
                ref.read(currentPageProvider.notifier).state = index;
                _resetAnimations();
                Future.delayed(const Duration(milliseconds: 100), () {
                  _startAnimations();
                });
              },
              itemCount: _onboardingData.length,
              itemBuilder: (context, index) {
                final data = _onboardingData[index];
                return _buildOnboardingPage(data, currentPage);
              },
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    _backgroundController.dispose();
    _illustrationController.dispose();
    _textController.dispose();
    _buttonController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _illustrationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 400),
      vsync: this,
    );

    _backgroundAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _backgroundController,
      curve: Curves.easeInOutCubic,
    ));

    _illustrationSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _illustrationController,
      curve: Curves.elasticOut,
    ));

    _illustrationScaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _illustrationController,
      curve: Curves.easeOutBack,
    ));

    _textFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeInOut,
    ));

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _textController,
      curve: Curves.easeOutCubic,
    ));

    _buttonScaleAnimation = Tween<double>(
      begin: 0.9,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _buttonController,
      curve: Curves.elasticOut,
    ));

    _startAnimations();
  }

  Widget _buildOnboardingPage(OnboardingData data, int currentPage) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SlideTransition(
              position: _illustrationSlideAnimation,
              child: ScaleTransition(
                scale: _illustrationScaleAnimation,
                child: Container(
                  width: 350,
                  height: 320,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: currentPage == 1 ? Radius.zero : const Radius.circular(50),
                      topRight: currentPage == 0 ? Radius.zero : const Radius.circular(50),
                      bottomLeft: currentPage == 2 ? Radius.zero : const Radius.circular(50),
                      bottomRight: const Radius.circular(50),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                    image: DecorationImage(
                      image: AssetImage(data.imagePath),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: Text(
                  data.title,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        color: Colors.black.withOpacity(0.3),
                        offset: const Offset(0, 2),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            const SizedBox(height: 16),
            
            SlideTransition(
              position: _textSlideAnimation,
              child: FadeTransition(
                opacity: _textFadeAnimation,
                child: SizedBox(
                  height: 44,
                  child: Text(
                    data.subtitle,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: Colors.white.withOpacity(0.9),
                      height: 1.5,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.2),
                          offset: const Offset(0, 1),
                          blurRadius: 2,
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 32),
            
            SmoothPageIndicator(
              controller: _pageController,
              count: _onboardingData.length,
              effect: ScrollingDotsEffect(
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
                dotColor: Colors.white.withOpacity(0.3),
                activeDotColor: Colors.white,
                paintStyle: PaintingStyle.fill,
              ),
            ),
            const Spacer(),
            
            ScaleTransition(
              scale: _buttonScaleAnimation,
              child: Container(
                width: double.infinity,
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, 5),
                    ),
                  ],
                ),
                child: ElevatedButton(
                  onPressed: _nextPage,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: _onboardingData[currentPage].startColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                    elevation: 0,
                  ),
                  child: Text(
                    currentPage == _onboardingData.length - 1 ? 'Get Started' : 'Next',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w700,
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

  void _nextPage() {
    if (ref.read(currentPageProvider) < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _buttonController.reverse().then((_) {
        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (context, animation, secondaryAnimation) => const SearchPage(),
            transitionsBuilder: (context, animation, secondaryAnimation, child) {
              const begin = Offset(1.0, 0.0);
              const end = Offset.zero;
              const curve = Curves.easeInOutCubic;

              var tween = Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
              var offsetAnimation = animation.drive(tween);

              return SlideTransition(
                position: offsetAnimation,
                child: child,
              );
            },
            transitionDuration: const Duration(milliseconds: 500),
          ),
        );
      });
    }
  }

  void _resetAnimations() {
    _illustrationController.reset();
    _textController.reset();
    _buttonController.reset();
  }

  void _startAnimations() {
    _backgroundController.forward();
    _illustrationController.forward();
    _textController.forward();
    _buttonController.forward();
  }
}
