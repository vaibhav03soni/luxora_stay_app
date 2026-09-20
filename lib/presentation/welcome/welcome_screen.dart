import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/config/app_router.dart';
import '../widgets/app_logo.dart';
import 'package:google_fonts/google_fonts.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: CachedNetworkImageProvider("https://images.unsplash.com/photo-1566073771259-6a8506099945?q=80&w=1200"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          Container(color: Colors.black.withValues(alpha: 0.6)),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                children: [
                  const SizedBox(height: 60),
                  const AppLogo(size: 120),
                  const SizedBox(height: 20),
                  Text(
                    "Stay Beautiful.\nTravel Better.",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.playfairDisplay(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                    ),
                  ),
                  const Spacer(),
                  ElevatedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRouter.login),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: AppColors.primary,
                    ),
                    child: const Text("Login"),
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () => Navigator.pushNamed(context, AppRouter.register),
                    style: OutlinedButton.styleFrom(
                      minimumSize: const Size(double.infinity, 56),
                      side: const BorderSide(color: Colors.white, width: 1.5),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      foregroundColor: Colors.white,
                    ),
                    child: const Text("Create Account", style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: () => Navigator.pushReplacementNamed(context, AppRouter.mainTabs),
                    child: const Text("Continue as Guest", style: TextStyle(color: Colors.white70, fontSize: 16)),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
