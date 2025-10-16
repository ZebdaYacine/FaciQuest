import 'package:equatable/equatable.dart';

class WalletEntity extends Equatable {
  const WalletEntity({
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

  final String id;
  final double amount;
  final double tempAmount;
  final int nbrSurveys;
  final String ccp;
  final String rip;
  final String userId;
  final String paymentMethod;
  final bool isCashable;

  @override
  List<Object?> get props => [
        id,
        amount,
        tempAmount,
        nbrSurveys,
        ccp,
        rip,
        userId,
        paymentMethod,
        isCashable,
      ];

  WalletEntity copyWith({
    String? id,
    double? amount,
    double? tempAmount,
    int? nbrSurveys,
    String? ccp,
    String? rip,
    String? userId,
    String? paymentMethod,
    bool? isCashable,
  }) {
    return WalletEntity(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      tempAmount: tempAmount ?? this.tempAmount,
      nbrSurveys: nbrSurveys ?? this.nbrSurveys,
      ccp: ccp ?? this.ccp,
      rip: rip ?? this.rip,
      userId: userId ?? this.userId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isCashable: isCashable ?? this.isCashable,
    );
  }
}

