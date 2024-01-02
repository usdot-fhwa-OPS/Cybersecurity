import 'package:cybersecurity_its_app/models/device_model.dart';
import 'package:cybersecurity_its_app/widgets/device_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cybersecurity_its_app/utils/device.dart';
import 'dart:convert';

/// The details screen for selected device.
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    required this.label,
    this.deviceJson,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

  final String? deviceJson;



  @override
  State<StatefulWidget> createState() => DetailsScreenState();
}

/// The state for DetailsScreen
class DetailsScreenState extends State<DetailsScreen> {
  final TextEditingController vendorController = TextEditingController();
  final TextEditingController deviceController = TextEditingController();
  final TextEditingController modelController = TextEditingController();

  String? selectedVendor;
  String? selectedType;  
  String? selectedModel;

  
  
  @override
  Widget build(BuildContext context) {
    
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    
    final decodedDevice = jsonDecode(widget.deviceJson!);
    ITSDevice device = ITSDevice.fromJson(decodedDevice);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.label),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          DeviceDropdown(dropdownLabel: 'Vendor', dropdownList: [device.deviceBrand], dropdownController: vendorController, selectedItem: selectedVendor),
          DeviceDropdown(dropdownLabel: 'Device Type', dropdownList: [device.deviceType], dropdownController: deviceController, selectedItem: selectedType),
          DeviceDropdown(dropdownLabel: 'Model', dropdownList: [device.deviceModel], dropdownController: modelController, selectedItem: selectedModel),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: ElevatedButton(
              style: style,
              onPressed: () => context.goNamed('opcontext', pathParameters: {'deviceJson': jsonEncode(device.toJson())}),
              child: const Text('Next Step'),
            ),
          ),
        ],
      ),
    );
  }
}