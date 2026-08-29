import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../navigation/app_routes.dart';

class VolunteerDetailApplyScreen extends StatefulWidget {
  final String opportunityId;

  const VolunteerDetailApplyScreen({super.key, required this.opportunityId});

  @override
  State<VolunteerDetailApplyScreen> createState() => _VolunteerDetailApplyScreenState();
}

class _VolunteerDetailApplyScreenState extends State<VolunteerDetailApplyScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _expController = TextEditingController(text: 'Served in 2024 and 2025 Wari at Saswad food camp.');
  String _selectedSlot = 'Morning Shift (06:00 AM - 12:00 PM)';
  bool _isLoading = false;

  final List<String> _slots = [
    'Morning Shift (06:00 AM - 12:00 PM)',
    'Afternoon Shift (12:00 PM - 06:00 PM)',
    'Night Shift (06:00 PM - 12:00 AM)',
    'Full Day Dedicated Seva (24h rotational)',
  ];

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _expController.dispose();
    super.dispose();
  }

  void _submitApplication() {
    if (_nameController.text.trim().isEmpty || _phoneController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required fields')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
                    color: AppColors.statusOpenBg,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.check_circle, color: AppColors.statusOpenText, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text('Application Submitted!', style: AppTypography.headlineLgMobile),
                ),
              ],
            ),
            content: const Text(
              'Your volunteer seva application has been submitted to the camp coordinator. You will receive an SMS confirmation once approved.',
              style: AppTypography.bodyMd,
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pushReplacementNamed(
                    AppRoutes.activityTracker,
                    arguments: {'tabIndex': 1},
                  );
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('View Status'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Volunteer Details & Apply',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header Card
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
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.primaryContainer.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                      child: Text(
                        'Sant Dnyaneshwar Water Point',
                        style: AppTypography.labelBold.copyWith(color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Text(
                      'Water Distribution Network',
                      style: AppTypography.headlineLg,
                    ),
                    const SizedBox(height: 12),
                    _buildInfoRow(Icons.location_on, 'Location', 'Valhe Village Chowk, Pune Route'),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.event, 'Dates', 'July 10 - July 15, 2026'),
                    const SizedBox(height: 8),
                    _buildInfoRow(Icons.group, 'Capacity', '18 of 25 Volunteer Slots Filled'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Duties & Requirements
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'KEY RESPONSIBILITIES',
                      style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 8),
                    _buildBullet('Distribute clean drinking water pouches to walking pilgrims.'),
                    _buildBullet('Assist elderly Warkaris and differently-abled devotees.'),
                    _buildBullet('Keep water stall surroundings clean and sanitized.'),
                    const Divider(height: 24),
                    Text(
                      'SEVA PERKS & ACCOMMODATION',
                      style: AppTypography.labelBold.copyWith(color: AppColors.secondary),
                    ),
                    const SizedBox(height: 8),
                    _buildBullet('Free Mahaprasad (Hot meals) & Resting Quarters provided.'),
                    _buildBullet('Official WariConnect Volunteer Seva Certificate & Badge.'),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Application Form
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.primaryContainer),
                  boxShadow: const [AppColors.tactileSaffronShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'APPLICATION DETAILS',
                      style: AppTypography.labelBold.copyWith(color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'APPLICANT NAME',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'CONTACT NUMBER',
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter 10-digit mobile number',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                    ),
                    const SizedBox(height: 14),
                    Text(
                      'PREFERRED SHIFT TIME',
                      style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedSlot,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more, color: AppColors.primary),
                          items: _slots.map((slot) {
                            return DropdownMenuItem(
                              value: slot,
                              child: Text(slot, style: AppTypography.bodySm),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedSlot = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    CustomTextField(
                      label: 'PRIOR EXPERIENCE / NOTES',
                      controller: _expController,
                      maxLines: 3,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              CustomButton(
                label: 'Submit Application',
                icon: Icons.check_circle,
                isLoading: _isLoading,
                onPressed: _submitApplication,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          '$label: ',
          style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant, fontSize: 12),
        ),
        Expanded(
          child: Text(
            value,
            style: AppTypography.bodySm.copyWith(fontWeight: FontWeight.w600, color: AppColors.onSurface),
          ),
        ),
      ],
    );
  }

  Widget _buildBullet(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('• ', style: TextStyle(color: AppColors.primary, fontSize: 16, fontWeight: FontWeight.bold)),
          Expanded(child: Text(text, style: AppTypography.bodySm)),
        ],
      ),
    );
  }
}

