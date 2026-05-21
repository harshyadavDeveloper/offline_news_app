import 'package:flutter/material.dart';
import 'package:offline_news_app/core/network/connectivity_service.dart';

import '../core/utils/app_logger.dart';
import '../data/local/news_local_service.dart';
import '../data/models/article_model.dart';
import '../data/repositories/news_repository.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsRepository repository = NewsRepository();

  final NewsLocalService localService = NewsLocalService();
  final ConnectivityService connectivityService = ConnectivityService();

  bool isOffline = false;

  bool isLoading = false;

  bool isRefreshing = false;

  List<ArticleModel> articles = [];

  Future<void> fetchNews() async {
    try {
      AppLogger.info('ViewModel fetchNews started');

      isLoading = true;

      notifyListeners();

      /// STEP 1
      /// LOAD LOCAL DATA

      final localArticles = localService.getArticles();

      articles = localArticles
          .map<ArticleModel>(
            (json) => ArticleModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();

      AppLogger.cache('UI updated with cached articles');

      notifyListeners();

      /// STEP 2
      /// FETCH FRESH DATA

      final hasInternet = await connectivityService.checkConnection();

      if (hasInternet) {
        await refreshNews();
      } else {
        AppLogger.warning('Skipping API refresh due to no internet');
      }
    } catch (e) {
      AppLogger.error('ViewModel Error: $e');
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  Future<void> refreshNews() async {
    try {
      AppLogger.network('Fetching fresh articles...');

      isRefreshing = true;

      notifyListeners();

      final response = await repository.newsService.fetchNews();

      await localService.saveArticles(response);

      articles = response
          .map<ArticleModel>(
            (json) => ArticleModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();

      AppLogger.success('UI updated with fresh API data');
    } catch (e) {
      AppLogger.error('Refresh Error: $e');
    } finally {
      isRefreshing = false;

      notifyListeners();
    }
  }

  void startConnectivityMonitoring() {
    connectivityService.startMonitoring(
      onStatusChanged: (isConnected) async {
        isOffline = !isConnected;

        notifyListeners();

        if (isConnected) {
          AppLogger.network('Auto syncing after internet restoration...');

          await refreshNews();
        }
      },
    );
  }
}
