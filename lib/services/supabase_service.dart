import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../models/camp_facility.dart';
import '../models/issue_report.dart';
import '../models/volunteer_opportunity.dart';
import '../models/organiser_app_model.dart';

class SupabaseService {
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

  SupabaseClient? get client => _client;

  // AUTH
  User? get currentUser => _client?.auth.currentUser;

  Future<void> signInWithPhone(String phone) async {
    final client = _client;
    if (client == null) return;
    // Ensuring it always has country code.
    String formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
    await client.auth.signInWithOtp(
      phone: formattedPhone,
    );
  }

  Future<AuthResponse?> verifyOTP(String phone, String token) async {
    final client = _client;
    if (client == null) return null;
    String formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
    return await client.auth.verifyOTP(
      phone: formattedPhone,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<void> signOut() async {
    final client = _client;
    if (client == null) return;
    await client.auth.signOut();
  }

  // PROFILES
  Future<UserProfile?> getProfile(String userId) async {
    final client = _client;
    if (client == null) return null;
    try {
      final response = await client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response != null) {
        return UserProfile.fromJson(response);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting profile: $e');
      return null;
    }
  }

  Future<void> createProfile(UserProfile profile) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot create profile: not authenticated');
    }
    final data = profile.toJson();
    data['id'] = currentUser!.id;
    await client.from('profiles').upsert(data);
  }

  Future<void> updateProfile(UserProfile profile) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot update profile: not authenticated');
    }
    await client.from('profiles').update(profile.toJson()).eq('id', currentUser!.id);
  }

  // FACILITIES
  Future<List<CampFacility>> getFacilities() async {
    final client = _client;
    if (client == null) return [];
    try {
      final response = await client.from('camp_facilities').select();
      return (response as List).map((e) => CampFacility.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting facilities: $e');
      return [];
    }
  }

  Future<void> createFacility(CampFacility facility) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot create facility: not authenticated');
    }
    final data = facility.toJson();
    data['organiser_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await client.from('camp_facilities').insert(data);
  }

  Future<void> updateFacility(CampFacility facility) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot update facility: not authenticated');
    }
    await client.from('camp_facilities').update(facility.toJson()).eq('id', facility.id);
  }

  // ISSUE REPORTS
  Future<List<IssueReport>> getIssueReports() async {
    final client = _client;
    if (client == null) return [];
    try {
      final response = await client.from('issue_reports').select();
      return (response as List).map((e) => IssueReport.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting issue reports: $e');
      return [];
    }
  }

  Future<void> createIssueReport(IssueReport report) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot create issue report: not authenticated');
    }
    final data = report.toJson();
    data['reporter_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await client.from('issue_reports').insert(data);
  }

  Future<void> updateIssueReport(IssueReport report) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot update issue report: not authenticated');
    }
    await client.from('issue_reports').update(report.toJson()).eq('id', report.id);
  }

  // VOLUNTEER OPPORTUNITIES
  Future<List<VolunteerOpportunity>> getVolunteerOpportunities() async {
    final client = _client;
    if (client == null) return [];
    try {
      final response = await client.from('volunteer_opportunities').select();
      return (response as List).map((e) => VolunteerOpportunity.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting volunteer opportunities: $e');
      return [];
    }
  }

  // VOLUNTEER APPLICATIONS
  Future<List<VolunteerApplication>> getVolunteerApplications() async {
    final client = _client;
    if (client == null || currentUser == null) return [];
    try {
      final response = await client
          .from('volunteer_applications')
          .select()
          .eq('user_id', currentUser!.id);
      return (response as List).map((e) => VolunteerApplication.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting volunteer applications: $e');
      return [];
    }
  }

  Future<void> createVolunteerApplication(VolunteerApplication application) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot create volunteer application: not authenticated');
    }
    final data = application.toJson();
    data['user_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await client.from('volunteer_applications').insert(data);
  }

  Future<void> updateVolunteerApplication(VolunteerApplication application) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot update volunteer application: not authenticated');
    }
    await client.from('volunteer_applications').update(application.toJson()).eq('id', application.id);
  }

  // ORGANISER APPLICATIONS
  Future<OrganiserApplication?> getOrganiserApplication(String userId) async {
    final client = _client;
    if (client == null) return null;
    try {
      final response = await client
          .from('organiser_applications')
          .select()
          .eq('organiser_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      if (response != null) {
        return OrganiserApplication.fromJson(response);
      }
      return null;
    } catch (e) {
      debugPrint('Error getting organiser application: $e');
      return null;
    }
  }

  Future<OrganiserApplication> submitOrganiserApplication(OrganiserApplication app) async {
    final client = _client;
    if (client == null || currentUser == null) throw Exception('Not logged in');
    final response = await client.functions.invoke('submit-organiser-application', body: app.toJson());
    // Assume edge function returns the created app ID or the full app
    if (response.status == 200) {
      final data = response.data;
      if (data is Map<String, dynamic> && data.containsKey('app_id')) {
         return app.copyWith(id: data['app_id'] as String);
      }
    }
    return app; // Fallback
  }

  // BACKEND RPC & MANAGEMENT METHODS

  /// Fetches dashboard statistics for a camp (uses Supabase RPC function).
  Future<Map<String, dynamic>> fetchCampStats(String campId) async {
    final client = _client;
    if (client == null) return {};
    try {
      final response = await client.rpc(
        'get_camp_stats',
        params: {'target_camp_id': campId},
      );
      return Map<String, dynamic>.from(response as Map);
    } catch (e) {
      debugPrint('Error fetching camp stats: $e');
      return {};
    }
  }

  /// Marks an issue report as resolved or in-progress (uses Supabase RPC function).
  Future<void> resolveCampIssue(String issueId, {String status = 'resolved'}) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot resolve issue: not authenticated');
    }
    try {
      await client.rpc(
        'resolve_issue_report',
        params: {
          'target_issue_id': issueId,
          'resolve_status': status,
        },
      );
    } catch (e) {
      debugPrint('Error resolving issue: $e');
      rethrow;
    }
  }

  /// Approves or rejects a volunteer application (uses Supabase RPC function).
  Future<void> reviewVolunteerApplication(String applicationId, String status) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot review application: not authenticated');
    }
    try {
      await client.rpc(
        'update_volunteer_application_status',
        params: {
          'target_application_id': applicationId,
          'new_status': status, // 'approved' or 'rejected'
        },
      );
    } catch (e) {
      debugPrint('Error reviewing volunteer application: $e');
      rethrow;
    }
  }

  /// Updates camp occupancy and live status.
  Future<void> updateCampStatus({
    required String campId,
    required String status,
    required int currentCapacity,
  }) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot update camp status: not authenticated');
    }
    try {
      await client.from('camp_facilities').update({
        'status': status,
        'capacity_current': currentCapacity,
      }).eq('id', campId);
    } catch (e) {
      debugPrint('Error updating camp status: $e');
      rethrow;
    }
  }

  // OTHER UTILS
  Future<void> triggerSos(double latitude, double longitude) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot trigger SOS: not authenticated');
    }
    try {
      await client.functions.invoke('trigger-sos', body: {
        'latitude': latitude,
        'longitude': longitude,
      });
    } catch (e) {
      debugPrint('Error triggering SOS: $e');
      rethrow;
    }
  }

  Future<void> checkInCamp(String campId) async {
    final client = _client;
    if (client == null || currentUser == null) {
      throw Exception('Cannot check in: not authenticated');
    }
    try {
      await client.from('camp_checkins').insert({
        'camp_id': campId,
        'user_id': currentUser!.id,
      });
    } catch (e) {
      debugPrint('Error checking into camp: $e');
      rethrow;
    }
  }
}
