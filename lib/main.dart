import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'core/services/app_bootstrap_service.dart';
import 'core/theme/app_theme.dart';
import 'core/config/app_router.dart';
import 'presentation/widgets/app_logo.dart';
import 'presentation/settings/bloc/theme_bloc.dart';

import 'package:flutter_localizations/flutter_localizations.dart';
import 'presentation/widgets/error_boundary.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize App via Bootstrap Service
  final initialRoute = await AppBootstrapService.init();

  runApp(
    GlobalErrorBoundary(
      child: BlocProvider(
        create: (context) => ThemeBloc()..add(LoadTheme()),
        child: LuxoraStayApp(initialRoute: initialRoute),
      ),
    ),
  );
}

class LuxoraStayApp extends StatelessWidget {
  final String initialRoute;
  const LuxoraStayApp({super.key, required this.initialRoute});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ThemeBloc, ThemeState>(
      builder: (context, state) {
        return MaterialApp(
          title: 'Luxora Stay',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: state.themeMode,
          onGenerateRoute: AppRouter.generateRoute,
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: const [
            Locale('en', ''),
            Locale('hi', ''),
          ],
          home: SplashScreen(initialRoute: initialRoute),
        );
      },
    );
  }
}

class SplashScreen extends StatefulWidget {
  final String initialRoute;
  const SplashScreen({super.key, required this.initialRoute});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToNext();
  }

  Future<void> _navigateToNext() async {
    await Future.delayed(const Duration(seconds: 3));
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(widget.initialRoute);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black, // Dark premium splash
      body: Center(
        child: Hero(
          tag: 'logo',
          child: AppLogo(size: 150),
        ),
      ),
    );
  }
}
