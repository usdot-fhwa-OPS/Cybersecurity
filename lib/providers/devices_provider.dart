import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/devices.dart';
import '../models/devices_repository.dart';

class DevicesProvider with ChangeNotifier {
  List<ITSDevice>? devices = []; 

  Future<void> fetchDevicesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await DevicesRepository().getDevices();
    final String? decodedResponse = prefs.getString('apiData');
    final parsedJson = jsonDecode(decodedResponse!);
    final List<dynamic> apiData = parsedJson['Items'] as List<dynamic>;
    devices = apiData.map((json) => ITSDevice.fromJson(json)).toList();

    notifyListeners();
  }

  void clearDevicesList() {
    devices!.clear();
    notifyListeners();
  }
}