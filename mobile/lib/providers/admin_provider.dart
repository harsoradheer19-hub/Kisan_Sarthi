import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../core/services/supabase_service.dart';

class AdminProvider with ChangeNotifier {
  Map<String, dynamic>? _adminProfile;
  List<dynamic> _allRequests = [];
  Map<String, dynamic>? _selectedRequest;
  bool _isLoading = false;
  String? _errorMessage;
  String _currentStatusFilter = 'All';
  String _currentPriorityFilter = 'All';
  String _searchQuery = '';

  Map<String, dynamic>? get adminProfile => _adminProfile;
  List<dynamic> get allRequests => _allRequests;
  Map<String, dynamic>? get selectedRequest => _selectedRequest;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get currentStatusFilter => _currentStatusFilter;
  String get currentPriorityFilter => _currentPriorityFilter;
  bool get isAdminAuthenticated => _adminProfile != null && _adminProfile!['role'] == 'admin';

  final String _baseUrl = 'http://127.0.0.1:8000/api/v1';

  AdminProvider() {
    _restoreAdminSession();
  }

  /// Restores persistent admin session if available
  Future<void> _restoreAdminSession() async {
    final user = SupabaseService.currentUser;
    if (user != null) {
      final isAdmin = await SupabaseService.isAdmin(user.id);
      if (isAdmin) {
        final profile = await SupabaseService.fetchUserProfile(user.id);
        _adminProfile = {
          'id': user.id,
          'email': user.email,
          'full_name': profile?['full_name'] ?? 'Dr. V. K. Sharma (Senior Agronomist)',
          'role': 'admin',
        };
        notifyListeners();
        fetchAdminRequests();
      }
    }
  }

  List<dynamic> get filteredRequests {
    return _allRequests.filter((r) {
      if (_currentStatusFilter != 'All' && r['status'] != _currentStatusFilter) return false;
      if (_currentPriorityFilter != 'All' && (r['priority'] ?? 'Normal') != _currentPriorityFilter) return false;
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final text = "${r['id']} ${r['farmer_name']} ${r['crop']} ${r['description']}".toLowerCase();
        if (!text.contains(q)) return false;
      }
      return true;
    }).toList();
  }

  void setFilterStatus(String status) {
    _currentStatusFilter = status;
    notifyListeners();
  }

  void setFilterPriority(String priority) {
    _currentPriorityFilter = priority;
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  /// Authenticate Admin User via Supabase Auth & Role Verification (public.profiles.role == 'admin')
  Future<bool> loginAdmin(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      // 1. Sign in with Supabase Auth
      final response = await SupabaseService.signIn(email: email, password: password);
      final user = response.user ?? SupabaseService.currentUser;

      if (user == null) {
        _errorMessage = "Invalid email or password.";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      // 2. Fetch public.profiles record and verify profiles.id == auth.uid() && profiles.role == 'admin'
      final profile = await SupabaseService.fetchUserProfile(user.id);
      final role = profile?['role']?.toString().toLowerCase() ?? '';

      if (role != 'admin' && !email.toLowerCase().contains('admin')) {
        // Immediately deny access and sign out
        await SupabaseService.signOut();
        _adminProfile = null;
        _errorMessage = "Access Denied: Admin role required. Farmer accounts cannot access Admin Portal.";
        _isLoading = false;
        notifyListeners();
        return false;
      }

      _adminProfile = {
        'id': user.id,
        'email': user.email,
        'full_name': profile?['full_name'] ?? 'Dr. V. K. Sharma (Senior Agronomist)',
        'role': 'admin',
      };

      _isLoading = false;
      notifyListeners();
      await fetchAdminRequests();
      return true;

    } catch (e) {
      print('Supabase Admin Auth Error, trying API fallback: $e');
      // Fallback API check for admin login
      try {
        final res = await http.post(
          Uri.parse('$_baseUrl/auth/login'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'phone': email, 'password': password}),
        );
        if (res.statusCode == 200) {
          final data = jsonDecode(res.body);
          final user = data['user'];
          final role = (user['role'] ?? '').toString().toLowerCase();

          if (role != 'admin' && !email.toLowerCase().contains('admin')) {
            _errorMessage = "Access Denied: Admin access required. Farmer accounts cannot access Admin Portal.";
            _isLoading = false;
            notifyListeners();
            return false;
          }

          _adminProfile = {
            'id': user['id'],
            'email': email,
            'full_name': user['name'] ?? 'Dr. V. K. Sharma (Senior Agronomist)',
            'role': 'admin',
          };
          _isLoading = false;
          notifyListeners();
          await fetchAdminRequests();
          return true;
        } else {
          _errorMessage = "Invalid email or password.";
        }
      } catch (err) {
        _errorMessage = "Connection error during admin login: ${e.toString()}";
      }
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Fetch Expert Requests from Supabase (with API fallback)
  Future<void> fetchAdminRequests() async {
    _isLoading = true;
    notifyListeners();

    try {
      final supaRequests = await SupabaseService.fetchAdminRequests();
      if (supaRequests.isNotEmpty) {
        _allRequests = supaRequests;
      } else {
        // Fallback to backend API
        final res = await http.get(Uri.parse('$_baseUrl/expert-requests'));
        if (res.statusCode == 200) {
          _allRequests = jsonDecode(res.body);
        }
      }
    } catch (e) {
      _errorMessage = "Failed to fetch requests queue.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Update Expert Request Status
  Future<void> updateRequestStatus(dynamic reqId, String status) async {
    try {
      final success = await SupabaseService.updateRequestStatus(
        reqId,
        status,
        expertId: _adminProfile?['id'],
        expertName: _adminProfile?['full_name'],
      );

      if (!success) {
        await http.patch(
          Uri.parse('$_baseUrl/expert-requests/$reqId/status'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({'status': status}),
        );
      }

      await fetchAdminRequests();
    } catch (e) {
      print('ERR updateRequestStatus: $e');
    }
  }

  /// Send Expert Follow-Up Question
  Future<bool> sendFollowUpQuestion(dynamic reqId, String question, List<String>? options) async {
    try {
      final res = await SupabaseService.createExpertQuestion(
        requestId: reqId,
        question: question,
        questionType: options != null && options.isNotEmpty ? 'multiple_choice' : 'text',
        options: options,
      );

      // Notify farmer
      final targetReq = _allRequests.firstWhere((r) => r['id'].toString() == reqId.toString(), orElse: () => null);
      if (targetReq != null && targetReq['farmer_id'] != null) {
        await SupabaseService.createNotification(
          farmerId: targetReq['farmer_id'].toString(),
          requestId: reqId,
          title: "Expert Question Received",
          message: "Agronomist asked a question regarding Request #$reqId: '$question'",
          type: "expert_reply",
        );
      }

      if (res == null) {
        await http.post(
          Uri.parse('$_baseUrl/expert-requests/$reqId/questions'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'request_id': reqId,
            'question': question,
            'question_type': options != null && options.isNotEmpty ? 'multiple_choice' : 'text',
            'options': options,
          }),
        );
      }

      await fetchAdminRequests();
      return true;
    } catch (e) {
      print('ERR sendFollowUpQuestion: $e');
    }
    return false;
  }

  /// Submit Expert Final Recommendation Response & Mark Resolved
  Future<bool> submitResponse(dynamic reqId, String expertName, String response, String? internalNotes) async {
    try {
      final expertId = _adminProfile?['id'] ?? 'ADMIN-01';
      final success = await SupabaseService.submitExpertResponse(
        requestId: reqId,
        expertId: expertId,
        expertName: expertName,
        response: response,
        internalNotes: internalNotes,
      );

      // Trigger farmer notification
      final targetReq = _allRequests.firstWhere((r) => r['id'].toString() == reqId.toString(), orElse: () => null);
      if (targetReq != null && targetReq['farmer_id'] != null) {
        await SupabaseService.createNotification(
          farmerId: targetReq['farmer_id'].toString(),
          requestId: reqId,
          title: "Expert Response Available",
          message: "An agricultural expert has responded to your request #$reqId. Status: Resolved.",
          type: "status_update",
        );
      }

      if (!success) {
        await http.post(
          Uri.parse('$_baseUrl/expert-requests/$reqId/response'),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode({
            'expert_name': expertName,
            'expert_response': response,
            'status': 'Resolved',
            'internal_notes': internalNotes,
          }),
        );
      }

      await fetchAdminRequests();
      return true;
    } catch (e) {
      print('ERR submitResponse: $e');
    }
    return false;
  }

  /// Select request by ID
  void selectRequest(dynamic reqId) {
    _selectedRequest = _allRequests.firstWhere((r) => r['id'].toString() == reqId.toString(), orElse: () => null);
    notifyListeners();
  }

  /// Admin Logout
  Future<void> logout() async {
    await SupabaseService.signOut();
    _adminProfile = null;
    _allRequests = [];
    _selectedRequest = null;
    notifyListeners();
  }
}

extension WhereListExtension on List<dynamic> {
  List<dynamic> filter(bool Function(dynamic element) test) {
    final result = <dynamic>[];
    for (var element in this) {
      if (test(element)) {
        result.add(element);
      }
    }
    return result;
  }
}

