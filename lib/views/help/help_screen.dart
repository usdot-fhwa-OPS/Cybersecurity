import 'package:cybersecurity_its_app/views/help/widgets/checkbox.dart';
import 'package:flutter/material.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({required this.label, Key? key})
      : super(key: key);

  /// The label
  final String label;
  
  @override
  State<HelpScreen> createState() => HelpScreenState();
}
class HelpScreenState extends State<HelpScreen> {
  final TextEditingController textController = TextEditingController();
  bool buttonEnabler = false;

  @override
  Widget build(BuildContext context) {
    final ButtonStyle style =
        ElevatedButton.styleFrom(textStyle: const TextStyle(fontSize: 20));
    //GestureDetector allows textfield to come out of focus and hides keyboard when tapping outside.
    return GestureDetector( 
      onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(widget.label),
        ),
        body: ListView(
          children: [ 
            const CheckboxWidget(),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: TextField(
                controller: textController,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    labelText: "Describe the issue",
                    alignLabelWithHint: true,
                ),
                maxLength: 200,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                onChanged: (data) {
                  if (textController.text.isEmpty) {
                    buttonEnabler = false;
                  } else {
                    buttonEnabler = true;
                  }
                  setState(() {});
                }
              )
            ),
            Tooltip(
              message: 'i am a tooltip',
              child: Padding (
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: ElevatedButton(
                  style: style,
                  onPressed: buttonEnabler ? () => print(textController.text) : null,
                  child: const Text('Submit'),
                ),
              )
            )
          ]
        ),
      )
    );
  }
}