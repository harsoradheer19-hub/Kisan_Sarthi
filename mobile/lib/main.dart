import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'core/services/supabase_service.dart';
import 'providers/auth_provider.dart';
import 'providers/advisory_provider.dart';
import 'providers/weather_provider.dart';
import 'providers/expert_provider.dart';
import 'providers/climate_provider.dart';
import 'providers/admin_provider.dart';

import 'views/splash/splash_view.dart';
import 'views/auth/login_view.dart';
import 'views/auth/signup_view.dart';
import 'views/onboarding/onboarding_view.dart';
import 'views/profile_setup/profile_setup_view.dart';
import 'views/home/home_dashboard_view.dart';
import 'views/advisory/select_category_view.dart';
import 'views/advisory/guided_questions_view.dart';
import 'views/advisory/summary_review_view.dart';
import 'views/advisory/advisory_result_view.dart';
import 'views/weather/weather_advisory_view.dart';
import 'views/climate/climate_advisory_view.dart';
import 'views/crop_recommendation/crop_recommendation_view.dart';
import 'views/expert_support/expert_escalation_view.dart';
import 'views/expert_support/expert_form_view.dart';
import 'views/expert_support/my_requests_view.dart';
import 'views/profile/profile_view.dart';
import 'views/admin/admin_login_view.dart';
import 'views/admin/admin_dashboard_view.dart';
import 'views/admin/admin_requests_list_view.dart';
import 'views/admin/admin_request_detail_view.dart';
import 'views/admin/admin_profile_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SupabaseService.initialize();
  runApp(const KisanSarthiApp());
}

class KisanSarthiApp extends StatelessWidget {
  const KisanSarthiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => AdvisoryProvider()),
        ChangeNotifierProvider(create: (_) => WeatherProvider()),
        ChangeNotifierProvider(create: (_) => ExpertProvider()),
        ChangeNotifierProvider(create: (_) => ClimateProvider()),
        ChangeNotifierProvider(create: (_) => AdminProvider()),
      ],
      child: MaterialApp(
        title: 'Kisan Sarthi',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const SplashView(),
          '/login': (context) => const LoginView(),
          '/signup': (context) => const SignupView(),
          '/onboarding': (context) => const OnboardingView(),
          '/profile-setup': (context) => const ProfileSetupView(),
          '/home': (context) => const HomeDashboardView(),
          '/select-category': (context) => const SelectCategoryView(),
          '/guided-questions': (context) => const GuidedQuestionsView(),
          '/summary-review': (context) => const SummaryReviewView(),
          '/advisory-result': (context) => const AdvisoryResultView(),
          '/weather': (context) => const WeatherAdvisoryView(),
          '/climate': (context) => const ClimateAdvisoryView(),
          '/crop-recommendation': (context) => const CropRecommendationView(),
          '/expert-escalation': (context) => const ExpertEscalationView(),
          '/expert-form': (context) => const ExpertFormView(),
          '/my-requests': (context) => const MyRequestsView(),
          '/profile': (context) => const ProfileView(),
          '/admin/login': (context) => const AdminLoginView(),
          '/admin/dashboard': (context) => const AdminDashboardView(),
          '/admin/requests': (context) => const AdminRequestsListView(),
          '/admin/request-detail': (context) => const AdminRequestDetailView(),
          '/admin/profile': (context) => const AdminProfileView(),
        },
      ),
    );
  }
}
