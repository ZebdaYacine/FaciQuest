class CashoutRequestModel {
  final String id;
  final String userId;
  final String userName;
  final String userEmail;
  final double amount;
  final CashoutStatus status;
  final String paymentMethod;
  final String? paymentDetails;
  final DateTime requestedAt;
  final DateTime? processedAt;
  final String? processedBy;
  final String? rejectionReason;

  CashoutRequestModel({
    required this.id,
    required this.userId,
    required this.userName,
    required this.userEmail,
    required this.amount,
    required this.status,
    required this.paymentMethod,
    this.paymentDetails,
    required this.requestedAt,
    this.processedAt,
    this.processedBy,
    this.rejectionReason,
  });

  factory CashoutRequestModel.fromJson(Map<String, dynamic> json) {
    return CashoutRequestModel(
      id: json['id'] ?? '',
      userId: json['user_id'] ?? '',
      userName: json['user_name'] ?? '',
      userEmail: json['user_email'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: CashoutStatus.fromString(json['status'] ?? 'pending'),
      paymentMethod: json['payment_method'] ?? '',
      paymentDetails: json['payment_details'],
      requestedAt: DateTime.tryParse(json['requested_at'] ?? '') ?? DateTime.now(),
      processedAt: json['processed_at'] != null 
          ? DateTime.tryParse(json['processed_at']) 
          : null,
      processedBy: json['processed_by'],
      rejectionReason: json['rejection_reason'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'user_name': userName,
      'user_email': userEmail,
      'amount': amount,
      'status': status.value,
      'payment_method': paymentMethod,
      'payment_details': paymentDetails,
      'requested_at': requestedAt.toIso8601String(),
      'processed_at': processedAt?.toIso8601String(),
      'processed_by': processedBy,
      'rejection_reason': rejectionReason,
    };
  }
}

enum CashoutStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  processed('processed'),
  all('all');

  const CashoutStatus(this.value);
  final String value;

  static CashoutStatus fromString(String value) {
    switch (value.toLowerCase()) {
      case 'pending':
        return CashoutStatus.pending;
      case 'approved':
        return CashoutStatus.approved;
      case 'rejected':
        return CashoutStatus.rejected;
      case 'processed':
        return CashoutStatus.processed;
      default:
        return CashoutStatus.pending;
    }
  }

  String get displayName {
    switch (this) {
      case CashoutStatus.pending:
        return 'Pending';
      case CashoutStatus.approved:
        return 'Approved';
      case CashoutStatus.rejected:
        return 'Rejected';
      case CashoutStatus.processed:
        return 'Processed';
      case CashoutStatus.all:
        return 'All';
    }
  }
}

class CashoutFilters {
  final CashoutStatus status;
  final DateTime? startDate;
  final DateTime? endDate;
  final double? minAmount;
  final double? maxAmount;

  CashoutFilters({
    this.status = CashoutStatus.all,
    this.startDate,
    this.endDate,
    this.minAmount,
    this.maxAmount,
  });

  CashoutFilters copyWith({
    CashoutStatus? status,
    DateTime? startDate,
    DateTime? endDate,
    double? minAmount,
    double? maxAmount,
  }) {
    return CashoutFilters(
      status: status ?? this.status,
      startDate: startDate ?? this.startDate,
      endDate: endDate ?? this.endDate,
      minAmount: minAmount ?? this.minAmount,
      maxAmount: maxAmount ?? this.maxAmount,
    );
  }
}
