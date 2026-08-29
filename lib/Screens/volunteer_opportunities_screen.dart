import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../models/volunteer_opportunity.dart';
import '../navigation/app_routes.dart';

class VolunteerOpportunitiesScreen extends StatelessWidget {
  const VolunteerOpportunitiesScreen({super.key});

  final List<VolunteerOpportunity> _opportunities = const [
    VolunteerOpportunity(
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
    VolunteerOpportunity(
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
    VolunteerOpportunity(
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Volunteer Seva / स्वयंसेवक',
        showBackButton: false,
        showSosButton: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header Banner
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.secondary.withValues(alpha: 0.3)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.volunteer_activism, color: AppColors.secondary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Serve the Warkaris with Devotion',
                            style: AppTypography.labelBold.copyWith(
                              color: AppColors.secondary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Select a camp below to register as an on-ground volunteer.',
                            style: AppTypography.bodySm.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Opportunities List
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                itemCount: _opportunities.length,
                separatorBuilder: (_, __) => const SizedBox(height: 14),
                itemBuilder: (context, index) {
                  final opp = _opportunities[index];
                  final slotsRemaining = opp.slotsTotal - opp.slotsFilled;

                  return Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: AppColors.primaryContainer.withValues(alpha: 0.3),
                      ),
                      boxShadow: const [AppColors.tactileSaffronShadow],
                    ),
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                opp.campName,
                                style: AppTypography.labelBold.copyWith(
                                  color: AppColors.primary,
                                  fontSize: 11,
                                ),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: slotsRemaining > 5
                                    ? AppColors.statusOpenBg
                                    : AppColors.statusBusyBg,
                                borderRadius: BorderRadius.circular(9999),
                              ),
                              child: Text(
                                '$slotsRemaining slots left',
                                style: AppTypography.labelBold.copyWith(
                                  fontSize: 10,
                                  color: slotsRemaining > 5
                                      ? AppColors.statusOpenText
                                      : AppColors.statusBusyText,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          opp.title,
                          style: AppTypography.headlineLgMobile.copyWith(
                            fontSize: 17,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            const Icon(Icons.location_on, size: 14, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                opp.location,
                                style: AppTypography.bodySm.copyWith(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule, size: 14, color: AppColors.onSurfaceVariant),
                            const SizedBox(width: 4),
                            Text(
                              opp.shiftTime,
                              style: AppTypography.bodySm.copyWith(fontSize: 12),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        const Divider(height: 1),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Meals & Stay Included',
                              style: AppTypography.labelBold.copyWith(
                                color: AppColors.secondary,
                                fontSize: 11,
                              ),
                            ),
                            ElevatedButton.icon(
                              onPressed: () {
                                Navigator.of(context).pushNamed(
                                  AppRoutes.volunteerDetailApply,
                                  arguments: {'opportunityId': opp.id},
                                );
                              },
                              icon: const Icon(Icons.arrow_forward, size: 16),
                              label: const Text('View Details & Apply'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: AppColors.primary,
                                foregroundColor: AppColors.onPrimary,
                                minimumSize: const Size(140, 36),
                                padding: const EdgeInsets.symmetric(horizontal: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 1),
    );
  }
}

