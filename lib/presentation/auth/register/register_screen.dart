import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../../../core/constants/app_colors.dart';
import '../../widgets/app_logo.dart';
import 'package:google_fonts/google_fonts.dart';
import '../bloc/auth_bloc.dart';
import '../../../core/config/dependency_injection.dart';
import '../../../core/services/auth_service.dart';
import '../../../core/config/app_router.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _acceptTerms = false;

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
            if (state is OtpSent) {
              Navigator.pushNamed(context, AppRouter.otpVerification, arguments: state.identifier);
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
                    image: CachedNetworkImageProvider("https://images.unsplash.com/photo-1542314831-068cd1dbfeeb?q=80&w=1200"),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Container(color: Colors.black.withValues(alpha: 0.7)),
              SafeArea(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(32),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: [
                        const AppLogo(size: 80),
                        const SizedBox(height: 32),
                        Text(
                          "Create Account",
                          style: GoogleFonts.playfairDisplay(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        const SizedBox(height: 32),
                        _buildTextField(_nameController, "Full Name", Icons.person_outline),
                        const SizedBox(height: 16),
                        _buildTextField(_emailController, "Email Address", Icons.email_outlined, keyboardType: TextInputType.emailAddress),
                        const SizedBox(height: 16),
                        _buildTextField(_phoneController, "Phone Number", Icons.phone_android_outlined, keyboardType: TextInputType.phone),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _passwordController,
                          "Password",
                          Icons.lock_outline,
                          obscure: _obscurePassword,
                          suffix: IconButton(
                            icon: Icon(_obscurePassword ? Icons.visibility_off : Icons.visibility, color: Colors.white70),
                            onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
                          ),
                        ),
                        const SizedBox(height: 16),
                        _buildTextField(
                          _confirmPasswordController,
                          "Confirm Password",
                          Icons.lock_reset_outlined,
                          obscure: _obscurePassword,
                          validator: (v) => v != _passwordController.text ? "Passwords do not match" : null,
                        ),
                        const SizedBox(height: 20),
                        Row(
                          children: [
                            Checkbox(
                              value: _acceptTerms,
                              onChanged: (v) => setState(() => _acceptTerms = v!),
                              fillColor: WidgetStateProperty.all(AppColors.secondary),
                            ),
                            const Expanded(
                              child: Text(
                                "I accept the Terms and Conditions",
                                style: TextStyle(color: Colors.white70, fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 32),
                        BlocBuilder<AuthBloc, AuthState>(
                          builder: (context, state) {
                            if (state is AuthLoading) return const CircularProgressIndicator(color: AppColors.secondary);
                            return ElevatedButton(
                              onPressed: () {
                                if (_formKey.currentState!.validate() && _acceptTerms) {
                                  context.read<AuthBloc>().add(RegisterRequested(
                                        _emailController.text,
                                        _passwordController.text,
                                        _nameController.text,
                                      ));
                                } else if (!_acceptTerms) {
                                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Please accept Terms and Conditions")));
                                }
                              },
                              style: ElevatedButton.styleFrom(backgroundColor: AppColors.secondary, foregroundColor: AppColors.primary),
                              child: const Text("Register"),
                            );
                          },
                        ),
                        const SizedBox(height: 24),
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text("Already have an account? Login", style: TextStyle(color: Colors.white70)),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Positioned(top: 40, left: 10, child: const BackButton(color: Colors.white)),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool obscure = false, Widget? suffix, String? Function(String?)? validator, TextInputType? keyboardType}) {
    return TextFormField(
      controller: controller,
      obscureText: obscure,
      keyboardType: keyboardType,
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
        errorStyle: const TextStyle(color: Colors.orangeAccent),
      ),
      validator: validator ?? (v) => v!.isEmpty ? "Required" : null,
    );
  }
}
