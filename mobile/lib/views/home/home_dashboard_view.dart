import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../providers/auth_provider.dart';
import '../../providers/weather_provider.dart';
import '../../providers/expert_provider.dart';

import '../advisory/select_category_view.dart';
import '../expert_support/my_requests_view.dart';
import '../profile/profile_view.dart';

class HomeDashboardView extends StatefulWidget {
  const HomeDashboardView({super.key});

  @override
  State<HomeDashboardView> createState() => _HomeDashboardViewState();
}

class _HomeDashboardViewState extends State<HomeDashboardView> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: IndexedStack(
        index: _currentIndex,
        children: [
          _HomeTabContent(onNavigateTab: (index) {
            setState(() => _currentIndex = index);
          }),
          const SelectCategoryView(),
          const MyRequestsView(),
          const ProfileView(),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: AppColors.outline,
        type: BottomNavigationBarType.fixed,
        onTap: (index) {
          setState(() => _currentIndex = index);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.psychology), label: 'Advisory'),
          BottomNavigationBarItem(icon: Icon(Icons.assignment), label: 'Requests'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

class _HomeTabContent extends StatefulWidget {
  final ValueChanged<int> onNavigateTab;
  const _HomeTabContent({required this.onNavigateTab});

  @override
  State<_HomeTabContent> createState() => _HomeTabContentState();
}

class _HomeTabContentState extends State<_HomeTabContent> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final authProv = context.read<AuthProvider>();
      final loc = authProv.userProfile?['location_name'] ?? 'Nashik, Maharashtra';
      context.read<WeatherProvider>().loadWeather(loc);
      context.read<ExpertProvider>().fetchRequests();
    });
  }

  @override
  Widget build(BuildContext context) {
    final authProv = context.watch<AuthProvider>();
    final weatherProv = context.watch<WeatherProvider>();
    final expertProv = context.watch<ExpertProvider>();

    final farmerName = authProv.fullName;
    final locationName = authProv.userProfile?['location_name'] ?? 'Nashik, Maharashtra';
    final mainCrop = authProv.userProfile?['main_crop'] ?? 'Tomato';

    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async {
          await weatherProv.loadWeather(locationName);
          await expertProv.fetchRequests();
        },
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER & WELCOME SECTION
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Namaste, $farmerName! 👋',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primary,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.outline),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                locationName,
                                style: const TextStyle(fontSize: 13, color: AppColors.outline),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  GestureDetector(
                    onTap: () => widget.onNavigateTab(3),
                    child: CircleAvatar(
                      radius: 22,
                      backgroundColor: AppColors.secondaryContainer,
                      child: Text(
                        farmerName.isNotEmpty ? farmerName[0].toUpperCase() : 'F',
                        style: const TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  )
                ],
              ),
              const SizedBox(height: 16),

              // MAIN CROP QUICK STATUS BADGE
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryContainer.withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.grass, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Text(
                      'Main Crop: $mainCrop',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // WEATHER ADVISORY CARD (Fault-Tolerant, Non-Blocking)
              _buildWeatherSection(context, weatherProv, locationName),

              const SizedBox(height: 16),

              // CLIMATE RISK CARD (El Niño / ENSO Module)
              _buildClimateSection(context, weatherProv),

              const SizedBox(height: 24),
              const Text(
                'Services & Advisory',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
              ),
              const SizedBox(height: 12),

              // QUICK ACTIONS GRID (Responsive layout preventing RenderFlex overflows)
              GridView.count(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 1.1,
                children: [
                  _buildActionCard(
                    title: 'Crop Advisory',
                    desc: 'Guided step-by-step diagnostic',
                    icon: Icons.energy_savings_leaf,
                    color: AppColors.primaryContainer,
                    iconColor: AppColors.onPrimary,
                    onTap: () => Navigator.pushNamed(context, '/select-category'),
                  ),
                  _buildActionCard(
                    title: 'Scan Crop Photo',
                    desc: 'Gemini AI Vision leaf scan',
                    icon: Icons.photo_camera,
                    color: Colors.lightBlue.shade100,
                    iconColor: Colors.lightBlue.shade800,
                    onTap: () => Navigator.pushNamed(context, '/select-category'),
                  ),
                  _buildActionCard(
                    title: 'Weather Advisory',
                    desc: 'IMD 5-day forecast & tips',
                    icon: Icons.cloud_queue,
                    color: AppColors.tertiaryContainer,
                    iconColor: AppColors.onPrimary,
                    onTap: () => Navigator.pushNamed(context, '/weather'),
                  ),
                  _buildActionCard(
                    title: 'Crop Recommendation',
                    desc: 'Soil & season suitable crops',
                    icon: Icons.agriculture,
                    color: AppColors.secondaryContainer,
                    iconColor: AppColors.primary,
                    onTap: () => Navigator.pushNamed(context, '/crop-recommendation'),
                  ),
                  _buildActionCard(
                    title: 'Expert Support',
                    desc: 'Contact real agronomists',
                    icon: Icons.contact_support_outlined,
                    color: AppColors.surfaceContainerHigh,
                    iconColor: AppColors.primary,
                    onTap: () => Navigator.pushNamed(context, '/expert-escalation'),
                  ),
                ],
              ),

              const SizedBox(height: 24),

              // RECENT ADVISORY SECTION (Useful Empty State)
              _buildRecentAdvisorySection(context),

              const SizedBox(height: 24),

              // EXPERT SUPPORT CARD
              _buildExpertSupportBanner(context),

              const SizedBox(height: 24),

              // RECENT EXPERT REQUESTS SECTION
              _buildRecentRequestsSection(context, expertProv),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildWeatherSection(BuildContext context, WeatherProvider weatherProv, String locationName) {
    if (weatherProv.isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer.withOpacity(0.4),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: const [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2, color: AppColors.primary),
            ),
            SizedBox(width: 12),
            Text('Fetching live weather advisory...', style: TextStyle(fontSize: 13, color: AppColors.outline)),
          ],
        ),
      );
    }

    if (weatherProv.error != null || weatherProv.weatherData == null) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Weather Unavailable', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                  const SizedBox(height: 2),
                  Text('Could not connect to weather server', style: TextStyle(fontSize: 12, color: AppColors.outline)),
                ],
              ),
            ),
            TextButton.icon(
              onPressed: () => weatherProv.loadWeather(locationName),
              icon: const Icon(Icons.refresh, size: 16),
              label: const Text('Retry'),
            )
          ],
        ),
      );
    }

    final weather = weatherProv.weatherData!;
    final temp = weather['temperature'] ?? 28.5;
    final cond = weather['condition'] ?? 'Partly Cloudy';
    final rain = weather['rain_probability'] ?? 35;
    final advisory = weather['farming_advisory'] ?? 'Ideal farming conditions today. Window open for spraying.';

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/weather'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.secondaryContainer.withOpacity(0.6),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.outlineVariant.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.wb_sunny_outlined, color: AppColors.tertiary, size: 36),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '$temp°C',
                          style: const TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                        ),
                        Text(
                          cond,
                          style: const TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
                        ),
                      ],
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.water_drop, size: 14, color: AppColors.primary),
                      const SizedBox(width: 4),
                      Text(
                        'Rain $rain%',
                        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.primary),
                      ),
                    ],
                  ),
                )
              ],
            ),
            const SizedBox(height: 12),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLowest.withOpacity(0.8),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                advisory,
                style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentAdvisorySection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Your Recent Advisory',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
        ),
        const SizedBox(height: 8),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.surfaceContainerHigh),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: const [
                  Icon(Icons.energy_savings_leaf, color: AppColors.primary, size: 24),
                  SizedBox(width: 10),
                  Text(
                    'No Recent Advisory',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15, color: AppColors.onSurface),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              const Text(
                'Select a crop problem category to generate a personalized step-by-step advisory.',
                style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: () => Navigator.pushNamed(context, '/select-category'),
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Get New Advisory'),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildExpertSupportBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primaryContainer.withOpacity(0.15),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.primaryContainer.withOpacity(0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.contact_support_outlined, color: AppColors.primary, size: 24),
              SizedBox(width: 10),
              Text(
                'Need Expert Help?',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: AppColors.primary),
              ),
            ],
          ),
          const SizedBox(height: 6),
          const Text(
            "Can't find a suitable solution? Connect directly with a certified agronomist for personalized crop inspection.",
            style: TextStyle(fontSize: 13, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: 12),
          ElevatedButton.icon(
            onPressed: () => Navigator.pushNamed(context, '/expert-escalation'),
            icon: const Icon(Icons.send, size: 16),
            label: const Text('Contact Expert'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentRequestsSection(BuildContext context, ExpertProvider expertProv) {
    final requests = expertProv.myRequests;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Expert Requests',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
            ),
            TextButton(
              onPressed: () => widget.onNavigateTab(2),
              child: const Text('View All'),
            )
          ],
        ),
        const SizedBox(height: 8),

        if (expertProv.isLoading) ...[
          const Center(child: Padding(
            padding: EdgeInsets.all(16.0),
            child: CircularProgressIndicator(color: AppColors.primary),
          ))
        ] else if (requests.isEmpty) ...[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: AppColors.surfaceContainerHigh),
            ),
            child: Row(
              children: const [
                Icon(Icons.assignment_outlined, color: AppColors.outline, size: 28),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'No active expert requests. Submit a query if you need agronomist assistance.',
                    style: TextStyle(fontSize: 13, color: AppColors.outline),
                  ),
                ),
              ],
            ),
          )
        ] else ...[
          ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: requests.length > 2 ? 2 : requests.length,
            itemBuilder: (context, idx) {
              final req = requests[idx];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.amber.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.schedule, color: Colors.amber),
                  ),
                  title: Text(
                    '${req['crop']} (${req['id']})',
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                  ),
                  subtitle: Text(
                    'Status: ${req['status']}',
                    style: const TextStyle(fontSize: 12),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => widget.onNavigateTab(2),
                ),
              );
            },
          )
        ]
      ],
    );
  }

  Widget _buildActionCard({
    required String title,
    required String desc,
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.surfaceContainerHigh),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.02), blurRadius: 6, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
              child: Icon(icon, color: iconColor, size: 22),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: AppColors.onSurface),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  desc,
                  style: const TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _buildClimateSection(BuildContext context, WeatherProvider weatherProv) {
    final weather = weatherProv.weatherData;
    final enso = weather?['enso_status'];
    final phase = enso?['enso_phase'] ?? 'El Niño';
    final riskLvl = enso?['risk_level'] ?? 'Moderate';

    return InkWell(
      onTap: () => Navigator.pushNamed(context, '/climate'),
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F9FF),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFF7DD3FC), width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: const [
                    Text('🌦️', style: TextStyle(fontSize: 18)),
                    SizedBox(width: 6),
                    Text(
                      'CLIMATE RISK',
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Color(0xFF0369A1)),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFEDD5),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '🌊 $phase ($riskLvl Risk)',
                    style: const TextStyle(color: Color(0xFFC2410C), fontWeight: FontWeight.bold, fontSize: 11),
                  ),
                )
              ],
            ),
            const SizedBox(height: 8),
            const Text(
              'Your area may experience increased weather variability based on regional climate signals.',
              style: TextStyle(fontSize: 12, color: Color(0xFF0C4A6E), height: 1.3),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: const [
                _ClimatePill(label: '✓ Local weather'),
                _ClimatePill(label: '✓ Forecast'),
                _ClimatePill(label: '✓ Crop'),
                _ClimatePill(label: '✓ ENSO Signal'),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  padding: const EdgeInsets.symmetric(vertical: 10),
                ),
                onPressed: () => Navigator.pushNamed(context, '/climate'),
                child: const Text('[ View Climate Advisory ]', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class _ClimatePill extends StatelessWidget {
  final String label;
  const _ClimatePill({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFBAE6FD)),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 10, color: Color(0xFF0369A1), fontWeight: FontWeight.w500),
      ),
    );
  }
}
