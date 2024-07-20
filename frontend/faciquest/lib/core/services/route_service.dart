import 'package:flutter/material.dart';

/// this class is to refresh to the route
class RouteService extends ChangeNotifier {
  /// when this function called the router is listening
  /// and will refresh
  void refresh() {
    notifyListeners();
  }
}
