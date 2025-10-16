enum PaymentMethod {
  baridimob,
  ccp,
  rip,
}

extension PaymentMethodExtension on PaymentMethod {
  String get displayName {
    switch (this) {
      case PaymentMethod.baridimob:
        return 'BaridiMob';
      case PaymentMethod.ccp:
        return 'CCP';
      case PaymentMethod.rip:
        return 'RIP';
    }
  }

  String get value {
    switch (this) {
      case PaymentMethod.baridimob:
        return 'baridimob';
      case PaymentMethod.ccp:
        return 'ccp';
      case PaymentMethod.rip:
        return 'rip';
    }
  }

  static PaymentMethod fromString(String value) {
    switch (value.toLowerCase()) {
      case 'baridimob':
        return PaymentMethod.baridimob;
      case 'ccp':
        return PaymentMethod.ccp;
      case 'rip':
        return PaymentMethod.rip;
      default:
        return PaymentMethod.ccp;
    }
  }
}
