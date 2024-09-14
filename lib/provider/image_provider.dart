import 'package:flutter/material.dart';
import 'package:image_gallery/pixabayService.dart';


class ImageProviderNotifier extends ChangeNotifier {
  final PixabayService _service = PixabayService();
  List<dynamic> images = [];
  int _page = 1;
  String _query = '';
  bool isLoading = false;
  bool hasMore = true;

  Future<void> loadImages({bool loadMore = false}) async {
    if (isLoading) return;
    if (loadMore) _page++;
    isLoading = true;
    notifyListeners();
    
    try {
      final newImages = await _service.fetchImages(page: _page, query: _query);
      if (newImages.isEmpty) hasMore = false;
      if (loadMore) {
        images.addAll(newImages);
      } else {
        images = newImages;
      }
    } catch (e) {
      hasMore = false;
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void updateQuery(String query) {
    _query = query;
    _page = 1;
    hasMore = true;
    loadImages();
  }
}
