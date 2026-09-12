import 'package:supabase_flutter/supabase_flutter.dart';

class SupabaseService {
  static const String supabaseUrl = 'https://gfzbcjfilvzqpxcwcpfp.supabase.co';
  static const String supabaseAnonKey = 'sb_publishable_38_1xwsfp3rGoa4vF1_PNA_50kN0Ngs';

  static SupabaseClient get client => Supabase.instance.client;

  static Future<void> initialize() async {
    await Supabase.initialize(
      url: supabaseUrl,
      anonKey: supabaseAnonKey,
    );
  }

  static User? get currentUser => client.auth.currentUser;
  static Session? get currentSession => client.auth.currentSession;
  static bool get isAuthenticated => currentSession != null;

  /// Sign Up with Email & Password, and create profile in public.profiles table
  static Future<AuthResponse> signUp({
    required String email,
    required String password,
    required String fullName,
    required String phone,
    required String language,
    String? locationName,
    double? latitude,
    double? longitude,
  }) async {
    print('SIGNUP STARTED: $email');
    final response = await client.auth.signUp(
      email: email,
      password: password,
      data: {
        'full_name': fullName,
        'phone': phone,
        'language': language,
        'location_name': locationName ?? 'Nashik, Maharashtra',
      },
    );

    print('SIGNUP RESPONSE: user=${response.user?.id}, session=${response.session != null}');

    final user = response.user ?? client.auth.currentUser;
    if (user != null) {
      print('USER ID: ${user.id}');
      print('SESSION EXISTS: ${client.auth.currentSession != null}');
      print('PROFILE INSERT STARTED');
      try {
        await client.from('profiles').upsert({
          'id': user.id,
          'full_name': fullName,
          'phone': phone,
          'role': 'farmer',
          'language': language,
          'location_name': locationName ?? 'Nashik, Maharashtra',
          'latitude': latitude ?? 19.9975,
          'longitude': longitude ?? 73.7898,
          'created_at': DateTime.now().toIso8601String(),
        });
        print('PROFILE INSERT RESULT: SUCCESS');
      } catch (e) {
        print('PROFILE INSERT RESULT ERROR: $e');
      }
    }

    return response;
  }

  /// Sign In with Email & Password
  static Future<AuthResponse> signIn({
    required String email,
    required String password,
  }) async {
    final response = await client.auth.signInWithPassword(
      email: email,
      password: password,
    );
    print('LOGIN RESPONSE: user=${response.user?.id}, session=${response.session != null}');
    return response;
  }

  /// Sign Out
  static Future<void> signOut() async {
    await client.auth.signOut();
  }

  /// Fetch user profile from public.profiles
  static Future<Map<String, dynamic>?> fetchUserProfile(String userId) async {
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      return response;
    } catch (e) {
      return null;
    }
  }

  /// Verify if user has role == 'admin'
  static Future<bool> isAdmin(String userId) async {
    try {
      final profile = await fetchUserProfile(userId);
      if (profile != null && profile['role']?.toString().toLowerCase() == 'admin') {
        return true;
      }
    } catch (e) {
      print('ERR verifying admin role: $e');
    }
    return false;
  }

  /// Fetch all expert requests from public.expert_requests
  static Future<List<Map<String, dynamic>>> fetchAdminRequests() async {
    try {
      final response = await client
          .from('expert_requests')
          .select()
          .order('created_at', ascending: false);
      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('ERR fetching admin requests from Supabase: $e');
      return [];
    }
  }

  /// Update expert request status
  static Future<bool> updateRequestStatus(
    dynamic reqId,
    String status, {
    String? expertId,
    String? expertName,
    String? internalNotes,
  }) async {
    try {
      final updateData = <String, dynamic>{
        'status': status,
        'updated_at': DateTime.now().toIso8601String(),
      };
      if (expertId != null) updateData['expert_id'] = expertId;
      if (expertName != null) updateData['expert_name'] = expertName;
      if (internalNotes != null) updateData['internal_notes'] = internalNotes;
      if (status == 'Resolved') updateData['resolved_at'] = DateTime.now().toIso8601String();

      await client
          .from('expert_requests')
          .update(updateData)
          .eq('id', reqId);
      return true;
    } catch (e) {
      print('ERR updating request status: $e');
      return false;
    }
  }

  /// Add expert follow-up question
  static Future<Map<String, dynamic>?> createExpertQuestion({
    required dynamic requestId,
    required String question,
    String questionType = 'multiple_choice',
    List<String>? options,
  }) async {
    try {
      final res = await client.from('expert_questions').insert({
        'request_id': requestId,
        'question': question,
        'question_type': questionType,
        'options': options,
        'created_at': DateTime.now().toIso8601String(),
      }).select().single();

      // Update status to 'More Information Required'
      await updateRequestStatus(requestId, 'More Information Required');

      return res;
    } catch (e) {
      print('ERR creating expert question: $e');
      return null;
    }
  }

  /// Fetch expert questions for a request
  static Future<List<Map<String, dynamic>>> fetchExpertQuestions(dynamic requestId) async {
    try {
      final res = await client
          .from('expert_questions')
          .select()
          .eq('request_id', requestId)
          .order('created_at', ascending: true);
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      return [];
    }
  }

  /// Fetch expert answers for a list of question IDs
  static Future<List<Map<String, dynamic>>> fetchExpertAnswers(List<dynamic> questionIds) async {
    if (questionIds.isEmpty) return [];
    try {
      final res = await client
          .from('expert_answers')
          .select()
          .in_('question_id', questionIds)
          .order('created_at', ascending: true);
      return List<Map<String, dynamic>>.from(res);
    } catch (e) {
      return [];
    }
  }

  /// Submit final expert response
  static Future<bool> submitExpertResponse({
    required dynamic requestId,
    required String expertId,
    required String expertName,
    required String response,
    String? internalNotes,
  }) async {
    try {
      await client.from('expert_responses').insert({
        'request_id': requestId,
        'expert_id': expertId,
        'response': response,
        'created_at': DateTime.now().toIso8601String(),
      });

      await client.from('expert_requests').update({
        'expert_id': expertId,
        'expert_name': expertName,
        'expert_response': response,
        'internal_notes': internalNotes,
        'status': 'Resolved',
        'resolved_at': DateTime.now().toIso8601String(),
      }).eq('id', requestId);

      return true;
    } catch (e) {
      print('ERR submitting expert response: $e');
      return false;
    }
  }

  /// Fetch disease scan detail by ID
  static Future<Map<String, dynamic>?> fetchDiseaseScan(String scanId) async {
    try {
      final res = await client
          .from('disease_scans')
          .select()
          .eq('id', scanId)
          .maybeSingle();
      return res;
    } catch (e) {
      return null;
    }
  }

  /// Insert farmer notification
  static Future<bool> createNotification({
    required String farmerId,
    dynamic requestId,
    required String title,
    required String message,
    String type = 'status_update',
  }) async {
    try {
      await client.from('notifications').insert({
        'farmer_id': farmerId,
        'request_id': requestId,
        'title': title,
        'message': message,
        'type': type,
        'is_read': false,
        'created_at': DateTime.now().toIso8601String(),
      });
      return true;
    } catch (e) {
      print('ERR creating notification: $e');
      return false;
    }
  }
}
