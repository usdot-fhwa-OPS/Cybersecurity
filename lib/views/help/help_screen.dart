import 'package:cybersecurity_its_app/views/help/widgets/checkbox.dart';
import 'package:flutter/material.dart';


class HelpScreen extends StatelessWidget {
  /// Creates a HelpScreen
  const HelpScreen({required this.label, Key? key})
      : super(key: key);

  /// The label
  final String label;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    //GestureDetector allows textfield to come out of focus and hides keyboard when tapping outside.
    return GestureDetector( 
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(label),
        ),
        body: ListView(
          children: [ 
            const CheckboxWidget(),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Describe the issue",
                    alignLabelWithHint: true,
                ),
                maxLength: 200,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
              )
            ),
            Padding (
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
              
              //TODO - Disable button if textfield is empty or if checkbox value is null
              child: ElevatedButton(
                style: style,
                onPressed: () {},
                child: const Text('Submit'),
              ),
            )
          ]
        ),
      )
    );
  }
}