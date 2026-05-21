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
    });
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = context.watch<NewsViewModel>();

    return Scaffold(
      appBar: AppBar(title: const Text('Offline News App')),
      body: RefreshIndicator(
  onRefresh: () async {
    AppLogger.info(
      'Pull-to-refresh triggered',
    );

    await viewModel.refreshNews();
  },
  child: viewModel.isLoading
      ? const Center(
          child: CircularProgressIndicator(),
        )
      : ListView.builder(
          itemCount:
              viewModel.articles.length,
          itemBuilder: (context, index) {
            final article =
                viewModel.articles[index];

            return ListTile(
              leading:
                  article.imageUrl.isNotEmpty
                      ? Image.network(
                          article.imageUrl,
                          width: 80,
                          fit: BoxFit.cover,
                        )
                      : null,
              title: Text(article.title),
              subtitle: Text(
                article.description,
                maxLines: 2,
                overflow:
                    TextOverflow.ellipsis,
              ),
            );
          },
        ),
),
    );
  }
}
