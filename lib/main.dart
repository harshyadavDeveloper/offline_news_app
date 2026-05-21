import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/utils/app_logger.dart';
import 'viewmodels/news_viewmodel.dart';
import 'views/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  AppLogger.info('Initializing Hive...');

  await Hive.initFlutter();

  AppLogger.success('Hive Initialized');

  AppLogger.info('Opening newsBox...');

  await Hive.openBox('newsBox');

  AppLogger.success('newsBox Opened');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    AppLogger.info('Application Started');

    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => NewsViewModel())],
      child: MaterialApp(debugShowCheckedModeBanner: false, home: HomeScreen()),
    );
  }
}
