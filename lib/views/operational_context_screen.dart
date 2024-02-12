import 'package:cybersecurity_its_app/models/devices.dart';
import 'package:cybersecurity_its_app/widgets/device_dropdown.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'dart:convert';

class OpContextScreen extends StatefulWidget {
  const OpContextScreen({required this.label, this.deviceJson, Key? key})
    : super(key: key);

    /// The label
  final String label;
  final String? deviceJson;

  @override
  State<OpContextScreen> createState() => _OpContextScreenState();
}

class _OpContextScreenState extends State<OpContextScreen> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController useController = TextEditingController();

  String? selectedType;  
  String? selectedUse;

  @override
  Widget build(BuildContext context) {

    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));

    final decodedDevice = jsonDecode(widget.deviceJson!);
    ITSDevice device = ITSDevice.fromJson(decodedDevice);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Operational Context"),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          DeviceDropdown(dropdownLabel: 'Connection Type', dropdownList: device.connectionType.keys.toList(), dropdownController: typeController, selectedItem: selectedType),
          DeviceDropdown(dropdownLabel: 'Intended Use', dropdownList: intendedUseList, dropdownController: useController, selectedItem: selectedUse),
      
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: ElevatedButton(
              style: style,
              //TODO: pass typeController.text and useController.text via onPressed to the Security Configurations page
              onPressed: () => context.goNamed('recommendations', pathParameters: {'deviceJson': jsonEncode(device.toJson())}),
              child: const Text('Begin Secure Configuration'),
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> intendedUseList = [
  'TBD',
];