// ignore_for_file: prefer_const_constructors
import 'package:flutter_map/flutter_map.dart';
import 'package:puam_app/map/data/campus_artworks.dart';
import 'package:puam_app/map/domain/models/art_marker.dart';

List<Marker> artMarkers = campusArtworks
    .map((artwork) => CampusArtMarker(campusArtwork: artwork))
    .toList();
