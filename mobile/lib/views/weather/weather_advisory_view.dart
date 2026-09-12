import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/weather_provider.dart';

class WeatherAdvisoryView extends StatelessWidget {
  const WeatherAdvisoryView({super.key});

  @override
  Widget build(BuildContext context) {
    final weatherProv = context.watch<WeatherProvider>();
    final data = weatherProv.weatherData;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        title: const Text('Weather Advisory'),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main Weather Display
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryContainer, AppColors.primary],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              data?['location'] ?? 'Nashik, Maharashtra',
                              style: const TextStyle(color: AppColors.onPrimary, fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              data?['condition'] ?? 'Partly Cloudy',
                              style: TextStyle(color: AppColors.onPrimary.withOpacity(0.8), fontSize: 14),
                            ),
                          ],
                        ),
                        const Icon(Icons.wb_sunny, color: Colors.amber, size: 48),
                      ],
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${data?['temperature'] ?? 28.5}°C',
                          style: const TextStyle(color: AppColors.onPrimary, fontSize: 44, fontWeight: FontWeight.bold),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text('Humidity: ${data?['humidity'] ?? 68}%', style: const TextStyle(color: AppColors.onPrimary, fontSize: 12)),
                            Text('Wind: ${data?['wind_speed_kmh'] ?? 12.4} km/h', style: const TextStyle(color: AppColors.onPrimary, fontSize: 12)),
                            Text('Rain Prob: ${data?['rain_probability'] ?? 35}%', style: const TextStyle(color: AppColors.onPrimary, fontSize: 12)),
                          ],
                        )
                      ],
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Farming Advisory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondaryContainer.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Icon(Icons.info_outline, color: AppColors.primary),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        data?['farming_advisory'] ?? 'Ideal conditions for field operations today.',
                        style: const TextStyle(fontSize: 14, height: 1.4, color: AppColors.onSurface),
                      ),
                    )
                  ],
                ),
              ),

              const SizedBox(height: 24),
              const Text(
                'Today Forecast',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 12),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: (data?['forecast'] as List? ?? []).length,
                  itemBuilder: (context, idx) {
                    final item = data!['forecast'][idx];
                    return Container(
                      width: 80,
                      margin: const EdgeInsets.only(right: 12),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.surfaceContainerHigh),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(item['time'], style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          const SizedBox(height: 6),
                          Text('${item['temp']}°C', style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: AppColors.primary)),
                          Text('🌧 ${item['pop']}%', style: const TextStyle(fontSize: 10, color: AppColors.outline)),
                        ],
                      ),
                    );
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
