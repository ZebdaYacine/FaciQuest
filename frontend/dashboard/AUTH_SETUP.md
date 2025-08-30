# FaciQuest Admin Dashboard - Authentication Setup

This document explains the authentication system implemented for the FaciQuest Admin Dashboard.

## Features

✅ **Complete Login Flow**
- Login screen with form validation
- JWT token-based authentication
- Session persistence using SharedPreferences
- Token validation on app initialization
- Secure logout functionality

✅ **State Management**
- Authentication state management with Provider
- Loading states and error handling
- Automatic navigation based on auth status

✅ **Security Features**
- JWT token storage in SharedPreferences
- Token validation
- Automatic logout on token expiration
- API request authentication

## File Structure

```
lib/
├── models/
│   └── auth_models.dart          # Authentication models (AdminUser, LoginRequest, etc.)
├── providers/
│   └── auth_provider.dart        # Authentication state management
├── services/
│   ├── auth_service.dart         # Authentication API service
│   └── api_service.dart          # Updated to use auth tokens
├── screens/
│   └── login_screen.dart         # Login UI with form validation
└── widgets/
    └── dashboard_sidebar.dart    # Updated with logout functionality
```

## Backend API Endpoints

The authentication system expects the following API endpoints:

### 1. Login
**POST** `/api/auth/login`
```json
{
  "email": "admin@faciquest.com",
  "password": "password123"
}
```

**Response (200):**
```json
{
  "date": {
    "token": "jwt_access_token",
    "expires_in": 3600,
    "userdata": {
      "id": "user_id",
      "username": "admin",
      "email": "admin@faciquest.com",
      "role": "admin",
      "created_at": "2024-01-01T00:00:00Z",
      "last_login_at": "2024-01-01T00:00:00Z"
    }
  }
}
```

### 2. Token Validation
**GET** `/api/auth/validate`
```
Headers: Authorization: Bearer {token}
```

**Response (200):**
```json
{
  "user": {
    "id": "user_id",
    "username": "admin",
    "email": "admin@faciquest.com",
    "role": "admin",
    "created_at": "2024-01-01T00:00:00Z",
    "last_login_at": "2024-01-01T00:00:00Z"
  }
}
```

### 3. Logout
**POST** `/api/auth/logout`
```
Headers: Authorization: Bearer {token}
```

## Test Credentials

For development and testing, you can use these default credentials:

- **Username:** `admin`
- **Password:** `password123`

## Configuration

Update the base URL in `lib/services/auth_service.dart`:

```dart
static const String baseUrl = 'http://your-backend-url:8080/api/auth';
```

## Dependencies Added

The following dependency was added to `pubspec.yaml`:

```yaml
dependencies:
  shared_preferences: ^2.2.2  # For session persistence
```

## Usage

1. **Run the app** - It will show the login screen initially
2. **Enter credentials** - Use the test credentials above
3. **Access dashboard** - After successful login, you'll see the main dashboard
4. **Logout** - Click the logout button in the sidebar

## Error Handling

The system handles various error scenarios:

- **Invalid credentials** - Shows appropriate error message
- **Network errors** - Shows connection error message
- **Token expiration** - Automatically redirects to login
- **Server errors** - Shows server error message

## Security Notes

- Tokens are stored using SharedPreferences (consider using flutter_secure_storage for production)
- All API requests include the Authorization header when authenticated
- Tokens are validated on each session initialization
- User session persists across app restarts
- Invalid or expired tokens automatically log the user out

## Development Notes

1. The login form includes client-side validation
2. The UI is responsive and follows Material Design 3
3. Loading states are shown during authentication operations
4. Error messages are displayed clearly to the user
5. The logout confirmation dialog prevents accidental logouts

## Next Steps

For production use, consider:

1. Implementing secure token storage with flutter_secure_storage
2. Adding biometric authentication
3. Implementing forgot password functionality
4. Adding role-based access control
5. Implementing audit logging for admin actions
