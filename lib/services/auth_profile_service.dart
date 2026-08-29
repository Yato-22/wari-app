import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_profile.dart';

/// Service that handles OTP authentication, fetches the user's profile
/// from Supabase, and caches it locally with SharedPreferences.
class AuthProfileService {
  static const String _profileStorageKey = 'cached_user_profile';
  final SupabaseClient _client = Supabase.instance.client;

  /// Step 1: Send OTP to Phone
  Future<void> sendOtp(String phone) async {
    await _client.auth.signInWithOtp(
      phone: phone, // Expects format like '+919876543210'
    );
  }

  /// Step 2: Verify OTP, fetch profile from DB, and cache locally
  Future<UserProfile?> verifyOtpAndSaveProfile({
    required String phone,
    required String token,
  }) async {
    // 1. Verify OTP with Supabase Auth
    final AuthResponse res = await _client.auth.verifyOTP(
      type: OtpType.sms,
      phone: phone,
      token: token,
    );

    final user = res.user;
    if (user == null) {
      throw Exception('Authentication failed. No user found.');
    }

    // 2. Fetch profile from 'profiles' table
    final data = await _client
        .from('profiles')
        .select()
        .eq('id', user.id)
        .maybeSingle();

    UserProfile profile;
    if (data != null) {
      profile = UserProfile.fromMap(data);
    } else {
      // Fallback: create default if DB row is still provisioning
      profile = UserProfile(id: user.id, phone: phone);
    }

    // 3. Save profile to local storage
    await saveProfileLocally(profile);

    return profile;
  }

  /// Save full profile object to SharedPreferences
  Future<void> saveProfileLocally(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_profileStorageKey, profile.toJsonString());
  }

  /// Read cached profile instantly upon app launch
  Future<UserProfile?> getCachedProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profileStorageKey);
    if (jsonString != null && jsonString.isNotEmpty) {
      return UserProfile.fromJsonString(jsonString);
    }
    return null;
  }

  /// Sync/refresh local profile with the latest Supabase data
  Future<UserProfile?> refreshProfileFromServer() async {
    final user = _client.auth.currentUser;
    if (user == null) return null;

    try {
      final data = await _client
          .from('profiles')
          .select()
          .eq('id', user.id)
          .maybeSingle();

      if (data != null) {
        final freshProfile = UserProfile.fromMap(data);
        await saveProfileLocally(freshProfile);
        return freshProfile;
      }
    } catch (_) {
      // Fall back to existing cached profile if network fails
    }
    return getCachedProfile();
  }

  /// Clear local profile cache on logout
  Future<void> logout() async {
    await _client.auth.signOut();
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileStorageKey);
  }
}
