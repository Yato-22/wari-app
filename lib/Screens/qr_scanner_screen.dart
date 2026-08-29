import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/custom_button.dart';
import '../models/app_state.dart';
import '../models/user_profile.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class QrScannerScreen extends StatefulWidget {
  const QrScannerScreen({super.key});

  @override
  State<QrScannerScreen> createState() => _QrScannerScreenState();
}

class _QrScannerScreenState extends State<QrScannerScreen> {
  final MobileScannerController cameraController = MobileScannerController();
  bool _isFlashOn = false;
  bool _isCampQrMode = false;

  @override
  void dispose() {
    cameraController.dispose();
    super.dispose();
  }

  void _simulateQrScan() async {
    final appState = AppStateScope.of(context);
    final mockCampId = appState.facilities.isNotEmpty ? appState.facilities.first.id : 'CAMP-001';
    await appState.supabaseService.checkInCamp(mockCampId);
    
    if (mounted) {
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
              child: Text('Attendance Recorded!', style: AppTypography.headlineLgMobile),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Successfully verified at Vitthal Rukmini Anna Chhatra (Saswad Halt).',
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
                  const Icon(Icons.verified, color: AppColors.primary, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Pilgrim Check-in: 10:42 AM',
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
  }

  @override
  Widget build(BuildContext context) {
    final user = AppStateScope.of(context).user;
    // Force scan mode for warkaris
    if (user.role == UserRole.warkari && _isCampQrMode) {
      _isCampQrMode = false;
    }

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: const AppTopBar(
        customTitle: 'Scan QR / क्युआर स्कॅन',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 12),
            // Mode Switcher (Scan QR vs My QR) - Only shown to organisers/volunteers
            if (user.role != UserRole.warkari)
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 24),
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Colors.white12,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isCampQrMode = false),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: !_isCampQrMode ? AppColors.primaryContainer : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'Scan QR Code',
                              style: TextStyle(
                                color: !_isCampQrMode ? AppColors.onPrimaryContainer : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: GestureDetector(
                        onTap: () => setState(() => _isCampQrMode = true),
                        child: Container(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          decoration: BoxDecoration(
                            color: _isCampQrMode ? AppColors.primaryContainer : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Center(
                            child: Text(
                              'My Camp QR',
                              style: TextStyle(
                                color: _isCampQrMode ? AppColors.onPrimaryContainer : Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 12,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

            const Spacer(),

            // QR Camera Frame / Camp QR Display
            if (!_isCampQrMode) ...[
              Center(
                child: Container(
                  width: 260,
                  height: 260,
                  decoration: BoxDecoration(
                    border: Border.all(color: AppColors.primaryContainer, width: 3),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(17),
                    child: MobileScanner(
                      controller: cameraController,
                      onDetect: (capture) {
                        final List<Barcode> barcodes = capture.barcodes;
                        for (final barcode in barcodes) {
                          debugPrint('Barcode found! ${barcode.rawValue}');
                          // In a real app, parse barcode.rawValue and check-in to that specific camp
                        }
                        _simulateQrScan(); // keeping simulation flow for UX demonstration
                        cameraController.stop();
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                'Point camera at Camp or Volunteer QR code',
                style: AppTypography.bodySm.copyWith(color: Colors.white70),
              ),
              const SizedBox(height: 16),
              // Flashlight toggle
              IconButton(
                icon: Icon(
                  _isFlashOn ? Icons.flash_on : Icons.flash_off,
                  color: _isFlashOn ? AppColors.primaryContainer : Colors.white,
                  size: 28,
                ),
                onPressed: () {
                  cameraController.toggleTorch();
                  setState(() => _isFlashOn = !_isFlashOn);
                },
              ),
            ] else ...[
              // Camp Display QR
              Center(
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.qr_code_2, size: 200, color: Colors.black87),
                      const SizedBox(height: 8),
                      Text(
                        'Vitthal Rukmini Anna Chhatra',
                        style: AppTypography.labelBold.copyWith(color: Colors.black87, fontSize: 14),
                      ),
                      Text(
                        'Camp ID: #CAMP-001',
                        style: AppTypography.bodySm.copyWith(color: Colors.black54, fontSize: 12),
                      ),
                    ],
                  ),
                ),
              ),
            ],

            const Spacer(),

            // Action Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: CustomButton(
                label: !_isCampQrMode ? 'Simulate Scan' : 'Share QR Code',
                icon: !_isCampQrMode ? Icons.qr_code_scanner : Icons.share,
                onPressed: () {
                  if (!_isCampQrMode) {
                    _simulateQrScan();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing Camp QR Code...')),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

