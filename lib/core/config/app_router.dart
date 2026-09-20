import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../services/auth_service.dart';
import './dependency_injection.dart';
import '../../presentation/auth/bloc/auth_bloc.dart';
import '../../presentation/main_tab_scaffold.dart';
import '../../presentation/auth/login_screen.dart';
import '../../presentation/hotel/hotel_details_screen.dart';
import '../../presentation/search/search_screen.dart';
import '../../presentation/booking/booking_screen.dart';
import '../../presentation/onboarding/onboarding_screen.dart';
import '../../presentation/welcome/welcome_screen.dart';
import '../../presentation/auth/register/register_screen.dart';
import '../../presentation/hotel/map_view_screen.dart';
import '../../presentation/settings/settings_screen.dart';
import '../../presentation/support/support_screen.dart';
import '../../presentation/notifications/notifications_screen.dart';
import '../../presentation/auth/forgot_password_screen.dart';
import '../../presentation/auth/otp_verification_screen.dart';
import '../../presentation/trips/booking_details_screen.dart';
import '../../presentation/profile/edit_profile_screen.dart';
import '../../data/models/hotel_model.dart';
import '../../data/models/booking_model.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class AppRouter {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String welcome = '/welcome';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String search = '/search';
  static const String hotelDetails = '/hotel-details';
  static const String booking = '/booking';
  static const String mainTabs = '/main';
  static const String mapView = '/map-view';
  static const String settings = '/settings';
  static const String support = '/support';
  static const String notifications = '/notifications';
  static const String forgotPassword = '/forgot-password';
  static const String otpVerification = '/otp-verification';
  static const String bookingDetails = '/booking-details';
  static const String editProfile = '/edit-profile';

  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case welcome:
        return MaterialPageRoute(builder: (_) => const WelcomeScreen());
      case login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case mainTabs:
        return MaterialPageRoute(builder: (_) => const MainTabScaffold());
      case AppRouter.settings:
        return MaterialPageRoute(builder: (_) => const SettingsScreen());
      case AppRouter.support:
        return MaterialPageRoute(builder: (_) => const SupportScreen());
      case notifications:
        return MaterialPageRoute(builder: (_) => const NotificationsScreen());
      case forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case otpVerification:
        final identifier = settings.arguments as String;
        return MaterialPageRoute(
          builder: (_) => BlocProvider(
            create: (context) => AuthBloc(authService: sl<AuthService>()),
            child: OtpVerificationScreen(identifier: identifier),
          ),
        );
      case search:
        final query = settings.arguments as String?;
        return MaterialPageRoute(builder: (_) => SearchScreen(initialQuery: query));
      case hotelDetails:
        final id = settings.arguments as String;
        return MaterialPageRoute(builder: (_) => HotelDetailsScreen(hotelId: id));
      case booking:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => BookingScreen(
            hotel: args['hotel'],
            room: args['room'],
          ),
        );
      case bookingDetails:
        final booking = settings.arguments as BookingModel;
        return MaterialPageRoute(builder: (_) => BookingDetailsScreen(booking: booking));
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case mapView:
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (_) => MapViewScreen(
            hotels: args['hotels'] as List<HotelModel>,
            initialPosition: args['initialPosition'] as LatLng?,
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(child: Text('No route defined for \${settings.name}')),
          ),
        );
    }
  }
}
