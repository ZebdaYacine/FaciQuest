import 'package:equatable/equatable.dart';

class CashOutRequest extends Equatable {
  const CashOutRequest({
    required this.amount,
    required this.ccp,
    required this.rip,
    required this.paymentMethod,
  });

  final double amount;
  final String ccp;
  final String rip;
  final String paymentMethod;

  @override
  List<Object?> get props => [
        amount,
        ccp,
        rip,
        paymentMethod,
      ];
}

class CashOutRequestEntity extends Equatable {
  const CashOutRequestEntity({
    required this.id,
    required this.amount,
    required this.ccp,
    required this.rip,
    required this.paymentMethod,
    required this.paymentRequestDate,
    required this.status,
    this.paymentDate,
  });

  final String id;
  final double amount;
  final String ccp;
  final String rip;
  final String paymentMethod;
  final DateTime paymentRequestDate;
  final String status;
  final DateTime? paymentDate;

  bool get isPending => status == 'pending';
  bool get isApproved => status == 'approved';
  bool get isRejected => status == 'rejected';
  bool get isCompleted => status == 'completed';

  @override
  List<Object?> get props => [
        id,
        amount,
        ccp,
        rip,
        paymentMethod,
        paymentRequestDate,
        status,
        paymentDate,
      ];
}

