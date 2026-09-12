import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  static const String baseUrl = 'http://127.0.0.1:8000/api/v1';

  static Future<List<dynamic>> fetchCategories() async {
    final res = await http.get(Uri.parse('$baseUrl/categories'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load categories');
  }

  static Future<List<dynamic>> fetchCrops({String? category}) async {
    final url = category != null ? '$baseUrl/crops?category=$category' : '$baseUrl/crops';
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load crops');
  }

  static Future<List<dynamic>> fetchQuestions(String categoryId) async {
    final res = await http.get(Uri.parse('$baseUrl/questions/$categoryId'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load questions');
  }

  static Future<Map<String, dynamic>> evaluateAdvisory({
    required String categoryId,
    required Map<String, String> answers,
    String location = 'Nashik, Maharashtra',
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/advisory/evaluate'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'category_id': categoryId,
        'answers': answers,
        'location': location,
      }),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to evaluate advisory');
  }

  static Future<Map<String, dynamic>> scanCropDisease({
    required String cropName,
    required String imageBase64OrUrl,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/disease/scan'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'crop_name': cropName,
        'image_base64_or_url': imageBase64OrUrl,
      }),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to scan crop disease');
  }

  static Future<Map<String, dynamic>> fetchWeather({
    String location = 'Nashik, Maharashtra',
    double? lat,
    double? lon,
  }) async {
    String url = '$baseUrl/weather?location=${Uri.encodeComponent(location)}';
    if (lat != null && lon != null) {
      url = '$baseUrl/weather?lat=$lat&lon=$lon';
    }
    final res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to load weather');
  }

  static Future<Map<String, dynamic>> fetchCropRecommendation({
    required String soilType,
    required String location,
    required String waterAvailability,
    required String season,
  }) async {
    final res = await http.post(
      Uri.parse('$baseUrl/crop-recommendation'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'soil_type': soilType,
        'location': location,
        'water_availability': waterAvailability,
        'season': season,
      }),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to get crop recommendations');
  }

  static Future<Map<String, dynamic>> submitExpertRequest(Map<String, dynamic> data) async {
    final res = await http.post(
      Uri.parse('$baseUrl/expert-requests'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(data),
    );
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to submit expert request');
  }

  static Future<List<dynamic>> fetchMyRequests() async {
    final res = await http.get(Uri.parse('$baseUrl/expert-requests'));
    if (res.statusCode == 200) return jsonDecode(res.body);
    throw Exception('Failed to fetch requests');
  }
}
