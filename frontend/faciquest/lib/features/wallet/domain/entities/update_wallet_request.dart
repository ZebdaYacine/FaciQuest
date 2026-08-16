import 'package:equatable/equatable.dart';

class UpdateWalletRequest extends Equatable {
  const UpdateWalletRequest({
    required this.amount,
    required this.nbrSurveys,
    required this.ccp,
    required this.rip,
    required this.paymentMethod,
  });

  final double amount;
  final int nbrSurveys;
  final String ccp;
  final String rip;
  final String paymentMethod;

  @override
  List<Object?> get props => [
        amount,
        nbrSurveys,
        ccp,
        rip,
        paymentMethod,
      ];
}
