import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/user_profile/index.dart';
import 'package:puam_app/art_of_the_day/widgets/index.dart';

class FavoritesDetailsPage extends StatefulWidget {
  final String artWorkID;

  const FavoritesDetailsPage(this.artWorkID, {super.key});

  @override
  State<FavoritesDetailsPage> createState() => _FavoritesDetailsPageState();
}

class _FavoritesDetailsPageState extends State<FavoritesDetailsPage> {
  late FavBloc _favBloc;

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _favBloc = FavBloc(FavoriteRepo());
    _favBloc.add(FetchFavoriteEvent(artid: widget.artWorkID));
  }

  @override
  void dispose() {
    _favBloc.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: appBar(),
        body: BlocBuilder<FavBloc, FavState>(
          bloc: _favBloc,
          builder: (context, state) {
            if (state is FavLoading) {
              return Center(
                  child: CircularProgressIndicator(
                color: AppTheme.princetonOrange,
              ));
            } else if (state is FavLoaded) {
              final fav = state.favoritesDetails;
              return LayoutBuilder(
                builder: (context, constraints) {
                  return SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: constraints.maxHeight * 0.5,
                          child: PaintingWidget(imageUrl: fav.imageUrl),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.05,
                          child: ArtworkNameWidget(title: fav.title),
                        ),
                        SizedBox(height: 5),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.01,
                          child: YearWidget(year: fav.year),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.025,
                          child: DetailsWidget(
                              materials: fav.materials, size: fav.size),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.05,
                          child: ArtistWidget(artists: fav.artists),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: deviceWidth(context) * 0.03,
                          ),
                          height: constraints.maxHeight * 0.2,
                          child: ArtworkDescriptionWidget(
                              description: fav.description),
                        ),
                      ],
                    ),
                  );
                },
              );
            } else if (state is FavError) {
              return Center(
                child: Text(state.message),
              );
            }
            return Center(child: Text('Unexpected state'));
          },
        ));
  }
}
