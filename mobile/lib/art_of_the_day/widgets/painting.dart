// ignore_for_file: prefer_const_constructors_in_immutables, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';

import '../../shared/widgets/full_screen_photo_view.dart';

class PaintingWidget extends StatelessWidget {
  final String imageUrl;
  PaintingWidget({
    super.key,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10.0),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            CachedNetworkImage(
              placeholder: (context, url) => CircularProgressIndicator(),
              errorWidget: (context, url, error) => Icon(Icons.error),
              fit: BoxFit.contain,
              imageUrl: '$imageUrl/full/pct:25/0/default.jpg',
              imageBuilder: (context, imageProvider) {
                return PhotoView(
                  imageProvider: imageProvider,
                );
              },
            ),
            Positioned(
              bottom: 10,
              right: 10,
              child: IconButton(
                icon: Icon(Icons.zoom_out_map, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) =>
                          FullScreenPhotoView(imageUrl: imageUrl),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
