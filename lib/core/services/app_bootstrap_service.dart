import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:firebase_core/firebase_core.dart';
import '../config/app_config.dart';
import '../config/dependency_injection.dart';
import '../config/app_router.dart';
import 'auth_service.dart';

class AppBootstrapService {
  static Future<String> init() async {
    // 1. Initialize App Config (Env variables, Data mode)
    await AppConfig.init();

    // 2. Initialize Firebase
    try {
      await Firebase.initializeApp();
      AppConfig.isFirebaseAvailable = true;
      debugPrint('Firebase Initialized');
    } catch (e) {
      AppConfig.isFirebaseAvailable = false;
      debugPrint('Firebase initialization failed: $e');
    }

    // 3. Initialize Dependency Injection
    await initDI();

    // 4. Decide initial route
    final prefs = await SharedPreferences.getInstance();
    final bool onboardingComplete = prefs.getBool('onboarding_complete') ?? false;

    if (!onboardingComplete) {
      return AppRouter.onboarding;
    }

    // Check auth session
    final authService = sl<AuthService>();
    if (authService.currentUser != null) {
      return AppRouter.mainTabs;
    }

    debugPrint('App Bootstrap Completed Successfully (${AppConfig.dataMode})');
    return AppRouter.welcome;
  }
}
