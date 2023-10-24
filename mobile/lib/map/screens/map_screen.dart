import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:puam_app/shared/widgets/index.dart';
import 'package:puam_app/map/index.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  final LocationBloc _locationBloc = LocationBloc();
  late LatLng _currentPosition;

  @override
  void initState() {
    super.initState();
    _locationBloc.dispatch(GetInitialLocation());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: StreamBuilder<LocationState>(
        stream: _locationBloc.locationStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            if (snapshot.data is LocationLoaded) {
              _currentPosition = (snapshot.data as LocationLoaded).position;

              var markers = <Marker>[
                Marker(
                  width: 20.0,
                  height: 20.0,
                  point: _currentPosition,
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ];

              return FlutterMap(
                options: MapOptions(
                  center: _currentPosition,
                  zoom: 16.0,
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    userAgentPackageName: 'com.puam.app',
                  ),
                  MarkerLayer(markers: markers),
                ],
              );
            } else if (snapshot.data is LocationError) {
              return Center(
                  child: Text((snapshot.data as LocationError).message));
            }
          }
          return Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  @override
  void dispose() {
    _locationBloc.dispose();
    super.dispose();
  }
}
