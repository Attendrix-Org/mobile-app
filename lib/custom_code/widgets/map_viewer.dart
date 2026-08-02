// Automatic FlutterFlow imports
import '/backend/schema/structs/index.dart';
import '/backend/schema/enums/enums.dart';
import '/backend/supabase/supabase.dart';
import '/flutter_flow/flutter_flow_theme.dart';
import '/flutter_flow/flutter_flow_util.dart';
import '/custom_code/widgets/index.dart'; // Imports other custom widgets
import '/custom_code/actions/index.dart'; // Imports custom actions
import '/flutter_flow/custom_functions.dart'; // Imports custom functions
import 'package:flutter/material.dart';
// Begin custom action code
// DO NOT REMOVE OR MODIFY THE CODE ABOVE!

import 'dart:async';
import 'dart:ui';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart' as ll;

class MapViewer extends StatefulWidget {
  const MapViewer({
    super.key,
    this.width,
    this.height,
    required this.userLocation,
    required this.destinationBuilding,
    this.destinationBuildingId,
    required this.mapTilerKey,
    this.orsApiKey = '',
    this.autoFollowUser = true,
    this.onRouteUpdated,
    this.targetArrivalTime,
    this.serverTimeOffsetMs,
  });

  final double? width;
  final double? height;
  final LatLng userLocation;
  final LatLng destinationBuilding;
  final String? destinationBuildingId;
  final String mapTilerKey;
  final String orsApiKey;
  final bool autoFollowUser;
  final Future Function(RouteResultStruct? route)? onRouteUpdated;
  final DateTime? targetArrivalTime;
  final int? serverTimeOffsetMs;

  @override
  State<MapViewer> createState() => _MapViewerState();
}

class _MapViewerState extends State<MapViewer> with SingleTickerProviderStateMixin {
  static const _distanceCalc = ll.Distance();

  final MapController _mapController = MapController();

  RouteResultStruct? _route;
  bool _isLoading = true;
  bool _hasInitialFit = false;

  int _requestToken = 0;
  Timer? _debounce;
  late AnimationController _pulseController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _fetchRoute();
  }

  @override
  void didUpdateWidget(MapViewer oldWidget) {
    super.didUpdateWidget(oldWidget);

    final movedMeaningfully = _distanceMoved(
          oldWidget.userLocation,
          widget.userLocation,
        ) >
        12.0;

    final destinationChanged = oldWidget.destinationBuilding.latitude !=
            widget.destinationBuilding.latitude ||
        oldWidget.destinationBuilding.longitude !=
            widget.destinationBuilding.longitude;

    final scheduleChanged =
        oldWidget.targetArrivalTime != widget.targetArrivalTime;

    if (destinationChanged) {
      _hasInitialFit = false;
      _fetchRouteDebounced();
    } else if (movedMeaningfully || scheduleChanged) {
      _fetchRouteDebounced();
    }
  }

  @override
  void dispose() {
    _debounce?.cancel();
    _pulseController.dispose();
    super.dispose();
  }

  double _distanceMoved(LatLng a, LatLng b) {
    return _distanceCalc.as(
      ll.LengthUnit.Meter,
      ll.LatLng(a.latitude, a.longitude),
      ll.LatLng(b.latitude, b.longitude),
    );
  }

  void _fetchRouteDebounced() {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 600), _fetchRoute);
  }

  Future<void> _fetchRoute() async {
    final token = ++_requestToken;

    if (_route == null) {
      setState(() => _isLoading = true);
    }

    final result = await calculateWalkRoute(
      widget.userLocation,
      widget.destinationBuilding,
      true,
      widget.targetArrivalTime,
    );

    if (!mounted || token != _requestToken) {
      return;
    }

    final unchanged = _route != null &&
        _route!.confidence == result.confidence &&
        (_route!.distanceMeters - result.distanceMeters).abs() < 5.0 &&
        (_route!.durationSeconds - result.durationSeconds).abs() < 5 &&
        _route!.isLate == result.isLate &&
        _route!.isLeaveNow == result.isLeaveNow;

    if (unchanged) {
      if (_isLoading) setState(() => _isLoading = false);
      return;
    }

    setState(() {
      _route = result;
      _isLoading = false;
    });

    if (widget.onRouteUpdated != null) {
      widget.onRouteUpdated!(result);
    }

    if (widget.autoFollowUser &&
        !_hasInitialFit &&
        result.polyline.length >= 2) {
      _fitToRoute(result.polyline);
      _hasInitialFit = true;
    }
  }

  void _fitToRoute(List<LatLng> points) {
    if (points.length < 2) return;
    final llPoints =
        points.map((p) => ll.LatLng(p.latitude, p.longitude)).toList();
    final bounds = LatLngBounds.fromPoints(llPoints);
    _mapController.fitCamera(
      CameraFit.bounds(bounds: bounds, padding: const EdgeInsets.all(48.0)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = FlutterFlowTheme.of(context);
    final userLl =
        ll.LatLng(widget.userLocation.latitude, widget.userLocation.longitude);
    final destLl = ll.LatLng(
      widget.destinationBuilding.latitude,
      widget.destinationBuilding.longitude,
    );

    final hasDrawableRoute =
        _route != null && _route!.polyline.length >= 2 && _route!.confidence != 'none';
    final routePoints = hasDrawableRoute
        ? _route!.polyline
            .map((p) => ll.LatLng(p.latitude, p.longitude))
            .toList()
        : <ll.LatLng>[];

    return Container(
      width: widget.width,
      height: widget.height,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: theme.secondaryBackground,
        borderRadius: BorderRadius.circular(16.0),
        border: Border.all(color: theme.alternate.withOpacity(0.6), width: 1.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: userLl,
              initialZoom: 16.5,
              minZoom: 13.5,
              maxZoom: 19.0,
            ),
            children: [
              TileLayer(
                urlTemplate:
                    'https://api.maptiler.com/maps/streets-v2/{z}/{x}/{y}.png?key=${widget.mapTilerKey}',
                userAgentPackageName: 'com.attendrix.campusapp',
              ),
              const RichAttributionWidget(
                attributions: [
                  TextSourceAttribution('OpenStreetMap contributors'),
                  TextSourceAttribution('MapTiler'),
                ],
              ),
              if (hasDrawableRoute) ...[
                PolylineLayer(
                  polylines: [
                    Polyline(
                      points: routePoints,
                      strokeWidth: 8.0,
                      color: theme.primary.withOpacity(0.3),
                    ),
                    Polyline(
                      points: routePoints,
                      strokeWidth: 5.0,
                      color: theme.primary,
                      borderStrokeWidth: 1.5,
                      borderColor: Colors.white,
                    ),
                  ],
                ),
              ],
              MarkerLayer(
                markers: [
                  Marker(
                    point: userLl,
                    width: 38.0,
                    height: 38.0,
                    child: AnimatedBuilder(
                      animation: _pulseController,
                      builder: (context, child) {
                        return Stack(
                          alignment: Alignment.center,
                          children: [
                            Container(
                              width: 32 + (10 * _pulseController.value),
                              height: 32 + (10 * _pulseController.value),
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                color: theme.primary.withOpacity(0.25 * (1 - _pulseController.value)),
                              ),
                            ),
                            Container(
                              width: 22.0,
                              height: 22.0,
                              decoration: BoxDecoration(
                                color: theme.secondary,
                                shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 3.0),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 8,
                                    offset: const Offset(0, 2),
                                  )
                                ],
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  Marker(
                    point: destLl,
                    width: 44.0,
                    height: 44.0,
                    alignment: Alignment.topCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          padding: const EdgeInsets.all(6.0),
                          decoration: BoxDecoration(
                            color: theme.primary,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: theme.primary.withOpacity(0.4),
                                blurRadius: 10,
                                offset: const Offset(0, 3),
                              )
                            ],
                            border: Border.all(color: Colors.white, width: 2.5),
                          ),
                          child: const Icon(
                            Icons.location_on_rounded,
                            color: Colors.white,
                            size: 22.0,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
          Positioned(
            top: 12.0,
            left: 12.0,
            right: 12.0,
            child: _buildStatusBanner(theme),
          ),
          Positioned(
            bottom: 12.0,
            right: 12.0,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (hasDrawableRoute) ...[
                  FloatingActionButton.small(
                    heroTag: 'recenter_map_btn',
                    backgroundColor: theme.secondaryBackground,
                    elevation: 4.0,
                    onPressed: () => _fitToRoute(_route!.polyline),
                    child: Icon(
                      Icons.center_focus_strong_rounded,
                      color: theme.primary,
                      size: 20.0,
                    ),
                  ),
                  const SizedBox(height: 8.0),
                ],
                FloatingActionButton.small(
                  heroTag: 'user_location_btn',
                  backgroundColor: theme.secondaryBackground,
                  elevation: 4.0,
                  onPressed: () {
                    _mapController.move(userLl, 17.0);
                  },
                  child: Icon(
                    Icons.my_location_rounded,
                    color: theme.primaryText,
                    size: 20.0,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBanner(FlutterFlowTheme theme) {
    if (_isLoading) {
      return _bannerGlassContainer(
        theme,
        accentColor: theme.primary,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 14,
              height: 14,
              child: CircularProgressIndicator(
                strokeWidth: 2.2,
                valueColor: AlwaysStoppedAnimation<Color>(theme.primary),
              ),
            ),
            const SizedBox(width: 10),
            Text(
              'Calculating walking route...',
              style: theme.bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      );
    }

    if (_route == null || _route!.confidence == 'none') {
      return _bannerGlassContainer(
        theme,
        accentColor: theme.secondaryText,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.location_off_rounded, size: 18, color: theme.secondaryText),
            const SizedBox(width: 8),
            Text(
              'Location / Route unavailable',
              style: theme.bodyMedium.override(
                fontFamily: 'Readex Pro',
                color: theme.secondaryText,
              ),
            ),
          ],
        ),
      );
    }

    final isApproximate = _route!.confidence == 'approximate';

    Color bannerAccent = theme.primary;
    if (_route!.isLate) {
      bannerAccent = theme.error;
    } else if (_route!.isLeaveNow || isApproximate) {
      bannerAccent = theme.warning;
    }

    final labelText = isApproximate
        ? '${_route!.statusMessage} (est.)'
        : _route!.statusMessage;

    return _bannerGlassContainer(
      theme,
      accentColor: bannerAccent,
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: bannerAccent.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _route!.isLate
                  ? Icons.warning_amber_rounded
                  : (_route!.isLeaveNow
                      ? Icons.directions_walk_rounded
                      : Icons.timer_outlined),
              size: 18.0,
              color: bannerAccent,
            ),
          ),
          const SizedBox(width: 10.0),
          Expanded(
            child: Text(
              labelText,
              style: theme.bodyMedium.override(
                fontFamily: 'Readex Pro',
                fontWeight: FontWeight.w600,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (_route!.formattedDistance.isNotEmpty) ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: theme.primaryBackground,
                borderRadius: BorderRadius.circular(6),
              ),
              child: Text(
                _route!.formattedDistance,
                style: theme.bodySmall.override(
                  fontFamily: 'Readex Pro',
                  fontWeight: FontWeight.w600,
                  color: theme.secondaryText,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _bannerGlassContainer(
    FlutterFlowTheme theme, {
    required Color accentColor,
    required Widget child,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(12.0),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10.0, sigmaY: 10.0),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14.0, vertical: 10.0),
          decoration: BoxDecoration(
            color: theme.secondaryBackground.withOpacity(0.88),
            borderRadius: BorderRadius.circular(12.0),
            border: Border.all(color: accentColor.withOpacity(0.3), width: 1.2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.12),
                blurRadius: 10,
                offset: const Offset(0, 3),
              )
            ],
          ),
          child: child,
        ),
      ),
    );
  }
}
