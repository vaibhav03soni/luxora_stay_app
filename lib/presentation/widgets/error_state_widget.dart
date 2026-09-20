import 'package:flutter/material.dart';

class ErrorStateWidget extends StatelessWidget {
  final String title;
  final String message;
  final IconData icon;
  final VoidCallback? onRetry;

  const ErrorStateWidget({
    super.key,
    this.title = 'Oops! Something went wrong',
    this.message = 'We encountered an error while loading the data. Please try again.',
    this.icon = Icons.error_outline,
    this.onRetry,
  });

  factory ErrorStateWidget.noInternet({VoidCallback? onRetry}) {
    return ErrorStateWidget(
      title: 'No Internet Connection',
      message: 'Please check your connection and try again.',
      icon: Icons.wifi_off,
      onRetry: onRetry,
    );
  }

  factory ErrorStateWidget.empty({String? title, String? message, VoidCallback? onRetry}) {
    return ErrorStateWidget(
      title: title ?? 'No results found',
      message: message ?? 'Try searching for something else.',
      icon: Icons.search_off,
      onRetry: onRetry,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 80, color: Colors.grey[300]),
            const SizedBox(height: 24),
            Text(title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message, style: const TextStyle(color: Colors.grey), textAlign: TextAlign.center),
            if (onRetry != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(160, 48),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                ),
                child: const Text('Try Again'),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
