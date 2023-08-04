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
        centerTitle: true,
        titleTextStyle: const TextStyle(fontSize: 18),
      ),
      body: Center(
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.center,                        
          children: [   
            const Image(
              image: NetworkImage('https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg'),
            ),
            ElevatedButton(
              onPressed: () {
                context.read<LoginInfo>().login('test-user');
              },
              child: const Text('Login'),
            ),
          ],                                   
        ),
      ),
    );
  }
}