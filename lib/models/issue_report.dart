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
    );
  }
}

