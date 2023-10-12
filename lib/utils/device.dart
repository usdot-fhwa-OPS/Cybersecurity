class Device {
  final int id;
  final String vendor;
  final String category;
  final String model;
  final String imageUrl;
  final String description;

  Device({required this.id, required this.vendor, required this.category, required this.model, required this.imageUrl, required this.description});

  factory Device.fromJson(Map<String, dynamic> json, int deviceId) {
    return Device(
      id: deviceId,
      vendor: json["vendor"],
      category: json["category"],
      model: json["model"],
      imageUrl: json["imageUrl"],
      description: json["description"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "device": {
        "vendor": vendor,
        "category": category,
        "model": model,
        "imageUrl": imageUrl,
        "description": description,
      }
    };
  }

  String deviceAsString(){
    return '$vendor $model';
  }
}