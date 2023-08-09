import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Class handles Zoom Level changes.
class ZoomInfo extends ChangeNotifier {
  
  static final ZoomInfo _singleton = ZoomInfo._internal();
  factory ZoomInfo() {
    return _singleton;
  }
  ZoomInfo._internal();

  double get zoomLevel => _zoomLevel;
  double _zoomLevel = 1;

  // Takes in new zoom level, stores it in SharedPreferences
  // and notifies listeners.
  void updateZoom(double zoomLevel) {
    _zoomLevel = zoomLevel;

    _storeZoomLevel(zoomLevel);
    notifyListeners();
  }

  // Initialize SharedPreferences. Check if zoom level is present,
  // grab stored value if so, if not set to 1 by default.
  void initZoomLevelStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double zoomLevel = prefs.getDouble('zoomLevel') ?? 1;

    _zoomLevel = zoomLevel;
  }

  // Store updated zoom level in SharedPreferences.
  void _storeZoomLevel(double zoomLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('zoomLevel', zoomLevel);
  }

  // Grab stored zoom level from SharedPreferences.
  Future<double> getStoredZoomLevel() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double zoomLevel = prefs.getDouble('zoomLevel') ?? 1;
    return zoomLevel;
  }
}