import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/app_router.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<OnboardingData> _pages = [
    OnboardingData(
      title: "Discover Exceptional Stays",
      description: "Explore our curated collection of luxury hotels and resorts across India's most beautiful destinations.",
      imageUrl: "https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=800",
    ),
    OnboardingData(
      title: "Book With Confidence",
      description: "Enjoy seamless booking with secure payments, instant confirmation, and 24/7 premium support.",
      imageUrl: "https://images.unsplash.com/photo-1571896349842-33c89424de2d?q=80&w=800",
    ),
    OnboardingData(
      title: "Travel Your Way",
      description: "Personalized recommendations and exclusive member benefits to make every journey unforgettable.",
      imageUrl: "https://images.unsplash.com/photo-1512343879784-a960bf40e7f2?q=80&w=800",
    ),
  ];

  void _finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_complete', true);
    if (mounted) {
      Navigator.pushReplacementNamed(context, AppRouter.welcome);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: _pages.length,
            onPageChanged: (index) => setState(() => _currentPage = index),
            itemBuilder: (context, index) => _OnboardingPage(data: _pages[index]),
          ),
          Positioned(
            top: 60,
            right: 20,
            child: TextButton(
              onPressed: _finishOnboarding,
              child: const Text("Skip", style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
            ),
          ),
          Positioned(
            bottom: 60,
            left: 30,
            right: 30,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _pages.length,
                    (index) => Container(
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      height: 8,
                      width: _currentPage == index ? 24 : 8,
                      decoration: BoxDecoration(
                        color: _currentPage == index ? AppColors.secondary : Colors.white54,
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    if (_currentPage == _pages.length - 1) {
                      _finishOnboarding();
                    } else {
                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.secondary,
                    foregroundColor: AppColors.primary,
                    minimumSize: const Size(double.infinity, 56),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text(_currentPage == _pages.length - 1 ? "Get Started" : "Next"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class OnboardingData {
  final String title;
  final String description;
  final String imageUrl;
  OnboardingData({required this.title, required this.description, required this.imageUrl});
}

class _OnboardingPage extends StatelessWidget {
  final OnboardingData data;
  const _OnboardingPage({required this.data});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: CachedNetworkImageProvider(data.imageUrl),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.mode(Colors.black.withValues(alpha: 0.4), BlendMode.darken),
        ),
      ),
      padding: const EdgeInsets.all(40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),
          Text(
            data.title,
            textAlign: TextAlign.center,
            style: GoogleFonts.playfairDisplay(
              color: Colors.white,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            data.description,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white70, fontSize: 16, height: 1.5),
          ),
          const Spacer(),
        ],
      ),
    );
  }
}
