import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../providers/advisory_provider.dart';
import '../widgets/kisan_sarthi_video_loader.dart';

class SummaryReviewView extends StatefulWidget {
  const SummaryReviewView({super.key});

  @override
  State<SummaryReviewView> createState() => _SummaryReviewViewState();
}

class _SummaryReviewViewState extends State<SummaryReviewView> {
  bool _isEvaluating = false;

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdvisoryProvider>();
    final answers = prov.userAnswers;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Summary Review'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Review your inputs',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 6),
              const Text(
                'Please verify the collected parameters before evaluating with our agricultural advisory engine.',
                style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),

              // Category Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.category, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      prov.selectedCategoryName ?? 'General Advisory',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 13),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),

              // Parameter Cards List
              ...answers.entries.map((e) {
                return Card(
                  margin: const EdgeInsets.only(bottom: 12),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              e.key.toUpperCase(),
                              style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.outline),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              e.value,
                              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.onSurface),
                            ),
                          ],
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, color: AppColors.primary, size: 20),
                          onPressed: () => Navigator.pop(context),
                        )
                      ],
                    ),
                  ),
                );
              }).toList(),

              const SizedBox(height: 36),
              _isEvaluating
                  ? const KisanSarthiVideoLoader(
                      title: 'Evaluating Parameters...',
                      subtitle: 'Evaluating parameters with Kisan Sarthi Advisory Engine...',
                    )
                  : ElevatedButton(
                      onPressed: () async {
                        setState(() => _isEvaluating = true);
                        try {
                          // Start API request and 5-second minimum loading timer simultaneously
                          final apiFuture = ApiService.evaluateAdvisory(
                            categoryId: prov.selectedCategoryId ?? 'pest_problem',
                            answers: prov.userAnswers,
                            location: 'Nashik, Maharashtra',
                          );
                          final minTimerFuture = Future.delayed(const Duration(seconds: 5));

                          final results = await Future.wait([
                            apiFuture,
                            minTimerFuture,
                          ]);

                          final result = results[0] as Map<String, dynamic>;
                          prov.setResult(result);

                          if (mounted) {
                            if (result['match_found'] == true) {
                              Navigator.pushReplacementNamed(context, '/advisory-result');
                            } else {
                              Navigator.pushReplacementNamed(context, '/expert-escalation');
                            }
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Evaluation error: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _isEvaluating = false);
                        }
                      },
                      child: const Text('Generate Advisory'),
                    ),

            ],
          ),
        ),
      ),
    );
  }
}
