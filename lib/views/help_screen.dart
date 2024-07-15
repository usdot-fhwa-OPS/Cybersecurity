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

import 'dart:async';
import 'package:cybersecurity_its_app/providers/button_enabler_provider.dart';
import 'package:cybersecurity_its_app/providers/issue_checkbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

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

  late StreamSubscription subscription;
  bool isDeviceConnected = false;
  bool isAlertSet = false;

  @override
  void initState() {
    getConnectivity();
    super.initState();
  }

  getConnectivity() =>
      subscription = Connectivity().onConnectivityChanged.listen(
        (ConnectivityResult result) async {
          isDeviceConnected = await InternetConnectionChecker().hasConnection;
        },
      );

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

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

 Future<void> sendIssue() async {
    if (!Provider.of<ButtonEnabler>(context, listen: false).isEnabled) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              "Error: Please include a description of your issue."),
          backgroundColor: Color(0xFFD50000),
          behavior: SnackBarBehavior.floating,));
      return;
    } else {
      try {
        if (!isDeviceConnected) {
          ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Warning: Connection unavailable. Your issue will be sent upon reconnection'),
          behavior: SnackBarBehavior.floating,));
        } 

        context.read<ButtonEnabler>().disable();
        
        final db = FirebaseFirestore.instance.collection('issues');
        await db.add({
          "issueDetails": textController.text,
          "issueType": Provider.of<IssueCheckboxList>(context, listen: false).currentValue,
          "timestamp": DateTime.timestamp(),
          "userEmail": "test1@gmail.com",
          "userName": "Test User",
        });

        ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Success: Your issue was recieved successfully.'),
          backgroundColor: Color(0xFF00C853),
          behavior: SnackBarBehavior.floating,));

        textController.clear();
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