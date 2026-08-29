enum OrganiserAppStatus {
  submitted('Application Submitted'),
  documentVerification('Document Verification'),
  fieldInspection('Field Inspection'),
  approved('Approved & Live'),
  rejected('Rejected');

  final String label;
  const OrganiserAppStatus(this.label);
}

class OrganiserApplication {
  final String id;
  // Step 1 Details
  final String organiserName;
  final String trustName;
  final String registrationNumber;
  final String phone;
  final String email;
  final String idProofType;
  
  // Step 2 Details
  final String facilityName;
  final List<String> serviceTypes;
  final int capacity;
  final String routeStop;
  final String locationAddress;
  final double latitude;
  final double longitude;
  final String emergencyContactOnSite;
  
  // Application Meta
  final OrganiserAppStatus status;
  final DateTime submittedAt;
  final String assignedOfficer;
  final String officerPhone;

  const OrganiserApplication({
    required this.id,
    required this.organiserName,
    required this.trustName,
    required this.registrationNumber,
    required this.phone,
    required this.email,
    required this.idProofType,
    required this.facilityName,
    required this.serviceTypes,
    required this.capacity,
    required this.routeStop,
    required this.locationAddress,
    this.latitude = 18.5204,
    this.longitude = 73.8567,
    required this.emergencyContactOnSite,
    this.status = OrganiserAppStatus.submitted,
    required this.submittedAt,
    this.assignedOfficer = 'Suresh Patil (Field Officer)',
    this.officerPhone = '+91 94220 12345',
  });

  OrganiserApplication copyWith({
    String? id,
    String? organiserName,
    String? trustName,
    String? registrationNumber,
    String? phone,
    String? email,
    String? idProofType,
    String? facilityName,
    List<String>? serviceTypes,
    int? capacity,
    String? routeStop,
    String? locationAddress,
    double? latitude,
    double? longitude,
    String? emergencyContactOnSite,
    OrganiserAppStatus? status,
    DateTime? submittedAt,
    String? assignedOfficer,
    String? officerPhone,
  }) {
    return OrganiserApplication(
      id: id ?? this.id,
      organiserName: organiserName ?? this.organiserName,
      trustName: trustName ?? this.trustName,
      registrationNumber: registrationNumber ?? this.registrationNumber,
      phone: phone ?? this.phone,
      email: email ?? this.email,
      idProofType: idProofType ?? this.idProofType,
      facilityName: facilityName ?? this.facilityName,
      serviceTypes: serviceTypes ?? this.serviceTypes,
      capacity: capacity ?? this.capacity,
      routeStop: routeStop ?? this.routeStop,
      locationAddress: locationAddress ?? this.locationAddress,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      emergencyContactOnSite: emergencyContactOnSite ?? this.emergencyContactOnSite,
      status: status ?? this.status,
      submittedAt: submittedAt ?? this.submittedAt,
      assignedOfficer: assignedOfficer ?? this.assignedOfficer,
      officerPhone: officerPhone ?? this.officerPhone,
    );
  }

  factory OrganiserApplication.fromJson(Map<String, dynamic> json) {
    return OrganiserApplication(
      id: json['id'] as String? ?? '',
      organiserName: json['trustee_name'] as String? ?? '',
      trustName: json['trust_name'] as String? ?? '',
      registrationNumber: json['reg_no'] as String? ?? '',
      phone: json['contact_phone'] as String? ?? '',
      email: json['email'] as String? ?? '',
      idProofType: json['id_type'] as String? ?? '',
      facilityName: json['facility_name'] as String? ?? '',
      serviceTypes: (json['services'] as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
      capacity: json['capacity'] as int? ?? 0,
      routeStop: json['route_stop'] as String? ?? '',
      locationAddress: json['address'] as String? ?? '',
      latitude: json['gps_coordinates'] != null
          ? double.tryParse((json['gps_coordinates'] as String).split(',').first) ?? 18.5204
          : 18.5204,
      longitude: json['gps_coordinates'] != null && (json['gps_coordinates'] as String).contains(',')
          ? double.tryParse((json['gps_coordinates'] as String).split(',').last) ?? 73.8567
          : 73.8567,
      emergencyContactOnSite: json['emergency_contact'] as String? ?? '',
      status: OrganiserAppStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => OrganiserAppStatus.submitted,
      ),
      submittedAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      assignedOfficer: json['assigned_officer_name'] as String? ?? 'Suresh Patil (Field Officer)',
      officerPhone: json['assigned_officer_phone'] as String? ?? '+91 94220 12345',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'trustee_name': organiserName,
      'trust_name': trustName,
      'reg_no': registrationNumber,
      'contact_phone': phone,
      'email': email,
      'id_type': idProofType,
      'facility_name': facilityName,
      'services': serviceTypes,
      'capacity': capacity,
      'route_stop': routeStop,
      'address': locationAddress,
      'gps_coordinates': '$latitude,$longitude',
      'emergency_contact': emergencyContactOnSite,
      'status': status.name,
      'assigned_officer_name': assignedOfficer,
      'assigned_officer_phone': officerPhone,
    };
  }
}

