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

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/devices.dart';
import '../models/devices_repository.dart';

class DevicesProvider with ChangeNotifier {
  List<ITSDevice>? devices = []; 

  Future<void> fetchDevicesList() async {
    try {
      await DevicesRepository().getDevices();
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      final String? decodedResponse = prefs.getString('apiData');
      final parsedJson = jsonDecode(decodedResponse!);
      final List<dynamic> apiData = parsedJson['Items'] as List<dynamic>;
      
      devices = apiData.map((json) => ITSDevice.fromJson(json)).toList();
    } catch (e) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      
      final String? decodedResponse = prefs.getString('apiData');
      final parsedJson = jsonDecode(decodedResponse!);
      final List<dynamic> apiData = parsedJson['Items'] as List<dynamic>;
      
      devices = apiData.map((json) => ITSDevice.fromJson(json)).toList();
    }
    notifyListeners();
  }

  // Clears device list for when a user logs out.
  void clearDevicesList() {
    devices!.clear();
    notifyListeners();
  }
}