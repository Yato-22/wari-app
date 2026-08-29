import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';
import '../models/camp_facility.dart';
import '../models/issue_report.dart';
import '../models/volunteer_opportunity.dart';

class SupabaseService {
  final SupabaseClient _client = Supabase.instance.client;

  // AUTH
  User? get currentUser => _client.auth.currentUser;

  Future<void> signInWithPhone(String phone) async {
    // Ensuring it always has country code.
    String formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
    await _client.auth.signInWithOtp(
      phone: formattedPhone,
    );
  }

  Future<AuthResponse> verifyOTP(String phone, String token) async {
    String formattedPhone = phone.startsWith('+') ? phone : '+91$phone';
    return await _client.auth.verifyOTP(
      phone: formattedPhone,
      token: token,
      type: OtpType.sms,
    );
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  // PROFILES
  Future<UserProfile?> getProfile(String userId) async {
    try {
      final response = await _client
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();
      if (response != null) {
        return UserProfile.fromJson(response);
      }
      return null;
    } catch (e) {
      print('Error getting profile: $e');
      return null;
    }
  }

  Future<void> createProfile(UserProfile profile) async {
    if (currentUser == null) throw Exception('Not logged in');
    final data = profile.toJson();
    data['id'] = currentUser!.id;
    await _client.from('profiles').insert(data);
  }

  Future<void> updateProfile(UserProfile profile) async {
    if (currentUser == null) throw Exception('Not logged in');
    await _client.from('profiles').update(profile.toJson()).eq('id', currentUser!.id);
  }

  // FACILITIES
  Future<List<CampFacility>> getFacilities() async {
    try {
      final response = await _client.from('facilities').select();
      return (response as List).map((e) => CampFacility.fromJson(e)).toList();
    } catch (e) {
      print('Error getting facilities: $e');
      return [];
    }
  }

  Future<void> createFacility(CampFacility facility) async {
    if (currentUser == null) throw Exception('Not logged in');
    final data = facility.toJson();
    data['organiser_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await _client.from('facilities').insert(data);
  }

  Future<void> updateFacility(CampFacility facility) async {
    if (currentUser == null) throw Exception('Not logged in');
    await _client.from('facilities').update(facility.toJson()).eq('id', facility.id);
  }

  // ISSUE REPORTS
  Future<List<IssueReport>> getIssueReports() async {
    try {
      final response = await _client.from('issue_reports').select();
      return (response as List).map((e) => IssueReport.fromJson(e)).toList();
    } catch (e) {
      print('Error getting issue reports: $e');
      return [];
    }
  }

  Future<void> createIssueReport(IssueReport report) async {
    if (currentUser == null) throw Exception('Not logged in');
    final data = report.toJson();
    data['reporter_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await _client.from('issue_reports').insert(data);
  }

  // VOLUNTEER OPPORTUNITIES
  Future<List<VolunteerOpportunity>> getVolunteerOpportunities() async {
    try {
      final response = await _client.from('volunteer_opportunities').select();
      return (response as List).map((e) => VolunteerOpportunity.fromJson(e)).toList();
    } catch (e) {
      print('Error getting volunteer opportunities: $e');
      return [];
    }
  }

  // VOLUNTEER APPLICATIONS
  Future<List<VolunteerApplication>> getVolunteerApplications() async {
    try {
      if (currentUser == null) return [];
      final response = await _client
          .from('volunteer_applications')
          .select()
          .eq('user_id', currentUser!.id);
      return (response as List).map((e) => VolunteerApplication.fromJson(e)).toList();
    } catch (e) {
      print('Error getting volunteer applications: $e');
      return [];
    }
  }

  Future<void> createVolunteerApplication(VolunteerApplication application) async {
    if (currentUser == null) throw Exception('Not logged in');
    final data = application.toJson();
    data['user_id'] = currentUser!.id;
    if (data['id'] == '') data.remove('id');
    await _client.from('volunteer_applications').insert(data);
  }
}
