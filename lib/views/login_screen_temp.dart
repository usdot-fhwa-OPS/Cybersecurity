import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget {
  /// Creates a SettingsScreen
  const LoginScreen({required this.label, Key? key})
      : super(key: key);

  /// The label
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('${label} Page'),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text('${label} Page',
                style: Theme.of(context).textTheme.titleLarge),
            const Padding(padding: EdgeInsets.all(4)),
          ],
        ),
      ),
    );
  }
}