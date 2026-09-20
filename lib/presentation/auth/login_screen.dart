import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../core/constants/app_colors.dart';
import '../../core/constants/app_strings.dart';
import '../widgets/app_logo.dart';
import 'bloc/auth_bloc.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/config/app_router.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(authService: sl<AuthService>()),
      child: Scaffold(
        body: BlocListener<AuthBloc, AuthState>(
          listener: (context, state) {
            if (state is Authenticated) {
              Navigator.pushNamedAndRemoveUntil(context, AppRouter.mainTabs, (route) => false);
            }
            if (state is AuthError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message)));
            }
          },
          child: Stack(
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
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Column(
                    children: [
                      const SizedBox(height: 40),
                      const AppLogo(size: 100),
                      const SizedBox(height: 48),
                      Text(
                        AppStrings.get(context, 'welcomeBack'),
                        style: GoogleFonts.playfairDisplay(fontSize: 32, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        AppStrings.get(context, 'loginToAccount'),
                        style: const TextStyle(color: Colors.white70),
                      ),
                      const SizedBox(height: 48),
                      _buildTextField(_emailController, AppStrings.get(context, 'email'), Icons.email_outlined),
                      const SizedBox(height: 16),
                      _buildTextField(
                        _passwordController,
                        AppStrings.get(context, 'password'),
                        Icons.lock_outline,
                        obscure: _obscurePassword,
                        suffix: IconButton(
                          icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                          onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                        ),
                      ),
                      const SizedBox(height: 12),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => Navigator.pushNamed(context, AppRouter.forgotPassword),
                          child: Text(AppStrings.get(context, 'forgotPassword'), style: const TextStyle(color: AppColors.secondary)),
                        ),
                      ),
                      const SizedBox(height: 32),
                      BlocBuilder<AuthBloc, AuthState>(
                        builder: (context, state) {
                          if (state is AuthLoading) return const CircularProgressIndicator(color: AppColors.secondary);
                          return ElevatedButton(
                            onPressed: () {
                              context.read<AuthBloc>().add(LoginRequested(_emailController.text, _passwordController.text));
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.secondary,
                              foregroundColor: AppColors.primary,
                              minimumSize: const Size(double.infinity, 56),
                            ),
                            child: Text(AppStrings.get(context, 'login')),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text("Don't have an account?", style: TextStyle(color: Colors.white)),
                          TextButton(
                            onPressed: () => Navigator.pushNamed(context, AppRouter.register),
                            child: Text(AppStrings.get(context, 'register'), style: const TextStyle(color: AppColors.secondary, fontWeight: FontWeight.bold)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text(AppStrings.get(context, 'continueGuest'), style: const TextStyle(color: Colors.white70)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false, Widget? suffix}) {
    return TextField(
      controller: controller,
      obscureText: obscure,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(icon, color: AppColors.secondary),
        suffixIcon: suffix,
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.1),
        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.2))),
        focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: AppColors.secondary)),
      ),
    );
  }
}
