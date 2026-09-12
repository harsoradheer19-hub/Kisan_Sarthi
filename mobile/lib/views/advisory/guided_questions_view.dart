import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/advisory_provider.dart';

class GuidedQuestionsView extends StatelessWidget {
  const GuidedQuestionsView({super.key});

  @override
  Widget build(BuildContext context) {
    final prov = context.watch<AdvisoryProvider>();
    final questions = prov.questions;
    final currentStep = prov.currentStep;

    if (questions.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Guided Advisory')),
        body: const Center(child: CircularProgressIndicator(color: AppColors.primary)),
      );
    }

    final q = questions[currentStep];
    final totalSteps = questions.length;
    final paramKey = q['param_key'];
    final selectedOption = prov.userAnswers[paramKey];

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: Text(prov.selectedCategoryName ?? 'Guided Advisory'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (currentStep > 0) {
              prov.previousStep();
            } else {
              Navigator.pop(context);
            }
          },
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress Header
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 12.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Step ${currentStep + 1} of $totalSteps',
                        style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary),
                      ),
                      Text(
                        '${((currentStep + 1) / totalSteps * 100).toInt()}% Completed',
                        style: const TextStyle(fontSize: 12, color: AppColors.outline),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: (currentStep + 1) / totalSteps,
                      backgroundColor: AppColors.surfaceContainerHigh,
                      color: AppColors.primary,
                      minHeight: 6,
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      q['question_text_en'] ?? '',
                      style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                    if (q['subtitle_en'] != null) ...[
                      const SizedBox(height: 6),
                      Text(
                        q['subtitle_en'],
                        style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
                      ),
                    ],
                    const SizedBox(height: 24),

                    // Options List
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: (q['options'] as List).length,
                      itemBuilder: (context, idx) {
                        final opt = q['options'][idx];
                        final optVal = opt['option_value'];
                        final isSelected = selectedOption == optVal;

                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: InkWell(
                            onTap: () {
                              prov.answerQuestion(paramKey, optVal);
                            },
                            borderRadius: BorderRadius.circular(16),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isSelected ? AppColors.primaryContainer.withOpacity(0.15) : AppColors.surfaceContainerLowest,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected ? AppColors.primary : AppColors.surfaceContainerHigh,
                                  width: isSelected ? 2 : 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(10),
                                    decoration: BoxDecoration(
                                      color: isSelected ? AppColors.primary : AppColors.secondaryContainer,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Icon(
                                      _getOptionIcon(opt['icon_name']),
                                      color: isSelected ? AppColors.onPrimary : AppColors.primary,
                                      size: 20,
                                    ),
                                  ),
                                  const SizedBox(width: 14),
                                  Expanded(
                                    child: Text(
                                      opt['label_en'] ?? optVal,
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                                        color: isSelected ? AppColors.primary : AppColors.onSurface,
                                      ),
                                    ),
                                  ),
                                  if (isSelected)
                                    const Icon(Icons.check_circle, color: AppColors.primary, size: 24),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),

            // Footer Action Button
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: ElevatedButton(
                onPressed: prov.canProceed()
                    ? () {
                        if (currentStep < totalSteps - 1) {
                          prov.nextStep();
                        } else {
                          Navigator.pushNamed(context, '/summary-review');
                        }
                      }
                    : null,
                child: Text(currentStep == totalSteps - 1 ? 'Review Summary' : 'Next Question'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  IconData _getOptionIcon(String? name) {
    switch (name) {
      case 'nutrition':
        return Icons.eco;
      case 'grass':
        return Icons.grass;
      case 'grain':
        return Icons.grain;
      case 'dry_cleaning':
        return Icons.dry_cleaning;
      case 'bug_report':
        return Icons.bug_report;
      case 'pest_control':
        return Icons.pest_control;
      case 'schedule':
        return Icons.schedule;
      case 'date_range':
        return Icons.date_range;
      case 'history':
        return Icons.history;
      default:
        return Icons.spa;
    }
  }
}
