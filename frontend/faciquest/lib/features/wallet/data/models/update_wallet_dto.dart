import 'package:faciquest/features/features.dart';

class UpdateWalletDto {
  const UpdateWalletDto({
    required this.amount,
    required this.nbrsurveys,
    required this.ccp,
    required this.rip,
    required this.paymentmethod,
  });

  final double amount;
  final int nbrsurveys;
  final String ccp;
  final String rip;
  final String paymentmethod;

  factory UpdateWalletDto.fromRequest(UpdateWalletRequest request) {
    return UpdateWalletDto(
      amount: request.amount,
      nbrsurveys: request.nbrSurveys,
      ccp: request.ccp,
      rip: request.rip,
      paymentmethod: request.paymentMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'amount': amount,
      'nbrsurveys': nbrsurveys,
      'ccp': ccp,
      'rip': rip,
      'paymentmethod': paymentmethod,
    };
  }
}
