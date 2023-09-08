import 'package:flutter/material.dart';

class DeviceDropdown extends StatefulWidget {
  DeviceDropdown({required this.dropdownLabel, required this.dropdownList, required this.dropdownController, required this.selectedItem, Key? key})
  : super(key: key);

  final String dropdownLabel;
  final List<String> dropdownList;
  final TextEditingController dropdownController;
  String? selectedItem;

  @override
  State<DeviceDropdown> createState() =>  DeviceDropdownState();
}

class DeviceDropdownState extends State<DeviceDropdown> {

  @override
  Widget build(BuildContext context) {

    final List<DropdownMenuEntry<String>> dropdownEntries = <DropdownMenuEntry<String>>[];
    for (final item in widget.dropdownList) {
      dropdownEntries.add(DropdownMenuEntry<String>(value: item, label: item));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [ 
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 32.0),
          child: Text(widget.dropdownLabel,
            style: Theme.of(context).textTheme.titleLarge),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 16.0, top: 8.0),
          child: DropdownMenu<String>(
            width: 250.0,
            initialSelection: widget.dropdownList[0],
            controller: widget.dropdownController,
            dropdownMenuEntries: dropdownEntries,
            onSelected: (String? item) {
              setState(() {
                widget.selectedItem = item!;
              });
            }
          ),
        )
      ],
    );
  }
}