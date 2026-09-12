import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';

class ProfileSetupView extends StatefulWidget {
  const ProfileSetupView({super.key});

  @override
  State<ProfileSetupView> createState() => _ProfileSetupViewState();
}

class _ProfileSetupViewState extends State<ProfileSetupView> {
  final _nameController = TextEditingController(text: 'Ramesh Patil');
  final _phoneController = TextEditingController(text: '9876543210');
  final _locationController = TextEditingController(text: 'Nashik, Maharashtra');
  String _selectedCrop = 'Tomato';

  final List<String> _crops = ['Tomato', 'Rice', 'Wheat', 'Cotton', 'Chilli', 'Sugarcane'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Farmer Profile Setup'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Tell us about your farm',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 6),
              const Text(
                'This helps Kisan Sarthi customize advisories and weather forecasts for your specific crops and region.',
                style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 24),
              
              const Text('Full Name', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.person_outline, color: AppColors.primary),
                  hintText: 'Enter your name',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Mobile Number', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.phone_outlined, color: AppColors.primary),
                  hintText: 'Enter 10-digit mobile number',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Location (Village/District)', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 6),
              TextField(
                controller: _locationController,
                decoration: const InputDecoration(
                  prefixIcon: Icon(Icons.location_on_outlined, color: AppColors.primary),
                  hintText: 'e.g. Nashik, Maharashtra',
                ),
              ),
              const SizedBox(height: 16),

              const Text('Main Crop Cultivated', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: _crops.map((crop) {
                  final isSelected = _selectedCrop == crop;
                  return ChoiceChip(
                    label: Text(crop),
                    selected: isSelected,
                    selectedColor: AppColors.primaryContainer,
                    labelStyle: TextStyle(
                      color: isSelected ? AppColors.onPrimary : AppColors.onSurface,
                      fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                    ),
                    onSelected: (val) {
                      if (val) setState(() => _selectedCrop = crop);
                    },
                  );
                }).toList(),
              ),

              const SizedBox(height: 36),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushReplacementNamed(context, '/home');
                },
                child: const Text('Save & Continue to Dashboard'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
