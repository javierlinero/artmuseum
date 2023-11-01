import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';

class DetailsWidget extends StatelessWidget {
  const DetailsWidget({
    super.key,
    required this.materials,
    required this.size,
  });

  final String materials;
  final String size;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(children: [
        AutoSizeText(
          '$materials • ',
          style: AppTheme.materialsText,
          maxFontSize: 12,
          minFontSize: 8,
          overflow: TextOverflow.clip,
        ),
        AutoSizeText(
          size,
          style: AppTheme.materialsText,
          maxFontSize: 12,
          minFontSize: 8,
          overflow: TextOverflow.clip,
        )
      ]),
    );
  }
}
