class CashoutRequestModel {
  final String id;
  final String userId;
  final String userFirstName;
  final String userLastName;
  final String userPhone;
  final String userEmail;
  final double amount;
  final CashoutStatus status;
  final String? paymentMethod;
  final String? ccp;
  final String? rip;
  final DateTime? paymentRequestDate;
  final DateTime? paymentDate;
  final WalletModel? wallet;

  CashoutRequestModel({
    required this.id,
    required this.userId,
    required this.userFirstName,
    required this.userLastName,
    required this.userPhone,
    required this.userEmail,
    required this.amount,
    required this.status,
    this.paymentMethod,
    this.ccp,
    this.rip,
    this.paymentRequestDate,
    this.paymentDate,
    this.wallet,
  });

  factory CashoutRequestModel.fromJson(Map<String, dynamic> json) {
    return CashoutRequestModel(
      id: json['_id'] ?? '',
      userId: json['userid'] ?? '',
      userFirstName: json['user_firstname'] ?? '',
      userLastName: json['user_lastname'] ?? '',
      userPhone: json['user_phone'] ?? '',
      userEmail: json['user_email'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      status: CashoutStatus.fromString(json['status'] ?? 'pending'),
      paymentMethod: json['wallet']?['payment_method'],
      ccp: json['wallet']?['ccp'],
      rip: json['wallet']?['rip'],
      paymentRequestDate: json['payment_request_date'] != null ? DateTime.tryParse(json['payment_request_date']) : null,
      paymentDate: json['payment_date'] != null ? DateTime.tryParse(json['payment_date']) : null,
      wallet: json['wallet'] != null ? WalletModel.fromJson(json['wallet']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'userid': userId,
      'user_firstname': userFirstName,
      'user_lastname': userLastName,
      'user_phone': userPhone,
      'user_email': userEmail,
      'amount': amount,
      'status': status.value,
      'payment_request_date': paymentRequestDate?.toIso8601String(),
      'payment_date': paymentDate?.toIso8601String(),
      'wallet': wallet?.toJson(),
    };
  }
}

class WalletModel {
  final String id;
  final double amount;
  final double tempAmount;
  final int nbrSurveys;
  final String ccp;
  final String rip;
  final String userId;
  final String paymentMethod;
  final bool isCashable;

  WalletModel({
    required this.id,
    required this.amount,
    required this.tempAmount,
    required this.nbrSurveys,
    required this.ccp,
    required this.rip,
    required this.userId,
    required this.paymentMethod,
    required this.isCashable,
  });

  factory WalletModel.fromJson(Map<String, dynamic> json) {
    return WalletModel(
      id: json['_id'] ?? '',
      amount: (json['amount'] ?? 0.0).toDouble(),
      tempAmount: (json['temp_amount'] ?? 0.0).toDouble(),
      nbrSurveys: json['nbr_surveys'] ?? 0,
      ccp: json['ccp'] ?? '',
      rip: json['rip'] ?? '',
      userId: json['userid'] ?? '',
      paymentMethod: json['payment_method'] ?? '',
      isCashable: json['is_cashable'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'amount': amount,
      'temp_amount': tempAmount,
      'nbr_surveys': nbrSurveys,
      'ccp': ccp,
      'rip': rip,
      'userid': userId,
      'payment_method': paymentMethod,
      'is_cashable': isCashable,
    };
  }
}

enum CashoutStatus {
  pending('pending'),
  approved('approved'),
  rejected('rejected'),
  processed('processed'),
  success('success'),
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
      case 'success':
        return CashoutStatus.success;
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
      case CashoutStatus.success:
        return 'Success';
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

  CashoutFilters({this.status = CashoutStatus.all, this.startDate, this.endDate, this.minAmount, this.maxAmount});

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
