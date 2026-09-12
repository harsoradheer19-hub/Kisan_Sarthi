import 'package:flutter/foundation.dart';
import '../core/services/api_service.dart';

class ExpertProvider extends ChangeNotifier {
  List<dynamic> myRequests = [];
  bool isLoading = false;

  Future<void> fetchRequests() async {
    isLoading = true;
    notifyListeners();
    try {
      myRequests = await ApiService.fetchMyRequests();
    } catch (e) {
      debugPrint("Error fetching expert requests: $e");
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<Map<String, dynamic>> submitRequest(Map<String, dynamic> data) async {
    isLoading = true;
    notifyListeners();
    try {
      final res = await ApiService.submitExpertRequest(data);
      await fetchRequests();
      return res;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
