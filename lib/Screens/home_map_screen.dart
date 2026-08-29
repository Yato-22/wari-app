import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../widgets/app_top_bar.dart';
import '../widgets/app_bottom_nav_bar.dart';
import '../widgets/facility_card.dart';
import '../models/camp_facility.dart';
import '../navigation/app_routes.dart';
import '../models/app_state.dart';
import '../services/routing_service.dart';
import '../services/location_service.dart';

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

  // --- Road-snapped route state ---
  List<LatLng> _roadSnappedRoute = [];
  bool _isLoadingRoute = true;

  // --- Live user location state ---
  LatLng? _userLocation;
  StreamSubscription<Position>? _positionStreamSubscription;
  bool _isLocationEnabled = false;

  // Real geographical Palkhi pilgrimage route waypoints from Alandi to Pandharpur
  static const List<LatLng> _palkhiRouteWaypoints = [
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

    // Fetch the road-snapped route
    _fetchRoadRoute();

    // Initialize live location
    _initializeLocation();
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _mapController.dispose();
    _positionStreamSubscription?.cancel();
    super.dispose();
  }

  /// Fetches the road-following route from OSRM.
  Future<void> _fetchRoadRoute() async {
    final route = await RoutingService.fetchRoute(_palkhiRouteWaypoints);
    if (mounted) {
      setState(() {
        _roadSnappedRoute = route;
        _isLoadingRoute = false;
      });
    }
  }

  /// Initializes live location tracking.
  Future<void> _initializeLocation() async {
    final error = await LocationService.checkAndRequestPermissions();
    if (error != null) {
      // Permission denied — don't block, just skip location
      if (mounted) {
        setState(() {
          _isLocationEnabled = false;
        });
      }
      return;
    }

    if (mounted) {
      setState(() {
        _isLocationEnabled = true;
      });
    }

    // Get initial position
    final result = await LocationService.getCurrentPosition();
    if (result.isSuccess && mounted) {
      setState(() {
        _userLocation = LatLng(
          result.position!.latitude,
          result.position!.longitude,
        );
      });
    }

    // Start listening to position stream
    final stream = LocationService.getPositionStream(distanceFilter: 10);
    if (stream != null) {
      _positionStreamSubscription = stream.listen((position) {
        if (mounted) {
          setState(() {
            _userLocation = LatLng(position.latitude, position.longitude);
          });
        }
      });
    }
  }

  /// Centers the map on the user's current location.
  void _centerOnUserLocation() async {
    if (_userLocation != null) {
      _mapController.move(_userLocation!, 15.0);
      return;
    }

    // Try to fetch location if not available yet
    if (!_isLocationEnabled) {
      final error = await LocationService.checkAndRequestPermissions();
      if (error != null && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error),
            backgroundColor: AppColors.error,
            action: SnackBarAction(
              label: 'Settings',
              textColor: Colors.white,
              onPressed: () => LocationService.openAppSettings(),
            ),
          ),
        );
        return;
      }
      setState(() => _isLocationEnabled = true);
    }

    final result = await LocationService.getCurrentPosition();
    if (result.isSuccess && mounted) {
      setState(() {
        _userLocation = LatLng(
          result.position!.latitude,
          result.position!.longitude,
        );
      });
      _mapController.move(_userLocation!, 15.0);
    } else if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(result.errorMessage ?? 'Could not get location'),
          backgroundColor: AppColors.error,
        ),
      );
    }
  }

  List<CampFacility> _getFilteredFacilities(List<CampFacility> allFacilities) {
    var list = allFacilities;
    if (_selectedFilter != FacilityType.all) {
      list = list.where((f) => f.type == _selectedFilter).toList();
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

          // Route loading indicator
          if (_isLoadingRoute)
            Positioned(
              top: 120,
              left: 0,
              right: 0,
              child: Center(
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 8),
                  decoration: BoxDecoration(
                    color: AppColors.primaryContainer,
                    borderRadius: BorderRadius.circular(9999),
                    boxShadow: const [AppColors.tactileSaffronShadow],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const SizedBox(
                        width: 16,
                        height: 16,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Loading road route...',
                        style: AppTypography.labelBold.copyWith(
                          color: AppColors.onPrimaryContainer,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

          // 2. Floating Top Controls (Filter Chips)
          Positioned(
            top: 12,
            left: 16,
            right: 16,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Filter Chips
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildFilterChip(appState.translate('all'), FacilityType.all, Icons.done),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          appState.translate('food'), FacilityType.food, Icons.restaurant),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          appState.translate('water'), FacilityType.water, Icons.water_drop),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          appState.translate('medical'), FacilityType.medical, Icons.medical_services),
                      const SizedBox(width: 8),
                      _buildFilterChip(
                          appState.translate('toilet'), FacilityType.toilet, Icons.wc),
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
                // My Location button
                _buildMapActionButton(
                  icon: Icons.person_pin_circle,
                  tooltip: 'My Location',
                  onTap: _centerOnUserLocation,
                  highlight: _userLocation != null,
                ),
                const SizedBox(height: 8),
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
    bool highlight = false,
  }) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: highlight
            ? AppColors.primaryContainer
            : AppColors.surfaceContainerLowest,
        shape: BoxShape.circle,
        border:
            Border.all(color: highlight
                ? AppColors.primary.withValues(alpha: 0.6)
                : AppColors.outlineVariant.withValues(alpha: 0.4)),
        boxShadow: const [AppColors.tactileSaffronShadow],
      ),
      child: IconButton(
        icon: Icon(icon,
            color: highlight
                ? AppColors.primary
                : AppColors.onSurfaceVariant,
            size: 20),
        tooltip: tooltip,
        onPressed: onTap,
      ),
    );
  }

  // --- OpenStreetMap Main View ---
  Widget _buildOpenStreetMap(List<CampFacility> facilities) {
    final currentLayer = _mapTileLayers[_currentMapLayerIndex];

    // Use road-snapped route if available, otherwise fall back to straight-line waypoints
    final routePoints = _roadSnappedRoute.isNotEmpty
        ? _roadSnappedRoute
        : _palkhiRouteWaypoints;

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

        // Palkhi Pilgrimage Route Polyline (now road-snapped!)
        PolylineLayer(
          polylines: [
            Polyline(
              points: routePoints,
              color: const Color(0xFF8F4E00).withValues(alpha: 0.4),
              strokeWidth: 7.0,
            ),
            Polyline(
              points: routePoints,
              color: AppColors.primaryContainer,
              strokeWidth: 4.0,
              borderColor: AppColors.primary,
              borderStrokeWidth: 1.0,
            ),
          ],
        ),

        // Markers: Live Palkhi + Camp Facilities + User Location
        MarkerLayer(
          markers: [
            // 1. Live Palkhi Pulsing Marker
            Marker(
              point: _livePalkhiLocation,
              width: 90,
              height: 90,
              child: _buildLivePalkhiMarker(appState),
            ),

            // 2. User Location Marker (blue dot)
            if (_userLocation != null)
              Marker(
                point: _userLocation!,
                width: 70,
                height: 70,
                child: _buildUserLocationMarker(),
              ),

            // 3. Dynamic Camp Facility Markers
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

  // --- User Location Marker Widget (blue Google Maps style dot) ---
  Widget _buildUserLocationMarker() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
          decoration: BoxDecoration(
            color: Colors.blue.shade700,
            borderRadius: BorderRadius.circular(9999),
            boxShadow: const [
              BoxShadow(
                color: Color(0x401565C0),
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            'You',
            style: AppTypography.labelBold.copyWith(
              color: Colors.white,
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ),
        const SizedBox(height: 3),
        ScaleTransition(
          scale: _pulseAnimation,
          child: Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.blue.shade500.withValues(alpha: 0.15),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Container(
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  color: Colors.blue.shade600,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2.5),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.blue.shade400.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // --- Live Palkhi Marker Widget ---
  Widget _buildLivePalkhiMarker(AppState appState) {
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
            appState.translate('live_palkhi'),
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
