import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:puam_app/shared/index.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';

class MapPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: FlutterMap(
        options: const MapOptions(
          initialCenter: LatLng(40.3430942, -74.6550739),
          maxZoom: 19,
          minZoom: 15,
          initialZoom: 15,
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
            maxZoom: 19,
          ),
          CurrentLocationLayer(),
        ],
      ),
    );
  }
}
