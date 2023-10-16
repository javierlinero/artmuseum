import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';

// Will make dependent upon API
class ArtistYearWidget extends StatelessWidget {
  const ArtistYearWidget({
    super.key,
    required this.artist,
    required this.year,
  });

  final String artist;
  final String year;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          alignment: Alignment.center,
          padding: EdgeInsets.symmetric(horizontal: 15),
          height: 20,
          decoration: AppTheme.circleText,
          child: AutoSizeText(
            artist,
            textAlign: TextAlign.center,
            style: AppTheme.artistName,
            maxFontSize: 12,
            minFontSize: 10,
          ),
        ),
        SizedBox(width: 20),
        AutoSizeText(
          year,
          style: AppTheme.yearText,
          maxFontSize: 12,
          minFontSize: 10,
        )
      ],
    );
  }
}
