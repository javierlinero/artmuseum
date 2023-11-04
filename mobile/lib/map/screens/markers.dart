// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

List<Marker> artMarkers = [
  Marker(
    point: LatLng(40.340694, -74.667000),
    child: Icon(Icons.location_pin),
  ),
  Marker(
    point: LatLng(40.341220, -74.666132),
    child: Icon(Icons.location_pin),
  ),
  Marker(
    point: LatLng(40.340887, -74.665171),
    child: Icon(Icons.location_pin),
  ),
];
