class AnalyticsModel {
  final int totalUsers;
  final int activeUsers;
  final double activeUserPercentage;
  final int totalSurveys;
  final int totalCashoutRequests;
  final double totalCashoutAmount;
  final DateTime periodStart;
  final DateTime periodEnd;

  AnalyticsModel({
    required this.totalUsers,
    required this.activeUsers,
    required this.activeUserPercentage,
    required this.totalSurveys,
    required this.totalCashoutRequests,
    required this.totalCashoutAmount,
    required this.periodStart,
    required this.periodEnd,
  });

  factory AnalyticsModel.fromJson(Map<String, dynamic> json) {
    return AnalyticsModel(
      totalUsers: json['total_users'] ?? 0,
      activeUsers: json['active_users'] ?? 0,
      activeUserPercentage: (json['active_user_percentage'] ?? 0.0).toDouble(),
      totalSurveys: json['total_surveys'] ?? 0,
      totalCashoutRequests: json['total_cashout_requests'] ?? 0,
      totalCashoutAmount: (json['total_cashout_amount'] ?? 0.0).toDouble(),
      periodStart: DateTime.tryParse(json['period_start'] ?? '') ?? DateTime.now(),
      periodEnd: DateTime.tryParse(json['period_end'] ?? '') ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'total_users': totalUsers,
      'active_users': activeUsers,
      'active_user_percentage': activeUserPercentage,
      'total_surveys': totalSurveys,
      'total_cashout_requests': totalCashoutRequests,
      'total_cashout_amount': totalCashoutAmount,
      'period_start': periodStart.toIso8601String(),
      'period_end': periodEnd.toIso8601String(),
    };
  }
}

enum TimePeriod {
  week('week'),
  month('month'),
  threeMonths('3months'),
  sixMonths('6months'),
  year('year');

  const TimePeriod(this.value);
  final String value;

  String get displayName {
    switch (this) {
      case TimePeriod.week:
        return 'This Week';
      case TimePeriod.month:
        return 'This Month';
      case TimePeriod.threeMonths:
        return 'Last 3 Months';
      case TimePeriod.sixMonths:
        return 'Last 6 Months';
      case TimePeriod.year:
        return 'This Year';
    }
  }

  DateTime getStartDate() {
    final now = DateTime.now();
    switch (this) {
      case TimePeriod.week:
        return now.subtract(const Duration(days: 7));
      case TimePeriod.month:
        return DateTime(now.year, now.month - 1, now.day);
      case TimePeriod.threeMonths:
        return DateTime(now.year, now.month - 3, now.day);
      case TimePeriod.sixMonths:
        return DateTime(now.year, now.month - 6, now.day);
      case TimePeriod.year:
        return DateTime(now.year - 1, now.month, now.day);
    }
  }

  DateTime getEndDate() {
    return DateTime.now();
  }
}

class AnalyticsCard {
  final String title;
  final String value;
  final String? subtitle;
  final double? percentage;
  final bool isPositive;

  AnalyticsCard({
    required this.title,
    required this.value,
    this.subtitle,
    this.percentage,
    this.isPositive = true,
  });
}
