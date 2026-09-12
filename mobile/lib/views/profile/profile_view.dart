import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';

class ProfileView extends StatelessWidget {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final fullName = authProvider.fullName;
    final phone = authProvider.phone;
    final initials = fullName.isNotEmpty ? fullName.split(' ').map((e) => e[0]).take(2).join().toUpperCase() : 'KS';

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Farmer Profile'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              // Profile Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: AppColors.surfaceContainerHigh),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 32,
                      backgroundColor: AppColors.primaryContainer,
                      child: Text(initials, style: const TextStyle(color: AppColors.onPrimary, fontSize: 22, fontWeight: FontWeight.bold)),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(fullName, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.onSurface)),
                          const SizedBox(height: 2),
                          Text(phone, style: const TextStyle(fontSize: 13, color: AppColors.outline)),
                          const SizedBox(height: 2),
                          const Text('📍 Verified Farmer Profile', style: TextStyle(fontSize: 13, color: AppColors.primary, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Options Menu
              _buildMenuItem(
                icon: Icons.language,
                title: 'App Language',
                subtitle: 'Language Code: ${authProvider.language.toUpperCase()}',
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Selected Language: ${authProvider.language}')));
                },
              ),
              _buildMenuItem(
                icon: Icons.bookmark_outline,
                title: 'My Saved Advisories',
                subtitle: 'Saved agricultural solutions',
                onTap: () => Navigator.pushNamed(context, '/home'),
              ),
              _buildMenuItem(
                icon: Icons.contact_support_outlined,
                title: 'My Expert Requests',
                subtitle: 'Track status of submitted queries',
                onTap: () => Navigator.pushNamed(context, '/my-requests'),
              ),
              _buildMenuItem(
                icon: Icons.notifications_none,
                title: 'Weather & Spray Alerts',
                subtitle: 'Push notifications enabled',
                onTap: () {},
              ),
              _buildMenuItem(
                icon: Icons.info_outline,
                title: 'About Kisan Sarthi',
                subtitle: 'v2.1.0 • K. J. Somaiya Institute of Technology',
                onTap: () {},
              ),

              const SizedBox(height: 24),
              OutlinedButton.icon(
                onPressed: () async {
                  await authProvider.signOut();
                  if (context.mounted) {
                    Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                  }
                },
                icon: const Icon(Icons.logout, color: AppColors.error),
                label: const Text('Logout', style: TextStyle(color: AppColors.error)),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.errorContainer),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: AppColors.primary),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
        subtitle: Text(subtitle, style: const TextStyle(fontSize: 12, color: AppColors.outline)),
        trailing: const Icon(Icons.chevron_right, size: 18),
        onTap: onTap,
      ),
    );
  }
}
