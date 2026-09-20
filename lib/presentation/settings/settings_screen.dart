import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/constants/app_colors.dart';
import 'bloc/theme_bloc.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, state) {
          return ListView(
            children: [
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text('Language'),
                trailing: const Text('English'),
                onTap: () => _showSelectionDialog(context, 'Language', ['English', 'Hindi', 'French', 'Spanish']),
              ),
              ListTile(
                leading: const Icon(Icons.currency_exchange),
                title: const Text('Currency'),
                trailing: const Text('INR'),
                onTap: () => _showSelectionDialog(context, 'Currency', ['INR', 'USD', 'EUR', 'GBP']),
              ),
              SwitchListTile(
                secondary: const Icon(Icons.notifications_active),
                title: const Text('Push Notifications'),
                value: true,
                onChanged: (val) {
                  final status = val ? "Enabled" : "Disabled";
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Notifications $status')));
                },
                activeThumbColor: AppColors.primary,
              ),
              SwitchListTile(
                secondary: const Icon(Icons.dark_mode),
                title: const Text('Dark Mode'),
                value: state.themeMode == ThemeMode.dark,
                onChanged: (val) {
                  context.read<ThemeBloc>().add(ToggleTheme(val));
                },
                activeThumbColor: AppColors.primary,
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About Luxora Stay'),
                onTap: () {
                  showAboutDialog(
                    context: context,
                    applicationName: 'Luxora Stay',
                    applicationVersion: '1.0.0',
                    applicationLegalese: '© 2026 Luxora Hotels & Resorts',
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  void _showSelectionDialog(BuildContext context, String title, List<String> options) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Select \$title'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: options.map((opt) => ListTile(
            title: Text(opt),
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('\$title set to \$opt')));
              Navigator.pop(context);
            },
          )).toList(),
        ),
      ),
    );
  }
}
