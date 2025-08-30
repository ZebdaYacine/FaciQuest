import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/models.dart';

class AuthService {
  static const String baseUrl = 'http://185.209.229.242:3000';

  // SharedPreferences keys
  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'auth_user';

  static String? _cachedToken;

  // Get cached token
  static String? get cachedToken => _cachedToken;

  // Initialize token from storage
  static Future<void> initializeTokens() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _cachedToken = prefs.getString(_tokenKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error initializing token: $e');
      }
    }
  }

  // Set token in cache and storage
  static Future<void> setToken(String token) async {
    _cachedToken = token;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_tokenKey, token);
    } catch (e) {
      if (kDebugMode) {
        print('Error saving token: $e');
      }
    }
  }

  // Clear token from cache and storage
  static Future<void> clearTokens() async {
    _cachedToken = null;

    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_tokenKey);
      await prefs.remove(_userKey);
    } catch (e) {
      if (kDebugMode) {
        print('Error clearing token: $e');
      }
    }
  }

  // Save user to storage
  static Future<void> saveUser(AdminUser user) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_userKey, json.encode(user.toJson()));
    } catch (e) {
      if (kDebugMode) {
        print('Error saving user: $e');
      }
    }
  }

  // Get user from storage
  static Future<AdminUser?> getSavedUser() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString(_userKey);
      if (userJson != null) {
        return AdminUser.fromJson(json.decode(userJson));
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error getting saved user: $e');
      }
    }
    return null;
  }

  // Login with username and password
  static Future<LoginResponse> login(LoginRequest request) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode(request.toJson()),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final loginResponse = LoginResponse.fromJson(data['date']);

        // Cache the token and save user
        await setToken(loginResponse.token);
        await saveUser(loginResponse.user);

        return loginResponse;
      } else if (response.statusCode == 401) {
        throw Exception('Invalid username or password');
      } else if (response.statusCode == 403) {
        throw Exception('Access denied. Admin permissions required.');
      } else {
        final data = json.decode(response.body);
        throw Exception(data['message'] ?? 'Login failed');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error. Please check your connection.');
    }
  }

  // Logout
  static Future<void> logout() async {
    try {
      if (_cachedToken != null) {
        final response = await http.post(
          Uri.parse('$baseUrl/logout'),
          headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_cachedToken'},
        );

        if (kDebugMode) {
          print('Logout response: ${response.statusCode}');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error during logout: $e');
      }
    } finally {
      await clearTokens();
    }
  }

  // Validate current token
  static Future<AdminUser?> validateToken() async {
    if (_cachedToken == null) {
      return null;
    }
    return getSavedUser();

    // try {
    //   final response = await http.get(
    //     Uri.parse('$baseUrl/validate'),
    //     headers: {'Content-Type': 'application/json', 'Authorization': 'Bearer $_cachedToken'},
    //   );

    //   if (response.statusCode == 200) {
    //     final data = json.decode(response.body);
    //     return AdminUser.fromJson(data['user']);
    //   } else {
    //     // Token is invalid or expired, clear tokens
    //     await clearTokens();
    //     return null;
    //   }
    // } catch (e) {
    //   return null;
    // }
  }

  // Check if user has valid session
  static Future<bool> hasValidSession() async {
    final user = await validateToken();
    return user != null;
  }
}
