import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/advisory_provider.dart';

class AdvisoryResultView extends StatelessWidget {
  const AdvisoryResultView({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdvisoryProvider>();
    final result = prov.advisoryResult;

    if (result == null) {
      return Scaffold(
        appBar: AppBar(title: const Text('Advisory Result')),
        body: const Center(child: Text('No advisory result available')),
      );
    }

    final actions = result['recommended_actions'] as List? ?? [];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Advisory Recommendation'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bookmark_border),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Advisory saved to My Advisories')),
              );
            },
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Badge & Severity
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: AppColors.onPrimaryContainer.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified, size: 16, color: AppColors.primary),
                        SizedBox(width: 6),
                        Text('Rule Engine Matched', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 12)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.errorContainer,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      'Severity: ${result['severity'] ?? 'Medium'}',
                      style: const TextStyle(color: AppColors.error, fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // Identified Problem Name
              Text(
                result['problem_identified'] ?? 'Problem Identified',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 16),

              // Possible Cause Card
              _buildSectionCard(
                title: 'Possible Cause',
                icon: Icons.lightbulb_outline,
                content: result['possible_cause'] ?? '',
                bgColor: AppColors.surfaceContainerLowest,
              ),

              const SizedBox(height: 16),

              // Recommended Actions
              const Text(
                'Recommended Action Plan',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 8),
              ...actions.asMap().entries.map((entry) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 8),
                  child: Padding(
                    padding: const EdgeInsets.all(14.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CircleAvatar(
                          radius: 12,
                          backgroundColor: AppColors.primaryContainer,
                          child: Text(
                            '${entry.key + 1}',
                            style: const TextStyle(color: AppColors.onPrimary, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            entry.value.toString(),
                            style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.onSurface),
                          ),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 16),

              // Precautions
              _buildSectionCard(
                title: 'Safety & Precautions',
                icon: Icons.shield_outlined,
                content: result['precautions'] ?? '',
                bgColor: AppColors.secondaryContainer.withOpacity(0.4),
              ),

              const SizedBox(height: 16),

              // Weather Consideration
              if (result['weather_consideration'] != null)
                _buildSectionCard(
                  title: 'Weather Context & Spray Window',
                  icon: Icons.cloud_queue,
                  content: result['weather_consideration'],
                  bgColor: AppColors.onTertiaryContainer.withOpacity(0.5),
                ),

              const SizedBox(height: 32),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Navigator.pushNamed(context, '/expert-escalation'),
                      child: const Text('Not Helpful? Ask Expert'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false),
                      child: const Text('Done'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionCard({
    required String title,
    required IconData icon,
    required String content,
    required Color bgColor,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.surfaceContainerHigh),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 20, color: AppColors.primary),
              const SizedBox(width: 8),
              Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.onSurface)),
            ],
          ),
          const SizedBox(height: 8),
          Text(content, style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.onSurfaceVariant)),
        ],
      ),
    );
  }
}
