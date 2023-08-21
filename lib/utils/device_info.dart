import 'package:flutter/material.dart';

class DeviceInfo {

  DeviceInfo(this._deviceName, this.description, this.category);

  String get deviceName => _deviceName; 
  String _deviceName;
  String description;
  String category;

}