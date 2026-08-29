import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../navigation/app_routes.dart';
import '../models/app_state.dart';
import '../models/organiser_app_model.dart';

class OrganiserApplicationStep2Screen extends StatefulWidget {
  const OrganiserApplicationStep2Screen({super.key});

  @override
  State<OrganiserApplicationStep2Screen> createState() => _OrganiserApplicationStep2ScreenState();
}

class _OrganiserApplicationStep2ScreenState extends State<OrganiserApplicationStep2Screen> {
  final TextEditingController _facilityNameController = TextEditingController(text: 'Vitthal Rukmini Anna Chhatra');
  final TextEditingController _capacityController = TextEditingController(text: '1200');
  final TextEditingController _addressController = TextEditingController(text: 'Survey No. 45, Alandi-Pandharpur Palkhi Marg, Saswad');
  final TextEditingController _emergencyContactController = TextEditingController(text: '9822011223');
  final TextEditingController _gpsController = TextEditingController(text: '18.5204° N, 73.8567° E');

  String _selectedRouteStop = 'Saswad Ghat Stop (Pune Route)';
  final List<String> _routeStops = [
    'Alandi / Dehu Starting Point',
    'Pune City Halting Point',
    'Saswad Ghat Stop (Pune Route)',
    'Jejuri Bypass Stop',
    'Valhe Village Halt',
    'Lonand Phata',
    'Taradgaon Camp Ground',
    'Phaltan Bypass',
    'Barad Camp Zone',
    'Natepute Stop',
    'Malshiras Halt',
    'Velapur Camp Area',
    'Bhandishegaon Stop',
    'Wakhari Camp Final Halt',
    'Pandharpur Temple Premises',
  ];

  final Map<String, bool> _services = {
    'Anna Chhatra (Hot Mahaprasad)': true,
    'RO Filtered Drinking Water': true,
    'First Aid & Emergency Medical': true,
    'Resting Hall & Shelter': true,
    'Clean Washrooms & Mobile Toilets': false,
  };

  bool _agreeTerms = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _facilityNameController.dispose();
    _capacityController.dispose();
    _addressController.dispose();
    _emergencyContactController.dispose();
    _gpsController.dispose();
    super.dispose();
  }

  void _submitApplication() async {
    if (!_agreeTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the verification terms')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final appState = AppStateScope.of(context);
      
      final application = OrganiserApplication(
        id: '',
        organiserName: appState.user.name.isEmpty ? 'Applicant Name' : appState.user.name,
        trustName: 'Demo Trust', // Should be passed from Step 1, using mock
        registrationNumber: 'REG-1234',
        phone: appState.user.phone,
        email: 'org@example.com',
        idProofType: 'Aadhaar Card',
        facilityName: _facilityNameController.text,
        serviceTypes: _services.entries.where((e) => e.value).map((e) => e.key).toList(),
        capacity: int.tryParse(_capacityController.text) ?? 100,
        routeStop: _selectedRouteStop,
        locationAddress: _addressController.text,
        latitude: 18.5204, // Derived from GPS controller in real app
        longitude: 73.8567,
        emergencyContactOnSite: _emergencyContactController.text,
        status: OrganiserAppStatus.submitted,
        submittedAt: DateTime.now(),
      );

      await appState.submitOrganiserApplication(application);

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pushReplacementNamed(
          AppRoutes.applicationSubmitted,
          arguments: {
            'appId': appState.currentOrganiserApp?.id ?? '#WARI-ORG-PENDING',
          },
        );
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to submit application: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Organiser Application (2/2)',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar (100%)
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      height: 6,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'STEP 2 OF 2: FACILITY & LOCATION DETAILS',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.primary,
                  fontSize: 11,
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
                      label: 'FACILITY / SEVA CAMP NAME *',
                      controller: _facilityNameController,
                      prefixIcon: const Icon(Icons.campaign, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'SERVICES PROVIDED *',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    ..._services.keys.map((serviceKey) {
                      return CheckboxListTile(
                        value: _services[serviceKey],
                        activeColor: AppColors.primary,
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(serviceKey, style: AppTypography.bodySm),
                        onChanged: (val) {
                          setState(() {
                            _services[serviceKey] = val ?? false;
                          });
                        },
                      );
                    }),
                    const SizedBox(height: 12),
                    CustomTextField(
                      label: 'DAILY CAPACITY (PILGRIMS PER DAY) *',
                      controller: _capacityController,
                      keyboardType: TextInputType.number,
                      prefixIcon: const Icon(Icons.groups, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'PALKHI ROUTE STOP / मुक्काम किंवा टप्पा *',
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
                        child: DropdownButton<String>(
                          value: _selectedRouteStop,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more, color: AppColors.primary),
                          items: _routeStops.map((stop) {
                            return DropdownMenuItem(
                              value: stop,
                              child: Text(stop, style: AppTypography.bodySm),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedRouteStop = val);
                          },
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'EXACT LANDMARK & ADDRESS *',
                      controller: _addressController,
                      maxLines: 2,
                      prefixIcon: const Icon(Icons.pin_drop, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'GPS COORDINATES',
                          style: AppTypography.labelBold.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                        TextButton.icon(
                          onPressed: () {
                            setState(() {
                              _gpsController.text = '18.5204° N, 73.8567° E (Acquired)';
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('GPS coordinates captured from device!')),
                            );
                          },
                          icon: const Icon(Icons.my_location, size: 16),
                          label: const Text('Use Current Location'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.primary,
                            padding: EdgeInsets.zero,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    TextField(
                      controller: _gpsController,
                      decoration: const InputDecoration(
                        prefixIcon: Icon(Icons.location_searching, color: AppColors.primary),
                      ),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'ON-SITE EMERGENCY CONTACT NUMBER *',
                      controller: _emergencyContactController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone_in_talk, color: AppColors.error),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Agreement Checkbox
              CheckboxListTile(
                value: _agreeTerms,
                activeColor: AppColors.primary,
                contentPadding: EdgeInsets.zero,
                title: const Text(
                  'I verify that the information provided is accurate and agree to abide by government health & safety pilgrimage norms.',
                  style: AppTypography.bodySm,
                ),
                onChanged: (val) => setState(() => _agreeTerms = val ?? false),
              ),

              const SizedBox(height: 24),

              CustomButton(
                label: 'Submit Application',
                icon: Icons.arrow_forward,
                iconTrailing: true,
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
}

