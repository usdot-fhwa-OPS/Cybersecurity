import 'package:uuid/uuid.dart';

class ITSDevice {
  final Uuid id; 
  final String deviceBrand;
  final String deviceModel; 
  final String deviceType;
  final String description;
  final String imageUrl;
  final Map<String, dynamic>? securityRecommendations;

  ITSDevice({required this.id, required this.deviceBrand, required this.deviceModel, required this.deviceType, required this.description, required this.imageUrl, this.securityRecommendations});

  factory ITSDevice.fromJson(Map<String, dynamic> data) {
    const id = Uuid();

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
    
    final securityRecommendations = data;

    return ITSDevice(id: id, deviceBrand: deviceBrand, deviceModel: deviceModel, deviceType: deviceType, description: description, imageUrl: imageUrl, securityRecommendations: securityRecommendations);
  }
}