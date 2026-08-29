enum VolunteerStatus {
  pending('Pending Approval'),
  approved('Approved'),
  rejected('Not Selected');

  final String label;
  const VolunteerStatus(this.label);
}

class VolunteerOpportunity {
  final String id;
  final String title;
  final String campName;
  final String location;
  final String dates;
  final String shiftTime;
  final int slotsTotal;
  final int slotsFilled;
  final List<String> duties;
  final List<String> requirements;
  final List<String> perks;
  final String? facilityId;

  const VolunteerOpportunity({
    required this.id,
    required this.title,
    required this.campName,
    required this.location,
    required this.dates,
    required this.shiftTime,
    required this.slotsTotal,
    required this.slotsFilled,
    required this.duties,
    required this.requirements,
    required this.perks,
    this.facilityId,
  });

  factory VolunteerOpportunity.fromJson(Map<String, dynamic> json) {
    return VolunteerOpportunity(
      id: json['id'] as String? ?? '',
      title: json['description'] as String? ?? 'Opportunity',
      facilityId: json['facility_id'] as String?,
      campName: 'Facility', // Provide placeholder, handle join in UI if needed
      location: 'Unknown Location',
      dates: json['starts_at'] != null ? json['starts_at'].toString() : 'TBD',
      shiftTime: 'TBD',
      slotsTotal: json['slots_needed'] as int? ?? 10,
      slotsFilled: json['slots_filled'] as int? ?? 0,
      duties: const [],
      requirements: const [],
      perks: const [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      if (facilityId != null) 'facility_id': facilityId,
      'description': title,
      'slots_needed': slotsTotal,
      'slots_filled': slotsFilled,
      // 'starts_at': dates // depends on parsing, omitted for safety
    };
  }
}

class VolunteerApplication {
  final String id;
  final String opportunityId;
  final String roleTitle;
  final String campName;
  final String applicantName;
  final String applicantPhone;
  final String selectedSlot;
  final String experience;
  final VolunteerStatus status;
  final DateTime appliedAt;
  final String? userId;

  const VolunteerApplication({
    required this.id,
    required this.opportunityId,
    required this.roleTitle,
    required this.campName,
    required this.applicantName,
    required this.applicantPhone,
    required this.selectedSlot,
    required this.experience,
    this.status = VolunteerStatus.pending,
    required this.appliedAt,
    this.userId,
  });

  VolunteerApplication copyWith({
    String? id,
    String? opportunityId,
    String? roleTitle,
    String? campName,
    String? applicantName,
    String? applicantPhone,
    String? selectedSlot,
    String? experience,
    VolunteerStatus? status,
    DateTime? appliedAt,
    String? userId,
  }) {
    return VolunteerApplication(
      id: id ?? this.id,
      opportunityId: opportunityId ?? this.opportunityId,
      roleTitle: roleTitle ?? this.roleTitle,
      campName: campName ?? this.campName,
      applicantName: applicantName ?? this.applicantName,
      applicantPhone: applicantPhone ?? this.applicantPhone,
      selectedSlot: selectedSlot ?? this.selectedSlot,
      experience: experience ?? this.experience,
      status: status ?? this.status,
      appliedAt: appliedAt ?? this.appliedAt,
      userId: userId ?? this.userId,
    );
  }

  factory VolunteerApplication.fromJson(Map<String, dynamic> json) {
    VolunteerStatus parsedStatus = VolunteerStatus.pending;
    if (json['status'] == 'approved') {
      parsedStatus = VolunteerStatus.approved;
    } else if (json['status'] == 'rejected') {
      parsedStatus = VolunteerStatus.rejected;
    }

    return VolunteerApplication(
      id: json['id'] as String? ?? '',
      opportunityId: json['opportunity_id'] as String? ?? '',
      userId: json['user_id'] as String?,
      roleTitle: 'Volunteer Role',
      campName: 'Facility',
      applicantName: 'Applicant',
      applicantPhone: '',
      selectedSlot: '',
      experience: '',
      status: parsedStatus,
      appliedAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'opportunity_id': opportunityId,
      if (userId != null) 'user_id': userId,
      'status': status.name,
      // 'created_at' managed by DB
    };
  }
}

