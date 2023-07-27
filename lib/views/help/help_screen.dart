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
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: const SafeArea(
        child: Center(
          child: CheckboxWidget()
          )),
    );
  }
}