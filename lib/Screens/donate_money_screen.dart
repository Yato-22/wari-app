import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../widgets/custom_text_field.dart';

class DonateMoneyScreen extends StatefulWidget {
  final String campName;

  const DonateMoneyScreen({
    super.key,
    this.campName = 'Vitthal Rukmini Anna Chhatra',
  });

  @override
  State<DonateMoneyScreen> createState() => _DonateMoneyScreenState();
}

class _DonateMoneyScreenState extends State<DonateMoneyScreen> {
  int _selectedAmount = 1000;
  final TextEditingController _customAmountController = TextEditingController();
  final TextEditingController _donorNameController = TextEditingController(text: 'Vitthal Bhakt');
  final TextEditingController _panController = TextEditingController();

  String _selectedPaymentMethod = 'upi'; // 'upi', 'card', 'netbanking'
  bool _isAnonymous = false;
  bool _taxReceipt = false;
  bool _isLoading = false;

  final List<int> _presetAmounts = [500, 1000, 2000, 5000];

  @override
  void dispose() {
    _customAmountController.dispose();
    _donorNameController.dispose();
    _panController.dispose();
    super.dispose();
  }

  void _processDonation() {
    setState(() {
      _isLoading = true;
    });

    final donationAmount = _customAmountController.text.isNotEmpty
        ? int.tryParse(_customAmountController.text) ?? _selectedAmount
        : _selectedAmount;

    Future.delayed(const Duration(milliseconds: 700), () {
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
                  child: const Icon(Icons.favorite, color: AppColors.secondary, size: 24),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Seva Contribution Received!',
                    style: AppTypography.headlineLgMobile,
                  ),
                ),
              ],
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '₹$donationAmount has been donated to ${widget.campName}. A digital acknowledgement has been sent to your registered number.',
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
                      const Icon(Icons.receipt_long, size: 18, color: AppColors.primary),
                      const SizedBox(width: 8),
                      Text(
                        'Txn ID: #DON-${DateTime.now().millisecondsSinceEpoch.toString().substring(6)}',
                        style: AppTypography.labelBold.copyWith(color: AppColors.primary),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.of(ctx).pop();
                  Navigator.of(context).pop();
                },
                style: ElevatedButton.styleFrom(backgroundColor: AppColors.primary),
                child: const Text('Done'),
              ),
            ],
          ),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final displayAmount = _customAmountController.text.isNotEmpty
        ? (int.tryParse(_customAmountController.text) ?? _selectedAmount)
        : _selectedAmount;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Donate Seva / अन्नदान',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Camp Seva Banner
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
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: AppColors.secondary.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.restaurant, color: AppColors.secondary, size: 24),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                widget.campName,
                                style: AppTypography.headlineLgMobile.copyWith(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              Text(
                                'Food & Water Seva for walking Warkaris',
                                style: AppTypography.bodySm,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'Your contribution helps provide warm meals (Mahaprasad), purified drinking water, and resting mats for over 5,000 devotees daily.',
                      style: AppTypography.bodySm.copyWith(color: AppColors.onSurfaceVariant),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Preset Amount Chips
              Text(
                'SELECT CONTRIBUTION AMOUNT',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: _presetAmounts.map((amount) {
                  final isSelected = _selectedAmount == amount && _customAmountController.text.isEmpty;
                  return Expanded(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: InkWell(
                        onTap: () {
                          setState(() {
                            _selectedAmount = amount;
                            _customAmountController.clear();
                          });
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? AppColors.primaryContainer
                                : AppColors.surfaceContainerLowest,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: isSelected ? AppColors.primary : AppColors.outlineVariant,
                              width: isSelected ? 2 : 1,
                            ),
                          ),
                          child: Center(
                            child: Text(
                              '₹$amount',
                              style: AppTypography.labelBold.copyWith(
                                fontSize: 14,
                                color: isSelected
                                    ? AppColors.onPrimaryContainer
                                    : AppColors.onSurface,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),

              const SizedBox(height: 16),

              // Custom Amount Input
              CustomTextField(
                label: 'OR ENTER CUSTOM AMOUNT (₹)',
                hintText: 'Enter amount in INR (e.g. 5000)',
                controller: _customAmountController,
                keyboardType: TextInputType.number,
                prefixIcon: const Icon(Icons.currency_rupee, color: AppColors.primary),
                onChanged: (_) => setState(() {}),
              ),

              const SizedBox(height: 20),

              // Payment Method Selector
              Text(
                'PAYMENT MODE',
                style: AppTypography.labelBold.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                ),
                child: Column(
                  children: [
                    _buildPaymentOption('upi', 'UPI (GPay / PhonePe / Paytm / BHIM)', Icons.account_balance_wallet_outlined),
                    const Divider(height: 1),
                    _buildPaymentOption('card', 'Credit / Debit Card (Visa / MasterCard / RuPay)', Icons.credit_card),
                    const Divider(height: 1),
                    _buildPaymentOption('netbanking', 'Net Banking (All Indian Banks)', Icons.account_balance),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Preferences & 80G Tax Exemption
              CheckboxListTile(
                value: _isAnonymous,
                activeColor: AppColors.primary,
                title: const Text('Make this donation anonymous', style: AppTypography.bodySm),
                onChanged: (val) => setState(() => _isAnonymous = val ?? false),
              ),
              CheckboxListTile(
                value: _taxReceipt,
                activeColor: AppColors.primary,
                title: const Text('I need an 80G Tax Exemption Certificate', style: AppTypography.bodySm),
                onChanged: (val) => setState(() => _taxReceipt = val ?? false),
              ),

              if (_taxReceipt) ...[
                const SizedBox(height: 8),
                CustomTextField(
                  label: 'PAN CARD NUMBER / पॅन क्रमांक',
                  hintText: 'Enter 10-character PAN for 80G receipt',
                  controller: _panController,
                  prefixIcon: const Icon(Icons.badge_outlined, color: AppColors.primary),
                ),
              ],

              const SizedBox(height: 28),

              CustomButton(
                label: 'Donate ₹$displayAmount',
                icon: Icons.favorite,
                isLoading: _isLoading,
                onPressed: _processDonation,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPaymentOption(String id, String label, IconData icon) {
    final isSelected = _selectedPaymentMethod == id;
    return InkWell(
      onTap: () => setState(() => _selectedPaymentMethod = id),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          children: [
            Icon(icon, color: isSelected ? AppColors.primary : AppColors.outline, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                label,
                style: AppTypography.bodyMd.copyWith(
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                  color: isSelected ? AppColors.primary : AppColors.onSurface,
                ),
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.outline,
                  width: 2,
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.primary,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}

