class Device {
  Device({required this.deviceBrand, required this.deviceType, required this.deviceModel});

  final String deviceBrand; 
  final String deviceType;
  final String deviceModel;

  factory Device.fromJson(Map<String, dynamic> data) {
    final deviceBrand = data['DeviceBrand'] as String;
    final deviceType = data['DeviceType'] as String;
    final deviceModel = data['DeviceModel'] as String;
    return Device(deviceBrand: deviceBrand, deviceType: deviceType, deviceModel: deviceModel);
  }
}