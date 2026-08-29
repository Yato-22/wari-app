import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../models/camp_facility.dart';
import '../models/issue_report.dart';

class MyCampManagementScreen extends StatefulWidget {
  const MyCampManagementScreen({super.key});

  @override
  State<MyCampManagementScreen> createState() => _MyCampManagementScreenState();
}

class _MyCampManagementScreenState extends State<MyCampManagementScreen> {
  FacilityStatus _campStatus = FacilityStatus.open;
  int _currentOccupancy = 850;
  final int _maxCapacity = 1200;

  final List<IssueReport> _campIssues = [
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
      id: '#REP-9014',
      campId: 'camp-001',
      campName: 'Vitthal Rukmini Anna Chhatra',
      category: IssueCategory.sanitation,
      description: 'Handwash sanitizer bottle needs replacement at dining entrance.',
      severity: IssueSeverity.low,
      status: IssueStatus.pending,
      createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
    ),
  ];

  final List<Map<String, dynamic>> _volunteerRequests = [
    {
      'id': '#VOL-101',
      'name': 'Ganesh More',
      'role': 'Food Distribution Seva',
      'slot': 'Morning (06:00 AM - 12:00 PM)',
      'status': 'pending',
    },
    {
      'id': '#VOL-102',
      'name': 'Pooja Deshmukh',
      'role': 'First Aid & Blister Care',
      'slot': 'Evening (02:00 PM - 08:00 PM)',
      'status': 'pending',
    },
  ];

  void _resolveIssue(String id) {
    setState(() {
      _campIssues.removeWhere((i) => i.id == id);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        backgroundColor: AppColors.statusOpenText,
        content: Text('Issue marked as resolved! Updated on public map.'),
      ),
    );
  }

  void _handleVolunteer(int index, bool approve) {
    setState(() {
      _volunteerRequests[index]['status'] = approve ? 'approved' : 'rejected';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: approve ? AppColors.statusOpenText : AppColors.secondary,
        content: Text(approve ? 'Volunteer approved!' : 'Volunteer request rejected.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final occupancyPercent = (_currentOccupancy / _maxCapacity).clamp(0.0, 1.0);

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Camp Dashboard',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Camp Header Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.primaryContainer.withValues(alpha: 0.3),
                  ),
                  boxShadow: const [AppColors.tactileSaffronShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'CAMP FACILITY ID: #CAMP-001',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 11,
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.statusOpenBg,
                            borderRadius: BorderRadius.circular(9999),
                          ),
                          child: Text(
                            'LIVE ON MAP',
                            style: AppTypography.labelBold.copyWith(
                              fontSize: 10,
                              color: AppColors.statusOpenText,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Vitthal Rukmini Anna Chhatra',
                      style: AppTypography.headlineLg,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Saswad Ghat Stop • Incharge: Vitthal Bhakt (+91 98765 43210)',
                      style: AppTypography.bodySm,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Live Status Switcher (Open / Busy / Closed)
              Text(
                'LIVE CROWD / OPERATIONAL STATUS',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Row(
                  children: [
                    _buildStatusOption(FacilityStatus.open, 'Open', AppColors.statusOpenBg, AppColors.statusOpenText),
                    _buildStatusOption(FacilityStatus.busy, 'Busy', AppColors.statusBusyBg, AppColors.statusBusyText),
                    _buildStatusOption(FacilityStatus.closed, 'Closed', AppColors.statusClosedBg, AppColors.statusClosedText),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Real-time Capacity Slider Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
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
                          'LIVE HEADCOUNT / CAPACITY',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        Text(
                          '$_currentOccupancy / $_maxCapacity',
                          style: AppTypography.headlineLgMobile.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(9999),
                      child: LinearProgressIndicator(
                        value: occupancyPercent,
                        minHeight: 10,
                        backgroundColor: AppColors.surfaceContainerHigh,
                        valueColor: AlwaysStoppedAnimation<Color>(
                          occupancyPercent > 0.85
                              ? AppColors.error
                              : occupancyPercent > 0.6
                                  ? AppColors.primaryContainer
                                  : AppColors.statusOpenText,
                        ),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        OutlinedButton.icon(
                          onPressed: () {
                            if (_currentOccupancy > 50) {
                              setState(() => _currentOccupancy -= 50);
                            }
                          },
                          icon: const Icon(Icons.remove, size: 16),
                          label: const Text('-50'),
                          style: OutlinedButton.styleFrom(minimumSize: const Size(80, 36)),
                        ),
                        OutlinedButton.icon(
                          onPressed: () {
                            if (_currentOccupancy + 50 <= _maxCapacity) {
                              setState(() => _currentOccupancy += 50);
                            }
                          },
                          icon: const Icon(Icons.add, size: 16),
                          label: const Text('+50'),
                          style: OutlinedButton.styleFrom(minimumSize: const Size(80, 36)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Pending Issues Section
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'REPORTED ISSUES (${_campIssues.length})',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              if (_campIssues.isEmpty)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.statusOpenBg,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: AppColors.statusOpenText),
                      const SizedBox(width: 10),
                      Text(
                        'All reported issues resolved! Good job.',
                        style: AppTypography.bodySm.copyWith(color: AppColors.statusOpenText),
                      ),
                    ],
                  ),
                )
              else
                ..._campIssues.map((issue) {
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: AppColors.errorContainer),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              issue.category.label,
                              style: AppTypography.labelBold.copyWith(color: AppColors.error),
                            ),
                            Text(
                              issue.id,
                              style: AppTypography.bodySm.copyWith(fontSize: 11),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(issue.description, style: AppTypography.bodySm),
                        const SizedBox(height: 12),
                        Align(
                          alignment: Alignment.centerRight,
                          child: ElevatedButton.icon(
                            onPressed: () => _resolveIssue(issue.id),
                            icon: const Icon(Icons.check, size: 16),
                            label: const Text('Mark Resolved'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.statusOpenText,
                              foregroundColor: Colors.white,
                              minimumSize: const Size(120, 34),
                              padding: const EdgeInsets.symmetric(horizontal: 12),
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                }),

              const SizedBox(height: 20),

              // Pending Volunteer Applications
              Text(
                'VOLUNTEER REQUESTS',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              ...List.generate(_volunteerRequests.length, (index) {
                final req = _volunteerRequests[index];
                final isPending = req['status'] == 'pending';

                return Container(
                  margin: const EdgeInsets.only(bottom: 12),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            req['name'],
                            style: AppTypography.headlineLgMobile.copyWith(fontSize: 16),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: isPending ? AppColors.statusBusyBg : AppColors.statusOpenBg,
                              borderRadius: BorderRadius.circular(9999),
                            ),
                            child: Text(
                              req['status'].toString().toUpperCase(),
                              style: AppTypography.labelBold.copyWith(
                                fontSize: 10,
                                color: isPending ? AppColors.statusBusyText : AppColors.statusOpenText,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(req['role'], style: AppTypography.bodySm),
                      Text(req['slot'], style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant, fontSize: 11)),
                      if (isPending) ...[
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            OutlinedButton(
                              onPressed: () => _handleVolunteer(index, false),
                              style: OutlinedButton.styleFrom(
                                minimumSize: const Size(80, 32),
                                foregroundColor: AppColors.error,
                                side: const BorderSide(color: AppColors.error),
                              ),
                              child: const Text('Reject'),
                            ),
                            const SizedBox(width: 8),
                            ElevatedButton(
                              onPressed: () => _handleVolunteer(index, true),
                              style: ElevatedButton.styleFrom(
                                minimumSize: const Size(80, 32),
                                backgroundColor: AppColors.statusOpenText,
                                foregroundColor: Colors.white,
                              ),
                              child: const Text('Approve'),
                            ),
                          ],
                        ),
                      ],
                    ],
                  ),
                );
              }),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatusOption(FacilityStatus status, String label, Color bg, Color text) {
    final isSelected = _campStatus == status;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          setState(() {
            _campStatus = status;
          });
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: text,
              content: Text('Camp status updated to "$label" on live map'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: isSelected ? bg : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected ? text : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Center(
            child: Text(
              label,
              style: AppTypography.labelBold.copyWith(
                color: isSelected ? text : AppColors.onSurfaceVariant,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

