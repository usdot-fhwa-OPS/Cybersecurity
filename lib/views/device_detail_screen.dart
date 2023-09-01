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

  Vendor? selectedVendor;
  DeviceType? selectedType;  
  Model? selectedModel;

  @override
  Widget build(BuildContext context) {

    final List<DropdownMenuEntry<Vendor>> vendorEntries = 
            <DropdownMenuEntry<Vendor>>[];
    for (final Vendor type in Vendor.values) {
      vendorEntries.add(DropdownMenuEntry<Vendor>(value: type, label: type.label));
    }

    final List<DropdownMenuEntry<DeviceType>> typeEntries = 
            <DropdownMenuEntry<DeviceType>>[];
    for (final DeviceType type in DeviceType.values) {
      typeEntries.add(DropdownMenuEntry<DeviceType>(value: type, label: type.label));
    }

   
    final List<DropdownMenuEntry<Model>> modelEntries = 
            <DropdownMenuEntry<Model>>[];
    for (final Model use in Model.values) {
      modelEntries.add(DropdownMenuEntry<Model>(value: use, label: use.label));
    }

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

          // Connection Type Dropdown
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0),
            child: Text('Vendor',
              style: Theme.of(context).textTheme.titleLarge),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: DropdownMenu<Vendor>(
                width: 250.0,
                initialSelection: Vendor.vendor1,
                controller: vendorController,
                dropdownMenuEntries: vendorEntries,
                onSelected: (Vendor? vendor) {
                  setState(() {
                    selectedVendor = vendor;
                  });
                }
            ),
          ),

          // Intended Use Dropdown
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0),
            child: Text('Device Type',
              style: Theme.of(context).textTheme.titleLarge),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: DropdownMenu<DeviceType>(
              width: 250.0,
              initialSelection: DeviceType.device1,
              controller: deviceController,
              dropdownMenuEntries: typeEntries,
              onSelected: (DeviceType? type) {
                setState(() {
                  selectedType
               = type;
                });
              }
            ),
          ),

          // Intended Use Dropdown
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0),
            child: Text('Model',
              style: Theme.of(context).textTheme.titleLarge),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: DropdownMenu<Model>(
              width: 250.0,
              initialSelection: Model.model1,
              controller: modelController,
              dropdownMenuEntries: modelEntries,
              onSelected: (Model? use) {
                setState(() {
                  selectedModel
               = use;
                });
              }
            ),
          ),

          // "Begin" Button
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0, right: 16.0),
            child: ElevatedButton(
              style: style,
              //TODO: pass deviceController.text and modelController.text via onPressed
              onPressed: () => context.goNamed('opcontext', pathParameters: {'vendor': vendorController.text, 'deviceType': deviceController.text, 'model': modelController.text}),
              child: const Text('Next Step'),
            ),
          ),
        ],
      ),
    );
  }
}

//this will change based on the api call
enum Vendor {
  vendor1('Vendor 1'),
  vendor2('Vendor 2'),
  vendor3('Vendor 3'),
  vendor4('Vendor 4');

  const Vendor(this.label);
  final String label;
}

//this will change based on the api call
enum DeviceType {
  device1('Device 1'),
  device2('Device 2'),
  device3('Device 3'),
  device4('Device 4');

  const DeviceType(this.label);
  final String label;
}

enum Model {
  model1('Model 1'),
  model2('Model 2'),
  model3('Model 3'),
  model4('Model 4');

  const Model(this.label);
  final String label;
}