import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/climate_provider.dart';
import '../../providers/auth_provider.dart';

class ClimateAdvisoryView extends StatefulWidget {
  const ClimateAdvisoryView({super.key});

  @override
  State<ClimateAdvisoryView> createState() => _ClimateAdvisoryViewState();
}

class _ClimateAdvisoryViewState extends State<ClimateAdvisoryView> {
  String _selectedCrop = "Tomato";
  String _selectedStage = "Vegetative";
  String _selectedWhatIf = "below_normal_rain";

  final List<String> _crops = [
    "Rice", "Wheat", "Maize", "Bajra", "Jowar", "Chickpea", "Pigeon Pea", "Moong", "Urad", "Soybean",
    "Groundnut", "Mustard", "Sunflower", "Cotton", "Sugarcane", "Tomato", "Potato", "Onion", "Brinjal", "Chilli",
    "Okra", "Banana", "Mango", "Grapes", "Pomegranate"
  ];

  final List<String> _stages = [
    "Sowing / Germination", "Vegetative", "Flowering / Blossoming", "Pod / Fruit Formation", "Harvesting / Maturity"
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProv = context.read<AuthProvider>();
      final mainCrop = authProv.userProfile?['main_crop'] ?? 'Tomato';
      if (_crops.contains(mainCrop)) {
        setState(() => _selectedCrop = mainCrop);
      }
      final climateProv = context.read<ClimateProvider>();
      climateProv.fetchClimateStatus();
      climateProv.evaluateCropImpact(
        crop: _selectedCrop,
        growthStage: _selectedStage,
        location: authProv.userProfile?['location_name'] ?? 'Nashik, Maharashtra',
      );
      climateProv.fetchWhatIfScenarios(crop: _selectedCrop);
    });
  }

  @override
  Widget build(BuildContext context) {
    final climateProv = context.watch<ClimateProvider>();
    final authProv = context.watch<AuthProvider>();
    final location = authProv.userProfile?['location_name'] ?? 'Nashik, Maharashtra';
    final enso = climateProv.ensoStatus;
    final impact = climateProv.cropImpactData;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Climate & El Niño Risk'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ENSO Diagnostic Header Banner
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            const Text('🌊', style: TextStyle(fontSize: 26)),
                            const SizedBox(width: 8),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  'CLIMATE SIGNAL',
                                  style: TextStyle(color: Colors.white70, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                                ),
                                Text(
                                  enso?['enso_phase'] ?? 'El Niño',
                                  style: const TextStyle(color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFEDD5),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Text(
                            '${enso?['risk_level'] ?? 'Moderate'} Risk',
                            style: const TextStyle(color: Color(0xFFC2410C), fontWeight: FontWeight.bold, fontSize: 12),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      enso?['summary'] ?? 'Current climate conditions indicate an active El Niño signal.',
                      style: const TextStyle(color: Colors.white, fontSize: 13, height: 1.4),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Source: ${enso?['source'] ?? 'NOAA Climate Prediction Center'}',
                      style: const TextStyle(color: Colors.white60, fontSize: 10, fontStyle: FontStyle.italic),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'How will this affect my crop?',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 4),
              const Text(
                'Select crop & stage for customized risk analysis:',
                style: TextStyle(fontSize: 13, color: AppColors.outline),
              ),

              const SizedBox(height: 12),
              // Selectors Card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceContainerHigh),
                ),
                child: Column(
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedCrop,
                      decoration: const InputDecoration(labelText: 'Select Crop', border: OutlineInputBorder()),
                      items: _crops.map((c) => DropdownMenuItem(value: c, child: Text(c))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedCrop = val);
                      },
                    ),
                    const SizedBox(height: 12),
                    DropdownButtonFormField<String>(
                      value: _selectedStage,
                      decoration: const InputDecoration(labelText: 'Growth Stage', border: OutlineInputBorder()),
                      items: _stages.map((s) => DropdownMenuItem(value: s, child: Text(s))).toList(),
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedStage = val);
                      },
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.analytics),
                        label: const Text('Analyze Crop Climate Impact'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          foregroundColor: AppColors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                        onPressed: () {
                          climateProv.evaluateCropImpact(
                            crop: _selectedCrop,
                            growthStage: _selectedStage,
                            location: location,
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Crop Impact Result Card
              if (climateProv.isLoading)
                const Center(child: Padding(padding: EdgeInsets.all(20), child: CircularProgressIndicator()))
              else if (impact != null)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.primary.withOpacity(0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${impact['crop_evaluated']} (${impact['growth_stage_evaluated']})',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: impact['overall_risk_level'] == 'HIGH' ? const Color(0xFFFEE2E2) : const Color(0xFFFFEDD5),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '${impact['overall_risk_level']} RISK',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: impact['overall_risk_level'] == 'HIGH' ? const Color(0xFFDC2626) : const Color(0xFFC2410C),
                              ),
                            ),
                          )
                        ],
                      ),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: AppColors.surface,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          impact['summary_advisory'] ?? '',
                          style: const TextStyle(fontSize: 13, height: 1.4, color: AppColors.onSurface),
                        ),
                      ),
                      const SizedBox(height: 16),
                      const Text('Risk Breakdown:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          _riskPill('Heat Stress', impact['risk_breakdown']?['heat_stress_risk'] ?? 'LOW'),
                          const SizedBox(width: 8),
                          _riskPill('Water Stress', impact['risk_breakdown']?['water_stress_risk'] ?? 'LOW'),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Row(
                        children: [
                          _riskPill('Rainfall Risk', impact['risk_breakdown']?['rainfall_variability_risk'] ?? 'LOW'),
                          const SizedBox(width: 8),
                          _riskPill('Disease Risk', impact['risk_breakdown']?['disease_conduciveness_risk'] ?? 'LOW'),
                        ],
                      ),
                      const SizedBox(height: 16),
                      const Text('Recommended Actions:', style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 6),
                      ...(impact['recommended_actions'] as List? ?? []).map((act) => Padding(
                        padding: const EdgeInsets.only(bottom: 6),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text('✓ ', style: TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold)),
                            Expanded(child: Text(act, style: const TextStyle(fontSize: 13, height: 1.3))),
                          ],
                        ),
                      )),
                      const SizedBox(height: 12),
                      Text(
                        impact['disclaimer'] ?? '',
                        style: const TextStyle(fontSize: 10, color: AppColors.outline, fontStyle: FontStyle.italic),
                      ),
                    ],
                  ),
                ),

              const SizedBox(height: 24),
              const Text(
                'Educational "What-If" Simulator',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.surfaceContainerHigh),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    DropdownButtonFormField<String>(
                      value: _selectedWhatIf,
                      decoration: const InputDecoration(labelText: 'Scenario', border: OutlineInputBorder()),
                      items: const [
                        DropdownMenuItem(value: 'below_normal_rain', child: Text('What if rainfall is below normal?')),
                        DropdownMenuItem(value: 'temperature_increase', child: Text('What if temperature increases?')),
                        DropdownMenuItem(value: 'heavy_rain_forecast', child: Text('What if heavy rain is forecast?')),
                        DropdownMenuItem(value: 'el_nino_continues', child: Text('What if El Niño conditions continue?')),
                      ],
                      onChanged: (val) {
                        if (val != null) setState(() => _selectedWhatIf = val);
                      },
                    ),
                    const SizedBox(height: 14),
                    _buildWhatIfCard(_selectedWhatIf),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _riskPill(String title, String val) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AppColors.surfaceContainerHigh),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontSize: 11, color: AppColors.outline)),
            const SizedBox(height: 2),
            Text(val, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget _buildWhatIfCard(String key) {
    final map = {
      'below_normal_rain': {
        'impact': 'Lower soil moisture reserves may cause crop water stress during peak vegetative and flowering stages.',
        'monitor': 'Soil moisture at root depth, leaf rolling during midday hours.',
        'prep': 'Implement drip irrigation or furrow mulching. Apply 1% KNO3 foliar spray.'
      },
      'temperature_increase': {
        'impact': 'Accelerated evapotranspiration and risk of flower/fruit drop during sensitive reproduction phases.',
        'monitor': 'Daytime maximum temperature, morning soil moisture.',
        'prep': 'Apply light evening irrigations to cool soil canopy. Maintain inter-crop cover.'
      },
      'heavy_rain_forecast': {
        'impact': 'Waterlogging near roots, nutrient leaching, and heightened fungal disease infection risk.',
        'monitor': 'Field drainage channels, standing water accumulation.',
        'prep': 'Clear field drainage channels prior to rain. Postpone foliar sprays.'
      },
      'el_nino_continues': {
        'impact': 'Increased monsoon rainfall variability and dry spells between rain events.',
        'monitor': 'Regional meteorological monsoon bulletins, reservoir levels.',
        'prep': 'Adopt farm pond water harvesting and crop diversification.'
      }
    };

    final item = map[key] ?? map['below_normal_rain']!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Potential Impact:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(item['impact']!, style: const TextStyle(fontSize: 13, height: 1.3)),
        const SizedBox(height: 8),
        const Text('What to Monitor:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(item['monitor']!, style: const TextStyle(fontSize: 13, height: 1.3)),
        const SizedBox(height: 8),
        const Text('Recommended Preparation:', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.primary)),
        Text(item['prep']!, style: const TextStyle(fontSize: 13, height: 1.3)),
      ],
    );
  }
}
