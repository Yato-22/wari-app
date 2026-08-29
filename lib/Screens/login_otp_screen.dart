import 'dart:async';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../navigation/app_routes.dart';
import '../models/app_state.dart';

class LoginOtpScreen extends StatefulWidget {
  const LoginOtpScreen({super.key});

  @override
  State<LoginOtpScreen> createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final TextEditingController _phoneController = TextEditingController(text: '9876543210');
  final List<TextEditingController> _otpControllers = List.generate(6, (_) => TextEditingController());
  final List<FocusNode> _focusNodes = List.generate(6, (_) => FocusNode());

  bool _otpSent = false;
  bool _isLoading = false;
  int _timerSeconds = 30;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    _phoneController.dispose();
    for (var c in _otpControllers) {
      c.dispose();
    }
    for (var f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  void _startTimer() {
    _timer?.cancel();
    setState(() {
      _timerSeconds = 30;
    });
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_timerSeconds > 0) {
        setState(() {
          _timerSeconds--;
        });
      } else {
        _timer?.cancel();
      }
    });
  }

  void _sendOtp() async {
    final phone = _phoneController.text.trim();
    if (phone.length < 10) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a valid 10-digit mobile number')),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final appState = AppStateScope.of(context);
      await appState.supabaseService.signInWithPhone(phone);
      if (mounted) {
        setState(() {
          _isLoading = false;
          _otpSent = true;
          // Clear test OTPs for real deployment, or prepopulate for dev
          _otpControllers[0].text = '';
          _otpControllers[1].text = '';
          _otpControllers[2].text = '';
          _otpControllers[3].text = '';
          _otpControllers[4].text = '';
          _otpControllers[5].text = '';
        });
        _startTimer();
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to send OTP: $e')),
        );
      }
    }
  }

  void _verifyOtp() async {
    final phone = _phoneController.text.trim();
    final otp = _otpControllers.map((c) => c.text).join();
    if (otp.length < 6) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final appState = AppStateScope.of(context);
      await appState.supabaseService.verifyOTP(phone, otp);
      await appState.login(phone); // fetch profile

      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            backgroundColor: AppColors.statusOpenText,
            content: Text('Login successful! Welcome to WariConnect.'),
          ),
        );
        Navigator.of(context).pushReplacementNamed(AppRoutes.profileLoggedIn);
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Invalid OTP or verification failed. $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Login | Secure Access',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Sacred Icon & Welcome
              Center(
                child: Container(
                  width: 80,
                  height: 80,
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer.withValues(alpha: 0.15),
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.primaryContainer, width: 2),
                  ),
                  child: const Icon(
                    Icons.temple_hindu,
                    size: 44,
                    color: AppColors.primary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Namaste Pilgrim',
                textAlign: TextAlign.center,
                style: AppTypography.headlineLg,
              ),
              const SizedBox(height: 6),
              Text(
                'Enter your mobile number to access your pilgrim pass, camp registrations, and volunteer updates.',
                textAlign: TextAlign.center,
                style: AppTypography.bodySm.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: 32),

              // Phone Number Container Card
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
                    Text(
                      'MOBILE NUMBER / मोबाईल क्रमांक',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainerLow,
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(color: AppColors.outlineVariant),
                          ),
                          child: const Text(
                            '+91',
                            style: TextStyle(
                              fontWeight: FontWeight.w700,
                              color: AppColors.onSurface,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            enabled: !_otpSent,
                            style: AppTypography.bodyMd.copyWith(
                              fontWeight: FontWeight.w600,
                              letterSpacing: 1.2,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter 10 digit number',
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (!_otpSent) ...[
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Get OTP',
                        icon: Icons.arrow_forward,
                        iconTrailing: true,
                        isLoading: _isLoading,
                        onPressed: _sendOtp,
                      ),
                    ],
                  ],
                ),
              ),

              // OTP Section (if sent)
              if (_otpSent) ...[
                const SizedBox(height: 20),
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
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'ENTER OTP CODE',
                            style: AppTypography.labelBold.copyWith(
                              color: AppColors.primary,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _otpSent = false;
                              });
                            },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                            ),
                            child: Text(
                              'Change Number',
                              style: AppTypography.labelBold.copyWith(
                                color: AppColors.secondary,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(6, (index) {
                          return SizedBox(
                            width: 44,
                            child: TextField(
                              controller: _otpControllers[index],
                              focusNode: _focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                              decoration: const InputDecoration(
                                counterText: '',
                                contentPadding: EdgeInsets.symmetric(vertical: 10),
                              ),
                              onChanged: (value) {
                                if (value.isNotEmpty && index < 5) {
                                  _focusNodes[index + 1].requestFocus();
                                } else if (value.isEmpty && index > 0) {
                                  _focusNodes[index - 1].requestFocus();
                                }
                              },
                            ),
                          );
                        }),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            _timerSeconds > 0
                                ? 'Resend code in ${_timerSeconds}s'
                                : 'Did not receive OTP?',
                            style: AppTypography.bodySm,
                          ),
                          if (_timerSeconds == 0)
                            TextButton(
                              onPressed: _startTimer,
                              child: Text(
                                'Resend Now',
                                style: AppTypography.labelBold.copyWith(
                                  color: AppColors.primary,
                                ),
                              ),
                            ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      CustomButton(
                        label: 'Verify & Proceed',
                        icon: Icons.verified_user,
                        isLoading: _isLoading,
                        onPressed: _verifyOtp,
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: 28),
              // Guest Bypass
              Center(
                child: TextButton.icon(
                  onPressed: () {
                    Navigator.of(context).pushReplacementNamed(AppRoutes.homeMap);
                  },
                  icon: const Icon(Icons.arrow_forward, size: 16),
                  label: const Text('Explore as Guest Pilgrim'),
                  style: TextButton.styleFrom(
                    foregroundColor: AppColors.onSurfaceVariant,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

