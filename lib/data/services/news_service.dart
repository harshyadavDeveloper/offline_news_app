import 'package:dio/dio.dart';

class NewsService {
  final Dio dio = Dio();

  final String apiKey = 'bbd14d6d93674d17b16caacde691a6a1';

  Future<List<dynamic>> fetchNews() async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {
          'country': 'us',
          'apiKey': apiKey,
        },
      );

      return response.data['articles'];
    } on DioException catch (e) {
      throw Exception(e.message);
    }
  }
}