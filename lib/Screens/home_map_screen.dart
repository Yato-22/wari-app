import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

import '../theme/app_theme.dart';

class FacilityItem {
  final String id;
  final String title;
  final String subtitle;
  final String category;
  final String distance;
  final String status;
  final IconData icon;
  final Color iconColor;
  final Color iconBgColor;
  final Offset mapPosition; // relative offset on map

  FacilityItem({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.distance,
    required this.status,
    required this.icon,
    required this.iconColor,
    required this.iconBgColor,
    required this.mapPosition,
  });
}

class HomeMapScreen extends StatefulWidget {
  final String? initialLanguage;

  const HomeMapScreen({super.key, this.initialLanguage});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen>
    with SingleTickerProviderStateMixin {
  int _selectedNavIndex = 0;
  String _selectedCategory = 'All';
  FacilityItem? _selectedFacility;
  final TextEditingController _searchController = TextEditingController();
  final TransformationController _transformationController =
      TransformationController();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  final List<String> _categories = [
    'All',
    'Food',
    'Water',
    'Medical',
    'Toilet',
  ];

  late final List<FacilityItem> _facilities;

  late final List<Marker> _sampleMarkers;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 0.95, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _sampleMarkers = [
      Marker(
        point: const LatLng(17.6792, 75.3317),
        width: 42,
        height: 42,
        child: _buildMapMarker(
          color: const Color(0xFF1B9E77),
          icon: Icons.medical_services_rounded,
        ),
      ),
      Marker(
        point: const LatLng(17.6815, 75.3338),
        width: 42,
        height: 42,
        child: _buildMapMarker(
          color: const Color(0xFFEF6C00),
          icon: Icons.restaurant_rounded,
        ),
      ),
      Marker(
        point: const LatLng(17.6768, 75.3296),
        width: 42,
        height: 42,
        child: _buildMapMarker(
          color: const Color(0xFF0288D1),
          icon: Icons.water_drop_rounded,
        ),
      ),
      Marker(
        point: const LatLng(17.6828, 75.3302),
        width: 42,
        height: 42,
        child: _buildMapMarker(
          color: const Color(0xFF5D4037),
          icon: Icons.wc_rounded,
        ),
      ),
    ];

    _facilities = [
      FacilityItem(
        id: 'med-1',
        title: 'Shree Medical Camp',
        subtitle: 'Free first aid and essential medicines provided by local volunteers.',
        category: 'Medical',
        distance: '0.5 km away',
        status: 'Open Now',
        icon: Icons.medical_services_rounded,
        iconColor: AppTheme.maroonLight,
        iconBgColor: AppTheme.maroonLight.withValues(alpha: 0.12),
        mapPosition: const Offset(0.70, 0.62),
      ),
      FacilityItem(
        id: 'food-1',
        title: 'Tukaram Annachatra',
        subtitle: 'Hot fresh mahaprasad and tea serving all warkaris 24/7.',
        category: 'Food',
        distance: '1.2 km away',
        status: 'Open Now',
        icon: Icons.restaurant_rounded,
        iconColor: const Color(0xFF60603E),
        iconBgColor: const Color(0xFFB5B48B).withValues(alpha: 0.3),
        mapPosition: const Offset(0.25, 0.28),
      ),
      FacilityItem(
        id: 'water-1',
        title: 'Jal Seva Kendra',
        subtitle: 'Filtered drinking water refill & electrolyte distribution.',
        category: 'Water',
        distance: '0.3 km away',
        status: 'Open Now',
        icon: Icons.water_drop_rounded,
        iconColor: const Color(0xFF0288D1),
        iconBgColor: const Color(0xFFE1F5FE),
        mapPosition: const Offset(0.32, 0.72),
      ),
      FacilityItem(
        id: 'toilet-1',
        title: 'Mobile Sanitation Unit 4',
        subtitle: 'Maintained hygienic mobile toilets with running water.',
        category: 'Toilet',
        distance: '0.8 km away',
        status: 'Open Now',
        icon: Icons.wc_rounded,
        iconColor: const Color(0xFF5D4037),
        iconBgColor: const Color(0xFFEFEBE9),
        mapPosition: const Offset(0.78, 0.35),
      ),
    ];

    // Default selected facility from Stitch template
    _selectedFacility = _facilities[0];
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  void _showSosDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppTheme.surfaceContainerLowest,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppTheme.error.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.emergency, color: AppTheme.error),
            ),
            const SizedBox(width: 12),
            Text(
              'Emergency SOS',
              style: AppTheme.headlineLgMobile(color: AppTheme.error),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Need immediate help during the Palkhi?',
              style: AppTheme.bodyMd(color: AppTheme.onSurface),
            ),
            const SizedBox(height: 12),
            _buildSosActionTile(
              icon: Icons.local_hospital,
              title: 'Call Medical Emergency',
              subtitle: '108 Ambulance Dispatch',
              color: AppTheme.error,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
            _buildSosActionTile(
              icon: Icons.local_police,
              title: 'Police Assistance',
              subtitle: '112 Pilgrimage Helpdesk',
              color: AppTheme.maroonLight,
              onTap: () => Navigator.pop(context),
            ),
            const SizedBox(height: 8),
            _buildSosActionTile(
              icon: Icons.group,
              title: 'Dindi Volunteer Alert',
              subtitle: 'Notify nearby volunteers of your location',
              color: AppTheme.saffronDark,
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              'Close',
              style: AppTheme.labelBold(color: AppTheme.onSurfaceVariant),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSosActionTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: color.withValues(alpha: 0.2)),
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTheme.labelBold(color: AppTheme.onSurface),
                  ),
                  Text(
                    subtitle,
                    style: AppTheme.bodySm(color: AppTheme.onSurfaceVariant),
                  ),
                ],
              ),
            ),
            Icon(Icons.chevron_right, color: color, size: 20),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.surface,
      body: Stack(
        children: [
          // 1. Interactive Map View Layer
          Positioned.fill(
            top: 64, // below header
            bottom: 80, // above bottom nav
            child: _buildMapCanvas(),
          ),

          // 2. Top App Bar Header (Fixed)
          Positioned(top: 0, left: 0, right: 0, child: _buildTopAppBar()),

          // 3. Floating Search & Filter Bar
          Positioned(
            top: 76,
            left: 0,
            right: 0,
            child: _buildSearchAndFilterBar(),
          ),

          // 4. Floating Action Buttons (Right side)
          Positioned(
            right: 16,
            bottom: _selectedFacility != null ? 240 : 100,
            child: _buildFloatingActions(),
          ),

          // 5. Floating Sync Pill ("Last updated 2m ago")
          Positioned(
            bottom: _selectedFacility != null ? 210 : 96,
            left: 0,
            right: 0,
            child: Center(child: _buildSyncPill()),
          ),

          // 6. Selected Facility Preview Card
          if (_selectedFacility != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 92,
              child: _buildFacilityPreviewCard(_selectedFacility!),
            ),

          // 7. Bottom Navigation Bar (Fixed)
          Positioned(bottom: 0, left: 0, right: 0, child: _buildBottomNavBar()),
        ],
      ),
    );
  }

  // --- Top App Bar ---
  Widget _buildTopAppBar() {
    return Container(
      height: 64 + MediaQuery.of(context).padding.top,
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top,
        left: 16,
        right: 16,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surface,
        boxShadow: const [
          BoxShadow(
            color: Color(0x0F000000),
            blurRadius: 4,
            offset: Offset(0, 2),
          ),
        ],
        border: Border(
          bottom: BorderSide(
            color: AppTheme.outlineVariant.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // App Title with Dual Brand Colors
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: AppTheme.saffronPrimary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.temple_hindu_rounded,
                  color: AppTheme.saffronDark,
                  size: 22,
                ),
              ),
              const SizedBox(width: 8),
              RichText(
                text: TextSpan(
                  children: [
                    TextSpan(
                      text: 'Wari',
                      style: AppTheme.headlineLgMobile(
                        color: AppTheme.maroonSecondary,
                      ).copyWith(fontWeight: FontWeight.w800),
                    ),
                    TextSpan(
                      text: 'Connect',
                      style: AppTheme.headlineLgMobile(
                        color: AppTheme.saffronPrimary,
                      ).copyWith(fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // Emergency SOS Pill Button
          Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: _showSosDialog,
              borderRadius: BorderRadius.circular(999),
              child: Ink(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: AppTheme.error,
                  borderRadius: BorderRadius.circular(999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x33BA1A1A),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.emergency,
                      color: AppTheme.onError,
                      size: 18,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      'SOS',
                      style: AppTheme.labelBold(color: AppTheme.onError),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // --- Interactive Map Canvas ---
  Widget _buildMapCanvas() {
    return FlutterMap(
      options: const MapOptions(
        initialCenter: LatLng(17.6792, 75.3317),
        initialZoom: 14.0,
        minZoom: 10.0,
        maxZoom: 19.0,
      ),
      children: [
        TileLayer(
          urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
          userAgentPackageName: 'com.example.test',
          maxZoom: 19,
        ),
        MarkerLayer(markers: _sampleMarkers),
        Positioned(
          top: 24,
          left: 0,
          right: 0,
          child: Align(
            alignment: Alignment.topCenter,
            child: _buildLivePalkhiMarker(),
          ),
        ),
      ],
    );
  }

  Widget _buildMapMarker({required Color color, required IconData icon}) {
    return Container(
      width: 42,
      height: 42,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 8,
            offset: Offset(0, 3),
          ),
        ],
      ),
      child: Center(child: Icon(icon, color: Colors.white, size: 18)),
    );
  }

  // --- Live Palkhi Marker ---
  Widget _buildLivePalkhiMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Live Palkhi Badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: AppTheme.saffronPrimary,
            borderRadius: BorderRadius.circular(999),
            border: Border.all(
              color: AppTheme.saffronDark.withValues(alpha: 0.3),
              width: 1,
            ),
            boxShadow: AppTheme.tactileSaffronShadow,
          ),
          child: Text(
            'Live Palkhi',
            style: AppTheme.labelBold(color: const Color(0xFF693800)),
          ),
        ),
        const SizedBox(height: 4),

        // Pulsing Live Circle
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.saffronDark,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [
                BoxShadow(
                  color: Color(0x66FF9933),
                  blurRadius: 16,
                  spreadRadius: 4,
                ),
              ],
            ),
            child: const Icon(
              Icons.celebration_rounded,
              color: Colors.white,
              size: 26,
            ),
          ),
        ),
      ],
    );
  }

  // --- Search & Filter Bar ---
  Widget _buildSearchAndFilterBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: [
          // Search Input
          Container(
            height: 48,
            decoration: BoxDecoration(
              color: AppTheme.surfaceContainerLowest,
              borderRadius: BorderRadius.circular(999),
              border: Border.all(
                color: AppTheme.outlineVariant.withValues(alpha: 0.4),
              ),
              boxShadow: AppTheme.tactileSaffronShadow,
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: AppTheme.onSurfaceVariant,
                  size: 22,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) => setState(() {}),
                    style: AppTheme.bodyMd(color: AppTheme.onSurface),
                    decoration: InputDecoration(
                      hintText: 'Search for facilities...',
                      hintStyle: AppTheme.bodyMd(
                        color: AppTheme.onSurfaceVariant.withValues(alpha: 0.6),
                      ),
                      border: InputBorder.none,
                      isDense: true,
                    ),
                  ),
                ),
                if (_searchController.text.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {});
                    },
                    child: const Icon(
                      Icons.clear_rounded,
                      color: AppTheme.onSurfaceVariant,
                      size: 20,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 10),

          // Horizontal Filter Chips
          SizedBox(
            height: 36,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemCount: _categories.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final category = _categories[index];
                final isActive = _selectedCategory == category;
                IconData iconData;
                switch (category) {
                  case 'Food':
                    iconData = Icons.restaurant_rounded;
                    break;
                  case 'Water':
                    iconData = Icons.water_drop_rounded;
                    break;
                  case 'Medical':
                    iconData = Icons.medical_services_rounded;
                    break;
                  case 'Toilet':
                    iconData = Icons.wc_rounded;
                    break;
                  default:
                    iconData = Icons.done_rounded;
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategory = category;
                    });
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isActive
                          ? AppTheme.saffronPrimary
                          : AppTheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(999),
                      border: Border.all(
                        color: isActive
                            ? AppTheme.saffronDark
                            : AppTheme.outlineVariant.withValues(alpha: 0.5),
                        width: 1,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x10000000),
                          blurRadius: 4,
                          offset: Offset(0, 1),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          iconData,
                          size: 16,
                          color: isActive
                              ? const Color(0xFF693800)
                              : AppTheme.onSurface,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          category,
                          style: AppTheme.labelBold(
                            color: isActive
                                ? const Color(0xFF693800)
                                : AppTheme.onSurface,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // --- Floating Action Buttons (Right) ---
  Widget _buildFloatingActions() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildFabButton(
          icon: Icons.my_location_rounded,
          onTap: () {
            _transformationController.value = Matrix4.identity();
          },
        ),
        const SizedBox(height: 10),
        _buildFabButton(
          icon: Icons.layers_rounded,
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Map Layer: Pilgrim Satellite Route',
                  style: AppTheme.bodySm(color: Colors.white),
                ),
                backgroundColor: AppTheme.inverseSurface,
                duration: const Duration(seconds: 2),
              ),
            );
          },
        ),
      ],
    );
  }

  Widget _buildFabButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(999),
        child: Ink(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppTheme.surfaceContainerLowest,
            shape: BoxShape.circle,
            border: Border.all(
              color: AppTheme.outlineVariant.withValues(alpha: 0.3),
            ),
            boxShadow: AppTheme.tactileSaffronShadow,
          ),
          child: Icon(icon, color: AppTheme.onSurfaceVariant, size: 22),
        ),
      ),
    );
  }

  // --- Floating Sync Pill ---
  Widget _buildSyncPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppTheme.inverseSurface.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(999),
        boxShadow: const [
          BoxShadow(
            color: Color(0x20000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(
            Icons.sync_rounded,
            color: AppTheme.inverseOnSurface,
            size: 14,
          ),
          const SizedBox(width: 6),
          Text(
            'Last updated 2m ago',
            style: AppTheme.labelBold(color: AppTheme.inverseOnSurface),
          ),
        ],
      ),
    );
  }

  // --- Facility Preview Card (Bottom Floating Card) ---
  Widget _buildFacilityPreviewCard(FacilityItem facility) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: AppTheme.outlineVariant.withValues(alpha: 0.3),
        ),
        boxShadow: AppTheme.tactileSaffronShadow,
      ),
      child: Stack(
        children: [
          // Close button
          Positioned(
            top: 0,
            right: 0,
            child: GestureDetector(
              onTap: () {
                setState(() {
                  _selectedFacility = null;
                });
              },
              child: Container(
                padding: const EdgeInsets.all(4),
                child: const Icon(
                  Icons.close_rounded,
                  size: 20,
                  color: AppTheme.onSurfaceVariant,
                ),
              ),
            ),
          ),

          // Main Card Content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Facility Icon Container
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: facility.iconBgColor,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(
                      facility.icon,
                      color: facility.iconColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),

                  // Facility Title & Details
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 24.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            facility.title,
                            style: AppTheme.headlineLgMobile(
                              color: AppTheme.onSurface,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            facility.subtitle,
                            style: AppTheme.bodySm(
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),

              // Status, Distance & Navigate Action Button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      // Status Chip: Open Now
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: AppTheme.statusOpenBg,
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          facility.status.toUpperCase(),
                          style: AppTheme.statusPill(
                            color: AppTheme.statusOpenText,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),

                      // Distance
                      Row(
                        children: [
                          const Icon(
                            Icons.route_rounded,
                            size: 14,
                            color: AppTheme.onSurfaceVariant,
                          ),
                          const SizedBox(width: 3),
                          Text(
                            facility.distance,
                            style: AppTheme.labelBold(
                              color: AppTheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  // Navigate Button
                  ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Starting route to ${facility.title}...',
                          ),
                          backgroundColor: AppTheme.saffronDark,
                        ),
                      );
                    },
                    iconAlignment: IconAlignment.end,
                    icon: const Icon(
                      Icons.directions_rounded,
                      size: 16,
                      color: Colors.white,
                    ),
                    label: Text(
                      'Navigate',
                      style: AppTheme.labelBold(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.saffronDark,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // --- Bottom Navigation Bar ---
  Widget _buildBottomNavBar() {
    return Container(
      height: 76 + MediaQuery.of(context).padding.bottom,
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).padding.bottom,
        left: 8,
        right: 8,
      ),
      decoration: BoxDecoration(
        color: AppTheme.surfaceContainer,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x1FFF9933),
            blurRadius: 12,
            offset: Offset(0, -4),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildNavItem(index: 0, label: 'Map', icon: Icons.map_rounded),
          _buildNavItem(
            index: 1,
            label: 'Volunteer',
            icon: Icons.volunteer_activism_rounded,
          ),
          _buildNavItem(
            index: 2,
            label: 'Reports',
            icon: Icons.report_problem_rounded,
          ),
          _buildNavItem(index: 3, label: 'Profile', icon: Icons.person_rounded),
        ],
      ),
    );
  }

  Widget _buildNavItem({
    required int index,
    required String label,
    required IconData icon,
  }) {
    final isActive = _selectedNavIndex == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedNavIndex = index;
        });
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? AppTheme.saffronPrimary : Colors.transparent,
          borderRadius: BorderRadius.circular(999),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 22,
              color: isActive
                  ? const Color(0xFF693800)
                  : AppTheme.onSurfaceVariant,
            ),
            const SizedBox(height: 2),
            Text(
              label,
              style: AppTheme.labelBold(
                color: isActive
                    ? const Color(0xFF693800)
                    : AppTheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Fallback background painter when offline/no image
class MapFallbackPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFEFE6E0)
      ..style = PaintingStyle.fill;
    canvas.drawRect(Rect.fromLTWH(0, 0, size.width, size.height), paint);

    final linePaint = Paint()
      ..color = const Color(0xFFDECFC3)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = ui.Path()
      ..moveTo(0, size.height * 0.3)
      ..quadraticBezierTo(
        size.width * 0.5,
        size.height * 0.2,
        size.width,
        size.height * 0.5,
      );
    canvas.drawPath(path, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// Route line painter demonstrating pilgrim route path
class RouteLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..color = AppTheme.saffronPrimary.withValues(alpha: 0.5)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final routePath = ui.Path()
      ..moveTo(size.width * 0.2, size.height * 0.8)
      ..quadraticBezierTo(
        size.width * 0.35,
        size.height * 0.6,
        size.width * 0.5,
        size.height * 0.5,
      )
      ..quadraticBezierTo(
        size.width * 0.65,
        size.height * 0.4,
        size.width * 0.8,
        size.height * 0.25,
      );

    canvas.drawPath(routePath, linePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
