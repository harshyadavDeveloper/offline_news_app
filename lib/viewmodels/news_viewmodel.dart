import 'package:flutter/material.dart';

import '../core/network/connectivity_service.dart';
import '../core/utils/app_logger.dart';
import '../core/utils/data_state.dart';
import '../data/models/article_model.dart';
import '../data/repositories/news_repository.dart';

class NewsViewModel extends ChangeNotifier {
  final NewsRepository repository = NewsRepository();

  final ConnectivityService connectivityService = ConnectivityService();

  bool isLoading = false;

  bool isRefreshing = false;

  bool isOffline = false;

  String? errorMessage;

  List<ArticleModel> articles = [];

  /// INITIAL LOAD

  Future<void> fetchNews() async {
    try {
      AppLogger.state('Starting initial news load...');

      isLoading = true;

      notifyListeners();

      /// LOAD CACHE FIRST

      final cachedArticles = await repository.getCachedNews();

      articles = cachedArticles
          .map<ArticleModel>(
            (json) => ArticleModel.fromJson(Map<String, dynamic>.from(json)),
          )
          .toList();

      AppLogger.cache('UI updated with cached data');

      notifyListeners();

      /// CHECK INTERNET

      final hasInternet = await connectivityService.checkConnection();

      if (hasInternet) {
        await refreshNews();
      } else {
        AppLogger.warning('Offline mode active');

        isOffline = true;
      }
    } catch (e) {
      AppLogger.error('ViewModel Error: $e');

      errorMessage = e.toString();
    } finally {
      isLoading = false;

      notifyListeners();
    }
  }

  /// REFRESH NEWS

  Future<void> refreshNews() async {
    try {
      isRefreshing = true;

      notifyListeners();

      final DataState<List<dynamic>> response = await repository.getFreshNews();

      if (response.isSuccess) {
        articles = response.data!
            .map<ArticleModel>(
              (json) => ArticleModel.fromJson(Map<String, dynamic>.from(json)),
            )
            .toList();

        AppLogger.success('UI updated with fresh news');

        errorMessage = null;
      } else {
        errorMessage = response.error;

        AppLogger.error('Refresh failed');
      }
    } catch (e) {
      AppLogger.error('Refresh Error: $e');

      errorMessage = e.toString();
    } finally {
      isRefreshing = false;

      notifyListeners();
    }
  }

  /// CONNECTIVITY MONITORING

  void startConnectivityMonitoring() {
    connectivityService.startMonitoring(
      onStatusChanged: (isConnected) async {
        isOffline = !isConnected;

        notifyListeners();

        if (isConnected) {
          AppLogger.network('Auto syncing after internet restore...');

          await refreshNews();
        }
      },
    );
  }

  /// CLEAR CACHE

  Future<void> clearCache() async {
    await repository.clearCache();

    articles.clear();

    notifyListeners();
  }
}
