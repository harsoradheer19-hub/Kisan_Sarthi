import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/services/api_service.dart';

class CropRecommendationView extends StatefulWidget {
  const CropRecommendationView({super.key});

  @override
  State<CropRecommendationView> createState() => _CropRecommendationViewState();
}

class _CropRecommendationViewState extends State<CropRecommendationView> {
  String _selectedSoil = 'Black Soil';
  String _selectedWater = 'Medium';
  String _selectedSeason = 'Kharif';
  bool _isLoading = false;
  List<dynamic>? _recommendations;

  final List<String> _soilTypes = ['Black Soil', 'Alluvial Soil', 'Red Soil', 'Clay Soil', 'Sandy Soil'];

  Future<void> _getRecommendations() async {
    setState(() => _isLoading = true);
    try {
      final res = await ApiService.fetchCropRecommendation(
        soilType: _selectedSoil,
        location: 'Nashik, Maharashtra',
        waterAvailability: _selectedWater,
        season: _selectedSeason,
      );
      setState(() {
        _recommendations = res['recommended_crops'];
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Crop Recommendation'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Find Suitable Crops',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 6),
              const Text(
                'Select your land parameters to receive agronomy-verified crop suggestions.',
                style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 20),

              const Text('Soil Type', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: _selectedSoil,
                items: _soilTypes.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                onChanged: (val) => setState(() => _selectedSoil = val!),
              ),

              const SizedBox(height: 16),
              const Text('Season', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
              const SizedBox(height: 6),
              Row(
                children: ['Kharif', 'Rabi', 'Zaid'].map((s) {
                  final isSelected = _selectedSeason == s;
                  return Expanded(
                    child: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: ChoiceChip(
                        label: Center(child: Text(s)),
                        selected: isSelected,
                        selectedColor: AppColors.primaryContainer,
                        labelStyle: TextStyle(color: isSelected ? AppColors.onPrimary : AppColors.onSurface),
                        onSelected: (val) => setState(() => _selectedSeason = s),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 24),
              ElevatedButton(
                onPressed: _isLoading ? null : _getRecommendations,
                child: _isLoading
                    ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : const Text('Get Crop Recommendations'),
              ),

              if (_recommendations != null) ...[
                const SizedBox(height: 32),
                const Text(
                  'Recommended Crops',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                ),
                const SizedBox(height: 12),
                ..._recommendations!.map((item) {
                  return Card(
                    margin: const EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(item['crop_name'], style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary)),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(color: AppColors.secondaryContainer, borderRadius: BorderRadius.circular(12)),
                                child: Text('Score: ${item['suitability_score']}%', style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.primary, fontSize: 12)),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text('Yield: ${item['expected_yield']}', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600)),
                          Text('Water: ${item['water_requirement']}', style: const TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant)),
                          const SizedBox(height: 8),
                          Text(item['growing_tips'], style: const TextStyle(fontSize: 12, color: AppColors.outline)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ]
            ],
          ),
        ),
      ),
    );
  }
}
