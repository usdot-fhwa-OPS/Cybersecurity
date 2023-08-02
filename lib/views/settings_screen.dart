import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  /// Creates a SettingsScreen
  const SettingsScreen({required this.label, Key? key})
      : super(key: key);

  /// The label
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
        iconTheme: const IconThemeData(color: Colors.black),
        backgroundColor: Colors.white,
        titleTextStyle: const TextStyle(fontSize: 16, color: Colors.black),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListView(
              padding: const EdgeInsets.only(top: 8.0),
              shrinkWrap: true,
              children: <Widget>[
                ListTile(
                leading: const Icon(Icons.exit_to_app),
                title: const Text('Logout'),
                  onTap: () {},
                )
              ],
            ),
            const Padding(padding: EdgeInsets.all(4)),
          ],
        ),
      ),
    );
  }
}