import 'dart:convert';
import 'package:dashboard/models/models.dart';
import 'package:http/http.dart' as http;
import 'auth_service.dart';

class ApiService {
  static const String baseUrl = 'http://185.209.229.242:3000';

  static Map<String, String> get _headers {
    final headers = {'Content-Type': 'application/json'};

    // Get token from AuthService instead of storing locally
    final token = AuthService.cachedToken;
    if (token != null && token.isNotEmpty) {
      headers['Authorization'] = 'Bearer $token';
    }

    return headers;
  }

  // Users API
  static Future<List<UserModel>> getUsers({UserFilters? filters, int page = 1, int limit = 10}) async {
    try {
      final queryParams = <String, String>{'page': page.toString(), 'limit': limit.toString()};

      if (filters != null) {
        if (filters.isActive != null) {
          queryParams['is_active'] = filters.isActive.toString();
        }
        if (filters.gender != UserGender.all) {
          queryParams['gender'] = filters.gender.name;
        }
        if (filters.minSurveys != null) {
          queryParams['min_surveys'] = filters.minSurveys.toString();
        }
        if (filters.maxSurveys != null) {
          queryParams['max_surveys'] = filters.maxSurveys.toString();
        }
        if (filters.minParticipations != null) {
          queryParams['min_participations'] = filters.minParticipations.toString();
        }
        if (filters.maxParticipations != null) {
          queryParams['max_participations'] = filters.maxParticipations.toString();
        }
      }

      final uri = Uri.parse('$baseUrl/admin/users');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> usersJson = data['date']['users'] ?? [];
        return usersJson.map((json) => UserModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch users: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching users: $e');
    }
  }

  static Future<UserModel?> getUserById(String userId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/users/$userId'), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return UserModel.fromJson(data);
      } else {
        throw Exception('Failed to fetch user: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching user: $e');
    }
  }

  static Future<bool> updateUserStatus(String userId, bool isActive) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/users/$userId/status'),
        headers: _headers,
        body: json.encode({'is_active': isActive}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating user status: $e');
    }
  }

  // Surveys API
  static Future<List<SurveyEntity>> getSurveys({SurveyFilters? filters, int page = 1, int limit = 10}) async {
    try {
      // TODO: add filters
      // final queryParams = <String, String>{'page': page.toString(), 'limit': limit.toString()};

      // if (filters != null) {
      //   if (filters.status != SurveyStatus.active) {
      //     queryParams['status'] = filters.status.name;
      //   }
      //   if (filters.startDate != null) {
      //     queryParams['start_date'] = filters.startDate!.toIso8601String();
      //   }
      //   if (filters.endDate != null) {
      //     queryParams['end_date'] = filters.endDate!.toIso8601String();
      //   }
      // }

      final uri = Uri.parse('$baseUrl/admin/surveys');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> surveysJson = data['date'] ?? [];
        return surveysJson.map((json) => SurveyEntity.fromMap(json)).toList();
      } else {
        throw Exception('Failed to fetch surveys: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching surveys: $e');
    }
  }

  static Future<SurveyEntity?> getSurveyById(String surveyId) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/surveys/$surveyId'), headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return SurveyEntity.fromMap(data);
      } else {
        throw Exception('Failed to fetch survey: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching survey: $e');
    }
  }

  static Future<bool> updateSurveyStatus(String surveyId, SurveyStatus status) async {
    try {
      final response = await http.put(
        Uri.parse('$baseUrl/admin/surveys/$surveyId/status'),
        headers: _headers,
        body: json.encode({'status': status.name}),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating survey status: $e');
    }
  }

  // Cashout Requests API
  static Future<List<CashoutRequestModel>> getCashoutRequests({
    CashoutFilters? filters,
    int page = 1,
    int limit = 10,
  }) async {
    try {
      // final queryParams = <String, String>{'page': page.toString(), 'limit': limit.toString()};

      // if (filters != null) {
      //   if (filters.status != CashoutStatus.all) {
      //     queryParams['status'] = filters.status.value;
      //   }
      //   if (filters.startDate != null) {
      //     queryParams['start_date'] = filters.startDate!.toIso8601String();
      //   }
      //   if (filters.endDate != null) {
      //     queryParams['end_date'] = filters.endDate!.toIso8601String();
      //   }
      //   if (filters.minAmount != null) {
      //     queryParams['min_amount'] = filters.minAmount.toString();
      //   }
      //   if (filters.maxAmount != null) {
      //     queryParams['max_amount'] = filters.maxAmount.toString();
      //   }
      // }

      final uri = Uri.parse('$baseUrl/admin/get-all-payments');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> cashoutsJson = data['date'] ?? [];
        return cashoutsJson.map((json) => CashoutRequestModel.fromJson(json)).toList();
      } else {
        throw Exception('Failed to fetch cashout requests: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching cashout requests: $e');
    }
  }

  static Future<bool> updateCashoutStatus(String cashoutId, CashoutStatus status) async {
    try {
      final body = {'status': status.value};

      final response = await http.put(
        Uri.parse('$baseUrl/admin/cashouts/$cashoutId/status'),
        headers: _headers,
        body: json.encode(body),
      );

      return response.statusCode == 200;
    } catch (e) {
      throw Exception('Error updating cashout status: $e');
    }
  }

  // Analytics API
  static Future<AnalyticsModel> getAnalytics(TimePeriod period) async {
    try {
      // final queryParams = {
      //   'period': period.value,
      //   'start_date': period.getStartDate().toIso8601String(),
      //   'end_date': period.getEndDate().toIso8601String(),
      // };

      final uri = Uri.parse('$baseUrl/admin/analytics');
      final response = await http.get(uri, headers: _headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        return AnalyticsModel.fromJson(data);
      } else {
        throw Exception('Failed to fetch analytics: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching analytics: $e');
    }
  }

  // Dashboard Stats
  static Future<Map<String, dynamic>> getDashboardStats() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/admin/dashboard/stats'), headers: _headers);

      if (response.statusCode == 200) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to fetch dashboard stats: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching dashboard stats: $e');
    }
  }
}
