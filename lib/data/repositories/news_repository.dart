import '../../core/utils/app_logger.dart';
import '../../core/utils/data_state.dart';
import '../local/news_local_service.dart';
import '../services/news_service.dart';

class NewsRepository {
  final NewsService newsService = NewsService();

  final NewsLocalService localService = NewsLocalService();

  /// LOAD CACHED NEWS

  Future<List<dynamic>> getCachedNews() async {
    AppLogger.cache('Fetching cached news from Hive...');

    return localService.getArticles();
  }

  /// FETCH FRESH NEWS

  Future<DataState<List<dynamic>>> getFreshNews() async {
    try {
      AppLogger.network('Fetching fresh news from API...');

      final articles = await newsService.fetchNews();

      await localService.saveArticles(articles);

      AppLogger.success('Fresh news saved to cache');

      return DataState.success(articles);
    } catch (e) {
      AppLogger.error('Repository Error: $e');

      return DataState.failure(e.toString());
    }
  }

  /// CLEAR CACHE

  Future<void> clearCache() async {
    await localService.clearCache();
  }
}
