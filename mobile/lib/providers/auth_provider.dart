import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../core/services/supabase_service.dart';

class AuthProvider extends ChangeNotifier {
  User? _user;
  Map<String, dynamic>? _userProfile;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  Map<String, dynamic>? get userProfile => _userProfile;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _user != null || SupabaseService.isAuthenticated;
  String get farmerId => _user?.id ?? SupabaseService.currentUser?.id ?? 'guest';

  String get fullName => _userProfile?['full_name'] ?? _user?.email?.split('@').first ?? 'Farmer';
  String get phone => _userProfile?['phone'] ?? '+91 9876543210';
  String get language => _userProfile?['language'] ?? 'en';

  AuthProvider() {
    _initAuthState();
  }

  void _initAuthState() {
    _user = SupabaseService.currentUser;
    if (_user != null) {
      _loadProfile(_user!.id);
    }

    SupabaseService.client.auth.onAuthStateChange.listen((data) {
      final session = data.session;
      _user = session?.user;
      if (_user != null) {
        _loadProfile(_user!.id);
      } else {
        _userProfile = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadProfile(String userId) async {
    final profile = await SupabaseService.fetchUserProfile(userId);
    if (profile != null) {
      _userProfile = profile;
      notifyListeners();
    }
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final res = await SupabaseService.signIn(
        email: email.trim(),
        password: password,
      );
      _user = res.user;
      if (_user != null) {
        await _loadProfile(_user!.id);
      }
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setErrorMessage(_translateAuthError(e.message));
    } catch (e) {
      _setErrorMessage('Network or server error. Please try again.');
    } finally {
      _setLoading(false);
    }
    return false;
  }

  Future<bool> register({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String language,
    String? locationName,
    double? latitude,
    double? longitude,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final res = await SupabaseService.signUp(
        email: email.trim(),
        password: password,
        fullName: fullName.trim(),
        phone: phone.trim(),
        language: language,
        locationName: locationName,
        latitude: latitude,
        longitude: longitude,
      );
      _user = res.user ?? SupabaseService.currentUser;
      if (_user == null) {
        _setErrorMessage('Unable to create account: No authenticated user created.');
        _setLoading(false);
        return false;
      }
      
      _userProfile = {
        'id': _user!.id,
        'full_name': fullName,
        'phone': phone,
        'role': 'farmer',
        'language': language,
        'location_name': locationName ?? 'Nashik, Maharashtra',
        'latitude': latitude ?? 19.9975,
        'longitude': longitude ?? 73.7898,
      };
      _setLoading(false);
      return true;
    } on AuthException catch (e) {
      _setErrorMessage(_translateAuthError(e.message));
    } catch (e) {
      _setErrorMessage('Unable to create account: ${e.toString().replaceAll("Exception: ", "")}');
    } finally {
      _setLoading(false);
    }
    return false;
  }

  Future<void> signOut() async {
    await SupabaseService.signOut();
    _user = null;
    _userProfile = null;
    notifyListeners();
  }

  void _setLoading(bool val) {
    _isLoading = val;
    notifyListeners();
  }

  void _setErrorMessage(String msg) {
    _errorMessage = msg;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  String _translateAuthError(String msg) {
    final lower = msg.toLowerCase();
    if (lower.contains('invalid login credentials') || lower.contains('invalid_credentials')) {
      return 'Invalid email or password. Please check your credentials.';
    }
    if (lower.contains('user already registered') || lower.contains('already exists') || lower.contains('email_exists')) {
      return 'Email already registered. Please login instead.';
    }
    if (lower.contains('password should be at least') || lower.contains('weak_password')) {
      return 'Password is too weak. Must be at least 6 characters.';
    }
    if (lower.contains('invalid email') || lower.contains('unable to validate email') || lower.contains('email_address_invalid')) {
      return 'Invalid email address format.';
    }
    if (lower.contains('rate limit exceeded') || lower.contains('over_email_send_rate_limit')) {
      return 'Email rate limit exceeded. Please try again later or contact support.';
    }
    return msg;
  }
}
