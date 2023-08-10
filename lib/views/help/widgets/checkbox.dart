import 'package:flutter/material.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({super.key});

  @override
  CheckboxWidgetState createState() => CheckboxWidgetState();
}

class CheckboxWidgetState extends State {
  final List _fields = [
    {
      "value": true,
      "text": "Missing Field Device"
    },
    {
      "value": false,
      "text": "Problems with App",
    },
    {
      "value": false,
      "text": "Wrong Security Recommendation",
    },
    {
      "value": false,
      "text": "Other",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        child: Column(
          children: List.generate(
            _fields.length,
            (index) => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text (
                _fields[index]["text"],
                style: const TextStyle(
                  fontSize: 16.0,
                  color: Colors.black,
                ),
              ),
              value: _fields[index]["value"],
              onChanged:(value) {
                setState(() {
                  for (var element in _fields) {
                    element["value"] = false;
                  }
                  _fields[index]["value"] = value;
                });
                if (_fields[index]["value"] == true) print(_fields[index]);
              },
            ),
          ),
        ),
      );
  }
}