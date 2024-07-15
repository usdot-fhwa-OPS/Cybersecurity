/*
 * Copyright (C) 2024 LEIDOS.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

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

    notifyListeners();
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