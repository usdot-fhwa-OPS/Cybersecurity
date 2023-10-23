class Device {
  final int id;
  final String vendor;
  final String category;
  final String model;
  final String imageUrl;
  final String description;
  final Map<String, dynamic> connectionType;
  final Map<String, dynamic> securityRecommendations;

  Device({required this.id, required this.vendor, required this.category, required this.model, required this.imageUrl, required this.description, required this.connectionType, required this.securityRecommendations});

  factory Device.fromJson(Map<String, dynamic> json, int deviceId, Map<String, dynamic> connectionType, Map<String, dynamic> securityRecommendations) {
    return Device(
      id: deviceId,
      vendor: json["vendor"],
      category: json["category"],
      model: json["model"],
      imageUrl: json["imageUrl"],
      description: json["description"],
      connectionType: connectionType,
      securityRecommendations: securityRecommendations,
    );
  }

  Map<String, dynamic> toJson() {
    Map<String, dynamic> deviceData = {
      "\"id\"": id,
      "\"device\"": {
        "\"vendor\"": addQuotesToString(vendor),
        "\"category\"": addQuotesToString(category),
        "\"model\"": addQuotesToString(model),
        "\"imageUrl\"": addQuotesToString(imageUrl),
        "\"description\"": addQuotesToString(description),
      },
      "\"connectionType\"": addQuotesToKeys(connectionType),
    };
    deviceData.addAll(securityRecommendations);
    return deviceData;
  }

  Map<String, dynamic> addQuotesToKeys(Map<String, dynamic> m){
    Map<String, dynamic> mapWithQuotes = {};
    for (String key in m.keys){
      mapWithQuotes[addQuotesToString(key)] = m[key];
    }
    return mapWithQuotes;
  }

  String addQuotesToString(String s){
    return '"$s"';
  }

  String deviceAsString(){
    return '$vendor $model';
  }
}