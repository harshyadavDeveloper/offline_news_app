import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../core/utils/app_logger.dart';
import '../../viewmodels/news_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppLogger.info('HomeScreen initialized');

      context.read<NewsViewModel>().fetchNews();
      context.read<NewsViewModel>().startConnectivityMonitoring();
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NewsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Offline News App')),
      body: Column(
        children: [
          if (viewModel.isOffline)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(10),
              color: Colors.red,
              child: const Text(
                'No Internet Connection',
                style: TextStyle(color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                AppLogger.info('Pull-to-refresh triggered');

                await viewModel.refreshNews();
              },
              child: viewModel.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : ListView.builder(
                      itemCount: viewModel.articles.length,
                      itemBuilder: (context, index) {
                        final article = viewModel.articles[index];

                        return ListTile(
                          leading: article.imageUrl.isNotEmpty
                              ? CachedNetworkImage(
                                  imageUrl: article.imageUrl,
                                  width: 80,
                                  fit: BoxFit.cover,

                                  placeholder: (context, url) {
                                    AppLogger.info('Loading image...');

                                    return const SizedBox(
                                      width: 80,
                                      height: 80,
                                      child: Center(
                                        child: CircularProgressIndicator(),
                                      ),
                                    );
                                  },

                                  errorWidget: (context, url, error) {
                                    AppLogger.warning(
                                      'Failed to load image: $url',
                                    );

                                    return Container(
                                      width: 80,
                                      height: 80,
                                      color: Colors.grey.shade300,
                                      child: const Icon(Icons.broken_image),
                                    );
                                  },
                                )
                              : null,
                          title: Text(article.title),
                          subtitle: Text(
                            article.description,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        );
                      },
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
