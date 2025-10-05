import 'package:flutter_dotenv/flutter_dotenv.dart';

class AppConfig {
  // API Configuration
  static String get apiBaseUrl => dotenv.env['API_BASE_URL'] ?? 'http://185.209.230.104:3000';
  static int get apiTimeout => int.tryParse(dotenv.env['API_TIMEOUT'] ?? '30000') ?? 30000;

  // Authentication Configuration
  static String get authTokenKey => dotenv.env['AUTH_TOKEN_KEY'] ?? 'dashboard_auth_token';
  static String get authRefreshTokenKey => dotenv.env['AUTH_REFRESH_TOKEN_KEY'] ?? 'dashboard_refresh_token';

  // App Configuration
  static String get appName => dotenv.env['APP_NAME'] ?? 'FaciQuest Admin Dashboard';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';
  static bool get debugMode => dotenv.env['DEBUG_MODE']?.toLowerCase() == 'true';

  // Pagination Configuration
  static int get defaultPageSize => int.tryParse(dotenv.env['DEFAULT_PAGE_SIZE'] ?? '10') ?? 10;
  static int get maxPageSize => int.tryParse(dotenv.env['MAX_PAGE_SIZE'] ?? '100') ?? 100;

  // Cache Configuration
  static int get cacheDurationMinutes => int.tryParse(dotenv.env['CACHE_DURATION_MINUTES'] ?? '5') ?? 5;

  // UI Configuration
  static int get defaultThemeColor => int.tryParse(dotenv.env['DEFAULT_THEME_COLOR'] ?? '0xFF2196F3') ?? 0xFF2196F3;
  static bool get enableResponsiveBreakpoints => dotenv.env['ENABLE_RESPONSIVE_BREAKPOINTS']?.toLowerCase() == 'true';

  // Analytics Configuration
  static bool get analyticsEnabled => dotenv.env['ANALYTICS_ENABLED']?.toLowerCase() == 'true';
  static String get analyticsTrackingId => dotenv.env['ANALYTICS_TRACKING_ID'] ?? '';

  // Error Handling
  static bool get showDetailedErrors => dotenv.env['SHOW_DETAILED_ERRORS']?.toLowerCase() == 'true';
  static String get logLevel => dotenv.env['LOG_LEVEL'] ?? 'debug';
}
