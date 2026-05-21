import 'package:dio/dio.dart';
import 'package:offline_news_app/core/utils/app_logger.dart';

class NewsService {
  final Dio dio = Dio();

  final String apiKey = 'bbd14d6d93674d17b16caacde691a6a1';

  Future<List<dynamic>> fetchNews() async {
    try {
      final response = await dio.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {'country': 'us', 'apiKey': apiKey},
      );
      AppLogger.success('News fetched successfully');
      return response.data['articles'];
    } on DioException catch (e) {
      AppLogger.error('API Error: ${e.message}');
      throw Exception(e.message);
    }
  }
}
