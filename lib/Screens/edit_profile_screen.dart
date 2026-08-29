import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../models/app_state.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emergencyContactController = TextEditingController();
  final TextEditingController _dindiController = TextEditingController();
  String _selectedBloodGroup = 'O+';
  bool _isLoading = false;
  bool _initialized = false;

  final List<String> _bloodGroups = ['A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      final user = AppStateScope.of(context).user;
      if (user.name.isNotEmpty) _nameController.text = user.name;
      if (user.phone.isNotEmpty) {
        _phoneController.text = user.phone.replaceAll(RegExp(r'\D'), '');
      }
      if (user.emergencyContact.isNotEmpty) {
        _emergencyContactController.text = user.emergencyContact.replaceAll(RegExp(r'\D'), '');
      }
      if (user.dindiNumber.isNotEmpty) _dindiController.text = user.dindiNumber;
      if (user.bloodGroup.isNotEmpty) _selectedBloodGroup = user.bloodGroup;
      _initialized = true;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emergencyContactController.dispose();
    _dindiController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    setState(() {
      _isLoading = true;
    });

    final appState = AppStateScope.of(context);
    final user = appState.user;
    final updated = user.copyWith(
      name: _nameController.text.trim(),
      phone: _phoneController.text.trim(),
      emergencyContact: _emergencyContactController.text.trim(),
      dindiNumber: _dindiController.text.trim(),
      bloodGroup: _selectedBloodGroup,
    );
    appState.updateUserProfile(updated);

    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.statusOpenText,
            content: Text('Profile changes saved successfully!'),
          ),
        );
        Navigator.of(context).pop();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Edit Profile',
        showBackButton: true,
        showSosButton: false,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Avatar Change Section
              Center(
                child: Stack(
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.primary, width: 3),
                        image: const DecorationImage(
                          image: NetworkImage(
                            'https://images.unsplash.com/photo-1534528741775-53994a69daeb?w=200&auto=format&fit=crop&q=80',
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          color: AppColors.primary,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                        ),
                        child: const Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),
              Center(
                child: TextButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Photo picker opened')),
                    );
                  },
                  child: Text(
                    'Change Photo',
                    style: AppTypography.labelBold.copyWith(
                      color: AppColors.primary,
                    ),
                  ),
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
                      label: 'FULL NAME / पूर्ण नाव',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'PHONE NUMBER / मोबाईल क्रमांक',
                      controller: _phoneController,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter 10-digit mobile number',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'EMERGENCY CONTACT NUMBER / आपत्कालीन संपर्क',
                      controller: _emergencyContactController,
                      keyboardType: TextInputType.number,
                      hintText: 'Enter 10-digit mobile number',
                      inputFormatters: [
                        FilteringTextInputFormatter.digitsOnly,
                        LengthLimitingTextInputFormatter(10),
                      ],
                      prefixIcon: const Icon(Icons.emergency_outlined, color: AppColors.error),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'DINDI NUMBER / दिंडी क्रमांक व मार्ग',
                      controller: _dindiController,
                      prefixIcon: const Icon(Icons.flag_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'BLOOD GROUP / रक्तगट',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainerLowest,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.outlineVariant),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: _selectedBloodGroup,
                          isExpanded: true,
                          icon: const Icon(Icons.arrow_drop_down, color: AppColors.primary),
                          items: _bloodGroups.map((group) {
                            return DropdownMenuItem(
                              value: group,
                              child: Text(
                                group,
                                style: AppTypography.bodyMd.copyWith(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() {
                                _selectedBloodGroup = val;
                              });
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              CustomButton(
                label: 'Save Changes',
                icon: Icons.save,
                isLoading: _isLoading,
                onPressed: _saveChanges,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

