import 'package:flutter/material.dart';
import '../models/devices.dart';
import '../models/devices_repository.dart';

class DevicesProvider with ChangeNotifier {
  List<ITSDevice>? devices = []; 

  Future<void> fetchDevicesList() async {
    devices = await DevicesRepository().getDevices();
    notifyListeners();
  }

  void clearDevicesList() {
    devices!.clear();
    notifyListeners();
  }
}