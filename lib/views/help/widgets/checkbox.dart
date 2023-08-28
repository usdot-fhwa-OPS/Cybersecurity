import 'package:cybersecurity_its_app/providers/issue_checkbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({super.key});

  @override
  CheckboxWidgetState createState() => CheckboxWidgetState();
}

class CheckboxWidgetState extends State {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 32.0),
        child: Column(
          children: List.generate(
           context.watch<IssueCheckboxList>().numOfFields,
            (index) => CheckboxListTile(
              controlAffinity: ListTileControlAffinity.leading,
              contentPadding: EdgeInsets.zero,
              dense: true,
              title: Text (
                context.watch<IssueCheckboxList>().fields.keys.elementAt(index),
                style: const TextStyle(
                  fontSize: 16.0,
                ),
              ),
              value: context.watch<IssueCheckboxList>().fields.values.elementAt(index),
              onChanged:(value) {
                context.read<IssueCheckboxList>().onSelection(index, value!);
                context.read<IssueCheckboxList>().updateCurrentValue();
              },
            ),
          ),
        ),
      );
  }
}