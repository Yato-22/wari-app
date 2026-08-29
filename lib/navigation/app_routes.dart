import 'package:flutter/material.dart';
import '../Screens/language_selection_screen.dart';
import '../Screens/login_otp_screen.dart';
import '../Screens/home_map_screen.dart';
import '../Screens/profile_guest_screen.dart';
import '../Screens/profile_logged_in_screen.dart';
import '../Screens/profile_org_management_screen.dart';
import '../Screens/profile_org_donation_screen.dart';
import '../Screens/edit_profile_screen.dart';
import '../Screens/emergency_sos_screen.dart';
import '../Screens/report_issue_screen.dart';
import '../Screens/report_submitted_screen.dart';
import '../Screens/activity_tracker_screen.dart';
import '../Screens/donate_money_screen.dart';
import '../Screens/volunteer_opportunities_screen.dart';
import '../Screens/volunteer_detail_apply_screen.dart';
import '../Screens/become_camp_organiser_screen.dart';
import '../Screens/organiser_application_step1_screen.dart';
import '../Screens/organiser_application_step2_screen.dart';
import '../Screens/application_submitted_screen.dart';
import '../Screens/application_status_screen.dart';
import '../Screens/camp_registration_screen.dart';
import '../Screens/my_camp_management_screen.dart';
import '../Screens/qr_scanner_screen.dart';
import '../Screens/help_and_support_screen.dart';
import '../Screens/about_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const String language = '/language';
  static const String loginOtp = '/login_otp';
  static const String homeMap = '/home_map';
  static const String profileGuest = '/profile_guest';
  static const String profileLoggedIn = '/profile_logged_in';
  static const String profileOrgManagement = '/profile_org_management';
  static const String profileOrgDonation = '/profile_org_donation';
  static const String editProfile = '/edit_profile';
  static const String emergencySos = '/emergency_sos';
  static const String reportIssue = '/report_issue';
  static const String reportSubmitted = '/report_submitted';
  static const String activityTracker = '/activity_tracker';
  static const String donateMoney = '/donate_money';
  static const String volunteerOpportunities = '/volunteer_opportunities';
  static const String volunteerDetailApply = '/volunteer_detail_apply';
  static const String becomeCampOrganiser = '/become_camp_organiser';
  static const String organiserAppStep1 = '/organiser_app_step1';
  static const String organiserAppStep2 = '/organiser_app_step2';
  static const String applicationSubmitted = '/application_submitted';
  static const String applicationStatus = '/application_status';
  static const String campRegistration = '/camp_registration';
  static const String myCampManagement = '/my_camp_management';
  static const String qrScanner = '/qr_scanner';
  static const String helpAndSupport = '/help_and_support';
  static const String about = '/about';

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case language:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
      case loginOtp:
        return MaterialPageRoute(builder: (_) => const LoginOtpScreen());
      case homeMap:
        return MaterialPageRoute(builder: (_) => const HomeMapScreen());
      case profileGuest:
        return MaterialPageRoute(builder: (_) => const ProfileGuestScreen());
      case profileLoggedIn:
        return MaterialPageRoute(builder: (_) => const ProfileLoggedInScreen());
      case profileOrgManagement:
        return MaterialPageRoute(builder: (_) => const ProfileOrgManagementScreen());
      case profileOrgDonation:
        return MaterialPageRoute(builder: (_) => const ProfileOrgDonationScreen());
      case editProfile:
        return MaterialPageRoute(builder: (_) => const EditProfileScreen());
      case emergencySos:
        return MaterialPageRoute(builder: (_) => const EmergencySosScreen());
      case reportIssue:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ReportIssueScreen(
            preselectedCampId: args?['campId'] as String?,
          ),
        );
      case reportSubmitted:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ReportSubmittedScreen(
            reportId: args?['reportId'] as String? ?? '#REP-8942',
            campName: args?['campName'] as String? ?? 'Vitthal Rukmini Anna Chhatra',
          ),
        );
      case activityTracker:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ActivityTrackerScreen(
            initialTabIndex: args?['tabIndex'] as int? ?? 0,
          ),
        );
      case donateMoney:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DonateMoneyScreen(
            campName: args?['campName'] as String? ?? 'Vitthal Rukmini Anna Chhatra',
          ),
        );
      case volunteerOpportunities:
        return MaterialPageRoute(builder: (_) => const VolunteerOpportunitiesScreen());
      case volunteerDetailApply:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => VolunteerDetailApplyScreen(
            opportunityId: args?['opportunityId'] as String? ?? 'vol-001',
          ),
        );
      case becomeCampOrganiser:
        return MaterialPageRoute(builder: (_) => const BecomeCampOrganiserScreen());
      case organiserAppStep1:
        return MaterialPageRoute(builder: (_) => const OrganiserApplicationStep1Screen());
      case organiserAppStep2:
        return MaterialPageRoute(builder: (_) => const OrganiserApplicationStep2Screen());
      case applicationSubmitted:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => ApplicationSubmittedScreen(
            appId: args?['appId'] as String? ?? '#WARI-ORG-2026-7891',
          ),
        );
      case applicationStatus:
        return MaterialPageRoute(builder: (_) => const ApplicationStatusScreen());
      case campRegistration:
        return MaterialPageRoute(builder: (_) => const CampRegistrationScreen());
      case myCampManagement:
        return MaterialPageRoute(builder: (_) => const MyCampManagementScreen());
      case qrScanner:
        return MaterialPageRoute(builder: (_) => const QrScannerScreen());
      case helpAndSupport:
        return MaterialPageRoute(builder: (_) => const HelpAndSupportScreen());
      case about:
        return MaterialPageRoute(builder: (_) => const AboutScreen());
      default:
        return MaterialPageRoute(builder: (_) => const HomeMapScreen());
    }
  }
}

