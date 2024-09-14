import 'package:flutter/material.dart';
import 'package:image_gallery/fullscreenImage.dart';
import 'package:image_gallery/provider/image_provider.dart';
import 'package:provider/provider.dart';
// Import your provider here
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
              child: GridTile(
                footer: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text('Likes: ${image['likes']}'),
                      Text('Views: ${image['views']}'),
                    ],
                  ),
                ),
                child: CachedNetworkImage(
                  imageUrl: image['webformatURL'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) => const Center(
                    child: CircularProgressIndicator(),
                  ),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
