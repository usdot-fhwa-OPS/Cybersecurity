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

import 'package:flutter/foundation.dart';

class ITSDevice {
  final int id; 
  final String deviceBrand;
  final String deviceModel; 
  final String deviceType;
  final String description;
  final String imageUrl;
  final Map<String, dynamic> connectionType;
  final Map<String, dynamic>? securityRecommendations;

  ITSDevice({required this.id, required this.deviceBrand, required this.deviceModel, required this.deviceType, required this.description, required this.imageUrl, required this.connectionType, this.securityRecommendations});

  factory ITSDevice.fromJson(Map<String, dynamic> data) {
    final id = UniqueKey().hashCode;
    data.remove('id');
    final deviceBrand = data['DeviceBrand'] as String;
    data.remove('DeviceBrand');
    final deviceModel = data['DeviceModel'] as String;
    data.remove('DeviceModel'); 
    final deviceType = data['DeviceType'] as String;
    data.remove('DeviceType'); 
    final description = data['Description'] as String;
    data.remove('Description');
    final imageUrl = data['Image'] as String;
    data.remove('Image');
    final connectionType = data['ConnectionType'] as Map<String, dynamic>;
    data.remove('ConnectionType');

    if (data['securityRecommendations'] == null) {
      final securityRecommendations = data;
      return ITSDevice(id: id, deviceBrand: deviceBrand, deviceModel: deviceModel, deviceType: deviceType, description: description, imageUrl: imageUrl, connectionType: connectionType, securityRecommendations: securityRecommendations);
      
    }
    else {
      final securityRecommendations = data['securityRecommendations'];
      return ITSDevice(id: id, deviceBrand: deviceBrand, deviceModel: deviceModel, deviceType: deviceType, description: description, imageUrl: imageUrl, connectionType: connectionType, securityRecommendations: securityRecommendations);
    }
    
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String,dynamic>{};
    data['id'] = id;
    data['DeviceBrand'] = deviceBrand;
    data['DeviceModel'] = deviceModel;
    data['DeviceType'] = deviceType; 
    data['Description'] = description;
    data['Image'] = imageUrl; 
    data['ConnectionType'] = connectionType;
    data['securityRecommendations'] = securityRecommendations;
    return data;
  }

  String deviceAsString(){
    return '$deviceBrand $deviceModel';
  }
}