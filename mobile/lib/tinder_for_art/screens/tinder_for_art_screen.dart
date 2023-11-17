// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/tinder_for_art/index.dart';
import 'package:puam_app/user_profile/index.dart';

class TinderForArtPage extends StatefulWidget {
  @override
  _TinderForArtPageState createState() => _TinderForArtPageState();
}

class _TinderForArtPageState extends State<TinderForArtPage> {
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  final List<TinderArt> artCards = [];
  AppinioSwiperController _swiperController = AppinioSwiperController();
  bool recommendationsFetched = false;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        if (authState is AuthStateLoggedIn) {
          return BlocProvider(
            create: (context) => TinderArtBloc(
                repository: TinderForArtRepository(token: authState.token)),
            child: BlocBuilder<TinderArtBloc, ArtworkState>(
              builder: (context, artState) {
                if (!recommendationsFetched) {
                  context
                      .read<TinderArtBloc>()
                      .add(FetchArtworkRecommendations(10, authState.token));
                  recommendationsFetched = true;
                }
                return _buildTFAPage(context, artState);
              },
            ),
          );
        } else if (authState is AuthStateLoggedOut) {
          return SignUpPage();
        } else {
          return Center(child: CircularProgressIndicator());
        }
      },
    );
  }

  Widget _buildTFAPage(BuildContext context, ArtworkState artState) {
    final appinioController = AppinioController(
      totalArtworks: artCards.length,
      context: context,
      swiperController: _swiperController,
    );

    if (artState.isLoading) {
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    } else if (artState.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${artState.error}')));
    } else {
      artCards.clear();
      artCards.addAll(artState.recommendations);

      return Scaffold(
        appBar: appBar(),
        body: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            double swiperHeight = constraints.maxHeight * 0.7;
            double buttonsHeight = constraints.maxHeight * 0.25;
            double undoHeight = constraints.maxHeight * 0.05;

            return Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: deviceWidth(context) * 0.05),
                  child: SizedBox(
                    height: undoHeight,
                    child: TinderUndoButton(
                        appinioController: appinioController, state: artState),
                  ),
                ),
                Container(
                  height: swiperHeight,
                  alignment: Alignment.center,
                  child: TinderSwiper(
                    swiperController: _swiperController,
                    imageCards: artCards,
                    appinioController: appinioController,
                  ),
                ),
                SizedBox(
                  height: buttonsHeight,
                  child: TinderButtonActionRow(
                      swiperController: _swiperController),
                ),
              ],
            );
          },
        ),
      );
    }
  }
}
