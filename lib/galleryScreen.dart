import 'package:flutter/material.dart';
import 'package:image_gallery/fullscreenImage.dart';
import 'package:image_gallery/provider/image_provider.dart';
import 'package:provider/provider.dart'; 
import 'package:cached_network_image/cached_network_image.dart';

class GalleryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final imageProvider = Provider.of<ImageProviderNotifier>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Image Gallery'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search Images',
                border: OutlineInputBorder(),
              ),
              onChanged: (query) {
                // Debounced search
                Future.delayed(const Duration(milliseconds: 500), () {
                  imageProvider.updateQuery(query);
                });
              },
            ),
          ),
        ),
      ),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels ==
              scrollNotification.metrics.maxScrollExtent &&
              imageProvider.hasMore) {
            imageProvider.loadImages(loadMore: true);
          }
          return false;
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(10),
          itemCount: imageProvider.images.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: (MediaQuery.of(context).size.width ~/ 150),
            crossAxisSpacing: 10,
            mainAxisSpacing: 10,
          ),
          itemBuilder: (context, index) {
            final image = imageProvider.images[index];
            return GestureDetector(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(
                  builder: (context) => FullScreenImage(image: image),
                ));
              },
              child: Stack(
                children: [
                  Center(
                    child: CachedNetworkImage(
                      
                      imageUrl: image['webformatURL'],
                      fit: BoxFit.contain,
                      placeholder: (context, url) => const Center(
                        child: CircularProgressIndicator(),
                      ),
                      errorWidget: (context, url, error) => const Icon(Icons.error),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: Colors.black.withOpacity(0.5),
                      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(Icons.favorite, color: Colors.white, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                '${image['likes']}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  ),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              const Icon(Icons.remove_red_eye, color: Colors.white, size: 16),
                              const SizedBox(width: 5),
                              Text(
                                '${image['views']}',
                                style: const TextStyle(color: Colors.white,
                                fontSize: 10
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
