import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ExpertEscalationView extends StatelessWidget {
  const ExpertEscalationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Expert Escalation'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withOpacity(0.5),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.support_agent, size: 64, color: AppColors.primary),
              ),
              const SizedBox(height: 24),
              const Text(
                'No Automated Advisory Found',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              const Text(
                'Your specific symptom combination requires custom review. Connect directly with certified government agronomists and crop specialists.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant, height: 1.4),
              ),
              const SizedBox(height: 36),
              ElevatedButton.icon(
                onPressed: () {
                  Navigator.pushNamed(context, '/expert-form');
                },
                icon: const Icon(Icons.send_outlined),
                label: const Text('Submit Request to Expert'),
              ),
              const SizedBox(height: 12),
              OutlinedButton(
                onPressed: () => Navigator.pushReplacementNamed(context, '/home'),
                child: const Text('Return to Home Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
