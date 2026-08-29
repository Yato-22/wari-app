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
  });
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
    );
  }
}

