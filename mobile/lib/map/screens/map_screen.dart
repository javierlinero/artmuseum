// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_marker_cluster/flutter_map_marker_cluster.dart';
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
                    alignment: Alignment.topRight,
                    child: SizedBox(
                      height: 50,
                      child: _locationButton(context),
                    ),
                  ),
                  MarkerClusterLayerWidget(
                    options: MarkerClusterLayerOptions(
                      maxClusterRadius: 120,
                      rotate: false,
                      disableClusteringAtZoom: 20,
                      markers: artMarkers,
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
                          popupBuilder: (_, marker) => Container(
                                width: 200,
                                height: 100,
                                color: Colors.white,
                                child: GestureDetector(
                                  onTap: () => debugPrint('Popup tap!'),
                                  child: const Text(
                                    'Container popup for marker',
                                  ),
                                ),
                              )),
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

  FloatingActionButton _locationButton(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.white.withOpacity(0.7),
      splashColor: AppTheme.princetonOrange.withOpacity(0.4),
      shape: CircleBorder(),
      onPressed: () {
        context.read<LocationBloc>().add(ZoomAndFollowCurrentLocation());
      },
      child: Icon(
        Icons.near_me_outlined,
        color: AppTheme.princetonOrange,
      ),
    );
  }
}
