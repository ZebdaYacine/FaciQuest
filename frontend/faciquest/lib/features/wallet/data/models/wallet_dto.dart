import 'package:faciquest/features/features.dart';

class WalletDto {
  const WalletDto({
    required this.id,
    required this.amount,
    required this.tempAmount,
    required this.nbrsurveys,
    required this.ccp,
    required this.rip,
    required this.userid,
    required this.paymentMethod,
    required this.iscashable,
  });

  final String id;
  final double amount;
  final double tempAmount;
  final int nbrsurveys;
  final String ccp;
  final String rip;
  final String userid;
  final String paymentMethod;
  final bool iscashable;

  factory WalletDto.fromMap(Map<String, dynamic> map) {
    return WalletDto(
      id: map['_id'] as String? ?? '',
      amount: (map['amount'] as num?)?.toDouble() ?? 0.0,
      tempAmount: (map['temp_amount'] as num?)?.toDouble() ?? 0.0,
      nbrsurveys: map['nbrsurveys'] as int? ?? 0,
      ccp: map['ccp'] as String? ?? '',
      rip: map['rip'] as String? ?? '',
      userid: map['userid'] as String? ?? '',
      paymentMethod: map['paymentMethod'] as String? ?? '',
      iscashable: map['iscashable'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      '_id': id,
      'amount': amount,
      'temp_amount': tempAmount,
      'nbrsurveys': nbrsurveys,
      'ccp': ccp,
      'rip': rip,
      'userid': userid,
      'paymentMethod': paymentMethod,
      'iscashable': iscashable,
    };
  }

  WalletEntity toEntity() {
    return WalletEntity(
      id: id,
      amount: amount,
      tempAmount: tempAmount,
      nbrSurveys: nbrsurveys,
      ccp: ccp,
      rip: rip,
      userId: userid,
      paymentMethod: paymentMethod,
      isCashable: iscashable,
    );
  }
}
