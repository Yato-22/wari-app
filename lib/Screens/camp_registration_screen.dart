import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../models/camp_facility.dart';
import '../navigation/app_routes.dart';

class CampRegistrationScreen extends StatefulWidget {
  const CampRegistrationScreen({super.key});

  @override
  State<CampRegistrationScreen> createState() => _CampRegistrationScreenState();
}

class _CampRegistrationScreenState extends State<CampRegistrationScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _capacityController = TextEditingController(text: '500');
  final TextEditingController _inchargeController = TextEditingController(text: 'Vitthal Bhakt');
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');

  FacilityType _selectedType = FacilityType.food;
  bool _is24Hours = true;
  bool _isLoading = false;

  final Map<String, bool> _amenities = {
    'RO Filtered Water': true,
    'Resting Mats & Cots': true,
    'Mobile Phone Charging Point': true,
    'First Aid Emergency Box': true,
    'Clean Washrooms for Women': false,
  };

  @override
  void dispose() {
    _nameController.dispose();
    _locationController.dispose();
    _capacityController.dispose();
    _inchargeController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _registerCamp() {
    if (_nameController.text.trim().isEmpty || _locationController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter facility name and location')),
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

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.statusOpenText,
            content: Text('Camp Facility registered and added to live map!'),
          ),
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.myCampManagement);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Register Camp Facility',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header description card
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: AppColors.primaryContainer.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.primaryContainer),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.add_location_alt, color: AppColors.primary, size: 28),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Add Facility to Pilgrimage Map',
                            style: AppTypography.labelBold.copyWith(
                              color: AppColors.primary,
                              fontSize: 13,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Provide camp details so pilgrims along the route can locate and access your seva.',
                            style: AppTypography.bodySm.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Form Container
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                  boxShadow: const [AppColors.tactileSaffronShadow],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CustomTextField(
                      label: 'FACILITY NAME / केंद्राचे नाव *',
                      hintText: 'e.g. Sant Tukaram Anna Chhatra',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.campaign, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'FACILITY TYPE / प्रकार *',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
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
                        child: DropdownButton<FacilityType>(
                          value: _selectedType,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more, color: AppColors.primary),
                          items: const [
                            DropdownMenuItem(value: FacilityType.food, child: Text('Anna Chhatra (Food Seva)')),
                            DropdownMenuItem(value: FacilityType.water, child: Text('Drinking Water Point')),
                            DropdownMenuItem(value: FacilityType.medical, child: Text('Medical & First Aid Camp')),
                            DropdownMenuItem(value: FacilityType.toilet, child: Text('Mobile Toilets & Sanitation')),
                            DropdownMenuItem(value: FacilityType.shelter, child: Text('Resting Hall & Shelter')),
                          ],
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedType = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'LOCATION & HIGHWAY MARK *',
                      hintText: 'e.g. Saswad - Jejuri Road, KM 38',
                      controller: _locationController,
                      prefixIcon: const Icon(Icons.pin_drop, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'DAILY PILGRIM CAPACITY *',
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.groups, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    SwitchListTile(
                      value: _is24Hours,
                      activeThumbColor: AppColors.primary,
                      contentPadding: EdgeInsets.zero,
                      title: const Text('Open 24x7 during Palkhi', style: AppTypography.bodyMd),
                      onChanged: (val) => setState(() => _is24Hours = val),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'AMENITIES PROVIDED',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ..._amenities.keys.map((key) {
                      return CheckboxListTile(
                        value: _amenities[key],
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(key, style: AppTypography.bodySm),
                        onChanged: (val) {
                          setState(() {
                            _amenities[key] = val ?? false;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'CAMP IN-CHARGE NAME',
                      controller: _inchargeController,
                      prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'CONTACT NUMBER',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              CustomButton(
                label: 'Register Facility',
                icon: Icons.add_location_alt,
                isLoading: _isLoading,
                onPressed: _registerCamp,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}
