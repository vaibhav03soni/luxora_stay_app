import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:luxora_stay_app/main.dart';
import 'package:luxora_stay_app/presentation/settings/bloc/theme_bloc.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    // We need to provide ThemeBloc as it's required by LuxoraStayApp
    await tester.pumpWidget(
      BlocProvider(
        create: (context) => ThemeBloc(),
        child: const LuxoraStayApp(initialRoute: '/'),
      ),
    );

    // Verify that the splash screen shows up (contains AppLogo/Hero)
    expect(find.byType(SplashScreen), findsOneWidget);
  });
}
