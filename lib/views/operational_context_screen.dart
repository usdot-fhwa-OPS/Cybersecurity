import 'package:flutter/material.dart';

//TODO -- Refactor with Provider
class OpContextScreen extends StatefulWidget {
  const OpContextScreen({required this.label, Key? key})
    : super(key: key);

    /// The label
  final String label;

  @override
  State<OpContextScreen> createState() => _OpContextScreenState();
}

class _OpContextScreenState extends State<OpContextScreen> {
  final TextEditingController typeController = TextEditingController();
  final TextEditingController useController = TextEditingController();

  ConnectionType? selectedType;  
  IntendedUse? selectedUse;

  @override
  Widget build(BuildContext context) {

    //Connection Type Dropdown
    final List<DropdownMenuEntry<ConnectionType>> typeEntries = 
            <DropdownMenuEntry<ConnectionType>>[];
    for (final ConnectionType type in ConnectionType.values) {
      typeEntries.add(DropdownMenuEntry<ConnectionType>(value: type, label: type.label));
    }

    //Intended Use Dropdown
    final List<DropdownMenuEntry<IntendedUse>> useEntries = 
            <DropdownMenuEntry<IntendedUse>>[];
    for (final IntendedUse use in IntendedUse.values) {
      useEntries.add(DropdownMenuEntry<IntendedUse>(value: use, label: use.label));
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
            child: Text('Connection Type',
              style: Theme.of(context).textTheme.titleLarge),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: DropdownMenu<ConnectionType>(
                width: 250.0,
                initialSelection: ConnectionType.cell,
                controller: typeController,
                dropdownMenuEntries: typeEntries,
                onSelected: (ConnectionType? type) {
                  setState(() {
                    selectedType = type;
                  });
                }
            ),
          ),

          // Intended Use Dropdown
          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 32.0),
            child: Text('Intended Use',
              style: Theme.of(context).textTheme.titleLarge),
          ),

          Padding(
            padding: const EdgeInsets.only(left: 16.0, top: 8.0),
            child: DropdownMenu<IntendedUse>(
              width: 250.0,
              initialSelection: IntendedUse.tbd1,
              controller: useController,
              dropdownMenuEntries: useEntries,
              onSelected: (IntendedUse? use) {
                setState(() {
                  selectedUse = use;
                });
              }
            ),
          ),

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

//this will change based on the api call
enum ConnectionType {
  cell('Cellular'),
  wired('Hardwired'),
  wifi('Wifi'),
  sat('Satellite');

  const ConnectionType(this.label);
  final String label;
}

//this will change based on the api call
enum IntendedUse {
  tbd1('TBD'),
  tbd2('TBD2'),
  tbd3('TBD3'),
  tbd4('TBD4');

  const IntendedUse(this.label);
  final String label;
}