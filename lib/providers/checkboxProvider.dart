import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Checkbox with ChangeNotifier {
  final Map<String, bool> _fields = {
    "Missing Field Device": false,
    "Problems with App": false,
    "Wrong Security Recommendation": false,
    "Other": false,
  };

  final _currentValue = '';

  Map<String, bool> get fields => _fields;

  String get currentValue => _currentValue;

  void onSelection(int index, bool value) {
    _fields.forEach((key, value) => 
      value = false
    );
    _fields[fields.keys.elementAt(index)] = value;
  }
}