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
    );
  }
}

