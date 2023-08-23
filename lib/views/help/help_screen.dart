import 'package:cybersecurity_its_app/views/help/widgets/checkbox.dart';
import 'package:cybersecurity_its_app/providers/button_enabler_provider.dart';
import 'package:cybersecurity_its_app/providers/issue_checkbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
  final GlobalKey<TooltipState> tooltipkey = GlobalKey<TooltipState>();


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
                maxLength: 1200,
                keyboardType: TextInputType.multiline,
                maxLines: 5,
                onChanged: (String value) {
                  if (textController.text.isEmpty) {
                    context.read<ButtonEnabler>().disable();
                  } else {
                    context.read<ButtonEnabler>().enable();
                  }
                }
              )
            ),
            Tooltip(
              message: 'Error: Please include a description of your issue.',
              key: tooltipkey,
              triggerMode: TooltipTriggerMode.manual,
              showDuration: const Duration(seconds: 1),
              child: Padding (
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: ElevatedButton(
                  style: style,
                  //TODO: POST below and textController.text when server is set up
                  onPressed: context.watch<ButtonEnabler>().isEnabled ? () => print('checkbox val: ${Provider.of<IssueCheckboxList>(context, listen: false).currentValue}, textbox val: ${textController.text}') : () => tooltipkey.currentState?.ensureTooltipVisible(),
                  child: const Text('Submit'),
                ),
              )
            ),
          ]
        ),
      )
    );
  }
}