import 'package:flutter/material.dart';

extension RangeValuesExtensions on RangeValues {
  static RangeValues fromMap(Map<String, dynamic> map) {
    return RangeValues(
      map['start'] as double,
      map['end'] as double,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'start': start,
      'end': end,
    };
  }
}
