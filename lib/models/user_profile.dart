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
  final String name;
  final String phone;
  final String email;
  final String emergencyContact;
  final String dindiNumber;
  final String bloodGroup;
  final UserRole role;
  final String? avatarUrl;
  final String? managedCampId;

  const UserProfile({
    required this.id,
    required this.name,
    required this.phone,
    this.email = 'vitthal.bhakt@warkari.org',
    this.emergencyContact = '+91 98220 54321',
    this.dindiNumber = 'Dindi #14 (Alandi to Pandharpur)',
    this.bloodGroup = 'O+',
    this.role = UserRole.warkari,
    this.avatarUrl,
    this.managedCampId = 'camp-001',
  });

  UserProfile copyWith({
    String? id,
    String? name,
    String? phone,
    String? email,
    String? emergencyContact,
    String? dindiNumber,
    String? bloodGroup,
    UserRole? role,
    String? avatarUrl,
    String? managedCampId,
  }) {
    return UserProfile(
      id: id ?? this.id,
      name: name ?? this.name,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      emergencyContact: emergencyContact ?? this.emergencyContact,
      dindiNumber: dindiNumber ?? this.dindiNumber,
      bloodGroup: bloodGroup ?? this.bloodGroup,
      role: role ?? this.role,
      avatarUrl: avatarUrl ?? this.avatarUrl,
      managedCampId: managedCampId ?? this.managedCampId,
    );
  }

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    UserRole parsedRole = UserRole.warkari;
    final roleStr = json['role'] as String?;
    if (roleStr == 'volunteer') {
      parsedRole = UserRole.volunteer;
    } else if (roleStr == 'organiser') {
      parsedRole = UserRole.organiser;
    } else if (roleStr == 'warkari' || roleStr == 'pilgrim') {
      parsedRole = UserRole.warkari;
    }
    
    return UserProfile(
      id: json['id'] as String? ?? '',
      phone: json['phone'] as String? ?? '',
      name: json['display_name'] as String? ?? 'Warkari',
      role: parsedRole,
    );
  }

  Map<String, dynamic> toJson() {
    String roleStr = 'warkari';
    if (role == UserRole.volunteer) roleStr = 'volunteer';
    if (role == UserRole.organiser) roleStr = 'organiser';

    return {
      'id': id,
      'phone': phone,
      'display_name': name,
      'role': roleStr,
    };
  }
}

