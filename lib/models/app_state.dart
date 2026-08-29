import 'package:flutter/material.dart';
import 'camp_facility.dart';
import 'issue_report.dart';
import 'volunteer_opportunity.dart';
import 'donation_model.dart';
import 'organiser_app_model.dart';
import 'user_profile.dart';

class AppState extends ChangeNotifier {
  // Language
  String _currentLanguage = 'en'; // 'mr', 'hi', 'en'
  String get currentLanguage => _currentLanguage;

  void setLanguage(String lang) {
    _currentLanguage = lang;
    notifyListeners();
  }

  // Active Bottom Nav Tab Index (0: Map, 1: Volunteer, 2: Reports, 3: Profile)
  int _currentTabIndex = 0;
  int get currentTabIndex => _currentTabIndex;

  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // User Profile
  UserProfile _user = const UserProfile(
    id: 'usr-101',
    name: 'Vitthal Bhakt',
    phone: '+91 98765 43210',
    email: 'vitthal.bhakt@warkari.org',
    dindiNumber: 'Dindi #12',
    role: UserRole.pilgrim,
  );
  UserProfile get user => _user;

  void updateUserProfile(UserProfile updated) {
    _user = updated;
    notifyListeners();
  }

  void setUserRole(UserRole role) {
    _user = _user.copyWith(role: role);
    notifyListeners();
  }

  void login(String phone) {
    _user = _user.copyWith(
      phone: phone,
      name: 'Vitthal Bhakt',
      role: UserRole.pilgrim,
    );
    notifyListeners();
  }

  void logout() {
    _user = _user.copyWith(
      role: UserRole.guest,
    );
    notifyListeners();
  }

  // Camp Facilities List
  final List<CampFacility> _facilities = [
    const CampFacility(
      id: 'camp-001',
      name: 'Vitthal Rukmini Anna Chhatra',
      type: FacilityType.food,
      description: 'Hot Mahaprasad, drinking water and resting mats available 24/7 for all Warkaris.',
      locationName: 'Saswad Ghat Stop, Pune Route',
      distanceKm: 0.5,
      status: FacilityStatus.open,
      capacity: 1200,
      currentOccupancy: 850,
      amenities: ['Hot Meals', 'Filtered Water', 'First Aid Box', 'Resting Hall'],
      contactPerson: 'Rameshwar Maharaj',
      contactPhone: '+91 98220 11223',
    ),
    const CampFacility(
      id: 'camp-002',
      name: 'Shree Medical Seva Camp',
      type: FacilityType.medical,
      description: 'Free first aid, emergency doctor, blister care, and essential medicines.',
      locationName: 'Jejuri Bypass, KM 42',
      distanceKm: 1.2,
      status: FacilityStatus.open,
      capacity: 300,
      currentOccupancy: 120,
      amenities: ['Emergency Doctor', 'Ambulance Standby', 'Pain Relief Sprays', 'Resting Cots'],
      contactPerson: 'Dr. Anant Kulkarni',
      contactPhone: '+91 94220 55667',
    ),
    const CampFacility(
      id: 'camp-003',
      name: 'Sant Dnyaneshwar Water Point',
      type: FacilityType.water,
      description: 'Cold RO filtered drinking water and portable water pouches.',
      locationName: 'Valhe Village Chowk',
      distanceKm: 2.8,
      status: FacilityStatus.busy,
      capacity: 5000,
      currentOccupancy: 4200,
      amenities: ['RO Chilled Water', 'Refill Stations', 'Biodegradable Cups'],
      contactPerson: 'Mahesh Jadhav',
      contactPhone: '+91 97654 33221',
    ),
    const CampFacility(
      id: 'camp-004',
      name: 'Pandharpur Seva Sanitation Camp',
      type: FacilityType.toilet,
      description: 'Clean mobile toilets and separate washrooms for women and senior citizens.',
      locationName: 'Lonand Phata',
      distanceKm: 4.1,
      status: FacilityStatus.open,
      capacity: 50,
      currentOccupancy: 35,
      amenities: ['Running Water', 'Sanitizers', 'Disabled Friendly'],
      contactPerson: 'Santosh Shinde',
      contactPhone: '+91 98900 44556',
    ),
  ];
  List<CampFacility> get facilities => List.unmodifiable(_facilities);

  CampFacility? getFacilityById(String id) {
    try {
      return _facilities.firstWhere((f) => f.id == id);
    } catch (_) {
      return _facilities.isNotEmpty ? _facilities.first : null;
    }
  }

  void updateFacilityStatus(String id, FacilityStatus newStatus) {
    final index = _facilities.indexWhere((f) => f.id == id);
    if (index != -1) {
      _facilities[index] = _facilities[index].copyWith(status: newStatus);
      notifyListeners();
    }
  }

  void updateFacilityOccupancy(String id, int occupancy) {
    final index = _facilities.indexWhere((f) => f.id == id);
    if (index != -1) {
      _facilities[index] = _facilities[index].copyWith(currentOccupancy: occupancy);
      notifyListeners();
    }
  }

  void addFacility(CampFacility facility) {
    _facilities.insert(0, facility);
    notifyListeners();
  }

  // Issue Reports List
  final List<IssueReport> _reports = [
    IssueReport(
      id: '#REP-8942',
      campId: 'camp-001',
      campName: 'Vitthal Rukmini Anna Chhatra',
      category: IssueCategory.waterShortage,
      description: 'Water dispenser 2 has low pressure and requires refill.',
      severity: IssueSeverity.medium,
      status: IssueStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    IssueReport(
      id: '#REP-7621',
      campId: 'camp-002',
      campName: 'Shree Medical Seva Camp',
      category: IssueCategory.crowdBlockage,
      description: 'Queue blockage near medicine distribution counter.',
      severity: IssueSeverity.low,
      status: IssueStatus.resolved,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    IssueReport(
      id: '#REP-9014',
      campId: 'camp-004',
      campName: 'Pandharpur Seva Sanitation Camp',
      category: IssueCategory.sanitation,
      description: 'Sanitizer refill needed at entrance wash station.',
      severity: IssueSeverity.low,
      status: IssueStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];
  List<IssueReport> get reports => List.unmodifiable(_reports);

  void addReport(IssueReport report) {
    _reports.insert(0, report);
    notifyListeners();
  }

  void resolveReport(String reportId) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(status: IssueStatus.resolved);
      notifyListeners();
    }
  }

  // Volunteer Opportunities & Applications
  final List<VolunteerOpportunity> _opportunities = [
    const VolunteerOpportunity(
      id: 'vol-001',
      title: 'Water Distribution Network Seva',
      campName: 'Sant Dnyaneshwar Water Point',
      location: 'Valhe Village Chowk, Pune Route',
      dates: 'July 10 - July 15, 2026',
      shiftTime: 'Morning Shift (06:00 AM - 12:00 PM)',
      slotsTotal: 25,
      slotsFilled: 18,
      duties: [
        'Distribute cold drinking water pouches to walking Warkaris',
        'Maintain cleanliness around the water dispenser kiosks',
        'Help senior citizens and differently-abled pilgrims with water',
      ],
      requirements: [
        'Age 18 or above',
        'Comfortable standing for 3-4 hours',
        'Devotional spirit and patience',
      ],
      perks: [
        'Hot Mahaprasad & Accommodations provided',
        'Official WariConnect Volunteer Seva Certificate',
        'Volunteer ID Badge & T-Shirt',
      ],
    ),
    const VolunteerOpportunity(
      id: 'vol-002',
      title: 'First Aid & Medical Assistant',
      campName: 'Shree Medical Seva Camp',
      location: 'Jejuri Bypass, KM 42',
      dates: 'July 11 - July 16, 2026',
      shiftTime: 'Evening Shift (02:00 PM - 08:00 PM)',
      slotsTotal: 15,
      slotsFilled: 11,
      duties: [
        'Assist on-duty doctors in managing patient registration queues',
        'Apply basic band-aids and pain relief sprays for foot blisters',
        'Coordinate emergency stretcher transport if needed',
      ],
      requirements: [
        'Basic first aid knowledge or nursing/medical background preferred',
        'Good communication skills in Marathi / Hindi',
      ],
      perks: [
        'Doctor-guided clinical mentorship',
        'Meals and resting quarters',
        'Volunteer Seva Certificate',
      ],
    ),
    const VolunteerOpportunity(
      id: 'vol-003',
      title: 'Anna Chhatra Crowd & Food Guide',
      campName: 'Vitthal Rukmini Anna Chhatra',
      location: 'Saswad Ghat Stop',
      dates: 'July 09 - July 14, 2026',
      shiftTime: 'All Day (Rotational Shifts)',
      slotsTotal: 40,
      slotsFilled: 32,
      duties: [
        'Guide pilgrims into systematic seating rows for Mahaprasad',
        'Assist senior sevadharis in serving warm meals and water',
        'Ensure zero food waste and orderly exit',
      ],
      requirements: [
        'Active and enthusiastic',
        'Ability to work in large community crowds',
      ],
      perks: [
        'Full accommodation & Prasad',
        'Certificate of Appreciation',
      ],
    ),
  ];
  List<VolunteerOpportunity> get opportunities => List.unmodifiable(_opportunities);

  final List<VolunteerApplication> _volunteerApplications = [
    VolunteerApplication(
      id: '#VOL-APP-3391',
      opportunityId: 'vol-001',
      roleTitle: 'Water Distribution Network Seva',
      campName: 'Sant Dnyaneshwar Water Point',
      applicantName: 'Vitthal Bhakt',
      applicantPhone: '+91 98765 43210',
      selectedSlot: 'Morning Shift (06:00 AM - 12:00 PM)',
      experience: 'Served in 2024 and 2025 Wari at Saswad food camp.',
      status: VolunteerStatus.approved,
      appliedAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    VolunteerApplication(
      id: '#VOL-APP-4102',
      opportunityId: 'vol-002',
      roleTitle: 'First Aid & Medical Assistant',
      campName: 'Shree Medical Seva Camp',
      applicantName: 'Ganesh More',
      applicantPhone: '+91 98234 56789',
      selectedSlot: 'Evening Shift (02:00 PM - 08:00 PM)',
      experience: 'Certified in Red Cross First Aid.',
      status: VolunteerStatus.pending,
      appliedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];
  List<VolunteerApplication> get volunteerApplications => List.unmodifiable(_volunteerApplications);

  void addVolunteerApplication(VolunteerApplication app) {
    _volunteerApplications.insert(0, app);
    notifyListeners();
  }

  void updateVolunteerAppStatus(String id, VolunteerStatus status) {
    final index = _volunteerApplications.indexWhere((a) => a.id == id);
    if (index != -1) {
      _volunteerApplications[index] = _volunteerApplications[index].copyWith(status: status);
      notifyListeners();
    }
  }

  // Donations List
  final List<DonationRecord> _donations = [
    DonationRecord(
      id: '#DON-2026-9812',
      amount: 1000,
      campName: 'Vitthal Rukmini Anna Chhatra',
      donorName: 'Vitthal Bhakt',
      donorPhone: '+91 98765 43210',
      paymentMode: 'UPI (GPay)',
      timestamp: DateTime.now().subtract(const Duration(days: 1)),
      taxReceiptRequired: true,
      panNumber: 'ABCDE1234F',
    ),
    DonationRecord(
      id: '#DON-2026-8740',
      amount: 2500,
      campName: 'Shree Medical Seva Camp',
      donorName: 'Anonymous Pilgrim',
      donorPhone: '+91 98220 99887',
      paymentMode: 'PhonePe',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isAnonymous: true,
    ),
  ];
  List<DonationRecord> get donations => List.unmodifiable(_donations);

  void addDonation(DonationRecord donation) {
    _donations.insert(0, donation);
    notifyListeners();
  }

  // Organiser Application
  OrganiserApplication? _currentOrganiserApp = OrganiserApplication(
    id: '#WARI-ORG-2026-7891',
    organiserName: 'Vitthal Bhakt',
    trustName: 'Shri Vitthal Seva Pratishthan Trust',
    registrationNumber: 'MAH/PUN/2018/9842',
    phone: '+91 98765 43210',
    email: 'vitthal.bhakt@warkari.org',
    idProofType: 'Aadhaar Card',
    facilityName: 'Vitthal Rukmini Anna Chhatra',
    serviceTypes: const ['Anna Chhatra (Food)', 'RO Water Point', 'First Aid'],
    capacity: 1200,
    routeStop: 'Saswad Ghat Stop, Pune Route',
    locationAddress: 'Survey No. 45, Alandi-Pandharpur Palkhi Marg, Saswad',
    emergencyContactOnSite: '+91 98220 11223',
    status: OrganiserAppStatus.documentVerification,
    submittedAt: DateTime.now().subtract(const Duration(hours: 18)),
  );
  OrganiserApplication? get currentOrganiserApp => _currentOrganiserApp;

  void submitOrganiserApplication(OrganiserApplication app) {
    _currentOrganiserApp = app;
    _user = _user.copyWith(role: UserRole.organiser);
    notifyListeners();
  }
}

