enum FacilityStatus {
  open,
  busy,
  closed,
}

enum FacilityType {
  all,
  food,
  water,
  medical,
  toilet,
  shelter,
}

class CampFacility {
  final String id;
  final String name;
  final FacilityType type;
  final String description;
  final String locationName;
  final double distanceKm;
  final FacilityStatus status;
  final int capacity;
  final int currentOccupancy;
  final List<String> amenities;
  final String contactPerson;
  final String contactPhone;
  final double latitude;
  final double longitude;
  final String? organiserId;

  const CampFacility({
    required this.id,
    required this.name,
    required this.type,
    required this.description,
    required this.locationName,
    required this.distanceKm,
    this.status = FacilityStatus.open,
    this.capacity = 1000,
    this.currentOccupancy = 450,
    this.amenities = const [],
    this.contactPerson = 'Camp Sevadhar',
    this.contactPhone = '+91 98765 43210',
    this.latitude = 18.5204,
    this.longitude = 73.8567,
    this.organiserId,
  });

  CampFacility copyWith({
    String? id,
    String? name,
    FacilityType? type,
    String? description,
    String? locationName,
    double? distanceKm,
    FacilityStatus? status,
    int? capacity,
    int? currentOccupancy,
    List<String>? amenities,
    String? contactPerson,
    String? contactPhone,
    double? latitude,
    double? longitude,
    String? organiserId,
  }) {
    return CampFacility(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      description: description ?? this.description,
      locationName: locationName ?? this.locationName,
      distanceKm: distanceKm ?? this.distanceKm,
      status: status ?? this.status,
      capacity: capacity ?? this.capacity,
      currentOccupancy: currentOccupancy ?? this.currentOccupancy,
      amenities: amenities ?? this.amenities,
      contactPerson: contactPerson ?? this.contactPerson,
      contactPhone: contactPhone ?? this.contactPhone,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      organiserId: organiserId ?? this.organiserId,
    );
  }

  factory CampFacility.fromJson(Map<String, dynamic> json) {
    FacilityType parsedType = FacilityType.all;
    if (json['category'] != null) {
      switch (json['category']) {
        case 'food': parsedType = FacilityType.food; break;
        case 'water': parsedType = FacilityType.water; break;
        case 'medical': parsedType = FacilityType.medical; break;
        case 'toilet': parsedType = FacilityType.toilet; break;
        case 'shelter': parsedType = FacilityType.shelter; break;
      }
    }

    FacilityStatus parsedStatus = FacilityStatus.open;
    if (json['status'] != null) {
      switch (json['status']) {
        case 'busy': parsedStatus = FacilityStatus.busy; break;
        case 'closed': parsedStatus = FacilityStatus.closed; break;
        default: parsedStatus = FacilityStatus.open;
      }
    }

    return CampFacility(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? 'Unnamed Facility',
      type: parsedType,
      status: parsedStatus,
      locationName: json['location'] as String? ?? 'Unknown Location',
      organiserId: json['organiser_id'] as String?,
      // Defaults for fields not in DB
      description: 'Camp Description',
      distanceKm: 0.0,
      capacity: 1000,
      currentOccupancy: 0,
      amenities: const [],
      contactPerson: 'Camp Organiser',
      contactPhone: '',
      latitude: 18.5204,
      longitude: 73.8567,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (id.isNotEmpty) 'id': id,
      'name': name,
      'category': type.name,
      'status': status.name,
      'location': locationName,
      if (organiserId != null) 'organiser_id': organiserId,
      'updated_at': DateTime.now().toIso8601String(),
    };
  }
}

