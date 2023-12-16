// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/art_of_the_day/index.dart';
import 'package:puam_app/tinder_for_art/domain/index.dart';
import 'package:tutorial_coach_mark/tutorial_coach_mark.dart';

class ArtOfTheDayDefault extends StatefulWidget {
  const ArtOfTheDayDefault({super.key});

  @override
  State<ArtOfTheDayDefault> createState() => _ArtOfTheDayDefaultState();
}

class _ArtOfTheDayDefaultState extends State<ArtOfTheDayDefault> {
  late ArtBloc _artBloc;
  GlobalKey helpButtonKey = GlobalKey();
  late TutorialCoachMark tutorialCoachMark;

  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;

  @override
  void initState() {
    super.initState();
    _artBloc = ArtBloc(ArtworkRepository());
    _artBloc.add(FetchArtOfTheDayEvent());
    createTutorial();
    _checkFirstRun();
  }

  @override
  void dispose() {
    _artBloc.close();
    super.dispose();
  }

  void _checkFirstRun() async {
    bool firstRun = await LocalStorageHelper.isFirstRun();
    if (firstRun) {
      WidgetsBinding.instance.addPostFrameCallback((_) => showTutorial());
      await LocalStorageHelper.setFirstRunCompleted();
    }
  }

  void createTutorial() {
    tutorialCoachMark = TutorialCoachMark(
      targets: _createTargets(),
      colorShadow: Colors.black,
      hideSkip: true,
    );
  }

  List<TargetFocus> _createTargets() {
    List<TargetFocus> targets = [];
    targets.add(
      TargetFocus(
        identify: "Help Button",
        keyTarget: helpButtonKey,
        contents: [
          TargetContent(
            align: ContentAlign.bottom,
            child: Text(
              "Tap the help buttons on each page to learn more.",
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
    return targets;
  }

  void showTutorial() {
    tutorialCoachMark.show(context: context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(
          helpText: HelpData.aotdHelp,
          context: context,
          helpButtonKey: helpButtonKey),
      body: BlocBuilder<ArtBloc, ArtState>(
        bloc: _artBloc,
        builder: (context, state) {
          if (state is ArtLoading) {
            return Center(
                child: CircularProgressIndicator(
              color: AppTheme.princetonOrange,
            ));
          } else if (state is ArtLoaded) {
            final aotd = state.artwork;
            return LayoutBuilder(
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
                        child: DetailsWidget(
                            materials: aotd.materials, size: aotd.size),
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
                        child: ArtworkDescriptionWidget(
                            description: aotd.description),
                      ),
                    ],
                  ),
                );
              },
            );
          } else if (state is ArtError) {
            return Center(child: Text(state.message));
          }
          return Center(child: Text('Unexpected state'));
        },
      ),
    );
  }
}
