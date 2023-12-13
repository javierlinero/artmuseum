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
  num artworks = 1;

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
      appBar: appBar(),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final topSectionHeight = constraints.maxHeight * 0.1;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Container(
                height: topSectionHeight,
                child: Center(
                  child: Text(
                    'Scavenger Hunt',
                    style: AppTheme.pageTitle,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Column(
                      children: [
                        Text('Select the amount of artworks to search for!'),
                        _buildSlider(),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppTheme.princetonOrange,
                      ),
                      onPressed: () =>
                          BlocProvider.of<ArtworkScavengerHuntBloc>(context)
                              .add(StartScavengerHunt(artworks.toInt())),
                      child: Text(
                        'Start Scavenger Hunt',
                        style: TextStyle(color: Colors.black),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSlider() {
    return SfSlider(
        activeColor: AppTheme.princetonOrange,
        inactiveColor: Colors.grey,
        value: artworks,
        min: 1,
        max: 20,
        thumbIcon: Text(
          '${artworks.toInt()}',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        onChanged: ((value) {
          setState(() {
            artworks = value;
          });
        }));
  }

  Widget _buildInProgressScreen(
      ScavengerHuntInProgress state, BuildContext context) {
    return Scaffold(
      appBar:
          appBar(helpText: HelpData.progressScavengerHelp, context: context),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Column(
              children: [
                Text(
                    '${state.proximityHint}: ${state.distance.toStringAsFixed(0)} meters away.'),
                Text('Image will get less blurry as you get closer!'),
              ],
            ),
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
      return CircularProgressIndicator(
        color: AppTheme.princetonOrange,
      );
    } else {
      return ClipRect(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: 500,
          ),
          child: ImageFiltered(
            imageFilter: ImageFilter.blur(
              sigmaX: calculateBlurLevel(state.distance),
              sigmaY: calculateBlurLevel(state.distance),
            ),
            child: CachedNetworkImage(
              imageUrl:
                  '${state.currentTarget.imageUrl}/full/full/0/default.jpg',
              fit: BoxFit.contain,
              placeholder: (context, url) => CircularProgressIndicator(
                color: AppTheme.princetonOrange,
              ),
              errorWidget: (context, url, error) => Icon(Icons.error),
            ),
          ),
        ),
      );
    }
  }

  Widget _buildCompletedScreen() {
    return Scaffold(
      appBar: appBar(),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
              child: Text(
                  'Congratulations! You have completed the scavenger hunt.')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.princetonOrange,
            ),
            onPressed: () => BlocProvider.of<ArtworkScavengerHuntBloc>(context)
                .add(EndScavengerHunt()),
            child: Text(
              'Play Again!',
              style: TextStyle(color: Colors.black),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultScreen(ScavengerHuntState state) {
    debugPrint(state.toString());
    if (state is ScavengerHuntError) {
      debugPrint(state.message);
    }
    return Scaffold(
      appBar: AppBar(title: Text('Scavenger Hunt')),
      body: Center(
          child: CircularProgressIndicator(
        color: AppTheme.princetonOrange,
      )),
    );
  }
}
