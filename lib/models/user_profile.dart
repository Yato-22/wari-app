enum UserRole {
  guest('Guest Pilgrim'),
  pilgrim('Warkari / Pilgrim'),
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
    this.role = UserRole.pilgrim,
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
}

