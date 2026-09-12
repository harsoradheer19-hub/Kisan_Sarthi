import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/admin_provider.dart';

class AdminProfileView extends StatelessWidget {
  const AdminProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    final adminProv = context.watch<AdminProvider>();
    final profile = adminProv.adminProfile;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Agronomist Admin Profile'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 20),
              CircleAvatar(
                radius: 44,
                backgroundColor: AppColors.primaryContainer,
                child: const Icon(Icons.verified_user, size: 52, color: AppColors.primary),
              ),
              const SizedBox(height: 16),
              Text(
                profile?['full_name'] ?? 'Dr. V. K. Sharma (Senior Agronomist)',
                style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
              const SizedBox(height: 4),
              Text(
                profile?['email'] ?? 'admin@kisansarthi.org',
                style: const TextStyle(fontSize: 14, color: AppColors.outline),
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(color: Colors.green.shade100, borderRadius: BorderRadius.circular(12)),
                child: const Text('Role: Certified Agronomist Admin', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold, fontSize: 12)),
              ),
              const SizedBox(height: 32),

              Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: const Column(
                  children: [
                    ListTile(
                      leading: Icon(Icons.security, color: AppColors.primary),
                      title: Text('Security & Access Level'),
                      subtitle: Text('Authenticated via Supabase Auth (Role: admin)'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.local_hospital, color: AppColors.primary),
                      title: Text('Specialization'),
                      subtitle: Text('Crop Pathology, Pest Management & Climate Resilience'),
                    ),
                    Divider(height: 1),
                    ListTile(
                      leading: Icon(Icons.location_on, color: AppColors.primary),
                      title: Text('Assigned Region'),
                      subtitle: Text('Maharashtra & Western India Zone'),
                    ),
                  ],
                ),
              ),

              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  icon: const Icon(Icons.logout),
                  label: const Text('Sign Out Admin Portal'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red.shade700,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  ),
                  onPressed: () async {
                    await adminProv.logout();
                    if (context.mounted) {
                      Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
