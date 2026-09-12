import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';
import '../../providers/advisory_provider.dart';

class SelectCategoryView extends StatefulWidget {
  const SelectCategoryView({super.key});

  @override
  State<SelectCategoryView> createState() => _SelectCategoryViewState();
}

class _SelectCategoryViewState extends State<SelectCategoryView> {
  List<dynamic> _categories = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCategories();
  }

  Future<void> _loadCategories() async {
    try {
      final cats = await ApiService.fetchCategories();
      setState(() {
        _categories = cats;
        _isLoading = false;
      });
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Select Problem Category'),
      ),
      body: SafeArea(
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
            : SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'What area is affected?',
                      style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select the primary issue category to begin your guided step-by-step advisory questions.',
                      style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 20),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: _categories.length,
                      itemBuilder: (context, index) {
                        final cat = _categories[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: ListTile(
                            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                            leading: Container(
                              padding: const EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: AppColors.secondaryContainer,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Icon(_getCategoryIcon(cat['icon_name']), color: AppColors.primary, size: 24),
                            ),
                            title: Text(
                              cat['name_en'],
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            subtitle: Text(
                              cat['description'] ?? '',
                              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: AppColors.outline),
                            onTap: () async {
                              final prov = context.read<AdvisoryProvider>();
                              prov.selectCategory(cat['id'], cat['name_en']);
                              
                              // Fetch dynamic questions for category
                              final questions = await ApiService.fetchQuestions(cat['id']);
                              prov.setQuestions(questions);

                              if (mounted) {
                                Navigator.pushNamed(context, '/guided-questions');
                              }
                            },
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  IconData _getCategoryIcon(String? iconName) {
    switch (iconName) {
      case 'bug_report':
        return Icons.bug_report;
      case 'energy_savings_leaf':
        return Icons.energy_savings_leaf;
      case 'water_drop':
        return Icons.water_drop;
      case 'potted_plant':
        return Icons.potted_plant;
      case 'coronavirus':
        return Icons.coronavirus;
      default:
        return Icons.help_outline;
    }
  }
}
