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
            const Padding(padding: EdgeInsets.all(8)),
            Text('Connection Type',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            // Connection Type Dropdown
            DropdownMenu<ConnectionType>(
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
            const Padding(padding: EdgeInsets.all(8)),
            Text('Intended Use',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
            DropdownMenu<IntendedUse>(
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
            const Padding(padding: EdgeInsets.all(8)),
            ElevatedButton(
              style: style,
              //TODO: pass typeController.text and useController.text via onPressed
              onPressed: () => print('${typeController.text} + ${useController.text}'),
              child: const Text('Begin Secure Configuration'),
            ),
          ],
        ),
    );
  }
}


enum ConnectionType {
  cell('Cellular'),
  wired('Hardwired'),
  wifi('Wifi'),
  sat('Satellite');

  const ConnectionType(this.label);
  final String label;
}

enum IntendedUse {
  tbd1('TBD'),
  tbd2('TBD2'),
  tbd3('TBD3'),
  tbd4('TBD4');

  const IntendedUse(this.label);
  final String label;
}