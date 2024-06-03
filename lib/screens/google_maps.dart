import 'dart:async';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class GoogleMapsScreen extends StatefulWidget {
  final double latitude;
  final double longitude;

  const GoogleMapsScreen({
    super.key,
    required this.latitude,
    required this.longitude,
  });

  @override
  State<GoogleMapsScreen> createState() => _GoogleMapsScreenState();
}

class _GoogleMapsScreenState extends State<GoogleMapsScreen> {
  final Completer<GoogleMapController> _controller = Completer();
  late CameraPosition _cameraPosition;
  late Set<Marker> _markers;
  late MarkerId _markerId;

  @override
  void initState() {
    super.initState();
    _cameraPosition = CameraPosition(
      target: LatLng(widget.latitude, widget.longitude),
      zoom: 15,
    );

    _markers = {};
    _markerId = MarkerId('${widget.latitude}${widget.longitude}');

    _markers.add(
      Marker(
        markerId: _markerId,
        position: LatLng(widget.latitude, widget.longitude),
        infoWindow: const InfoWindow(
          title: 'Your target location',
          snippet: 'a good place to visit',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GoogleMap(
      myLocationEnabled: true,
      myLocationButtonEnabled: true,
      mapType: MapType.normal,
      initialCameraPosition: _cameraPosition,
      markers: _markers,
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
        Future.delayed(const Duration(milliseconds: 500), () {
          controller.showMarkerInfoWindow(_markerId);
        });
      },
    );
  }
}
