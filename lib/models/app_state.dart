import 'package:flutter/material.dart';
import 'camp_facility.dart';
import 'issue_report.dart';
import 'volunteer_opportunity.dart';
import 'donation_model.dart';
import 'organiser_app_model.dart';
import '../services/supabase_service.dart';
import 'user_profile.dart';

class AppState extends ChangeNotifier {
  final SupabaseService supabaseService = SupabaseService();
  bool isLoading = false;
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

  void updateUserProfile(UserProfile updated) async {
    _user = updated;
    notifyListeners();
    try {
      await supabaseService.updateProfile(updated);
    } catch (e) {
      debugPrint('Failed to update profile: $e');
    }
  }

  void setUserRole(UserRole role) {
    _user = _user.copyWith(role: role);
    notifyListeners();
    // In a real app we might sync this to Supabase, but profile update covers it.
  }

  Future<void> login(String phone) async {
    // This is called after OTP is verified
    final userId = supabaseService.currentUser?.id;
    if (userId != null) {
      final profile = await supabaseService.getProfile(userId);
      if (profile != null) {
        _user = profile;
      } else {
        // Create new profile
        _user = UserProfile(
          id: userId,
          phone: phone,
          name: 'Warkari',
          role: UserRole.pilgrim,
        );
        try {
          await supabaseService.createProfile(_user);
        } catch (e) {
          debugPrint('Error creating profile: $e');
        }
      }
    }
    await loadInitialData();
  }

  Future<void> logout() async {
    await supabaseService.signOut();
    _user = const UserProfile(
      id: '',
      name: 'Guest Pilgrim',
      phone: '',
      role: UserRole.guest,
    );
    _facilities = List.from(_defaultFacilities);
    _reports = [];
    _opportunities = [];
    _volunteerApplications = [];
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    isLoading = true;
    notifyListeners();

    try {
      final remoteFacilities = await supabaseService.getFacilities();
      if (remoteFacilities.isNotEmpty) {
        _facilities = remoteFacilities;
      } else if (_facilities.isEmpty) {
        _facilities = List.from(_defaultFacilities);
      }
      _reports = await supabaseService.getIssueReports();
      _opportunities = await supabaseService.getVolunteerOpportunities();
      if (supabaseService.currentUser != null) {
        _volunteerApplications = await supabaseService.getVolunteerApplications();
      }
    } catch (e) {
      debugPrint('Error loading data: $e');
      if (_facilities.isEmpty) {
        _facilities = List.from(_defaultFacilities);
      }
    }

    isLoading = false;
    notifyListeners();
  }

  // Default Pilgrimage Facilities List along Palkhi Marg
  static const List<CampFacility> _defaultFacilities = [
    CampFacility(
      id: 'camp-001',
      name: 'Vitthal Rukmini Anna Chhatra',
      type: FacilityType.food,
      description: 'Hot Mahaprasad (Khichdi, Pithla-Bhakri), filtered water, and resting mats available 24/7 for all Warkaris.',
      locationName: 'Saswad Ghat Stop, Pune-Pandharpur Route',
      distanceKm: 0.5,
      status: FacilityStatus.open,
      capacity: 1500,
      currentOccupancy: 850,
      amenities: ['Hot Mahaprasad', 'RO Filtered Water', 'Resting Hall (Mats provided)', 'Mobile Charging', 'First Aid'],
      contactPerson: 'Rameshwar Maharaj',
      contactPhone: '+91 98220 11223',
      latitude: 18.3444,
      longitude: 74.0305,
    ),
    CampFacility(
      id: 'camp-002',
      name: 'Shree Sant Tukaram Medical Seva Camp',
      type: FacilityType.medical,
      description: 'Free emergency doctor consultations, leg massage, blister care, pain sprays, and essential medicines.',
      locationName: 'Jejuri Khandoba Mandir Foothills',
      distanceKm: 1.2,
      status: FacilityStatus.open,
      capacity: 300,
      currentOccupancy: 120,
      amenities: ['Emergency Doctor On-Duty', 'Ambulance Standby (108)', 'Pain Relief Sprays', 'Foot Blister Dressing', 'Resting Cots'],
      contactPerson: 'Dr. Anant Kulkarni',
      contactPhone: '+91 94220 55667',
      latitude: 18.2750,
      longitude: 74.1592,
    ),
    CampFacility(
      id: 'camp-003',
      name: 'Sant Dnyaneshwar Jal Seva Kendra',
      type: FacilityType.water,
      description: 'Chilled RO filtered drinking water refill station, electrolyte distribution, and compostable cups.',
      locationName: 'Valhe Village Chowk, Palkhi Marg',
      distanceKm: 2.8,
      status: FacilityStatus.busy,
      capacity: 6000,
      currentOccupancy: 4800,
      amenities: ['Chilled RO Water', 'ORS / Electrolytes', 'Quick Refill Dispensers', 'Biodegradable Cups'],
      contactPerson: 'Mahesh Jadhav',
      contactPhone: '+91 97654 33221',
      latitude: 18.1722,
      longitude: 74.1611,
    ),
    CampFacility(
      id: 'camp-004',
      name: 'Pandharpur Mobile Sanitation & Toilet Complex',
      type: FacilityType.toilet,
      description: 'Maintained hygienic mobile toilets, separate washrooms for women, running water, and liquid sanitizers.',
      locationName: 'Lonand Phata, Palkhi Highway',
      distanceKm: 4.1,
      status: FacilityStatus.open,
      capacity: 80,
      currentOccupancy: 35,
      amenities: ['Separate Women Washrooms', '24/7 Running Water', 'Handwash & Sanitizer', 'Disabled Accessible'],
      contactPerson: 'Santosh Shinde',
      contactPhone: '+91 98900 44556',
      latitude: 18.0428,
      longitude: 74.1883,
    ),
    CampFacility(
      id: 'camp-005',
      name: 'Dnyanoba Mauli Annachatra & Vishranti Gruha',
      type: FacilityType.food,
      description: 'Continuous hot meals serving Shira, Sheera-Upma breakfast and full thali meal. Large waterproof tent for overnight stay.',
      locationName: 'Phaltan Sugar Factory Ground, Phaltan',
      distanceKm: 8.5,
      status: FacilityStatus.open,
      capacity: 2500,
      currentOccupancy: 1400,
      amenities: ['Breakfast & Thali Meals', 'Waterproof Night Shelter', 'Clean Drinking Water', 'Luggage Cloakroom'],
      contactPerson: 'Pandurang Patil',
      contactPhone: '+91 94230 77889',
      latitude: 17.9833,
      longitude: 74.4333,
    ),
    CampFacility(
      id: 'camp-006',
      name: 'Red Cross Emergency Trauma & Blister Care Unit',
      type: FacilityType.medical,
      description: 'Advanced medical camp with orthopedic support, cardiac defibrillator, and 50 bed resting recovery facility.',
      locationName: 'Malshiras Central Bus Stand Stop',
      distanceKm: 14.0,
      status: FacilityStatus.open,
      capacity: 500,
      currentOccupancy: 210,
      amenities: ['Physiotherapy & Foot Care', 'Cardiac ICU Van', 'Free Glucose & IV Drips', 'Wheelchairs Available'],
      contactPerson: 'Dr. Sunita Deshmukh',
      contactPhone: '+91 98231 99001',
      latitude: 17.8500,
      longitude: 74.9000,
    ),
    CampFacility(
      id: 'camp-007',
      name: 'Wakhari Ringan Seva Camp & Water Station',
      type: FacilityType.water,
      description: 'Grand Ringan ceremony hydration zone. High-capacity water tankers and glucose drink pouches for all Dindis.',
      locationName: 'Wakhari Ringan Ground, Pandharpur Outskirts',
      distanceKm: 22.4,
      status: FacilityStatus.busy,
      capacity: 10000,
      currentOccupancy: 8500,
      amenities: ['Tanker Refill Lines', 'Glucose Energy Drinks', 'Emergency First Aid', 'Dindi Coordination Desk'],
      contactPerson: 'Babanrao Salunkhe',
      contactPhone: '+91 97630 44552',
      latitude: 17.6980,
      longitude: 75.2750,
    ),
    CampFacility(
      id: 'camp-008',
      name: 'Chandrabhaga Snan & Ghat Sanitation Base',
      type: FacilityType.toilet,
      description: 'Holy bath assistance station at Chandrabhaga river bank with changing rooms, locker kiosks, and mobile toilets.',
      locationName: 'Chandrabhaga River Ghat, Pandharpur',
      distanceKm: 25.0,
      status: FacilityStatus.open,
      capacity: 200,
      currentOccupancy: 180,
      amenities: ['Secure Clothes Locker', 'Women Changing Rooms', 'Life Guard Patrol', 'Soap & Water Kiosks'],
      contactPerson: 'Vitthal Mandir Trust Sevadhar',
      contactPhone: '+91 98500 12345',
      latitude: 17.6775,
      longitude: 75.3268,
    ),
    CampFacility(
      id: 'camp-009',
      name: 'Alandi Palkhi Prasthan Annachatra',
      type: FacilityType.food,
      description: 'Palkhi departure ceremony base camp with sweet Prasad, hot tea, and medical standby.',
      locationName: 'Indrayani River Ghat, Alandi',
      distanceKm: 0.0,
      status: FacilityStatus.open,
      capacity: 3000,
      currentOccupancy: 2200,
      amenities: ['24/7 Chai & Prasad', 'Resting Pandal', 'Lost & Found Booth', 'Audio Public Announcement'],
      contactPerson: 'Eknath Maharaj',
      contactPhone: '+91 98224 88776',
      latitude: 18.6772,
      longitude: 73.8967,
    ),
    CampFacility(
      id: 'camp-010',
      name: 'Dive Ghat Top Relief & Hydration Post',
      type: FacilityType.water,
      description: 'Crucial mountain pass resting post after the steep Dive Ghat ascent. Energy drinks, lemon water, and medical rest beds.',
      locationName: 'Dive Ghat Summit Mastani Talav Viewpoint',
      distanceKm: 3.5,
      status: FacilityStatus.open,
      capacity: 4000,
      currentOccupancy: 2900,
      amenities: ['Lemon Sharbath (Hydration)', 'Stretcher Evacuation Team', 'Oxygen Support', 'Shaded Rest Benches'],
      contactPerson: 'Sanjay Jagtap',
      contactPhone: '+91 94225 33441',
      latitude: 18.3980,
      longitude: 73.9980,
    ),
  ];

  // Camp Facilities List
  List<CampFacility> _facilities = List.from(_defaultFacilities);
  List<CampFacility> get facilities => List.unmodifiable(_facilities);

  CampFacility? getFacilityById(String id) {
    try {
      return _facilities.firstWhere((f) => f.id == id);
    } catch (_) {
      return _facilities.isNotEmpty ? _facilities.first : null;
    }
  }

  Future<void> updateFacilityStatus(String id, FacilityStatus newStatus) async {
    final index = _facilities.indexWhere((f) => f.id == id);
    if (index != -1) {
      final updated = _facilities[index].copyWith(status: newStatus);
      _facilities[index] = updated;
      notifyListeners();
      try {
        await supabaseService.updateFacility(updated);
      } catch (e) {
        debugPrint('Error updating facility: $e');
      }
    }
  }

  Future<void> updateFacilityOccupancy(String id, int occupancy) async {
    final index = _facilities.indexWhere((f) => f.id == id);
    if (index != -1) {
      final updated = _facilities[index].copyWith(currentOccupancy: occupancy);
      _facilities[index] = updated;
      notifyListeners();
      try {
        await supabaseService.updateFacility(updated);
      } catch (e) {
        debugPrint('Error updating facility: $e');
      }
    }
  }

  Future<void> addFacility(CampFacility facility) async {
    _facilities.insert(0, facility);
    notifyListeners();
    try {
      await supabaseService.createFacility(facility);
    } catch (e) {
      debugPrint('Error adding facility: $e');
      // Could remove it on failure or show error
    }
  }

  // Issue Reports List
  List<IssueReport> _reports = [];
  List<IssueReport> get reports => List.unmodifiable(_reports);

  Future<void> addReport(IssueReport report) async {
    _reports.insert(0, report);
    notifyListeners();
    try {
      await supabaseService.createIssueReport(report);
    } catch (e) {
      debugPrint('Error adding report (RLS might prevent this): $e');
    }
  }

  void resolveReport(String reportId) {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      _reports[index] = _reports[index].copyWith(status: IssueStatus.resolved);
      notifyListeners();
      // Need an update IssueReport method in SupabaseService if this feature is needed.
      // Leaving local-only for now if RLS is restricted.
    }
  }

  // Volunteer Opportunities & Applications
  List<VolunteerOpportunity> _opportunities = [];
  List<VolunteerOpportunity> get opportunities => List.unmodifiable(_opportunities);

  List<VolunteerApplication> _volunteerApplications = [];
  List<VolunteerApplication> get volunteerApplications => List.unmodifiable(_volunteerApplications);

  Future<void> addVolunteerApplication(VolunteerApplication app) async {
    _volunteerApplications.insert(0, app);
    notifyListeners();
    try {
      await supabaseService.createVolunteerApplication(app);
    } catch (e) {
      debugPrint('Error adding application (RLS might prevent this): $e');
    }
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

class AppStateScope extends InheritedNotifier<AppState> {
  const AppStateScope({
    super.key,
    required AppState appState,
    required super.child,
  }) : super(notifier: appState);

  static AppState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppStateScope>();
    return scope?.notifier ?? AppState();
  }
}

