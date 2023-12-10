import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:puam_app/shared/index.dart';

class YearWidget extends StatelessWidget {
  const YearWidget({
    super.key,
    required this.year,
  });

  final String year;

  @override
  Widget build(BuildContext context) {
    return AutoSizeText(
      year,
      style: AppTheme.yearText,
      maxFontSize: 12,
      minFontSize: 10,
    );
  }
}
