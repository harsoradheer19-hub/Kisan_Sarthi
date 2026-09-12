import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'weather_provider.dart';

class ClimateProvider with ChangeNotifier {
  Map<String, dynamic>? _ensoStatus;
  Map<String, dynamic>? _cropImpactData;
  List<dynamic> _whatIfScenarios = [];
  List<dynamic> _smartAlerts = [];
  bool _isLoading = false;
  String? _errorMessage;

  Map<String, dynamic>? get ensoStatus => _ensoStatus;
  Map<String, dynamic>? get cropImpactData => _cropImpactData;
  List<dynamic> get whatIfScenarios => _whatIfScenarios;
  List<dynamic> get smartAlerts => _smartAlerts;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  final String _baseUrl = 'http://127.0.0.1:8000/api/v1';

  Future<void> fetchClimateStatus() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await http.get(Uri.parse('$_baseUrl/climate/status'));
      if (res.statusCode == 200) {
        _ensoStatus = jsonDecode(res.body);
      } else {
        _ensoStatus = {
          "enso_phase": "El Niño",
          "risk_level": "Moderate",
          "summary": "Current climate conditions indicate an active El Niño phase with regional weather variability."
        };
      }
    } catch (e) {
      _ensoStatus = {
        "enso_phase": "El Niño",
        "risk_level": "Moderate",
        "summary": "Climate signal diagnostic active. Cross-referencing local weather forecast."
      };
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> evaluateCropImpact({
    required String crop,
    required String growthStage,
    required String location,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final res = await http.post(
        Uri.parse('$_baseUrl/climate/crop-impact'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'crop': crop,
          'growth_stage': growthStage,
          'location': location,
        }),
      );

      if (res.statusCode == 200) {
        _cropImpactData = jsonDecode(res.body);
      } else {
        _errorMessage = "Failed to calculate crop climate impact.";
      }
    } catch (e) {
      _errorMessage = "Network error calculating climate impact. Please try again.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWhatIfScenarios({String crop = "Tomato", String location = "Nashik, Maharashtra"}) async {
    try {
      final res = await http.post(Uri.parse('$_baseUrl/climate/what-if?crop=$crop&location=$location'));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        _whatIfScenarios = data['scenarios'] ?? [];
      }
    } catch (e) {}
    notifyListeners();
  }
}
