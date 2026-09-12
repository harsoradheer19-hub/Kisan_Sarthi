import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/expert_provider.dart';

class ExpertFormView extends StatefulWidget {
  const ExpertFormView({super.key});

  @override
  State<ExpertFormView> createState() => _ExpertFormViewState();
}

class _ExpertFormViewState extends State<ExpertFormView> {
  final _descController = TextEditingController();
  final _cropController = TextEditingController(text: 'Tomato');
  final _locationController = TextEditingController(text: 'Nashik, Maharashtra');
  bool _isSubmitting = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Contact Agricultural Expert'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Submit Issue Details',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 6),
              const Text(
                'An agricultural specialist will analyze your problem and respond within 24 hours.',
                style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),

              const Text('Affected Crop', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: _cropController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.eco_outlined, color: AppColors.primary)),
              ),

              const SizedBox(height: 16),
              const Text('Location', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary)),
              ),

              const SizedBox(height: 16),
              const Text('Detailed Description of Problem', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: _descController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Describe leaf symptoms, insect appearance, spread rate, fertilizers used...',
                ),
              ),

              const SizedBox(height: 16),
              OutlinedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Photo picker ready')),
                  );
                },
                icon: const Icon(Icons.add_a_photo_outlined),
                label: const Text('Attach Plant Photo (Optional)'),
              ),

              const SizedBox(height: 36),
              _isSubmitting
                  ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
                  : ElevatedButton(
                      onPressed: () async {
                        if (_descController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter a description')),
                          );
                          return;
                        }

                        setState(() => _isSubmitting = true);
                        try {
                          final expertProv = context.read<ExpertProvider>();
                          await expertProv.submitRequest({
                            'farmer_name': 'Ramesh Patil',
                            'phone': '9876543210',
                            'location': _locationController.text,
                            'crop': _cropController.text,
                            'problem_category': 'Unresolved Guided Inquiry',
                            'description': _descController.text,
                          });

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Request submitted successfully!')),
                            );
                            Navigator.pushReplacementNamed(context, '/my-requests');
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Submission error: $e')),
                          );
                        } finally {
                          if (mounted) setState(() => _isSubmitting = false);
                        }
                      },
                      child: const Text('Submit Expert Request'),
                    ),
            ],
          ),
        ),
      ),
    );
  }
}
