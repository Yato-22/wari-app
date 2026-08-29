import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/facility_card.dart';
import '../models/camp_facility.dart';
import '../navigation/app_routes.dart';
import '../main.dart';

class HomeMapScreen extends StatefulWidget {
  const HomeMapScreen({super.key});

  @override
  State<HomeMapScreen> createState() => _HomeMapScreenState();
}

class _HomeMapScreenState extends State<HomeMapScreen>
    with SingleTickerProviderStateMixin {
  FacilityType _selectedFilter = FacilityType.all;
  CampFacility? _selectedFacility;
  final TextEditingController _searchController = TextEditingController();
  final TransformationController _transformationController =
      TransformationController();

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

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
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _searchController.dispose();
    _transformationController.dispose();
    super.dispose();
  }

  List<CampFacility> _getFilteredFacilities(List<CampFacility> allFacilities) {
    var list = allFacilities;
    if (_selectedFilter != FacilityType.all) {
      list = list.where((f) => f.type == _selectedFilter).toList();
    }
    final query = _searchController.text.toLowerCase().trim();
    if (query.isNotEmpty) {
      list = list
          .where((f) =>
              f.name.toLowerCase().contains(query) ||
              f.description.toLowerCase().contains(query) ||
              f.locationName.toLowerCase().contains(query))
          .toList();
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final allFacilities = appState.facilities;
    final filteredFacilities = _getFilteredFacilities(allFacilities);

    if (_selectedFacility == null && filteredFacilities.isNotEmpty) {
      _selectedFacility = filteredFacilities.first;
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        showBackButton: false,
        showSosButton: true,
      ),
      body: Stack(
        children: [
          // Interactive Pan & Zoom Map Canvas
          Positioned.fill(
            child: _buildInteractiveMapCanvas(filteredFacilities),
          ),

          // Floating Top Controls (Search & Filter Chips)
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Search Bar
                Container(
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceContainerLowest,
                    borderRadius: BorderRadius.circular(9999),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.5),
                    ),
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
                            hintText: 'Search for facilities, camps, or Dindi...',
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            contentPadding: EdgeInsets.zero,
                            filled: false,
                          ),
                        ),
                      ),
                      if (_searchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear, size: 18),
                          onPressed: () {
                            _searchController.clear();
                            setState(() {});
                          },
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip('All', FacilityType.all, Icons.done),
                      const SizedBox(width: 8),
                      _buildFilterChip('Food', FacilityType.food, Icons.restaurant),
                      const SizedBox(width: 8),
                      _buildFilterChip('Water', FacilityType.water, Icons.water_drop),
                      const SizedBox(width: 8),
                      _buildFilterChip('Medical', FacilityType.medical, Icons.medical_services),
                      const SizedBox(width: 8),
                      _buildFilterChip('Toilet', FacilityType.toilet, Icons.wc),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Floating Action Buttons (Right)
          Positioned(
            right: 16,
            bottom: _selectedFacility != null ? 240 : 90,
            child: Column(
              children: [
                _buildMapActionButton(
                  icon: Icons.my_location,
                  tooltip: 'Reset / Center Map',
                  onTap: () {
                    _transformationController.value = Matrix4.identity();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Centering GPS location on Palkhi Marg...'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildMapActionButton(
                  icon: Icons.layers,
                  tooltip: 'Map Layers',
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Map View: Pilgrim Satellite & Terrain Route'),
                        duration: Duration(seconds: 1),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),

          // Last Updated Pill
          Positioned(
            bottom: _selectedFacility != null ? 220 : 80,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.inverseSurface.withValues(alpha: 0.85),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x20000000),
                      blurRadius: 4,
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sync, size: 14, color: AppColors.inverseOnSurface),
                    const SizedBox(width: 4),
                    Text(
                      'Live Palkhi Route • Updated 2m ago',
                      style: AppTypography.labelBold.copyWith(
                        color: AppColors.inverseOnSurface,
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Selected Facility Preview Card
          if (_selectedFacility != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 80,
              child: FacilityCard(
                facility: _selectedFacility!,
                onClose: () {
                  setState(() {
                    _selectedFacility = null;
                  });
                },
                onNavigate: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primary,
                      content: Text('Navigating to ${_selectedFacility!.name}...'),
                    ),
                  );
                },
                onReportIssue: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.reportIssue,
                    arguments: {'campId': _selectedFacility!.id},
                  );
                },
                onDonate: () {
                  Navigator.of(context).pushNamed(
                    AppRoutes.donateMoney,
                    arguments: {'campName': _selectedFacility!.name},
                  );
                },
              ),
            ),
        ],
      ),
      bottomNavigationBar: const AppBottomNavBar(currentIndex: 0),
    );
  }

  Widget _buildFilterChip(String label, FacilityType type, IconData icon) {
    final isSelected = _selectedFilter == type;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedFilter = type;
        });
      },
      borderRadius: BorderRadius.circular(9999),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        height: 36,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: isSelected
              ? AppColors.primaryContainer
              : AppColors.surfaceContainerLowest,
          borderRadius: BorderRadius.circular(9999),
          border: Border.all(
            color: isSelected
                ? AppColors.primary
                : AppColors.outlineVariant.withValues(alpha: 0.5),
          ),
          boxShadow: isSelected ? const [AppColors.tactileSaffronShadow] : [],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected
                  ? AppColors.onPrimaryContainer
                  : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTypography.labelBold.copyWith(
                color: isSelected
                    ? AppColors.onPrimaryContainer
                    : AppColors.onSurface,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMapActionButton({
    required IconData icon,
    required String tooltip,
    required VoidCallback onTap,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLowest,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: const [AppColors.tactileSaffronShadow],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }

  Widget _buildInteractiveMapCanvas(List<CampFacility> facilities) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final canvasWidth = constraints.maxWidth > 600 ? constraints.maxWidth : constraints.maxWidth * 1.25;
        final canvasHeight = constraints.maxHeight > 800 ? constraints.maxHeight : constraints.maxHeight * 1.25;

        return ClipRect(
          child: InteractiveViewer(
            transformationController: _transformationController,
            boundaryMargin: const EdgeInsets.all(120),
            minScale: 0.8,
            maxScale: 2.5,
            child: SizedBox(
              width: canvasWidth,
              height: canvasHeight,
              child: Container(
                color: const Color(0xFFF3ECE4),
                child: CustomPaint(
                  painter: _PalkhiRoutePainter(),
                  child: Stack(
                    children: [
                      // Live Palkhi Marker (Pulsing)
                      Positioned(
                        top: canvasHeight * 0.35,
                        left: canvasWidth * 0.45,
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 8, vertical: 3),
                              decoration: BoxDecoration(
                                color: AppColors.primaryContainer,
                                borderRadius: BorderRadius.circular(9999),
                                border: Border.all(
                                    color: AppColors.primary, width: 1),
                                boxShadow: const [AppColors.tactileSaffronShadow],
                              ),
                              child: Text(
                                'Live Palkhi',
                                style: AppTypography.labelBold.copyWith(
                                  color: AppColors.onPrimaryContainer,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(height: 4),
                            ScaleTransition(
                              scale: _pulseAnimation,
                              child: Container(
                                width: 48,
                                height: 48,
                                decoration: BoxDecoration(
                                  color: AppColors.primary,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                      color: Colors.white, width: 2.5),
                                  boxShadow: const [
                                    AppColors.tactileSaffronShadowElevated
                                  ],
                                ),
                                child: const Icon(
                                  Icons.celebration,
                                  color: Colors.white,
                                  size: 26,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      // Dynamic Facility Pins
                      ...facilities.asMap().entries.map((entry) {
                        final index = entry.key;
                        final facility = entry.value;
                        final isSelected = _selectedFacility?.id == facility.id;

                        // Calculate visual coordinate on canvas
                        double topRatio = 0.45;
                        double leftRatio = 0.30;

                        if (facility.type == FacilityType.medical) {
                          topRatio = 0.42;
                          leftRatio = 0.68;
                        } else if (facility.type == FacilityType.food) {
                          topRatio = 0.26;
                          leftRatio = 0.22;
                        } else if (facility.type == FacilityType.water) {
                          topRatio = 0.56;
                          leftRatio = 0.48;
                        } else if (facility.type == FacilityType.toilet) {
                          topRatio = 0.68;
                          leftRatio = 0.62;
                        } else {
                          // Additional dynamic registered camps
                          topRatio = (0.20 + (index * 0.14)) % 0.8;
                          leftRatio = (0.25 + (index * 0.18)) % 0.8;
                        }

                        final top = canvasHeight * topRatio;
                        final left = canvasWidth * leftRatio;

                        return Positioned(
                          top: top,
                          left: left,
                          child: GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedFacility = facility;
                              });
                            },
                            child: AnimatedScale(
                              scale: isSelected ? 1.25 : 1.0,
                              duration: const Duration(milliseconds: 200),
                              child: Container(
                                width: 40,
                                height: 40,
                                decoration: BoxDecoration(
                                  color: facility.type == FacilityType.medical
                                      ? AppColors.secondary
                                      : facility.type == FacilityType.food
                                          ? AppColors.tertiary
                                          : facility.type == FacilityType.water
                                              ? Colors.blue.shade700
                                              : Colors.teal.shade700,
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: isSelected
                                        ? AppColors.primaryContainer
                                        : Colors.white,
                                    width: isSelected ? 3 : 2,
                                  ),
                                  boxShadow: const [
                                    AppColors.tactileSaffronShadow
                                  ],
                                ),
                                child: Icon(
                                  facility.type == FacilityType.medical
                                      ? Icons.medical_services
                                      : facility.type == FacilityType.food
                                          ? Icons.restaurant
                                          : facility.type == FacilityType.water
                                              ? Icons.water_drop
                                              : Icons.wc,
                                  color: Colors.white,
                                  size: 20,
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class _PalkhiRoutePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    // Draw pilgrimage route path scaling across size
    final path = Path();
    path.moveTo(size.width * 0.15, size.height * 0.15);
    path.cubicTo(
      size.width * 0.30,
      size.height * 0.25,
      size.width * 0.20,
      size.height * 0.35,
      size.width * 0.48,
      size.height * 0.38,
    );
    path.cubicTo(
      size.width * 0.75,
      size.height * 0.42,
      size.width * 0.65,
      size.height * 0.60,
      size.width * 0.55,
      size.height * 0.68,
    );
    path.cubicTo(
      size.width * 0.45,
      size.height * 0.76,
      size.width * 0.70,
      size.height * 0.85,
      size.width * 0.80,
      size.height * 0.95,
    );

    final roadBorderPaint = Paint()
      ..color = const Color(0xFFD5CBBF)
      ..strokeWidth = 14
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, roadBorderPaint);

    final roadPaint = Paint()
      ..color = const Color(0xFFE8E0D2)
      ..strokeWidth = 10
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, roadPaint);

    final roadCenterPaint = Paint()
      ..color = AppColors.primaryContainer.withValues(alpha: 0.7)
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke;
    canvas.drawPath(path, roadCenterPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

