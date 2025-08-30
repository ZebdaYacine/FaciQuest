import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  AuthStatus _status = AuthStatus.initial;
  AdminUser? _user;
  String? _errorMessage;
  bool _isLoading = false;

  // Getters
  AuthStatus get status => _status;
  AdminUser? get user => _user;
  String? get errorMessage => _errorMessage;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _status == AuthStatus.authenticated && _user != null;

  // Initialize auth state
  Future<void> initialize() async {
    _setLoading(true);
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      // Initialize tokens from storage
      await AuthService.initializeTokens();

      // Check if we have a saved user
      final savedUser = await AuthService.getSavedUser();
      print('authProvider:savedUser => $savedUser');
      if (savedUser != null) {
        // Validate the token
        // final user = await AuthService.validateToken();
        _user = savedUser;
        _status = AuthStatus.authenticated;
      } else {
        _status = AuthStatus.unauthenticated;
      }
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      if (kDebugMode) {
        print('Auth initialization error: $e');
      }
    } finally {
      _setLoading(false);
    }
  }

  // Login
  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();
    _status = AuthStatus.loading;
    notifyListeners();

    try {
      final loginRequest = LoginRequest(username: username, password: password);
      final loginResponse = await AuthService.login(loginRequest);

      _user = loginResponse.user;
      _status = AuthStatus.authenticated;
      _setLoading(false);

      return true;
    } catch (e) {
      _status = AuthStatus.unauthenticated;
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _setLoading(false);

      return false;
    }
  }

  // Logout
  Future<void> logout() async {
    _setLoading(true);

    try {
      await AuthService.logout();
    } catch (e) {
      if (kDebugMode) {
        print('Logout error: $e');
      }
    } finally {
      _user = null;
      _status = AuthStatus.unauthenticated;
      _clearError();
      _setLoading(false);
    }
  }

  // Check session validity
  Future<void> checkSession() async {
    if (_status == AuthStatus.authenticated) {
      final hasValidSession = await AuthService.hasValidSession();
      if (!hasValidSession) {
        _user = null;
        _status = AuthStatus.unauthenticated;
        notifyListeners();
      }
    }
  }

  // Private methods
  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  // Clear error manually
  void clearError() {
    _clearError();
  }
}
