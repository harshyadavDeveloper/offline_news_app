class AppLogger {
  static void info(String message) {
    print('🟢 INFO: $message');
  }

  static void warning(String message) {
    print('🟡 WARNING: $message');
  }

  static void error(String message) {
    print('🔴 ERROR: $message');
  }

  static void success(String message) {
    print('✅ SUCCESS: $message');
  }

  static void cache(String message) {
    print('📦 CACHE: $message');
  }

  static void network(String message) {
    print('🌐 NETWORK: $message');
  }

  static void retry(String message) {
    print('🔄 RETRY: $message');
  }

  static void state(String message) {
    print('🧠 STATE: $message');
  }
}
