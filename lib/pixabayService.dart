import 'package:dio/dio.dart';

class PixabayService {
  final Dio _dio = Dio();
  final String apiKey = '45939626-8018b04694e3aa1af3f196135';  // Add your API key here

  Future<List<dynamic>> fetchImages({int page = 1, String query = ''}) async {
    try {
      final response = await _dio.get(
        'https://pixabay.com/api/',
        queryParameters: {
          'key': apiKey,
          'q': query,
          'image_type': 'photo',
          'page': page,
          'per_page': 100
        },
      );
      return response.data['hits'];
    } catch (e) {
      throw Exception('Error fetching images');
    }
  }
}



