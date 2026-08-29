import 'dart:convert';

enum AuthenticationState {
  guest,
  authenticated,
}

enum UserRole {
  warkari('Warkari / Pilgrim'),
  volunteer('Volunteer (Sevak)'),
  organiser('Camp Organiser');

  final String label;
  const UserRole(this.label);
}

class UserProfile {
  final String id;
  final String? phone;
  final String displayName;
  final String? emergencyContact;
  final String? dindiNumber;
  final String? bloodGroup;
  final String? avatarUrl;
  final UserRole role;
  final String? managedCampId;

  const UserProfile({
    required this.id,
    this.phone,
    this.displayName = 'Warkari',
    this.emergencyContact,
    this.dindiNumber,
    this.bloodGroup,
    this.avatarUrl,
    this.role = UserRole.warkari,
    this.managedCampId,
  });

  // --- Role string helpers ---

  static UserRole _parseRole(String? roleStr) {
    switch (roleStr) {
      case 'Volunteer':
      case 'volunteer':
        return UserRole.volunteer;
      case 'organiser':
        return UserRole.organiser;
      case 'Warkari':
      case 'warkari':
      case 'pilgrim':
      default:
        return UserRole.warkari;
    }
  }

  static String _roleToString(UserRole role) {
    switch (role) {
      case UserRole.volunteer:
        return 'Volunteer';
      case UserRole.organiser:
        return 'Volunteer';
      case UserRole.warkari:
        return 'Warkari';
    }
  }

  // --- Serialization: Map (Supabase row) ---

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      id: map['id'] as String? ?? '',
      phone: map['phone'] as String?,
      displayName: (map['display_name'] as String?) ?? 'Warkari',
      emergencyContact: map['emergency_contact'] as String?,
      dindiNumber: map['dindi_number'] as String?,
      bloodGroup: map['blood_group'] as String?,
      avatarUrl: map['avatar_url'] as String?,
      role: _parseRole(map['role'] as String?),
      managedCampId: map['managed_camp_id'] as String?,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'phone': phone,
      'display_name': displayName,
      'emergency_contact': emergencyContact,
      'dindi_number': dindiNumber,
      'blood_group': bloodGroup,
      'avatar_url': avatarUrl,
      'role': _roleToString(role),
      'managed_camp_id': managedCampId,
    };
  }

  // --- Serialization: JSON string (for SharedPreferences caching) ---

  String toJsonString() => json.encode(toMap());

  factory UserProfile.fromJsonString(String source) =>
      UserProfile.fromMap(json.decode(source) as Map<String, dynamic>);

  // --- Backwards-compatible aliases used by SupabaseService ---

  /// Alias for [fromMap] — accepts a Map<String, dynamic> (e.g. Supabase row).
  factory UserProfile.fromJson(Map<String, dynamic> json) =>
      UserProfile.fromMap(json);

  /// Alias for [toMap] — returns a Map<String, dynamic> for Supabase writes.
  Map<String, dynamic> toJson() => toMap();

  // --- copyWith ---

  UserProfile copyWith({
    String? id,
    String? phone,
    String? displayName,
    String? emergencyContact,
    String? dindiNumber,
    String? bloodGroup,
    String? avatarUrl,
    UserRole? role,
    String? managedCampId,
  }) {
    return UserProfile(
      id: id ?? this.id,
      phone: phone ?? this.phone,
      displayName: displayName ?? this.displayName,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      dindiNumber: dindiNumber ?? this.dindiNumber,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      role: role ?? this.role,
      managedCampId: managedCampId ?? this.managedCampId,
    );
  }
}
