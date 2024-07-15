/*
 * Copyright (C) 2024 LEIDOS.
 *
 * Licensed under the Apache License, Version 2.0 (the "License"); you may not
 * use this file except in compliance with the License. You may obtain a copy of
 * the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
 * WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
 * License for the specific language governing permissions and limitations under
 * the License.
 */

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