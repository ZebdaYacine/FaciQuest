import 'package:faciquest/features/features.dart';

class WalletResponseDto {
  const WalletResponseDto({
    required this.message,
    required this.date,
  });

  final String message;
  final WalletDto date;

  factory WalletResponseDto.fromMap(Map<String, dynamic> map) {
    return WalletResponseDto(
      message: map['message'] as String? ?? '',
      date: WalletDto.fromMap(map['date'] as Map<String, dynamic>? ?? {}),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'message': message,
      'date': date.toMap(),
    };
  }

  WalletEntity toEntity() => date.toEntity();
}
