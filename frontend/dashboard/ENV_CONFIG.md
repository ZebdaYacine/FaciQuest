# FaciQuest Dashboard - Environment Configuration

This dashboard application uses environment variables for configuration management. All configuration can be modified through the `.env` file without changing the code.

## Setup

1. Copy the example environment file:
   ```bash
   cp .env.example .env
   ```

2. Modify the `.env` file with your specific configuration values.

3. Run the application:
   ```bash
   flutter run
   ```

## Environment Variables

### API Configuration
- `API_BASE_URL`: Base URL for the API server (default: `http://185.209.230.104:3000`)
- `API_TIMEOUT`: Request timeout in milliseconds (default: `30000`)

### Authentication Configuration
- `AUTH_TOKEN_KEY`: Key for storing authentication token in SharedPreferences (default: `dashboard_auth_token`)
- `AUTH_REFRESH_TOKEN_KEY`: Key for storing refresh token in SharedPreferences (default: `dashboard_refresh_token`)

### App Configuration
- `APP_NAME`: Application name displayed in the title bar (default: `FaciQuest Admin Dashboard`)
- `APP_VERSION`: Application version (default: `1.0.0`)
- `DEBUG_MODE`: Enable debug mode and show debug banner (default: `true`)

### Pagination Configuration
- `DEFAULT_PAGE_SIZE`: Default number of items per page (default: `10`)
- `MAX_PAGE_SIZE`: Maximum number of items per page (default: `100`)

### Cache Configuration
- `CACHE_DURATION_MINUTES`: Cache duration in minutes (default: `5`)

### UI Configuration
- `DEFAULT_THEME_COLOR`: Primary theme color in hex format (default: `0xFF2196F3`)
- `ENABLE_RESPONSIVE_BREAKPOINTS`: Enable responsive breakpoints (default: `true`)

### Analytics Configuration
- `ANALYTICS_ENABLED`: Enable analytics tracking (default: `true`)
- `ANALYTICS_TRACKING_ID`: Analytics tracking ID (default: empty)

### Error Handling
- `SHOW_DETAILED_ERRORS`: Show detailed error messages (default: `true`)
- `LOG_LEVEL`: Logging level (default: `debug`)

## Usage Examples

### Changing API Server
To point to a different API server, update the `.env` file:
```
API_BASE_URL=https://your-api-server.com/api
```

### Changing Theme Color
To change the primary theme color:
```
DEFAULT_THEME_COLOR=0xFF4CAF50
```

### Disabling Debug Mode
To disable debug mode for production:
```
DEBUG_MODE=false
SHOW_DETAILED_ERRORS=false
LOG_LEVEL=info
```

### Custom Pagination
To change default page size:
```
DEFAULT_PAGE_SIZE=20
MAX_PAGE_SIZE=50
```

## Configuration Access

The application uses the `AppConfig` class to access environment variables throughout the codebase. This provides:

- Type-safe access to configuration values
- Default values for all variables
- Centralized configuration management

Example usage in code:
```dart
import 'services/app_config.dart';

// Get API base URL
String apiUrl = AppConfig.apiBaseUrl;

// Get theme color
Color themeColor = Color(AppConfig.defaultThemeColor);

// Check if debug mode is enabled
bool isDebug = AppConfig.debugMode;
```

## Security Notes

- Never commit the `.env` file to version control
- The `.env.example` file is safe to commit as it contains no sensitive data
- Use different `.env` files for different environments (development, staging, production)
- Keep sensitive information like API keys secure and use environment-specific values
