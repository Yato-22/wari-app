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
}

