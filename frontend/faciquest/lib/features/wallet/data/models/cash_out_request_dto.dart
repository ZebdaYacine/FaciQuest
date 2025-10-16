import 'package:faciquest/features/features.dart';

class WalletInfoDto {
  const WalletInfoDto({
    required this.ccp,
    required this.rip,
    required this.paymentMethod,
  });

  final String ccp;
  final String rip;
  final String paymentMethod;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'ccp': ccp,
      'rip': rip,
      'payment_method': paymentMethod,
    };
  }

  factory WalletInfoDto.fromMap(Map<String, dynamic> map) {
    return WalletInfoDto(
      ccp: map['ccp'] as String? ?? '',
      rip: map['rip'] as String? ?? '',
      paymentMethod: map['payment_method'] as String? ?? '',
    );
  }
}

class CashOutRequestDto {
  const CashOutRequestDto({
    required this.wallet,
    required this.paymentRequestDate,
    required this.amount,
    required this.status,
    required this.paymentDate,
  });

  final WalletInfoDto wallet;
  final int paymentRequestDate;
  final double amount;
  final String status;
  final int paymentDate;

  factory CashOutRequestDto.fromRequest(
    CashOutRequest request,
    DateTime requestDate,
  ) {
    return CashOutRequestDto(
      wallet: WalletInfoDto(
        ccp: request.ccp,
        rip: request.rip,
        paymentMethod: request.paymentMethod,
      ),
      paymentRequestDate: requestDate.millisecondsSinceEpoch,
      amount: request.amount,
      status: 'pending',
      paymentDate: 0,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'wallet': wallet.toMap(),
      'payment_request_date': paymentRequestDate,
      'amount': amount,
      'status': status,
      'payment_date': paymentDate,
    };
  }

  factory CashOutRequestDto.fromMap(Map<String, dynamic> map) {
    return CashOutRequestDto(
      wallet: WalletInfoDto.fromMap(
        map['wallet'] as Map<String, dynamic>? ?? {},
      ),
      paymentRequestDate: map['payment_request_date'] as int? ?? 0,
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      status: map['status'] as String? ?? '',
      paymentDate: map['payment_date'] as int? ?? 0,
    );
  }

  CashOutRequestEntity toEntity(String id) {
    return CashOutRequestEntity(
      id: id,
      amount: amount,
      ccp: wallet.ccp,
      rip: wallet.rip,
      paymentMethod: wallet.paymentMethod,
      paymentRequestDate:
          DateTime.fromMillisecondsSinceEpoch(paymentRequestDate),
      status: status,
      paymentDate: paymentDate > 0
          ? DateTime.fromMillisecondsSinceEpoch(paymentDate)
          : null,
    );
  }
}

class CashOutResponseDto {
  const CashOutResponseDto({
    required this.message,
    this.data,
  });

  final String message;
  final Map<String, dynamic>? data;

  factory CashOutResponseDto.fromMap(Map<String, dynamic> map) {
    return CashOutResponseDto(
      message: map['message'] as String? ?? '',
      data: map['data'] as Map<String, dynamic>?,
    );
  }
}

