// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:puam_app/shared/index.dart';
import 'package:flutter_map_location_marker/flutter_map_location_marker.dart';
import 'package:puam_app/map/index.dart';

class MapPage extends StatelessWidget {
  const MapPage({Key? key}) : super(key: key);
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
            return FlutterMap(
              options: MapOptions(
                initialCenter: state.location,
                maxZoom: 20,
                minZoom: 15,
                initialZoom: 18,
                // onPositionChanged: (MapPosition position, bool hasGesture) {
                //   if (hasGesture) {
                //     context.read<LocationBloc>().add(FetchCurrentLocation());
                //   }
                // },
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                  maxZoom: 20,
                ),
                CurrentLocationLayer(
                  followCurrentLocationStream:
                      context.read<LocationBloc>().followCurrentLocationStream,
                  // followOnLocationUpdate: FollowOnLocationUpdate.always,
                ),
                Container(
                  padding: EdgeInsets.all(10),
                  alignment: Alignment.topRight,
                  child: SizedBox(
                    height: 50,
                    child: _locationButton(context),
                  ),
                ),
              ],
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
