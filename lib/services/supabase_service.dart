import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../models/camp_facility.dart';
import '../models/issue_report.dart';
import '../models/volunteer_opportunity.dart';

class SupabaseService {
  SupabaseClient? get _client {
    try {
      return Supabase.instance.client;
    } catch (_) {
      return null;
    }
  }

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
    if (client == null || currentUser == null) return;
    final data = profile.toJson();
    data['id'] = currentUser!.id;
    await client.from('profiles').insert(data);
  }

  Future<void> updateProfile(UserProfile profile) async {
    final client = _client;
    if (client == null || currentUser == null) return;
    await client.from('profiles').update(profile.toJson()).eq('id', currentUser!.id);
  }

  // FACILITIES
  Future<List<CampFacility>> getFacilities() async {
    final client = _client;
    if (client == null) return [];
    try {
      final response = await client.from('facilities').select();
      return (response as List).map((e) => CampFacility.fromJson(e)).toList();
    } catch (e) {
      debugPrint('Error getting facilities: $e');
      return [];
    }
  }

  Future<void> createFacility(CampFacility facility) async {
    final client = _client;
    if (client == null || currentUser == null) return;
    final data = facility.toJson();
    data['organiser_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await client.from('facilities').insert(data);
  }

  Future<void> updateFacility(CampFacility facility) async {
    final client = _client;
    if (client == null || currentUser == null) return;
    await client.from('facilities').update(facility.toJson()).eq('id', facility.id);
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
    if (client == null || currentUser == null) return;
    final data = report.toJson();
    data['reporter_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await client.from('issue_reports').insert(data);
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
    if (client == null || currentUser == null) return;
    final data = application.toJson();
    data['user_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await client.from('volunteer_applications').insert(data);
  }
}
