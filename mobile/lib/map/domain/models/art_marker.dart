import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:puam_app/map/domain/models/campus_art.dart';

class CampusArtMarker extends Marker {
  CampusArtMarker({required this.campusArtwork})
      : super(
          point: LatLng(campusArtwork.lat, campusArtwork.long),
          child: const Icon(Icons.location_pin),
        );

  final CampusArtwork campusArtwork;
}
