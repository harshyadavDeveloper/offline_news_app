import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';

import '../utils/app_logger.dart';

class ConnectivityService {
  final Connectivity connectivity = Connectivity();

  StreamSubscription? subscription;

  void startMonitoring({required Function(bool isConnected) onStatusChanged}) {
    AppLogger.network('Starting connectivity monitoring...');

    subscription = connectivity.onConnectivityChanged.listen((result) {
      final isConnected =
          result.contains(ConnectivityResult.mobile) ||
          result.contains(ConnectivityResult.wifi);

      if (isConnected) {
        AppLogger.success('Internet connection restored');
      } else {
        AppLogger.warning('No internet connection');
      }

      onStatusChanged(isConnected);
    });
  }

  Future<bool> checkConnection() async {
    final result = await connectivity.checkConnectivity();

    final isConnected =
        result.contains(ConnectivityResult.mobile) ||
        result.contains(ConnectivityResult.wifi);

    AppLogger.network('Internet status: $isConnected');

    return isConnected;
  }

  void dispose() {
    subscription?.cancel();
  }
}
