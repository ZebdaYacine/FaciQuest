import 'package:flutter/foundation.dart';
import '../models/models.dart';
import '../services/api_service.dart';

class DashboardProvider with ChangeNotifier {
  // Loading states
  bool _isLoadingUsers = false;
  bool _isLoadingSurveys = false;
  bool _isLoadingCashouts = false;
  bool _isLoadingAnalytics = false;

  // Data
  List<UserModel> _users = [];
  List<SurveyEntity> _surveys = [];
  List<CashoutRequestModel> _cashouts = [];
  AnalyticsModel? _analytics;

  // Filters
  UserFilters _userFilters = UserFilters();
  SurveyFilters _surveyFilters = SurveyFilters();
  CashoutFilters _cashoutFilters = CashoutFilters();
  TimePeriod _selectedPeriod = TimePeriod.month;

  // Pagination
  int _usersPage = 1;
  int _surveysPage = 1;
  int _cashoutsPage = 1;
  final int _itemsPerPage = 10;

  // Getters
  bool get isLoadingUsers => _isLoadingUsers;
  bool get isLoadingSurveys => _isLoadingSurveys;
  bool get isLoadingCashouts => _isLoadingCashouts;
  bool get isLoadingAnalytics => _isLoadingAnalytics;

  List<UserModel> get users => _users;
  List<SurveyEntity> get surveys => _surveys;
  List<CashoutRequestModel> get cashouts => _cashouts;
  AnalyticsModel? get analytics => _analytics;

  UserFilters get userFilters => _userFilters;
  SurveyFilters get surveyFilters => _surveyFilters;
  CashoutFilters get cashoutFilters => _cashoutFilters;
  TimePeriod get selectedPeriod => _selectedPeriod;

  // Users methods
  Future<void> loadUsers({bool refresh = false}) async {
    if (refresh) {
      _usersPage = 1;
      _users.clear();
    }

    _isLoadingUsers = true;
    notifyListeners();

    try {
      final newUsers = await ApiService.getUsers(filters: _userFilters, page: _usersPage, limit: _itemsPerPage);

      if (refresh) {
        _users = newUsers;
      } else {
        _users.addAll(newUsers);
      }

      _usersPage++;
    } catch (e) {
      debugPrint('Error loading users: $e');
    } finally {
      _isLoadingUsers = false;
      notifyListeners();
    }
  }

  void updateUserFilters(UserFilters filters) {
    _userFilters = filters;
    loadUsers(refresh: true);
  }

  Future<void> updateUserStatus(String userId, bool isActive) async {
    try {
      final success = await ApiService.updateUserStatus(userId, isActive);
      if (success) {
        final userIndex = _users.indexWhere((user) => user.id == userId);
        if (userIndex != -1) {
          _users[userIndex] = UserModel(
            id: _users[userIndex].id,
            name: _users[userIndex].name,
            email: _users[userIndex].email,
            gender: _users[userIndex].gender,
            isActive: isActive,
            surveyCount: _users[userIndex].surveyCount,
            participationCount: _users[userIndex].participationCount,
            createdAt: _users[userIndex].createdAt,
            lastLoginAt: _users[userIndex].lastLoginAt,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating user status: $e');
    }
  }

  // Surveys methods
  Future<void> loadSurveys({bool refresh = false}) async {
    if (refresh) {
      _surveysPage = 1;
      _surveys.clear();
    }

    _isLoadingSurveys = true;
    notifyListeners();

    try {
      final newSurveys = await ApiService.getSurveys(filters: _surveyFilters, page: _surveysPage, limit: _itemsPerPage);

      if (refresh) {
        _surveys = newSurveys;
      } else {
        _surveys.addAll(newSurveys);
      }

      _surveysPage++;
    } catch (e) {
      debugPrint('Error loading surveys: $e');
    } finally {
      _isLoadingSurveys = false;
      notifyListeners();
    }
  }

  void updateSurveyFilters(SurveyFilters filters) {
    _surveyFilters = filters;
    loadSurveys(refresh: true);
  }

  Future<void> updateSurveyStatus(String surveyId, SurveyStatus status) async {
    try {
      final success = await ApiService.updateSurveyStatus(surveyId, status);
      if (success) {
        final surveyIndex = _surveys.indexWhere((survey) => survey.id == surveyId);
        if (surveyIndex != -1) {
          _surveys[surveyIndex] = _surveys[surveyIndex].copyWith(status: status);
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating survey status: $e');
    }
  }

  // Cashouts methods
  Future<void> loadCashouts({bool refresh = false}) async {
    if (refresh) {
      _cashoutsPage = 1;
      _cashouts.clear();
    }

    _isLoadingCashouts = true;
    notifyListeners();

    try {
      final newCashouts = await ApiService.getCashoutRequests(
        filters: _cashoutFilters,
        page: _cashoutsPage,
        limit: _itemsPerPage,
      );

      if (refresh) {
        _cashouts = newCashouts;
      } else {
        _cashouts.addAll(newCashouts);
      }

      _cashoutsPage++;
    } catch (e) {
      debugPrint('Error loading cashouts: $e');
    } finally {
      _isLoadingCashouts = false;
      notifyListeners();
    }
  }

  void updateCashoutFilters(CashoutFilters filters) {
    _cashoutFilters = filters;
    loadCashouts(refresh: true);
  }

  Future<void> updateCashoutStatus(String cashoutId, CashoutStatus status, {String? rejectionReason}) async {
    try {
      final success = await ApiService.updateCashoutStatus(cashoutId, status, rejectionReason: rejectionReason);
      if (success) {
        final cashoutIndex = _cashouts.indexWhere((cashout) => cashout.id == cashoutId);
        if (cashoutIndex != -1) {
          _cashouts[cashoutIndex] = CashoutRequestModel(
            id: _cashouts[cashoutIndex].id,
            userId: _cashouts[cashoutIndex].userId,
            userName: _cashouts[cashoutIndex].userName,
            userEmail: _cashouts[cashoutIndex].userEmail,
            amount: _cashouts[cashoutIndex].amount,
            status: status,
            paymentMethod: _cashouts[cashoutIndex].paymentMethod,
            paymentDetails: _cashouts[cashoutIndex].paymentDetails,
            requestedAt: _cashouts[cashoutIndex].requestedAt,
            processedAt: DateTime.now(),
            processedBy: 'admin', // Should be current admin user
            rejectionReason: rejectionReason,
          );
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Error updating cashout status: $e');
    }
  }

  // Analytics methods
  Future<void> loadAnalytics({TimePeriod? period}) async {
    if (period != null) {
      _selectedPeriod = period;
    }

    _isLoadingAnalytics = true;
    notifyListeners();

    try {
      _analytics = await ApiService.getAnalytics(_selectedPeriod);
    } catch (e) {
      debugPrint('Error loading analytics: $e');
    } finally {
      _isLoadingAnalytics = false;
      notifyListeners();
    }
  }

  void updateTimePeriod(TimePeriod period) {
    _selectedPeriod = period;
    loadAnalytics();
  }

  // Initialize dashboard data
  Future<void> initializeDashboard() async {
    await Future.wait([
      loadUsers(refresh: true),
      loadSurveys(refresh: true),
      loadCashouts(refresh: true),
      loadAnalytics(),
    ]);
  }
}
