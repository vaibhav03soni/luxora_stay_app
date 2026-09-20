import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/services/image_service/image_service.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/config/dependency_injection.dart';
import '../../core/services/auth_service.dart';
import '../../core/constants/app_strings.dart';
import '../../core/config/app_router.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = sl<AuthService>();

    return StreamBuilder(
      stream: authService.user,
      builder: (context, snapshot) {
        final user = authService.currentUser;
        return Scaffold(
          body: CustomScrollView(
            slivers: [
              _buildHeader(context, user),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _buildProfileMenu(context, Icons.person_outline, 'My Profile', () {
                        if (user != null) {
                          _showEditProfileDialog(context, user);
                        } else {
                          Navigator.pushNamed(context, AppRouter.login);
                        }
                      }),
                      _buildProfileMenu(context, Icons.business_center_outlined, 'My Trips', () {
                        // User can navigate via Tab Bar for best experience,
                        // but we can also trigger a tab switch if we had a controller.
                        // For now, let's just show a message or do nothing if it's redundant.
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please use the "Trips" tab below')));
                      }),
                      _buildProfileMenu(context, Icons.favorite_outline, 'Wishlist', () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Please use the "Wishlist" tab below')));
                      }),
                      _buildProfileMenu(context, Icons.payment_outlined, 'Payments', () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Payment methods coming soon!')));
                      }),
                      const Divider(height: 40),
                      _buildProfileMenu(context, Icons.notifications_none_outlined, 'Notifications', () => Navigator.pushNamed(context, AppRouter.notifications)),
                      _buildProfileMenu(context, Icons.settings_outlined, 'Settings', () => Navigator.pushNamed(context, AppRouter.settings)),
                      _buildProfileMenu(context, Icons.help_outline, 'Support', () => Navigator.pushNamed(context, AppRouter.support)),
                      const Divider(height: 40),
                      _buildProfileMenu(context, Icons.logout, AppStrings.get(context, 'logout'), () {
                        _showLogoutDialog(context);
                      }, isLogout: true),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(AppStrings.get(context, 'logout')),
        content: Text(AppStrings.get(context, 'confirmLogout')),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(AppStrings.get(context, 'cancel'))),
          TextButton(
            onPressed: () async {
              await sl<AuthService>().logout();
              if (context.mounted) {
                Navigator.pop(context); // Close dialog
                Navigator.pushNamedAndRemoveUntil(context, AppRouter.welcome, (route) => false);
              }
            },
            child: Text(AppStrings.get(context, 'logout'), style: const TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditProfileDialog(BuildContext context, dynamic user) {
    final nameController = TextEditingController(text: user.displayName);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Full Name'),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancel')),
          TextButton(
            onPressed: () async {
              await sl<AuthService>().updateProfile(name: nameController.text);
              if (context.mounted) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Profile updated successfully')));
              }
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic user) {
    return SliverAppBar(
      expandedHeight: 280,
      pinned: true,
      backgroundColor: AppColors.primary,
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [AppColors.primary, AppColors.primaryLight],
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 40),
              ImageService.profile(
                imageUrl: user?.photoURL ?? "https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?q=80&w=400",
                size: 100,
              ),
              const SizedBox(height: 16),
              Text(
                user?.displayName ?? "Guest User",
                style: GoogleFonts.playfairDisplay(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
              ),
              Text(
                user?.email ?? "Welcome to Luxora Stay",
                style: const TextStyle(color: Colors.white70),
              ),
              const SizedBox(height: 12),
              if (user != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(color: AppColors.secondary, borderRadius: BorderRadius.circular(20)),
                  child: const Text("GOLD MEMBER", style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileMenu(BuildContext context, IconData icon, String title, VoidCallback onTap, {bool isLogout = false}) {
    return ListTile(
      onTap: onTap,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(color: isLogout ? Colors.red.withValues(alpha: 0.1) : AppColors.primary.withValues(alpha: 0.05), borderRadius: BorderRadius.circular(8)),
        child: Icon(icon, color: isLogout ? Colors.red : AppColors.primary, size: 20),
      ),
      title: Text(title, style: TextStyle(fontWeight: FontWeight.w600, color: isLogout ? Colors.red : AppColors.textPrimary)),
      trailing: const Icon(Icons.chevron_right, size: 18),
    );
  }
}
