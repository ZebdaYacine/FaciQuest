import 'dart:convert';


import 'package:faciquest/core/core.dart';
import 'package:shared_preferences/shared_preferences.dart';

enum StorageKeys {
  showOnBoarding(StoredType.boolType),
  // catalogId(StoredType.stringType),
  // catalogAddress(StoredType.stringType),
  themeMode(StoredType.stringType),
  selectedGeoHashEntity(StoredType.mapType),
  ;

  const StorageKeys(this.storedType);
  final StoredType storedType;

  Future<void> clearKeys() async {
    final pref = getIt<SharedPreferences>();
    await pref.remove(name);
  }

  /// update or store new value
  Future<bool> setValue<T>(T value) async {
    //!  FixME:  when the type is map  the assert always false
    // assert(storedType == testType(value), 'not the same type');
    try {
      final pref = getIt<SharedPreferences>();
      switch (storedType) {
        case StoredType.listType:
          return pref.setStringList(name, value as List<String>);
        case StoredType.boolType:
          return pref.setBool(name, value as bool);
        case StoredType.stringType:
          return pref.setString(name, value as String);
        case StoredType.doubleType:
          return pref.setDouble(name, value as double);
        case StoredType.intType:
          return pref.setInt(name, value as int);
        case StoredType.mapType:
          final list = <String>[];
          (value as Map<String, dynamic>).forEach((key, value) {
            final map = {key: value};
            list.add(jsonEncode(map));
          });
          return pref.setStringList(name, list);
      }
    } on Exception {
      rethrow;
    }
  }

  /// get storedValue from sharedPreferences
  dynamic get storedValue {
    final pref = getIt<SharedPreferences>();
    switch (storedType) {
      case StoredType.listType:
        return pref.getStringList(name);
      case StoredType.boolType:
        return pref.getBool(name);
      case StoredType.stringType:
        return pref.getString(name);
      case StoredType.doubleType:
        return pref.getDouble(name);
      case StoredType.intType:
        return pref.getInt(name);
      case StoredType.mapType:
        final list = pref.getStringList(name);
        final maps = <String, dynamic>{};
        list?.forEach((item) {
          final map = jsonDecode(item) as Map<String, dynamic>;
          maps.addAll(map);
        });

        return maps;
    }
  }
}

/// to define stored type for type safety
enum StoredType {
  /// bool
  boolType(bool),

  ///
  stringType(String),

  ///
  doubleType(double),

  ///
  intType(int),

  mapType(Map<String, dynamic>),

  ///
  listType(List<String>);

  const StoredType(this.x);

  /// the real type of the stored value [bool,String,double,int,List<String>]
  final Object x;
}

/// from type to stored type
StoredType? testType<T>(T type) {
  switch (T) {
    case List<String>():
      return StoredType.listType;
    case const (bool):
      return StoredType.boolType;
    case const (String):
      return StoredType.stringType;
    case const (double):
      return StoredType.doubleType;
    case const (int):
      return StoredType.intType;
    case const (Map<String, dynamic>):
      return StoredType.mapType;
    default:
      return null;
  }
}
