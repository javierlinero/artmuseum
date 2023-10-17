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
      title: 'Garden of Earthly Delights',
      artist: 'Hieronymus Bosch',
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/9/96/The_Garden_of_earthly_delights.jpg/1920px-The_Garden_of_earthly_delights.jpg',
      year: '1490-1510',
      materials: 'Materials of Artwork',
      size: '81 in. x 152 in.',
      description:
          "As little is known of Bosch's life or intentions, interpretations of his artistic intent behind the work range from an admonition of worldly fleshy indulgence, to a dire warning on the perils of life's temptations, to an evocation of ultimate sexual joy. The intricacy of its symbolism, particularly that of the central panel, has led to a wide range of scholarly interpretations over the centuries. Twentieth-century art historians are divided as to whether the triptych's central panel is a moral warning or a panorama of paradise lost.");
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
                child: PaintingWidget(imageUrl: aotd.imageUrl),
              ),
              SizedBox(height: 25),
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: deviceWidth(context) * 0.03,
                ),
                height: constraints.maxHeight * 0.05,
                child: ArtworkNameWidget(title: aotd.title),
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
                child: ArtistYearWidget(artist: aotd.artist, year: aotd.year),
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
