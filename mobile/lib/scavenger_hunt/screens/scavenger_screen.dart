import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/scavenger_hunt/index.dart';

class ScavengerHuntScreen extends StatelessWidget {
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text('Hint: ${state.proximityHint}'),
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
