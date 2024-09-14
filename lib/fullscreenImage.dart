import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

class FullScreenImage extends StatelessWidget {
  final dynamic image;

  const FullScreenImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Hero(
          tag: image['id'],
          child: CachedNetworkImage(
            imageUrl: image['largeImageURL'],
            fit: BoxFit.contain,
          ),
        ),
      ),
    );
  }
}
