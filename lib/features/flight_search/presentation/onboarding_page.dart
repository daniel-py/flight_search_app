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

class _OnboardingPageState extends ConsumerState<OnboardingPage> {
  final PageController _pageController = PageController();

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
      body: PageView.builder(
        controller: _pageController,
        onPageChanged: (index) {
          ref.read(currentPageProvider.notifier).state = index;
        },
        itemCount: _onboardingData.length,
        itemBuilder: (context, index) {
          final data = _onboardingData[index];
          return Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [data.startColor, data.endColor],
              ),
            ),
            child: SafeArea(
              child: Padding(
                padding: const EdgeInsets.only(top: 20, left: 20, right: 20),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 350,
                      height: 320,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            topLeft: currentPage == 1 ? Radius.zero : const Radius.circular(50),
                            topRight: currentPage == 0 ? Radius.zero : const Radius.circular(50),
                            bottomLeft: currentPage == 2 ? Radius.zero : const Radius.circular(50),
                            bottomRight: const Radius.circular(50)),
                        image: DecorationImage(
                          image: AssetImage(data.imagePath),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      data.title,
                      style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      height: 44,
                      child: Text(
                        data.subtitle,
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: Colors.white.withOpacity(0.9),
                              height: 1.5,
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 32),
                    SmoothPageIndicator(
                      controller: _pageController,
                      count: _onboardingData.length,
                      effect: WormEffect(
                        dotHeight: 8,
                        dotWidth: 8,
                        spacing: 8,
                        dotColor: Colors.white.withOpacity(0.3),
                        activeDotColor: Colors.white,
                      ),
                    ),
                    const Spacer(),
                    SizedBox(
                      width: double.infinity,
                      height: 48,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: _onboardingData[currentPage].startColor,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
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
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (ref.read(currentPageProvider) < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const SearchPage(),
        ),
      );
    }
  }
}
