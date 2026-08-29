import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';
import '../navigation/app_routes.dart';

class OrganiserApplicationStep1Screen extends StatefulWidget {
  const OrganiserApplicationStep1Screen({super.key});

  @override
  State<OrganiserApplicationStep1Screen> createState() => _OrganiserApplicationStep1ScreenState();
}

class _OrganiserApplicationStep1ScreenState extends State<OrganiserApplicationStep1Screen> {
  final TextEditingController _nameController = TextEditingController(text: 'Vitthal Bhakt');
  final TextEditingController _trustController = TextEditingController(text: 'Shri Vitthal Seva Pratishthan Trust');
  final TextEditingController _regNoController = TextEditingController(text: 'MAH/PUN/2018/9842');
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  final TextEditingController _emailController = TextEditingController(text: 'vitthal.bhakt@warkari.org');
  String _selectedIdType = 'Aadhaar Card';

  final List<String> _idTypes = ['Aadhaar Card', 'PAN Card', 'Trustee Certificate ID', 'Voter ID'];

  @override
  void dispose() {
    _nameController.dispose();
    _trustController.dispose();
    _regNoController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  void _goToStep2() {
    if (_nameController.text.trim().isEmpty || _trustController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all required trust details')),
      );
      return;
    }
    Navigator.of(context).pushNamed(AppRoutes.organiserAppStep2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Organiser Application (1/2)',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Progress Bar
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
                        color: AppColors.outlineVariant.withValues(alpha: 0.5),
                        borderRadius: BorderRadius.circular(9999),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'STEP 1 OF 2: TRUST & ORGANISER DETAILS',
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
                      label: 'ORGANISER / TRUSTEE NAME *',
                      controller: _nameController,
                      prefixIcon: const Icon(Icons.person, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'TRUST / MANDALI / MANDAL NAME *',
                      controller: _trustController,
                      prefixIcon: const Icon(Icons.account_balance, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'TRUST REGISTRATION NUMBER / नोंदणी क्रमांक *',
                      controller: _regNoController,
                      prefixIcon: const Icon(Icons.badge, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'CONTACT NUMBER *',
                      controller: _phoneController,
                      keyboardType: TextInputType.phone,
                      prefixIcon: const Icon(Icons.phone, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    CustomTextField(
                      label: 'OFFICIAL EMAIL ADDRESS',
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      prefixIcon: const Icon(Icons.email_outlined, color: AppColors.primary),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'ID VERIFICATION TYPE *',
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
                          value: _selectedIdType,
                          isExpanded: true,
                          icon: const Icon(Icons.expand_more, color: AppColors.primary),
                          items: _idTypes.map((type) {
                            return DropdownMenuItem(
                              value: type,
                              child: Text(type, style: AppTypography.bodySm),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) setState(() => _selectedIdType = val);
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 28),

              CustomButton(
                label: 'Next Step / पुढील पायरी',
                icon: Icons.arrow_forward,
                iconTrailing: true,
                onPressed: _goToStep2,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}

