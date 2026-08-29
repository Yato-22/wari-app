import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';

class HelpAndSupportScreen extends StatefulWidget {
  const HelpAndSupportScreen({super.key});

  @override
  State<HelpAndSupportScreen> createState() => _HelpAndSupportScreenState();
}

class _HelpAndSupportScreenState extends State<HelpAndSupportScreen> {
  String _selectedCategory = 'all'; // 'all', 'map', 'donation', 'volunteer'
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _faqs = [
    {
      'cat': 'map',
      'q': 'How do I track the live location of the Palkhi procession?',
      'a': 'Open the "Map" tab from the bottom navigation. The live Palkhi marker with the glowing celebration icon updates every 2 minutes with real-time GPS coordinates along the Alandi/Dehu to Pandharpur route.',
    },
    {
      'cat': 'all',
      'q': 'What should I do in case of a medical emergency or foot blister?',
      'a': 'Tap the red "SOS" button in the top right corner of any screen or call 108. You can also filter the map for "Medical" to locate the nearest first aid camp with doctors on duty.',
    },
    {
      'cat': 'all',
      'q': 'How can I report an obstacle or water shortage?',
      'a': 'Go to the "Reports" tab, choose the issue category (e.g. Water Shortage, Crowd Blockage), select the nearest camp, attach an optional photo, and submit. The on-ground disaster response team will be alerted immediately.',
    },
    {
      'cat': 'donation',
      'q': 'Are online donations eligible for 80G tax exemptions?',
      'a': 'Yes, all registered Anna Chhatras and Medical camps under WariConnect issue valid 80G tax exemption receipts. Simply enter your PAN card during checkout.',
    },
    {
      'cat': 'volunteer',
      'q': 'Can I volunteer for only 1 or 2 days along the route?',
      'a': 'Yes! You can apply for individual shift slots (Morning, Afternoon, or Night) at specific camp stops through the "Volunteer" tab.',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredFaqs {
    var list = _faqs;
    if (_selectedCategory != 'all') {
      list = list.where((f) => f['cat'] == _selectedCategory).toList();
    }
    final query = _searchController.text.toLowerCase().trim();
    if (query.isNotEmpty) {
      list = list.where((f) => f['q'].toString().toLowerCase().contains(query) || f['a'].toString().toLowerCase().contains(query)).toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        customTitle: 'Help & Support / मदत',
        showBackButton: true,
        showSosButton: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Search Field
              Container(
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(9999),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  boxShadow: const [AppColors.tactileSaffronShadow],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Row(
                  children: [
                    const Icon(Icons.search, color: AppColors.onSurfaceVariant),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        onChanged: (_) => setState(() {}),
                        decoration: const InputDecoration(
                          hintText: 'Search help topics & FAQs...',
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.zero,
                          filled: false,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Category Pills
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    _buildPill('all', 'Common FAQs', Icons.help_outline),
                    const SizedBox(width: 8),
                    _buildPill('map', 'Map & Route', Icons.map),
                    const SizedBox(width: 8),
                    _buildPill('donation', 'Donations & 80G', Icons.volunteer_activism),
                    const SizedBox(width: 8),
                    _buildPill('volunteer', 'Volunteering', Icons.handshake),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'FREQUENTLY ASKED QUESTIONS',
                style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 12),

              // FAQs Expansion List
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
                  boxShadow: const [AppColors.tactileSaffronShadow],
                ),
                child: Column(
                  children: _filteredFaqs.map((faq) {
                    return ExpansionTile(
                      shape: const Border(),
                      iconColor: AppColors.primary,
                      collapsedIconColor: AppColors.outline,
                      title: Text(
                        faq['q'],
                        style: AppTypography.headlineLgMobile.copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                          child: Text(
                            faq['a'],
                            style: AppTypography.bodySm.copyWith(
                              height: 1.5,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ),
              ),

              const SizedBox(height: 24),

              Text(
                'DIRECT SUPPORT CHANNELS',
                style: AppTypography.labelBold.copyWith(color: AppColors.onSurfaceVariant),
              ),
              const SizedBox(height: 12),

              _buildContactTile(
                icon: Icons.chat,
                title: 'WhatsApp Helpline',
                subtitle: 'Instant messaging support in Marathi & Hindi',
                color: Colors.green.shade700,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Opening WhatsApp Support (+91 98220 11223)...')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildContactTile(
                icon: Icons.phone_in_talk,
                title: 'Toll-Free Pilgrim Support',
                subtitle: '1800-233-1111 (24/7 during Palkhi)',
                color: AppColors.primary,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Calling Toll-Free 1800-233-1111...')),
                  );
                },
              ),
              const SizedBox(height: 10),
              _buildContactTile(
                icon: Icons.mail_outline,
                title: 'Email Us',
                subtitle: 'support@wariconnect.org',
                color: AppColors.secondary,
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Composing email to support@wariconnect.org...')),
                  );
                },
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
      bottomNavigationBar: const AppBottomNavBar(currentTab: 'profile'),
    );
  }

  Widget _buildPill(String code, String label, IconData icon) {
    final isSelected = _selectedCategory == code;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = code),
      borderRadius: BorderRadius.circular(9999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelBold.copyWith(
                fontSize: 12,
                color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildContactTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.5)),
        boxShadow: const [AppColors.tactileSaffronShadow],
      ),
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 22),
        ),
        title: Text(
          title,
          style: AppTypography.labelBold.copyWith(fontSize: 14, color: AppColors.onSurface),
        ),
        subtitle: Text(
          subtitle,
          style: AppTypography.bodySm.copyWith(fontSize: 11, color: AppColors.onSurfaceVariant),
        ),
        trailing: const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.outline),
        onTap: onTap,
      ),
    );
  }
}

