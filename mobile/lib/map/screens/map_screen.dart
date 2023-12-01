// ignore_for_file: prefer_const_constructors, prefer_const_constructors_in_immutables

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:puam_app/map/screens/markers.dart';
import 'package:puam_app/scavenger_hunt/screens/scavenger_screen.dart';
import 'package:puam_app/shared/index.dart';
import 'package:geolocator/geolocator.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:puam_app/map/index.dart';

class MapPage extends StatefulWidget {
  MapPage({Key? key}) : super(key: key);

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final PopupController _popupController = PopupController();
  late final MapController _mapController;
  final Completer<void> _locationPermissionCompleter = Completer();

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _handleLocationPermission();
  }

  Future<void> _handleLocationPermission() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
    if (permission == LocationPermission.whileInUse ||
        permission == LocationPermission.always) {
      _locationPermissionCompleter.complete();
    }
  }

  // void _fetchLocation() {
  //   if (mounted) {
  //     BlocProvider.of<LocationBloc>(context).add(FetchCurrentLocation());
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LocationBloc>(
      create: (context) => LocationBloc(_mapController),
      child: Scaffold(
        appBar: appBar(),
        body: BlocBuilder<LocationBloc, LocationState>(
          builder: (context, state) {
            if (state is LocationInitial) {
              _locationPermissionCompleter.future.then((_) {
                context.read<LocationBloc>().add(FetchCurrentLocation());
              });
              return Center(child: CircularProgressIndicator());
            } else if (state is LocationLoaded) {
              return _buildMap(state, context);
            } else if (state is LocationError) {
              return Center(child: Text(state.message));
            } else {
              return Center(child: Text("Unknown state!"));
            }
          },
        ),
      ),
    );
  }

  PopupScope _buildMap(LocationLoaded state, BuildContext context) {
    return PopupScope(
      popupController: _popupController,
      child: Stack(
        children: [
          FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: state.location,
              maxZoom: 21,
              minZoom: 15,
              initialZoom: 18,
              onTap: (_, __) => _popupController
                  .hideAllPopups(), // Hide popup when the map is tapped.
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                maxZoom: 21,
                userAgentPackageName: 'com.puam.app',
              ),
              CurrentLocationLayer(
                followCurrentLocationStream:
                    context.read<LocationBloc>().followCurrentLocationStream,
              ),
              MarkerClusterLayerWidget(
                options: MarkerClusterLayerOptions(
                  maxClusterRadius: 80,
                  rotate: false,
                  disableClusteringAtZoom: 20,
                  zoomToBoundsOnClick: false,
                  markers: artMarkers,
                  onMarkersClustered: (p0) => _popupController.hideAllPopups(),
                  size: const Size(40, 40),
                  builder: (context, markers) {
                    return Container(
                      height: 30,
                      width: 30,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                          color: AppTheme.princetonOrange,
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: Colors.black,
                            width: 2,
                          )),
                      child: Text(markers.length.toString()),
                    );
                  },
                  popupOptions: PopupOptions(
                    popupSnap: PopupSnap.markerTop,
                    popupAnimation: PopupAnimation.fade(),
                    popupController: _popupController,
                    popupBuilder: (_, marker) {
                      if (marker is CampusArtMarker) {
                        return _buildPopup(marker);
                      } else {
                        throw Error();
                      }
                    },
                  ),
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.topRight,
                child: ZoomButtons(
                  onZoomIn: () {
                    context.read<LocationBloc>().add(ZoomIn());
                  },
                  onZoomOut: () {
                    context.read<LocationBloc>().add(ZoomOut());
                  },
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: 75,
                  child: _locationButton(context),
                ),
              ),
              Positioned(
                right: 20,
                bottom: 100,
                child: _startScavengerHuntButton(context),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _buildPopup(CampusArtMarker marker) {
    return GestureDetector(
      onTap: () {
        debugPrint(marker.campusArtwork.name);
      },
      child: Container(
        width: 150,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxHeight: 200,
                ),
                child: Image.network(
                  '${marker.campusArtwork.imageUrl}/full/pct:25/0/default.jpg',
                  fit: BoxFit.contain,
                ),
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.only(left: 8.0, right: 8.0, bottom: 8.0),
              child: Text(
                '${marker.campusArtwork.name} (${marker.campusArtwork.year})',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(marker.campusArtwork.artist),
            ),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _locationButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white,
      splashColor: AppTheme.princetonOrange,
      shape: CircleBorder(),
      onPressed: () {
        _popupController.hideAllPopups();
        context.read<LocationBloc>().add(ZoomAndFollowCurrentLocation());
      },
      child: Icon(
        Icons.near_me_outlined,
        color: AppTheme.princetonOrange,
      ),
    );
  }

  Widget _startScavengerHuntButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        // Navigate to ScavengerHuntScreen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => ScavengerHuntScreen()),
        );
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: AppTheme.princetonOrange,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        elevation: 4,
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
      ),
      child: Text('Start Scavenger Hunt'),
    );
  }
}
