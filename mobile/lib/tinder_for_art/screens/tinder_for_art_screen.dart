// ignore_for_file: prefer_const_constructors

import 'package:cached_network_image/cached_network_image.dart';
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
  bool isInitialized = false;

  Future<void> preloadImages(
      List<TinderArt> imageCards, BuildContext context) async {
    for (var art in imageCards) {
      final imageUrl = '${art.imageUrl}/full/pct:15/0/default.jpg';
      final imageProvider = CachedNetworkImageProvider(imageUrl);
      await precacheImage(imageProvider, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(
      builder: (context, authState) {
        // Ensure TinderArtBloc is available above where it's needed
        return BlocProvider(
          create: (context) => TinderArtBloc(
            repository: TinderForArtRepository(
                token: authState is AuthStateLoggedIn ? authState.token : ''),
          ),
          child: BlocBuilder<TinderArtBloc, ArtworkState>(
            builder: (context, artState) {
              if (authState is AuthStateLoggedIn) {
                // Initialize only once
                if (!isInitialized) {
                  loadArtworks(context, authState);
                  isInitialized = true;
                }

                // Building UI when user is logged in
                return _buildTFAPage(context, artState);
              } else if (authState is AuthStateLoggedOut) {
                // UI for logged out state
                return SignUpPage();
              } else {
                // UI for other states (e.g., loading)
                return Center(child: CircularProgressIndicator());
              }
            },
          ),
        );
      },
    );
  }

  void loadArtworks(BuildContext context, AuthState authState) async {
    List<TinderArt>? savedArtworks = await LocalStorageHelper.loadArtworks();
    if (savedArtworks != null && savedArtworks.isNotEmpty) {
      context.read<TinderArtBloc>().add(LoadSavedArtworks(savedArtworks));
      setState(() {
        artCards.addAll(savedArtworks);
      });
    } else if (authState is AuthStateLoggedIn) {
      context
          .read<TinderArtBloc>()
          .add(FetchArtworkRecommendations(10, authState.token));
    }
  }

  Widget _buildTFAPage(BuildContext context, ArtworkState artState) {
    final appinioController = AppinioController(
      totalArtworks: artCards.length,
      context: context,
      swiperController: _swiperController,
    );

    // // Populate artCards only once when recommendations are fetched
    // if (artState.recommendations.isNotEmpty && artCards.isEmpty) {
    //   preloadImages(artState.recommendations, context).then((_) {
    //     setState(() {
    //       artCards.addAll(artState.recommendations);
    //     });
    //   });
    // }

    if (artState.recommendations.isNotEmpty && artCards.isEmpty) {
      artCards.addAll(artState.recommendations);
    }

    if (artState.isLoading) {
      return Scaffold(
          appBar: appBar(),
          body: Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('Loading your recommendations!'),
              CircularProgressIndicator(),
            ],
          )));
    } else if (artState.error != null) {
      return Scaffold(body: Center(child: Text('Error: ${artState.error}')));
    } else {
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
                    // child: TinderUndoButton(
                    //     appinioController: appinioController, state: artState),
                    child: IconButton(
                        icon: Icon(Icons.zoom_out_map, color: Colors.black),
                        onPressed: () {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => FullScreenPhotoView(
                                  imageUrl: artState
                                      .recommendations[artState.currentIndex]
                                      .imageUrl),
                            ),
                          );
                        }),
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
