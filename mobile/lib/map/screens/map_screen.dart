// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
import 'package:puam_app/map/domain/models/art_marker.dart';
import 'package:puam_app/map/screens/markers.dart';
import 'package:puam_app/shared/index.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:puam_app/map/index.dart';

class MapPage extends StatelessWidget {
  MapPage({Key? key}) : super(key: key);

  final PopupController _popupController = PopupController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: BlocBuilder<LocationBloc, LocationState>(
        builder: (context, state) {
          if (state is LocationInitial) {
            context.read<LocationBloc>().add(FetchCurrentLocation());
            return Center(child: CircularProgressIndicator());
          } else if (state is LocationLoaded) {
            return PopupScope(
              popupController: _popupController,
              child: FlutterMap(
                options: MapOptions(
                  initialCenter: state.location,
                  maxZoom: 20,
                  minZoom: 15,
                  initialZoom: 18,
                  onTap: (_, __) => _popupController
                      .hideAllPopups(), // Hide popup when the map is tapped.
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    maxZoom: 20,
                  ),
                  CurrentLocationLayer(
                    followCurrentLocationStream: context
                        .read<LocationBloc>()
                        .followCurrentLocationStream,
                  ),
                  Container(
                    padding: EdgeInsets.all(10),
                    alignment: Alignment.bottomRight,
                    child: SizedBox(
                      height: 75,
                      child: _locationButton(context),
                    ),
                  ),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 120,
                      rotate: false,
                      disableClusteringAtZoom: 17,
                      markers: artMarkers,
                      onMarkersClustered: (p0) =>
                          _popupController.hideAllPopups(),
                      size: const Size(40, 40),
                      builder: (context, markers) {
                        return FloatingActionButton(
                          onPressed: null,
                          backgroundColor: AppTheme.princetonOrange,
                          child: Text(markers.length.toString()),
                        );
                      },
                      popupOptions: PopupOptions(
                        popupSnap: PopupSnap.markerTop,
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
                ],
              ),
            );
          } else if (state is LocationError) {
            return Center(child: Text(state.message));
          } else {
            return Center(child: Text("Unknown state!"));
          }
        },
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
        height: 300,
        color: Colors.white,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Image.network(
                marker.campusArtwork.imageUrl,
                fit: BoxFit.contain,
              ),
            ),
            Text('${marker.campusArtwork.name} (${marker.campusArtwork.year})'),
            Text(marker.campusArtwork.artist),
          ],
        ),
      ),
    );
  }

  FloatingActionButton _locationButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white.withOpacity(0.7),
      splashColor: AppTheme.princetonOrange.withOpacity(0.4),
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
}