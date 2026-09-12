import 'package:flutter/foundation.dart';
import '../core/services/api_service.dart';

class WeatherProvider extends ChangeNotifier {
  Map<String, dynamic>? weatherData;
  bool isLoading = false;
  String? error;

  Future<void> loadWeather([String location = 'Nashik, Maharashtra']) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final data = await ApiService.fetchWeather(location: location);
      weatherData = data;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
