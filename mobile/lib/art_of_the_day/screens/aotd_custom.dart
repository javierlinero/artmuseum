import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/art_of_the_day/index.dart';
import 'package:puam_app/shared/index.dart';

class ArtOfTheDayContent extends StatefulWidget {
  final String? token;

  ArtOfTheDayContent(this.token);

  @override
  _ArtOfTheDayContentState createState() => _ArtOfTheDayContentState();
}

class _ArtOfTheDayContentState extends State<ArtOfTheDayContent> {
  late ArtBloc _artBloc;

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _artBloc = ArtBloc(ArtworkRepository());
    if (widget.token != null) {
      _artBloc.add(FetchArtOfTheDayEvent(token: widget.token));
    } else {
      _artBloc.add(FetchArtOfTheDayEvent());
    }
  }

  @override
  void dispose() {
    _artBloc.close();
    super.dispose();
  }

  @override
  void didUpdateWidget(ArtOfTheDayContent oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Trigger the fetch event whenever the token changes
    if (widget.token != oldWidget.token) {
      _artBloc.add(FetchArtOfTheDayEvent(token: widget.token));
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ArtBloc, ArtState>(
      bloc: _artBloc,
      builder: (context, state) {
        if (state is ArtLoading || state is ArtInitial) {
          return Center(
              child: CircularProgressIndicator(
            color: AppTheme.princetonOrange,
          ));
        } else if (state is ArtLoaded) {
          return _buildArtwork(state.artwork);
        } else if (state is ArtError) {
          // return Center(child: Text(state.message));
          return ArtOfTheDayDefault();
        }
        return Center(child: Text('Unexpected state'));
      },
    );
  }

  Widget _buildArtwork(Artwork aotd) {
    return Scaffold(
      appBar: appBar(helpText: HelpData.aotdHelp, context: context),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: constraints.maxHeight * 0.1,
                  child: Center(
                    child: Text(
                      'Art of the Day',
                      style: AppTheme.pageTitle,
                    ),
                  ),
                ),
                Container(
                  height: constraints.maxHeight * 0.5,
                  child: PaintingWidget(imageUrl: aotd.imageUrl),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.03,
                  ),
                  height: constraints.maxHeight * 0.05,
                  child: ArtworkNameWidget(title: aotd.title),
                ),
                SizedBox(height: 5),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.03,
                  ),
                  height: constraints.maxHeight * 0.01,
                  child: YearWidget(year: aotd.year),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.03,
                  ),
                  height: constraints.maxHeight * 0.025,
                  child:
                      DetailsWidget(materials: aotd.materials, size: aotd.size),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.03,
                  ),
                  height: constraints.maxHeight * 0.05,
                  child: ArtistWidget(artists: aotd.artists),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: deviceWidth(context) * 0.03,
                  ),
                  height: constraints.maxHeight * 0.2,
                  child:
                      ArtworkDescriptionWidget(description: aotd.description),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
