import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/scavenger_hunt/index.dart';

class ScavengerHuntScreen extends StatelessWidget {
  double calculateBlurLevel(double distance) {
    const maxDistance = 500.0; // Max distance for max blur
    const minBlur = 0.0; // No blur when the target is reached
    const maxBlur = 10.0; // Maximum blur

    if (distance <= 0) {
      return minBlur;
    }

    double blurRatio = (distance / maxDistance).clamp(0.0, 1.0);
    double blur = maxBlur * (1 - blurRatio);
    debugPrint(blur.toString());
    return blur;
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
          return Placeholder();
        }
      },
    );
  }

  Widget _buildInitialScreen(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Start Scavenger Hunt')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => BlocProvider.of<ArtworkScavengerHuntBloc>(context)
              .add(StartScavengerHunt(5)), // Assuming 5 artworks for example
          child: Text('Start Scavenger Hunt'),
        ),
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
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ImageFiltered(
                imageFilter: ImageFilter.blur(
                    sigmaX: calculateBlurLevel(state.distance.floorToDouble()),
                    sigmaY: calculateBlurLevel(
                      state.distance.floorToDouble(),
                    )),
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: 300,
                  ),
                  child: CachedNetworkImage(
                    imageUrl:
                        '${state.currentTarget.imageUrl}/full/full/0/default.jpg',
                    fit: BoxFit.contain,
                    placeholder: (context, url) => CircularProgressIndicator(),
                    errorWidget: (context, url, error) => Icon(Icons.error),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () =>
                  BlocProvider.of<ArtworkScavengerHuntBloc>(context)
                      .add(ArtworkFound()),
              child: Text('Found'),
            ),
          ],
        ),
      ),
    );
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
