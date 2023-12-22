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
    deviceData.addAll(addQuotesToKeys(securityRecommendations));
    return deviceData;
  }

  Map<String, dynamic> addQuotesToKeys(Map<String, dynamic> m){
    Map<String, dynamic> mapWithQuotes = {};
    for (String key in m.keys){
      dynamic value = m[key];
      //if value is also a map
      if(value.runtimeType == mapWithQuotes.runtimeType){
        value = addQuotesToKeys(value);
      }
      mapWithQuotes[addQuotesToString(key)] = value;
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