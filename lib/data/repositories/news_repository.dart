import '../../core/utils/app_logger.dart';
import '../local/news_local_service.dart';
import '../services/news_service.dart';

class NewsRepository {
  final NewsService newsService = NewsService();

  final NewsLocalService localService = NewsLocalService();

  Future<List<dynamic>> getNews() async {
    try {
      AppLogger.info('Starting offline-first news fetch...');

      /// STEP 1
      /// LOAD LOCAL DATA FIRST

      final localArticles = localService.getArticles();

      /// STEP 2
      /// BACKGROUND API CALL

      _fetchAndUpdateInBackground();

      /// STEP 3
      /// RETURN LOCAL DATA IMMEDIATELY

      return localArticles;
    } catch (e) {
      AppLogger.error(e.toString());

      return [];
    }
  }

  Future<void> _fetchAndUpdateInBackground() async {
    try {
      AppLogger.network('Fetching fresh articles in background...');

      final freshArticles = await newsService.fetchNews();

      await localService.saveArticles(freshArticles);

      AppLogger.success('Background sync completed');
    } catch (e) {
      AppLogger.error('Background sync failed: $e');
    }
  }
}
