import 'package:cybersecurity_its_app/providers/button_enabler_provider.dart';
import 'package:cybersecurity_its_app/providers/issue_checkbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class HelpScreen extends StatefulWidget {
  const HelpScreen({required this.label, Key? key})
      : super(key: key);

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
          backgroundColor: Colors.white,
          iconTheme: const IconThemeData(color: Colors.black),
          titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
          centerTitle: true,
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
            Padding (
                padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 24.0),
                child: ElevatedButton(
                  style: style,
                  onPressed: () => sendIssue(),
                  child: const Text('Submit'),
                ),
              )
          ]
        ),
      )
    );
  }

  void sendIssue() async {
    if (!Provider.of<ButtonEnabler>(context, listen: false).isEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Error: Please include a description of your issue."),
          backgroundColor: Color(0xFFD50000),
          behavior: SnackBarBehavior.floating,));
      return;
    } else {
      try {
        final db = FirebaseFirestore.instance.collection('issues');
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Success: Your issue was recieved successfully.'),
          backgroundColor: Color(0xFF00C853),
          behavior: SnackBarBehavior.floating,));
        
        context.read<ButtonEnabler>().disable();

        await db.doc().set({
          "issueDetails": textController.text,
          "issueType": Provider.of<IssueCheckboxList>(context, listen: false).currentValue,
          "timestamp": DateTime.timestamp(),
          "userEmail": "test1@gmail.com",
          "userName": "Test User",
        });

        textController.clear();
        textController.text.isEmpty;
      } catch (e) {
        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Error: Unable to send your issue at this time. Try again later.'),
          backgroundColor: Color(0xFFD50000),
          behavior: SnackBarBehavior.floating,));
      }
    }
  }
}

class CheckboxWidget extends StatefulWidget {
  const CheckboxWidget({super.key});

  @override
  CheckboxWidgetState createState() => CheckboxWidgetState();
}

class CheckboxWidgetState extends State {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 24.0),
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