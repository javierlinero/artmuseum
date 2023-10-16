import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';

class ArtworkDescriptionWidget extends StatelessWidget {
  const ArtworkDescriptionWidget({
    super.key,
    required this.description,
  });

  final String description;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      description,
      style: AppTheme.artworkDescription,
      maxFontSize: 16,
      minFontSize: 10,
      maxLines: 8,
      overflow: TextOverflow.ellipsis,
    );
  }
}
