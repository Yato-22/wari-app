enum IssueCategory {
  waterShortage('Water Shortage', 'water_drop'),
  medicalEmergency('Medical Emergency', 'medical_services'),
  sanitation('Toilet & Sanitation', 'wc'),
  crowdBlockage('Crowd Blockage', 'groups'),
  lostPerson('Lost Person', 'person_off'),
  foodQuality('Food / Anna Chhatra', 'restaurant'),
  other('Other Issue', 'more_horiz');

  final String label;
  final String iconName;
  const IssueCategory(this.label, this.iconName);
}

enum IssueSeverity {
  low('Low Priority'),
  medium('Medium Priority'),
  critical('Critical / Urgent');

  final String label;
  const IssueSeverity(this.label);
}

enum IssueStatus {
  pending('Pending'),
  underReview('Under Review'),
  inProgress('In Progress'),
  resolved('Resolved');

  final String label;
  const IssueStatus(this.label);
}

class IssueReport {
  final String id;
  final String campId;
  final String campName;
  final IssueCategory category;
  final String description;
  final IssueSeverity severity;
  final IssueStatus status;
  final DateTime createdAt;
  final String? photoPath;
  final String? reporterId;

  const IssueReport({
    required this.id,
    required this.campId,
    required this.campName,
    required this.category,
    required this.description,
    this.severity = IssueSeverity.medium,
    this.status = IssueStatus.underReview,
    required this.createdAt,
    this.photoPath,
    this.reporterId,
  });

  IssueReport copyWith({
    String? id,
    String? campId,
    String? campName,
    IssueCategory? category,
    String? description,
    IssueSeverity? severity,
    IssueStatus? status,
    DateTime? createdAt,
    String? photoPath,
    String? reporterId,
  }) {
    return IssueReport(
      id: id ?? this.id,
      campId: campId ?? this.campId,
      campName: campName ?? this.campName,
      category: category ?? this.category,
      description: description ?? this.description,
      severity: severity ?? this.severity,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      photoPath: photoPath ?? this.photoPath,
      reporterId: reporterId ?? this.reporterId,
    );
  }

  factory IssueReport.fromJson(Map<String, dynamic> json) {
    IssueCategory parsedCategory = IssueCategory.other;
    if (json['issue_type'] != null) {
      switch (json['issue_type']) {
        case 'waterShortage': parsedCategory = IssueCategory.waterShortage; break;
        case 'medicalEmergency': parsedCategory = IssueCategory.medicalEmergency; break;
        case 'sanitation': parsedCategory = IssueCategory.sanitation; break;
        case 'crowdBlockage': parsedCategory = IssueCategory.crowdBlockage; break;
        case 'lostPerson': parsedCategory = IssueCategory.lostPerson; break;
        case 'foodQuality': parsedCategory = IssueCategory.foodQuality; break;
      }
    }

    IssueStatus parsedStatus = IssueStatus.pending;
    if (json['status'] != null) {
      switch (json['status']) {
        case 'underReview': parsedStatus = IssueStatus.underReview; break;
        case 'inProgress': parsedStatus = IssueStatus.inProgress; break;
        case 'resolved': parsedStatus = IssueStatus.resolved; break;
      }
    }

    return IssueReport(
      id: json['id'] as String? ?? '',
      campId: json['facility_id'] as String? ?? '',
      campName: 'Facility', // We don't have the join right now, provide dummy or handle in UI
      category: parsedCategory,
      description: json['note'] as String? ?? '',
      status: parsedStatus,
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      reporterId: json['reporter_id'] as String?,
      severity: IssueSeverity.medium, // Default
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'facility_id': campId,
      if (reporterId != null) 'reporter_id': reporterId,
      'issue_type': category.name,
      'note': description,
      'status': status.name,
      // 'created_at' is handled by DB defaults, but can send if needed
    };
  }
}

