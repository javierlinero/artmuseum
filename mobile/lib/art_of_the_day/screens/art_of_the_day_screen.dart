// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';
import 'package:puam_app/art_of_the_day/domain/index.dart';
import 'package:puam_app/shared/index.dart';
import 'package:puam_app/art_of_the_day/index.dart';

class ArtOfTheDayPage extends StatefulWidget {
  const ArtOfTheDayPage({super.key});

  @override
  State<ArtOfTheDayPage> createState() => _ArtOfTheDayPageState();
}

class _ArtOfTheDayPageState extends State<ArtOfTheDayPage> {
  double deviceHeight(BuildContext context) =>
      MediaQuery.of(context).size.height;
  double deviceWidth(BuildContext context) => MediaQuery.of(context).size.width;
  Artwork aotd = Artwork(
      title: 'Artwork Title',
      artist: 'Artwork Artist',
      imageUrl: 'imageUrl',
      year: 'Year',
      materials: 'Materials of Artwork',
      size: 'Size of Artwork',
      description:
          'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Column(
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
                child: PaintingWidget(),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth(context) * 0.03,
                ),
                height: constraints.maxHeight * 0.05,
                child: ArtworkNameWidget(title: 'Artwork Title'),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth(context) * 0.03,
                ),
                height: constraints.maxHeight * 0.025,
                child: DetailsWidget(
                    materials: 'Materials of Item', size: 'Size of Item'),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth(context) * 0.03,
                ),
                height: constraints.maxHeight * 0.05,
                child: ArtistYearWidget(artist: 'Artist Name', year: 'Year'),
              ),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth(context) * 0.03,
                ),
                height: constraints.maxHeight * 0.2,
                child: ArtworkDescriptionWidget(description: aotd.description),
              ),
            ],
          );
        },
      ),
    );
  }
}
