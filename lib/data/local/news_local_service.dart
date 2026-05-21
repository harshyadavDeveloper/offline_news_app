import 'package:hive/hive.dart';

import '../../core/utils/app_logger.dart';

class NewsLocalService {
  final Box newsBox = Hive.box('newsBox');

  Future<void> saveArticles(List<dynamic> articles) async {
    AppLogger.cache('Saving articles to Hive...');

    await newsBox.put('articles', articles);

    AppLogger.success('Articles saved locally');
  }

  List<dynamic> getArticles() {
    AppLogger.cache('Loading articles from Hive...');

    final articles = newsBox.get('articles', defaultValue: []);

    AppLogger.success(
      'Loaded ${articles.length} cached articles',
    );

    return articles;
  }

  Future<void> clearCache() async {
    AppLogger.warning('Clearing local cache...');

    await newsBox.clear();

    AppLogger.success('Cache cleared successfully');
  }
}