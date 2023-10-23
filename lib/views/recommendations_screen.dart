import 'package:cybersecurity_its_app/widgets/device_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:cybersecurity_its_app/utils/device.dart';
import 'dart:convert';


//TODO -- Refactor with Provider
class RecommendationsScreen extends StatefulWidget {
  const RecommendationsScreen({required this.label, this.deviceJson, Key? key})
    : super(key: key);

    /// The label
  final String label;
  final String? deviceJson;

  @override
  State<RecommendationsScreen> createState() => _RecommendationsScreenState();
}

class _RecommendationsScreenState extends State<RecommendationsScreen> {

  @override
  Widget build(BuildContext context) {

    Map<String, dynamic> decodedJSON = jsonDecode(widget.deviceJson!);
    Map<String, dynamic> securityRecommendations = {...decodedJSON};
    securityRecommendations.remove("device");
    securityRecommendations.remove("id");
    securityRecommendations.remove("connectionType");
    Device device = Device.fromJson(decodedJSON["device"], decodedJSON["id"], decodedJSON["connectionType"], securityRecommendations);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Security Recommendations"),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        centerTitle: true,
      ),
      body: ListView(
        children: const <Widget>[
          
        ],
      ),
    );
  }
}
