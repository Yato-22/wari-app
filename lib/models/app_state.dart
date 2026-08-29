import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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
  bool get isLoggedIn => supabaseService.currentUser != null;

  // CHANGED: load public data (facilities, opportunities) immediately on
  // construction so guests see real data without needing to log in.
  AppState() {
    loadInitialData();
    _subscribeToFacilityUpdates();
  }

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
    id: '',
    name: 'Guest Pilgrim',
    phone: '',
    role: UserRole.guest,
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
  }

  Future<void> login(String phone) async {
    final userId = supabaseService.currentUser?.id;
    if (userId != null) {
      final profile = await supabaseService.getProfile(userId);
      if (profile != null) {
        _user = profile;
      } else {
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
    // Re-fetch everything now that we're authenticated (RLS unlocks
    // user-specific rows: own reports, own volunteer apps, own org application).
    await loadInitialData();
    // ADDED: pull the organiser's application/camp status if they have one.
    if (_user.role == UserRole.organiser) {
      await _loadOrganiserApplication();
    }
  }

  Future<void> logout() async {
    await supabaseService.signOut();
    _user = const UserProfile(
      id: '',
      name: 'Guest Pilgrim',
      phone: '',
      role: UserRole.guest,
    );
    _reports = [];
    _volunteerApplications = [];
    _currentOrganiserApp = null;
    notifyListeners();
    // NOTE: _facilities intentionally NOT cleared — the map stays populated
    // with public data for guests after logout.
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

  // ============ Camp Facilities ============
  List<CampFacility> _facilities = [];
  List<CampFacility> get facilities => List.unmodifiable(_facilities);

  RealtimeChannel? _facilitiesChannel;

  // ADDED: keep the map in sync when ANY organiser updates their camp
  // (status, occupancy), not just the current device's own edits.
  void _subscribeToFacilityUpdates() {
    final client = supabaseService.client;
    if (client == null) return;
    
    _facilitiesChannel = client
        .channel('public:camp_facilities')
      ..onPostgresChanges(
        event: PostgresChangeEvent.update,
        schema: 'public',
        table: 'camp_facilities',
        callback: (payload) {
          final updated = CampFacility.fromJson(payload.newRecord);
          final index = _facilities.indexWhere((f) => f.id == updated.id);
          if (index != -1) {
            _facilities[index] = updated;
          } else {
            _facilities.insert(0, updated);
          }
          notifyListeners();
        },
      )
      ..onPostgresChanges(
        event: PostgresChangeEvent.insert,
        schema: 'public',
        table: 'camp_facilities',
        callback: (payload) {
          final created = CampFacility.fromJson(payload.newRecord);
          if (!_facilities.any((f) => f.id == created.id)) {
            _facilities.insert(0, created);
            notifyListeners();
          }
        },
      )
      ..subscribe();
  }

  CampFacility? getFacilityById(String id) {
    try {
      return _facilities.firstWhere((f) => f.id == id);
    } catch (_) {
      return null;
    }
  }

  // REMOVED: loadFacilities() — was redundant with loadInitialData() and
  // called a supabaseService.fetchFacilities() method that doesn't exist
  // in your service (which uses getFacilities()). loadInitialData() now
  // covers this for both guests and logged-in users.

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
    }
  }

  // ============ Issue Reports ============
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

  // CHANGED: now persists to Supabase instead of local-only, so
  // my_camp_management_screen's "Mark Resolved" actually sticks.
  // Requires adding `updateIssueReport` to SupabaseService (see below).
  Future<void> resolveReport(String reportId) async {
    final index = _reports.indexWhere((r) => r.id == reportId);
    if (index != -1) {
      final updated = _reports[index].copyWith(status: IssueStatus.resolved);
      _reports[index] = updated;
      notifyListeners();
      try {
        await supabaseService.updateIssueReport(updated);
      } catch (e) {
        print('Error resolving report: $e');
      }
    }
  }

  // ============ Volunteer Opportunities & Applications ============
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

  // CHANGED: now persists to Supabase, so organiser approve/reject sticks.
  // Requires adding `updateVolunteerApplication` to SupabaseService.
  Future<void> updateVolunteerAppStatus(String id, VolunteerStatus status) async {
    final index = _volunteerApplications.indexWhere((a) => a.id == id);
    if (index != -1) {
      final updated = _volunteerApplications[index].copyWith(status: status);
      _volunteerApplications[index] = updated;
      notifyListeners();
      try {
        await supabaseService.updateVolunteerApplication(updated);
      } catch (e) {
        print('Error updating volunteer application: $e');
      }
    }
  }

  // ============ Donations (LOCAL ONLY — for show, not wired to backend) ============
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

  // ============ Organiser Application ============
  OrganiserApplication? _currentOrganiserApp;
  OrganiserApplication? get currentOrganiserApp => _currentOrganiserApp;

  // ADDED: pulls the real application status/officer assignment for
  // application_status_screen.dart instead of showing hardcoded data.
  // Requires adding `getOrganiserApplication` to SupabaseService.
  Future<void> _loadOrganiserApplication() async {
    try {
      final app = await supabaseService.getOrganiserApplication(_user.id);
      _currentOrganiserApp = app;
      notifyListeners();
    } catch (e) {
      print('Error loading organiser application: $e');
    }
  }

  // CHANGED: now async and actually submits to Supabase (via the
  // submit-organiser-application Edge Function), instead of just
  // storing locally. Requires adding `submitOrganiserApplication`
  // to SupabaseService.
  Future<void> submitOrganiserApplication(OrganiserApplication app) async {
    try {
      final created = await supabaseService.submitOrganiserApplication(app);
      _currentOrganiserApp = created;
      _user = _user.copyWith(role: UserRole.organiser);
      notifyListeners();
    } catch (e) {
      print('Error submitting organiser application: $e');
      rethrow; // let the screen show an error SnackBar
    }
  }

  @override
  void dispose() {
    _facilitiesChannel?.unsubscribe();
    super.dispose();
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