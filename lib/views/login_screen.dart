import 'package:flutter/material.dart';
import 'package:cybersecurity_its_app/utils/login_info.dart';
import 'package:provider/provider.dart';

class LoginScreen extends StatelessWidget {
  /// Creates a LoginScreen
  const LoginScreen({required this.label, Key? key})
      : super(key: key);

  /// The label
  final String label;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(label),
      ),
      body: Center(
          child: ElevatedButton(
            onPressed: () {
              // log a user in, letting all the listeners know
              context.read<LoginInfo>().login('test-user');

              // router will automatically redirect from /Login to / using
              // refreshListenable
            },
            child: const Text('Login'),
          ),
        ),
    );
  }
}