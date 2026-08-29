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
      print('Failed to update profile: $e');
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
          print('Error creating profile: $e');
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
    _facilities = [];
    _reports = [];
    _opportunities = [];
    _volunteerApplications = [];
    notifyListeners();
  }

  Future<void> loadInitialData() async {
    isLoading = true;
    notifyListeners();

    try {
      _facilities = await supabaseService.getFacilities();
      _reports = await supabaseService.getIssueReports();
      _opportunities = await supabaseService.getVolunteerOpportunities();
      if (supabaseService.currentUser != null) {
        _volunteerApplications = await supabaseService.getVolunteerApplications();
      }
    } catch (e) {
      print('Error loading data: $e');
    }

    isLoading = false;
    notifyListeners();
  }

  // Camp Facilities List
  List<CampFacility> _facilities = [];
  List<CampFacility> get facilities => List.unmodifiable(_facilities);

  CampFacility? getFacilityById(String id) {
    try {
      return _facilities.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
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
        print('Error updating facility: $e');
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
        print('Error updating facility: $e');
      }
    }
  }

  Future<void> addFacility(CampFacility facility) async {
    _facilities.insert(0, facility);
    notifyListeners();
    try {
      await supabaseService.createFacility(facility);
    } catch (e) {
      print('Error adding facility: $e');
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
      print('Error adding report (RLS might prevent this): $e');
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
      print('Error adding application (RLS might prevent this): $e');
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

