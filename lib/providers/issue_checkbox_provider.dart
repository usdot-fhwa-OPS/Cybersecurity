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

class IssueCheckboxList with ChangeNotifier {
  final Map<String, bool> _fields = {
    "Missing Field Device": true,
    "Problems with App": false,
    "Wrong Security Recommendation": false,
    "Other": false,
  };

  String _currentValue = 'Missing Field Device';

  int get numOfFields => _fields.length;

  Map<String, bool> get fields => _fields;

  String get currentValue => _currentValue;

  void updateCurrentValue () {
    // Finds which field contains a true value and sets current value
    _fields.forEach((k,v) => {
        if (_fields[k] == true) {
          _currentValue = k,
        }
      }
    );

    // If no fields are selected, clear current value
    if (_fields.containsValue(true) == false) _currentValue = '';
    notifyListeners();
  }

  void onSelection(int index, bool value) {
    
    // Ensures one item is always checked by not allowing user to deselect a currently checked value. 
    if (_fields[fields.keys.elementAt(index)] == true) {
      null;
    }
    else {
      // Makes all false before updating to ensure no double selection
      _fields.forEach((k, v) => 
        _fields[k] = false
      );

      // Updates the selected field's value.
      _fields[fields.keys.elementAt(index)] = value;
    }
    notifyListeners();
  }
}