import 'package:flutter/material.dart';
import '../models/app_state.dart';
import '../theme/app_colors.dart';
import '../Screens/language_selection_screen.dart';
import '../Screens/login_otp_screen.dart';
import '../Screens/role_selection_screen.dart';
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
  static const String roleSelection = '/role_selection';
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

  static Route<dynamic> _protectedRoute({
    required WidgetBuilder builder,
    String message = 'Please log in to use this feature.',
  }) {
    return MaterialPageRoute(
      builder: (context) {
        final appState = AppStateScope.of(context);
        if (appState.isGuest) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(message),
                backgroundColor: AppColors.primary,
                duration: const Duration(seconds: 2),
              ),
            );
          });
          return const LoginOtpScreen();
        }
        return builder(context);
      },
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case language:
        return MaterialPageRoute(builder: (_) => const LanguageSelectionScreen());
      case loginOtp:
        return MaterialPageRoute(builder: (_) => const LoginOtpScreen());
      case roleSelection:
        return MaterialPageRoute(builder: (_) => const RoleSelectionScreen());
      case homeMap:
        return MaterialPageRoute(builder: (_) => const HomeMapScreen());
      case profileGuest:
        return MaterialPageRoute(builder: (_) => const ProfileGuestScreen());
      case profileLoggedIn:
        return MaterialPageRoute(
          builder: (context) {
            final appState = AppStateScope.of(context);
            if (appState.isGuest) {
              return const ProfileGuestScreen();
            }
            return const ProfileLoggedInScreen();
          },
        );
      case profileOrgManagement:
        return _protectedRoute(
          builder: (_) => const ProfileOrgManagementScreen(),
          message: 'Please log in to access organiser management.',
        );
      case profileOrgDonation:
        return _protectedRoute(
          builder: (_) => const ProfileOrgDonationScreen(),
          message: 'Please log in to view organiser donations.',
        );
      case editProfile:
        return _protectedRoute(
          builder: (_) => const EditProfileScreen(),
          message: 'Please log in to edit your profile.',
        );
      case emergencySos:
        return MaterialPageRoute(builder: (_) => const EmergencySosScreen());
      case reportIssue:
        final args = settings.arguments as Map<String, dynamic>?;
        return _protectedRoute(
          builder: (_) => ReportIssueScreen(
            preselectedCampId: args?['campId'] as String?,
          ),
          message: 'Please log in to report an issue.',
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
        return _protectedRoute(
          builder: (_) => ActivityTrackerScreen(
            initialTabIndex: args?['tabIndex'] as int? ?? 0,
          ),
          message: 'Please log in to view your activity.',
        );
      case donateMoney:
        final args = settings.arguments as Map<String, dynamic>?;
        return MaterialPageRoute(
          builder: (_) => DonateMoneyScreen(
            campName: args?['campName'] as String? ?? 'Vitthal Rukmini Anna Chhatra',
          ),
        );
      case volunteerOpportunities:
        return _protectedRoute(
          builder: (_) => const VolunteerOpportunitiesScreen(),
          message: 'Please log in to access volunteer opportunities.',
        );
      case volunteerDetailApply:
        final args = settings.arguments as Map<String, dynamic>?;
        return _protectedRoute(
          builder: (_) => VolunteerDetailApplyScreen(
            opportunityId: args?['opportunityId'] as String? ?? 'vol-001',
          ),
          message: 'Please log in to apply for volunteering.',
        );
      case becomeCampOrganiser:
        return _protectedRoute(
          builder: (_) => const BecomeCampOrganiserScreen(),
          message: 'Please log in to apply as a camp organiser.',
        );
      case organiserAppStep1:
        return _protectedRoute(
          builder: (_) => const OrganiserApplicationStep1Screen(),
          message: 'Please log in to apply as a camp organiser.',
        );
      case organiserAppStep2:
        return _protectedRoute(
          builder: (_) => const OrganiserApplicationStep2Screen(),
          message: 'Please log in to apply as a camp organiser.',
        );
      case applicationSubmitted:
        final args = settings.arguments as Map<String, dynamic>?;
        return _protectedRoute(
          builder: (_) => ApplicationSubmittedScreen(
            appId: args?['appId'] as String? ?? '#WARI-ORG-2026-7891',
          ),
        );
      case applicationStatus:
        return _protectedRoute(
          builder: (_) => const ApplicationStatusScreen(),
          message: 'Please log in to check your application status.',
        );
      case campRegistration:
        return _protectedRoute(
          builder: (_) => const CampRegistrationScreen(),
          message: 'Please log in to register a camp.',
        );
      case myCampManagement:
        return _protectedRoute(
          builder: (_) => const MyCampManagementScreen(),
          message: 'Please log in to manage your camp.',
        );
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

