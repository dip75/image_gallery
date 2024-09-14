import 'package:flutter/material.dart';
import 'package:image_gallery/galleryScreen.dart';
import 'package:image_gallery/provider/image_provider.dart';
import 'package:provider/provider.dart';


void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ImageProviderNotifier()..loadImages(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pixabay Image Gallery',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: GalleryScreen(),
    );
  }
}
