import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';

class EmergencySosScreen extends StatefulWidget {
  const EmergencySosScreen({super.key});

  @override
  State<EmergencySosScreen> createState() => _EmergencySosScreenState();
}

class _EmergencySosScreenState extends State<EmergencySosScreen> {
  bool _sosBroadcastActive = false;

  void _triggerBroadcast() {
    setState(() {
      _sosBroadcastActive = true;
    });

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: AppColors.errorContainer,
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emergency, color: AppColors.error, size: 28),
            ),
            const SizedBox(width: 12),
            const Expanded(
              child: Text(
                'SOS Alert Broadcasted!',
                style: AppTypography.headlineLgMobile,
              ),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Your GPS live location (18.5204° N, 73.8567° E) has been sent to the nearest Palkhi Disaster Management unit and Police Chowki.',
              style: AppTypography.bodyMd,
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainerLow,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.timer, size: 18, color: AppColors.secondary),
                  const SizedBox(width: 8),
                  Text(
                    'Estimated response: ~4 minutes',
                    style: AppTypography.labelBold.copyWith(color: AppColors.secondary),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.of(ctx).pop(),
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Emergency SOS / आपत्कालीन',
        showBackButton: true,
        showSosButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Urgent Alert Banner & Broadcast Trigger
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.errorContainer,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.error.withValues(alpha: 0.4)),
                ),
                child: Column(
                  children: [
                    const Icon(
                      Icons.warning_amber_rounded,
                      color: AppColors.error,
                      size: 48,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Life Safety & Medical Emergency',
                      textAlign: TextAlign.center,
                      style: AppTypography.headlineLgMobile.copyWith(
                        color: AppColors.onErrorContainer,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Press the button below to instantly broadcast your live coordinates to rapid response teams along the Wari route.',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodySm.copyWith(
                        color: AppColors.onErrorContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Big SOS Pulsing Button
                    GestureDetector(
                      onTap: _triggerBroadcast,
                      child: Container(
                        height: 56,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: AppColors.error,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.error.withValues(alpha: 0.4),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.emergency_share, color: Colors.white, size: 24),
                            const SizedBox(width: 10),
                            Text(
                              _sosBroadcastActive
                                  ? 'SOS SIGNAL ACTIVE'
                                  : 'BROADCAST EMERGENCY SOS',
                              style: AppTypography.labelBold.copyWith(
                                color: Colors.white,
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'QUICK EMERGENCY HOTLINES',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              _buildHotlineCard(
                icon: Icons.local_police,
                title: 'Police Emergency',
                number: '112',
                color: Colors.indigo.shade700,
              ),
              const SizedBox(height: 10),
              _buildHotlineCard(
                icon: Icons.local_hospital,
                title: 'Medical Ambulance',
                number: '108',
                color: AppColors.secondary,
              ),
              const SizedBox(height: 10),
              _buildHotlineCard(
                icon: Icons.support_agent,
                title: 'Wari Disaster Helpline',
                number: '1800-233-1111',
                color: AppColors.primary,
              ),

              const SizedBox(height: 24),

              Text(
                'NEARBY EMERGENCY SERVICES',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 12),

              _buildNearbyServiceCard(
                title: 'Shree Sant Tukaram Medical Base Camp',
                distance: '0.3 km away',
                category: 'Doctor & Trauma Care',
                phone: '+91 94220 55667',
              ),
              const SizedBox(height: 12),
              _buildNearbyServiceCard(
                title: 'Saswad Police Mobile Chowki',
                distance: '0.7 km away',
                category: 'Police & Security Patrol',
                phone: '+91 98220 33445',
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHotlineCard({
    required IconData icon,
    required String title,
    required String number,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: const [AppColors.tactileSaffronShadow],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTypography.labelBold.copyWith(
                    fontSize: 14,
                    color: AppColors.onSurface,
                  ),
                ),
                Text(
                  number,
                  style: AppTypography.headlineLgMobile.copyWith(
                    fontSize: 16,
                    color: color,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  backgroundColor: color,
                  content: Text('Calling $title ($number)...'),
                ),
              );
            },
            icon: const Icon(Icons.call, size: 16),
            label: const Text('Call Now'),
            style: ElevatedButton.styleFrom(
              backgroundColor: color,
              foregroundColor: Colors.white,
              minimumSize: const Size(90, 36),
              padding: const EdgeInsets.symmetric(horizontal: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNearbyServiceCard({
    required String title,
    required String distance,
    required String category,
    required String phone,
  }) {
    return Container(
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
              Expanded(
                child: Text(
                  title,
                  style: AppTypography.headlineLgMobile.copyWith(
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHigh,
                  borderRadius: BorderRadius.circular(9999),
                ),
                child: Text(
                  distance,
                  style: AppTypography.labelBold.copyWith(fontSize: 11),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(category, style: AppTypography.bodySm),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Calling $title at $phone...')),
                    );
                  },
                  icon: const Icon(Icons.call, size: 16),
                  label: const Text('Call Station'),
                  style: OutlinedButton.styleFrom(
                    minimumSize: const Size(0, 38),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Starting GPS navigation to $title...')),
                    );
                  },
                  icon: const Icon(Icons.navigation, size: 16),
                  label: const Text('Navigate'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    minimumSize: const Size(0, 38),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

