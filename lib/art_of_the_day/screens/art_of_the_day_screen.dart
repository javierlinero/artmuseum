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
      body: Padding(
        padding: EdgeInsets.only(top: deviceHeight(context) * 0.03),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Text(
                'Art of the Day',
                style: AppTheme.pageTitle,
              ),
            ),
            SizedBox(height: 30),
            PaintingWidget(),
            SizedBox(height: 30),
            Padding(
              padding:
                  EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.03),
              child: ArtworkNameWidget(title: 'Artwork Title'),
            ),
            SizedBox(height: 30),
            Padding(
              padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
              child: DetailsWidget(
                  materials: 'Materials of Item', size: 'Size of Item'),
            ),
            SizedBox(height: 15),
            Padding(
              padding: EdgeInsets.only(left: deviceWidth(context) * 0.03),
              child: ArtistYearWidget(artist: 'Artist Name', year: 'Year'),
            ),
            SizedBox(height: 10),
            Container(
              padding:
                  EdgeInsets.symmetric(horizontal: deviceWidth(context) * 0.03),
              height: deviceHeight(context) * 0.15,
              width: deviceWidth(context),
              child: ArtworkDescriptionWidget(description: aotd.description),
            ),
          ],
        ),
      ),
    );
  }
}
