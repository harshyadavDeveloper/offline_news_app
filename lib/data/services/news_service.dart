import '../../core/network/dio_client.dart';
import '../../core/utils/app_logger.dart';

class NewsService {
  final DioClient dioClient = DioClient();

  final String apiKey = 'bbd14d6d93674d17b16caacde691a6a1';

  Future<List<dynamic>> fetchNews() async {
    try {
      AppLogger.network('Fetching latest news from API...');

      final response = await dioClient.get(
        'https://newsapi.org/v2/top-headlines',
        queryParameters: {'country': 'us', 'apiKey': apiKey},
      );

      AppLogger.success('News fetched successfully');

      return response.data['articles'];
    } catch (e) {
      AppLogger.error('API Error: $e');

      rethrow;
    }
  }
}
