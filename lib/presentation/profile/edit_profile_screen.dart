import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/image_service/image_service.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/services/auth_service.dart';
import 'package:google_fonts/google_fonts.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    final user = sl<AuthService>().currentUser;
    if (user != null) {
      _nameController.text = user.displayName ?? '';
      _emailController.text = user.email ?? '';
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = sl<AuthService>().currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile', style: GoogleFonts.playfairDisplay(fontWeight: FontWeight.bold)),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Stack(
              children: [
                ImageService.profile(
                  imageUrl: user?.photoURL ?? "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=400",
                  size: 120,
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: CircleAvatar(
                    backgroundColor: AppColors.secondary,
                    radius: 18,
                    child: IconButton(
                      icon: const Icon(Icons.camera_alt, size: 18, color: Colors.white),
                      onPressed: () {},
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            _buildTextField(_nameController, "Full Name", Icons.person_outline),
            const SizedBox(height: 20),
            _buildTextField(_emailController, "Email Address", Icons.email_outlined, enabled: false),
            const SizedBox(height: 20),
            _buildTextField(_phoneController, "Phone Number", Icons.phone_android_outlined),
            const SizedBox(height: 48),
            if (_isLoading)
              const CircularProgressIndicator()
            else
              ElevatedButton(
                onPressed: _saveProfile,
                style: ElevatedButton.styleFrom(minimumSize: const Size(double.infinity, 56)),
                child: const Text('Save Changes'),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String label, IconData icon, {bool enabled = true}) {
    return TextField(
      controller: controller,
      enabled: enabled,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: AppColors.primary),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: !enabled,
        fillColor: enabled ? null : Colors.grey[100],
      ),
    );
  }

  Future<void> _saveProfile() async {
    setState(() => _isLoading = true);
    try {
      await sl<AuthService>().updateProfile(name: _nameController.text);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully!')));
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Update failed: \$e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
}
