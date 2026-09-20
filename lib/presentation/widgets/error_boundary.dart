import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

import 'package:google_fonts/google_fonts.dart';

class GlobalErrorBoundary extends StatelessWidget {
  final Widget child;

  const GlobalErrorBoundary({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    ErrorWidget.builder = (FlutterErrorDetails details) {
      return Material(
        child: Container(
          color: Colors.white,
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.warning_amber_rounded, size: 80, color: AppColors.secondary),
              const SizedBox(height: 32),
              Text(
                'Unexpected Error',
                style: GoogleFonts.playfairDisplay(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              const Text(
                'We apologize for the inconvenience. Our team has been notified of this issue.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey, height: 1.5),
              ),
              const SizedBox(height: 48),
              ElevatedButton(
                onPressed: () {
                  // Attempt to go back or reset
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(200, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text('Return to Safety'),
              ),
            ],
          ),
        ),
      );
    };
    return child;
  }
}
