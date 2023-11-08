import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/map/index.dart';

class CampusArtMarker extends Marker {
  CampusArtMarker({required this.campusArtwork})
      : super(
            point: LatLng(campusArtwork.lat, campusArtwork.long),
            child: Container(
              height: 5,
              width: 5,
              decoration: BoxDecoration(
                  color: AppTheme.princetonOrange,
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.black,
                    width: 2,
                  )),
            ));

  final CampusArtwork campusArtwork;
}
