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

  void updateZoom(double zoomLevel) {
    _zoomLevel = zoomLevel;

    print("new Zoom: $_zoomLevel");

    _storeZoomLevel(zoomLevel);
    notifyListeners();
  }

  void initZoomLevelStore() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double zoomLevel = prefs.getDouble('zoomLevel') ?? 1;

    _zoomLevel = zoomLevel;
  }

  void _storeZoomLevel(double zoomLevel) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble('zoomLevel', zoomLevel);
  }

  Future<double> getStoredZoomLevel() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();

    double zoomLevel = prefs.getDouble('zoomLevel') ?? 1;
    return zoomLevel;
  }
}