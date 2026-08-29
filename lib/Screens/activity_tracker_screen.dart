import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../models/issue_report.dart';
import '../models/volunteer_opportunity.dart';
import '../models/donation_model.dart';
import '../navigation/app_routes.dart';

class ActivityTrackerScreen extends StatefulWidget {
  final int initialTabIndex;

  const ActivityTrackerScreen({super.key, this.initialTabIndex = 0});

  @override
  State<ActivityTrackerScreen> createState() => _ActivityTrackerScreenState();
}

class _ActivityTrackerScreenState extends State<ActivityTrackerScreen> {
  late int _activeTab;

  final List<IssueReport> _reports = [
    IssueReport(
      id: '#REP-8942',
      campId: 'camp-001',
      campName: 'Vitthal Rukmini Anna Chhatra',
      category: IssueCategory.waterShortage,
      description: 'Water dispenser 2 has low pressure and requires immediate tank refill.',
      severity: IssueSeverity.medium,
      status: IssueStatus.inProgress,
      createdAt: DateTime.now().subtract(const Duration(minutes: 45)),
    ),
    IssueReport(
      id: '#REP-7621',
      campId: 'camp-002',
      campName: 'Shree Medical Seva Camp',
      category: IssueCategory.crowdBlockage,
      description: 'Queue blockage near emergency blister care counter resolved by sevadharis.',
      severity: IssueSeverity.low,
      status: IssueStatus.resolved,
      createdAt: DateTime.now().subtract(const Duration(hours: 3)),
    ),
    IssueReport(
      id: '#REP-9014',
      campId: 'camp-004',
      campName: 'Pandharpur Seva Sanitation Camp',
      category: IssueCategory.sanitation,
      description: 'Sanitizer dispenser refill requested at main entrance.',
      severity: IssueSeverity.low,
      status: IssueStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  final List<VolunteerApplication> _volunteerApps = [
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
      applicantName: 'Vitthal Bhakt',
      applicantPhone: '+91 98765 43210',
      selectedSlot: 'Evening Shift (02:00 PM - 08:00 PM)',
      experience: 'Certified in Red Cross First Aid.',
      status: VolunteerStatus.pending,
      appliedAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
  ];

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
      donorName: 'Vitthal Bhakt',
      donorPhone: '+91 98765 43210',
      paymentMode: 'PhonePe UPI',
      timestamp: DateTime.now().subtract(const Duration(days: 4)),
      isAnonymous: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _activeTab = widget.initialTabIndex;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'My Activity Tracker',
        showBackButton: false,
        showSosButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Segmented Tab Bar
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    _buildTabButton(0, 'My Reports (${_reports.length})'),
                    _buildTabButton(1, 'Volunteering (${_volunteerApps.length})'),
                    _buildTabButton(2, 'Donations (${_donations.length})'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Tab Content
            Expanded(
              child: IndexedStack(
                index: _activeTab,
                children: [
                  _buildReportsList(),
                  _buildVolunteeringList(),
                  _buildDonationsList(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: _activeTab == 0
          ? FloatingActionButton.extended(
              onPressed: () {
                Navigator.of(context).pushNamed(AppRoutes.reportIssue);
              },
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              icon: const Icon(Icons.add_alert),
              label: const Text('Report New Issue'),
            )
          : null,
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 2),
    );
  }

  Widget _buildTabButton(int index, String label) {
    final isSelected = _activeTab == index;
    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _activeTab = index;
          });
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected
                ? AppColors.surfaceContainerLowest
                : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: isSelected ? const [AppColors.tactileSaffronShadow] : [],
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.labelBold.copyWith(
              fontSize: 12,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildReportsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _reports.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final report = _reports[index];
        Color statusBg;
        Color statusText;
        switch (report.status) {
          case IssueStatus.resolved:
            statusBg = AppColors.statusOpenBg;
            statusText = AppColors.statusOpenText;
            break;
          case IssueStatus.inProgress:
            statusBg = AppColors.statusBusyBg;
            statusText = AppColors.statusBusyText;
            break;
          case IssueStatus.pending:
          case IssueStatus.underReview:
            statusBg = AppColors.primaryContainer.withValues(alpha: 0.2);
            statusText = AppColors.primary;
            break;
        }

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            boxShadow: const [AppColors.tactileSaffronShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    report.id,
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: statusBg,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      report.status.label.toUpperCase(),
                      style: AppTypography.labelBold.copyWith(
                        fontSize: 10,
                        color: statusText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                report.campName,
                style: AppTypography.headlineLgMobile.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                report.description,
                style: AppTypography.bodySm,
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  const Icon(Icons.access_time, size: 14, color: AppColors.onSurfaceVariant),
                  const SizedBox(width: 4),
                  Text(
                    'Reported 45 mins ago',
                    style: AppTypography.labelBold.copyWith(
                      fontSize: 11,
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildVolunteeringList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _volunteerApps.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final app = _volunteerApps[index];
        final isApproved = app.status == VolunteerStatus.approved;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            boxShadow: const [AppColors.tactileSaffronShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    app.id,
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: isApproved ? AppColors.statusOpenBg : AppColors.statusBusyBg,
                      borderRadius: BorderRadius.circular(9999),
                    ),
                    child: Text(
                      app.status.label.toUpperCase(),
                      style: AppTypography.labelBold.copyWith(
                        fontSize: 10,
                        color: isApproved ? AppColors.statusOpenText : AppColors.statusBusyText,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                app.roleTitle,
                style: AppTypography.headlineLgMobile.copyWith(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text(app.campName, style: AppTypography.bodySm),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.schedule, size: 16, color: AppColors.primary),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        app.selectedSlot,
                        style: AppTypography.labelBold.copyWith(fontSize: 11),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDonationsList() {
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      itemCount: _donations.length,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final don = _donations[index];

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
            boxShadow: const [AppColors.tactileSaffronShadow],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    don.id,
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
                  Text(
                    '₹${don.amount.toInt()}',
                    style: AppTypography.headlineLgMobile.copyWith(
                      color: AppColors.secondary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                don.campName,
                style: AppTypography.headlineLgMobile.copyWith(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 4),
              Text('Mode: ${don.paymentMode}', style: AppTypography.bodySm),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Receipt available',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontSize: 11,
                    ),
                  ),
                  TextButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Downloading 80G tax receipt for ${don.id}...')),
                      );
                    },
                    icon: const Icon(Icons.download, size: 16),
                    label: const Text('Download Receipt'),
                    style: TextButton.styleFrom(
                      foregroundColor: AppColors.primary,
                      padding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

