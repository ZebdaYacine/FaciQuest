import 'dart:convert';
import 'package:faciquest/core/core.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

enum SecuredStorageKeys {
  token(StoredType.stringType),
  syncToken(StoredType.stringType),
  user(StoredType.stringType),
  ;

  const SecuredStorageKeys(this.storedType);
  final StoredType storedType;

  Future<bool> setValue(dynamic value) async {
    try {
      final secureStorage = getIt<FlutterSecureStorage>();
      final serializedValue = jsonEncode(value);
      await secureStorage.write(key: name, value: serializedValue);
      return true;
    } on Exception {
      throw Exception('Failed to set value for key: $name');
    }
  }

  Future<dynamic> getStoredValue() async {
    final secureStorage = getIt<FlutterSecureStorage>();
    final serializedValue = await secureStorage.read(key: name);
    if (serializedValue != null) {
      final value = _decodeValue(serializedValue);
      return value;
    }
    return null;
  }

  dynamic _decodeValue(String serializedValue) {
    final decoded = jsonDecode(serializedValue);
    switch (storedType) {
      case StoredType.listType:
        return decoded as List<String>;
      case StoredType.boolType:
        return decoded as bool;
      case StoredType.stringType:
        return decoded as String;
      case StoredType.doubleType:
        return decoded as double;
      case StoredType.intType:
        return decoded as int;
      case StoredType.mapType:
        final list = decoded as List<String>?;
        final maps = <String, dynamic>{};
        list?.forEach((item) {
          final map = jsonDecode(item) as Map<String, dynamic>;
          maps.addAll(map);
        });

        return maps;
    }
  }

  Future<void> delete() async {
    final secureStorage = getIt<FlutterSecureStorage>();
    await secureStorage.delete(key: name);
  }
}
