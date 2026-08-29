import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
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
  final MapController _mapController = MapController();
  FacilityType _selectedFilter = FacilityType.all;
  CampFacility? _selectedFacility;
  final TextEditingController _searchController = TextEditingController();

  int _currentMapLayerIndex = 0;
  final List<Map<String, String>> _mapTileLayers = [
    {
      'name': 'OpenStreetMap Standard',
      'url': 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
    },
    {
      'name': 'OSM Humanitarian (HOT)',
      'url': 'https://a.tile.openstreetmap.fr/hot/{z}/{x}/{y}.png',
    },
    {
      'name': 'CartoDB Voyager (Warm)',
      'url': 'https://basemaps.cartocdn.com/rastertiles/voyager/{z}/{x}/{y}.png',
    },
  ];

  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  // Real geographical Palkhi pilgrimage route coordinates from Alandi to Pandharpur
  static const List<LatLng> _palkhiRouteCoordinates = [
    LatLng(18.6772, 73.8967), // Alandi (Start of Sant Dnyaneshwar Palkhi)
    LatLng(18.5204, 73.8567), // Pune (Shivajinagar)
    LatLng(18.5089, 73.9260), // Hadapsar
    LatLng(18.3980, 73.9980), // Dive Ghat (Mastani Talav)
    LatLng(18.3444, 74.0305), // Saswad (First major halt)
    LatLng(18.2750, 74.1592), // Jejuri (Khandoba mandir)
    LatLng(18.1722, 74.1611), // Valhe
    LatLng(18.0428, 74.1883), // Lonand
    LatLng(17.9944, 74.3167), // Taradgaon
    LatLng(17.9833, 74.4333), // Phaltan
    LatLng(17.8833, 74.5833), // Barad
    LatLng(17.9000, 74.7833), // Natepute
    LatLng(17.8500, 74.9000), // Malshiras
    LatLng(17.7667, 75.0500), // Velapur
    LatLng(17.7167, 75.2000), // Bhandishegaon
    LatLng(17.6980, 75.2750), // Wakhari (Palkhi Ringan)
    LatLng(17.6775, 75.3268), // Pandharpur (Shri Vitthal-Rukmini Mandir)
  ];

  // Current Live Palkhi Location
  static const LatLng _livePalkhiLocation = LatLng(18.3444, 74.0305);

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
    _mapController.dispose();
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

  void _cycleMapLayer() {
    setState(() {
      _currentMapLayerIndex =
          (_currentMapLayerIndex + 1) % _mapTileLayers.length;
    });
    final layerName = _mapTileLayers[_currentMapLayerIndex]['name'];
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Switched to $layerName'),
        duration: const Duration(seconds: 2),
        backgroundColor: AppColors.inverseSurface,
      ),
    );
  }

  void _centerOnLivePalkhi() {
    _mapController.move(_livePalkhiLocation, 13.5);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Centered on Live Palkhi (Saswad - Pune Route)'),
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final appState = AppStateScope.of(context);
    final allFacilities = appState.facilities;
    final filteredFacilities = _getFilteredFacilities(allFacilities);

    // Remove the forced selection so the dialogue can be dismissed

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const AppTopBar(
        showBackButton: false,
        showSosButton: true,
      ),
      body: Stack(
        children: [
          // 1. OpenStreetMap Tile Layer Canvas
          Positioned.fill(
            child: _buildOpenStreetMap(filteredFacilities),
          ),

          // 2. Floating Top Controls (Search & Filter Chips)
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
                      const Icon(Icons.search,
                          color: AppColors.onSurfaceVariant),
                      const SizedBox(width: 8),
                      Expanded(
                        child: TextField(
                          controller: _searchController,
                          onChanged: (_) => setState(() {}),
                          decoration: const InputDecoration(
                            hintText:
                                'Search facilities, medical, water, camps...',
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
                      _buildFilterChip(
                          'Food', FacilityType.food, Icons.restaurant),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Water', FacilityType.water, Icons.water_drop),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Medical', FacilityType.medical, Icons.medical_services),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          'Toilet', FacilityType.toilet, Icons.wc),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // 3. Floating Action Buttons (Right)
          Positioned(
            right: 16,
            bottom: _selectedFacility != null ? 220 : 16,
            child: Column(
              children: [
                _buildMapActionButton(
                  icon: Icons.my_location,
                  tooltip: 'Center on Live Palkhi',
                  onTap: _centerOnLivePalkhi,
                ),
                const SizedBox(height: 8),
                _buildMapActionButton(
                  icon: Icons.layers_outlined,
                  tooltip: 'Switch Map Layer',
                  onTap: _cycleMapLayer,
                ),
                const SizedBox(height: 8),
                _buildMapActionButton(
                  icon: Icons.add,
                  tooltip: 'Zoom In',
                  onTap: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      (currentZoom + 1).clamp(6.0, 18.0),
                    );
                  },
                ),
                const SizedBox(height: 8),
                _buildMapActionButton(
                  icon: Icons.remove,
                  tooltip: 'Zoom Out',
                  onTap: () {
                    final currentZoom = _mapController.camera.zoom;
                    _mapController.move(
                      _mapController.camera.center,
                      (currentZoom - 1).clamp(6.0, 18.0),
                    );
                  },
                ),
              ],
            ),
          ),

          // 4. Last Updated Pill
          Positioned(
            bottom: _selectedFacility != null ? 200 : 16,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                decoration: BoxDecoration(
                  color: AppColors.inverseSurface.withValues(alpha: 0.90),
                  borderRadius: BorderRadius.circular(9999),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x30000000),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sync,
                        size: 14, color: AppColors.inverseOnSurface),
                    const SizedBox(width: 6),
                    Text(
                      'Live OpenStreetMap • Pandharpur Palkhi Marg',
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

          // 5. Selected Facility Preview Card
          if (_selectedFacility != null)
            Positioned(
              left: 16,
              right: 16,
              bottom: 16,
              child: FacilityCard(
                facility: _selectedFacility!,
                onClose: () {
                  setState(() {
                    _selectedFacility = null;
                  });
                },
                onNavigate: () {
                  _mapController.move(
                    LatLng(_selectedFacility!.latitude,
                        _selectedFacility!.longitude),
                    15.0,
                  );
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      backgroundColor: AppColors.primary,
                      content:
                          Text('Navigating to ${_selectedFacility!.name}...'),
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
        border:
            Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: const [AppColors.tactileSaffronShadow],
      ),
      child: IconButton(
        icon: Icon(icon, color: AppColors.onSurfaceVariant, size: 20),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }

  // --- OpenStreetMap Main View ---
  Widget _buildOpenStreetMap(List<CampFacility> facilities) {
    final currentLayer = _mapTileLayers[_currentMapLayerIndex];

    return FlutterMap(
      mapController: _mapController,
      options: MapOptions(
        initialCenter: _livePalkhiLocation,
        initialZoom: 12.5,
        minZoom: 6.0,
        maxZoom: 18.0,
        onTap: (_, __) {
          if (_selectedFacility != null) {
            setState(() {
              _selectedFacility = null;
            });
          }
        },
      ),
      children: [
        // OpenStreetMap Tile Layer
        TileLayer(
          urlTemplate: currentLayer['url']!,
          userAgentPackageName: 'org.warkari.wariconnect',
          maxZoom: 19,
        ),

        // Palkhi Pilgrimage Route Polyline
        PolylineLayer(
          polylines: [
            Polyline(
              points: _palkhiRouteCoordinates,
              color: const Color(0xFF8F4E00).withValues(alpha: 0.4),
              strokeWidth: 7.0,
            ),
            Polyline(
              points: _palkhiRouteCoordinates,
              color: AppColors.primaryContainer,
              strokeWidth: 4.0,
              borderColor: AppColors.primary,
              borderStrokeWidth: 1.0,
            ),
          ],
        ),

        // Markers: Live Palkhi + Camp Facilities
        MarkerLayer(
          markers: [
            // 1. Live Palkhi Pulsing Marker
            Marker(
              point: _livePalkhiLocation,
              width: 90,
              height: 90,
              child: _buildLivePalkhiMarker(),
            ),

            // 2. Dynamic Camp Facility Markers
            ...facilities.map((facility) {
              final isSelected = _selectedFacility?.id == facility.id;
              return Marker(
                point: LatLng(facility.latitude, facility.longitude),
                width: isSelected ? 48 : 38,
                height: isSelected ? 48 : 38,
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedFacility = facility;
                    });
                    _mapController.move(
                      LatLng(facility.latitude, facility.longitude),
                      14.0,
                    );
                  },
                  child: _buildFacilityMarker(facility, isSelected),
                ),
              );
            }),
          ],
        ),
      ],
    );
  }

  // --- Live Palkhi Marker Widget ---
  Widget _buildLivePalkhiMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: AppColors.primaryContainer,
            borderRadius: BorderRadius.circular(9999),
            border: Border.all(color: AppColors.primary, width: 1),
            boxShadow: const [AppColors.tactileSaffronShadow],
          ),
          child: Text(
            'Live Palkhi',
            style: AppTypography.labelBold.copyWith(
              color: AppColors.onPrimaryContainer,
              fontSize: 10,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 4),
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white, width: 2.5),
              boxShadow: const [AppColors.tactileSaffronShadowElevated],
            ),
            child: const Icon(
              Icons.celebration,
              color: Colors.white,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }

  // --- Facility Marker Widget ---
  Widget _buildFacilityMarker(CampFacility facility, bool isSelected) {
    Color markerColor;
    IconData markerIcon;

    switch (facility.type) {
      case FacilityType.medical:
        markerColor = AppColors.secondary;
        markerIcon = Icons.medical_services;
        break;
      case FacilityType.food:
        markerColor = const Color(0xFF60603E);
        markerIcon = Icons.restaurant;
        break;
      case FacilityType.water:
        markerColor = Colors.blue.shade700;
        markerIcon = Icons.water_drop;
        break;
      case FacilityType.toilet:
        markerColor = Colors.teal.shade700;
        markerIcon = Icons.wc;
        break;
      default:
        markerColor = AppColors.primary;
        markerIcon = Icons.temple_hindu;
    }

    return AnimatedScale(
      scale: isSelected ? 1.2 : 1.0,
      duration: const Duration(milliseconds: 200),
      child: Container(
        decoration: BoxDecoration(
          color: markerColor,
          shape: BoxShape.circle,
          border: Border.all(
            color: isSelected ? AppColors.primaryContainer : Colors.white,
            width: isSelected ? 3 : 2,
          ),
          boxShadow: [
            if (isSelected)
              AppColors.tactileSaffronShadowElevated
            else
              const BoxShadow(
                color: Color(0x33000000),
                blurRadius: 4,
                offset: Offset(0, 2),
              ),
          ],
        ),
        child: Center(
          child: Icon(
            markerIcon,
            color: Colors.white,
            size: isSelected ? 22 : 18,
          ),
        ),
      ),
    );
  }
}


