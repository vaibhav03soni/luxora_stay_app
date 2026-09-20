import 'package:flutter/material.dart';

class AppStrings {
  static const String appName = 'Luxora Stay';

  static String get(BuildContext context, String key) {
    final locale = Localizations.localeOf(context).languageCode;
    return _localizedValues[locale]?[key] ?? _localizedValues['en']![key]!;
  }

  static const Map<String, Map<String, String>> _localizedValues = {
    'en': {
      'tagline': 'Stay Beautiful. Travel Better.',
      'homeHeroTitle': 'Where will you stay next?',
      'findPerfectStay': 'Find your perfect stay',
      'welcomeBack': 'Welcome Back',
      'loginToAccount': 'Login to your account',
      'email': 'Email',
      'password': 'Password',
      'forgotPassword': 'Forgot Password?',
      'searchDestination': 'Search destination',
      'checkIn': 'Check-in',
      'checkOut': 'Check-out',
      'guests': 'Guests',
      'rooms': 'Rooms',
      'popularDestinations': 'Popular Destinations',
      'featuredStays': 'Featured Stays',
      'exclusiveOffers': 'Exclusive Offers',
      'luxuryCollection': 'Luxury Collection',
      'recommendedForYou': 'Recommended for You',
      'logout': 'Logout',
      'confirmLogout': 'Are you sure you want to logout?',
      'cancel': 'Cancel',
      'login': 'Login',
      'register': 'Register',
      'continueGuest': 'Continue as Guest',
      'noTrips': 'No trips found',
      'errorOccurred': 'Something went wrong. Please try again.',
      'offlineMode': 'Offline mode — showing recently available data',
    },
    'hi': {
      'tagline': 'सुंदर रहें। बेहतर यात्रा करें।',
      'homeHeroTitle': 'आप अगली बार कहाँ रुकेंगे?',
      'findPerfectStay': 'अपना सही प्रवास खोजें',
      'welcomeBack': 'वापसी पर स्वागत है',
      'loginToAccount': 'अपने खाते में लॉगिन करें',
      'email': 'ईमेल',
      'password': 'पासवर्ड',
      'forgotPassword': 'पासवर्ड भूल गए?',
      'searchDestination': 'गंतव्य खोजें',
      'checkIn': 'चेक-इन',
      'checkOut': 'चेक-आउट',
      'guests': 'अतिथि',
      'rooms': 'कमरे',
      'popularDestinations': 'लोकप्रिय गंतव्य',
      'featuredStays': 'विशेष प्रवास',
      'exclusiveOffers': 'विशेष ऑफ़र',
      'luxuryCollection': 'लक्जरी संग्रह',
      'recommendedForYou': 'आपके लिए अनुशंसित',
      'logout': 'लॉगआउट',
      'confirmLogout': 'क्या आप वाकई लॉगआउट करना चाहते हैं?',
      'cancel': 'रद्द करें',
      'login': 'लॉगिन',
      'register': 'पंजीकरण',
      'continueGuest': 'अतिथि के रूप में जारी रखें',
      'noTrips': 'कोई यात्रा नहीं मिली',
      'errorOccurred': 'कुछ गलत हो गया। कृपया पुन: प्रयास करें।',
      'offlineMode': 'ऑफलाइन मोड - हाल ही में उपलब्ध डेटा दिखा रहा है',
    }
  };
}
