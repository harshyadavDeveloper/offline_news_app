import 'package:flutter/material.dart';

import '../core/utils/app_logger.dart';
import '../data/models/article_model.dart';
import '../data/repositories/news_repository.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsRepository repository = NewsRepository();

  bool isLoading = false;

  List<ArticleModel> articles = [];

  Future<void> fetchNews() async {
    try {
      AppLogger.info('ViewModel fetchNews started');

      isLoading = true;

      notifyListeners();

      final response = await repository.getNews();

     articles = response
    .map<ArticleModel>(
      (json) => ArticleModel.fromJson(
        Map<String, dynamic>.from(json),
      ),
    )
    .toList();

      AppLogger.success('UI updated with ${articles.length} articles');
    } catch (e) {
      AppLogger.error('ViewModel Error: $e');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }
}
