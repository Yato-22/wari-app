import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:latlong2/latlong.dart';

/// Service that fetches road-snapped routes from the OSRM routing engine.
/// Uses the public OSRM demo server with the "foot" profile (walking).
class RoutingService {
  static const String _baseUrl = 'https://router.project-osrm.org';
  static const String _profile = 'foot'; // walking pilgrimage

  // Cached route so we only fetch once per app session
  static List<LatLng>? _cachedRoute;

  /// Fetches a road-following route through the given [waypoints].
  ///
  /// Returns a list of [LatLng] points that follow the actual road network.
  /// Falls back to the original waypoints if the API call fails.
  static Future<List<LatLng>> fetchRoute(List<LatLng> waypoints) async {
    // Return cached route if available
    if (_cachedRoute != null && _cachedRoute!.isNotEmpty) {
      return _cachedRoute!;
    }

    try {
      // Build coordinate string: lon1,lat1;lon2,lat2;...
      final coordinates = waypoints
          .map((p) => '${p.longitude},${p.latitude}')
          .join(';');

      final url = Uri.parse(
        '$_baseUrl/route/v1/$_profile/$coordinates'
        '?overview=full&geometries=polyline',
      );

      final response = await http.get(url).timeout(
        const Duration(seconds: 15),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['code'] == 'Ok' &&
            data['routes'] != null &&
            (data['routes'] as List).isNotEmpty) {
          final encodedPolyline =
              data['routes'][0]['geometry'] as String;

          final decoded = _decodePolyline(encodedPolyline);

          if (decoded.isNotEmpty) {
            _cachedRoute = decoded;
            return decoded;
          }
        }
      }

      // API returned non-200 or unexpected format — fall back
      return waypoints;
    } catch (e) {
      // Network error, timeout, etc. — fall back to straight lines
      return waypoints;
    }
  }

  /// Clears the cached route (useful if waypoints change).
  static void clearCache() {
    _cachedRoute = null;
  }

  /// Decodes a Google-encoded polyline string into a list of [LatLng].
  ///
  /// Algorithm reference: https://developers.google.com/maps/documentation/utilities/polylinealgorithm
  static List<LatLng> _decodePolyline(String encoded) {
    final points = <LatLng>[];
    int index = 0;
    int lat = 0;
    int lng = 0;

    while (index < encoded.length) {
      // Decode latitude
      int shift = 0;
      int result = 0;
      int byte;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lat += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      // Decode longitude
      shift = 0;
      result = 0;
      do {
        byte = encoded.codeUnitAt(index++) - 63;
        result |= (byte & 0x1F) << shift;
        shift += 5;
      } while (byte >= 0x20);
      lng += (result & 1) != 0 ? ~(result >> 1) : (result >> 1);

      points.add(LatLng(lat / 1e5, lng / 1e5));
    }

    return points;
  }
}
