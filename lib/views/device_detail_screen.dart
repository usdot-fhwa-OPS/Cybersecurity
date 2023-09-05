import 'package:cybersecurity_its_app/widgets/device_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// The details screen for selected device.
class DetailsScreen extends StatefulWidget {
  const DetailsScreen({
    required this.label,
    Key? key,
  }) : super(key: key);

  /// The label to display in the center of the screen.
  final String label;

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
          DeviceDropdown(dropdownLabel: 'Vendor', dropdownList: vendorList, dropdownController: vendorController, selectedItem: selectedVendor),
          DeviceDropdown(dropdownLabel: 'Device Type', dropdownList: deviceList, dropdownController: deviceController, selectedItem: selectedType),
          DeviceDropdown(dropdownLabel: 'Model', dropdownList: modelList, dropdownController: modelController, selectedItem: selectedModel),

          // "Begin" Button
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: ElevatedButton(
              style: style,
              onPressed: () => context.goNamed('opcontext', pathParameters: {'vendor': vendorController.text, 'deviceType': deviceController.text, 'model': modelController.text}),
              child: const Text('Next Step'),
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> vendorList = [
  'Vendor 1', 'Vendor 2', 'Vendor 3', 'Vendor 4'
];

final List<String> deviceList = [
  'Device 1', 'Device 2', 'Device 3', 'Device 4',
];

final List<String> modelList = [
  'Model 1', 'Model 2', 'Model 3', 'Model 4'
];