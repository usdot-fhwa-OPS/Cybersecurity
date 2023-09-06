import 'package:cybersecurity_its_app/widgets/device_dropdown.dart';
import 'package:flutter/material.dart';

//TODO -- Refactor with Provider
class OpContextScreen extends StatefulWidget {
  const OpContextScreen({required this.label, this.vendor,
  this.deviceType, this.model, Key? key})
    : super(key: key);

    /// The label
  final String label;
  final String? vendor;
  final String? deviceType;
  final String? model;

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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.vendor!),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        centerTitle: true,
      ),
      body: ListView(
        children: <Widget>[
          DeviceDropdown(dropdownLabel: 'Connection Type', dropdownList: connectionList, dropdownController: typeController, selectedItem: selectedType),
          DeviceDropdown(dropdownLabel: 'Intended Use', dropdownList: intendedUseList, dropdownController: useController, selectedItem: selectedUse),
         

          // "Begin" Button
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: ElevatedButton(
              style: style,
              //TODO: pass typeController.text and useController.text via onPressed
              onPressed: () => print('${typeController.text} + ${useController.text}'),
              child: const Text('Begin Secure Configuration'),
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> connectionList = [
  'Cellular', 'Hardwired', 'Wifi', 'Satellite'
];

final List<String> intendedUseList = [
  'TBD','TBD 2','TBD 3', 'TBD 4'
];