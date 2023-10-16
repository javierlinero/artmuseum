import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';

class ArtworkNameWidget extends StatelessWidget {
  const ArtworkNameWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      title,
      style: AppTheme.artworkTitle,
      maxLines: 1,
    );
  }
}
