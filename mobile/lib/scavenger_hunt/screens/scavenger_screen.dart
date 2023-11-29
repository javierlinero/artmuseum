// ignore_for_file: prefer_const_constructors

import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/scavenger_hunt/index.dart';
import 'package:puam_app/shared/index.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

class ScavengerHuntScreen extends StatefulWidget {
  @override
  State<ScavengerHuntScreen> createState() => _ScavengerHuntScreenState();
}

class _ScavengerHuntScreenState extends State<ScavengerHuntScreen> {
  double artworks = 1;

  double calculateBlurLevel(double distance) {
    const maxDistance = 500.0; // Max distance for max blur
    const minBlur = 0.0; // No blur when the target is reached
    const maxBlur = 10.0; // Maximum blur

    if (distance <= 50) {
      return minBlur;
    }

    double blurRatio = distance / maxDistance;

    double blur = maxBlur * (blurRatio);
    return blur.clamp(minBlur, maxBlur);
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtworkScavengerHuntBloc, ScavengerHuntState>(
      builder: (context, state) {
        if (state is ScavengerHuntInitial) {
          return _buildInitialScreen(context);
        } else if (state is ScavengerHuntInProgress) {
          return _buildInProgressScreen(state, context);
        } else if (state is ScavengerHuntCompleted) {
          return _buildCompletedScreen();
        } else if (state is ScavengerHuntError &&
            state.message == "No current target set.") {
          return _buildInitialScreen(context);
        } else {
          return Text('Oops... you\'re not supposed to see this.');
        }
      },
    );
  }

  Widget _buildInitialScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start Scavenger Hunt')),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SfSlider(
              value: artworks,
              onChanged: ((value) {
                setState(() {
                  artworks = value;
                });
              })),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.princetonOrange,
              ),
              onPressed: () =>
                  BlocProvider.of<ArtworkScavengerHuntBloc>(context)
                      .add(StartScavengerHunt(5)),
              child: Text(
                'Start Scavenger Hunt',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInProgressScreen(
      ScavengerHuntInProgress state, BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Scavenger Hunt In Progress')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Text(
                '${state.proximityHint}: ${state.distance.toStringAsFixed(0)} meters away.'),
            _buildBlurredImage(state),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.princetonOrange,
              ),
              onPressed: () =>
                  BlocProvider.of<ArtworkScavengerHuntBloc>(context)
                      .add(ArtworkFound()),
              child: Text(
                'Found',
                style: TextStyle(color: Colors.black),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBlurredImage(ScavengerHuntInProgress state) {
    if (state.distance < 0) {
      return CircularProgressIndicator();
    } else {
      return ClipRect(
        // Clip the image to its bounds
        child: ImageFiltered(
          imageFilter: ImageFilter.blur(
            sigmaX: calculateBlurLevel(state.distance),
            sigmaY: calculateBlurLevel(state.distance),
          ),
          child: CachedNetworkImage(
            imageUrl: '${state.currentTarget.imageUrl}/full/full/0/default.jpg',
            fit: BoxFit.contain,
            placeholder: (context, url) => CircularProgressIndicator(),
            errorWidget: (context, url, error) => Icon(Icons.error),
          ),
        ),
      );
    }
  }

  Widget _buildCompletedScreen() {
    return Scaffold(
      appBar: AppBar(title: Text('Scavenger Hunt Completed')),
      body: Center(
          child:
              Text('Congratulations! You have completed the scavenger hunt.')),
    );
  }

  Widget _buildDefaultScreen(ScavengerHuntState state) {
    debugPrint(state.toString());
    if (state is ScavengerHuntError) {
      debugPrint('meow');
      debugPrint(state.message);
    }
    return Scaffold(
      appBar: AppBar(title: Text('Scavenger Hunt')),
      body: Center(child: CircularProgressIndicator()),
    );
  }
}
