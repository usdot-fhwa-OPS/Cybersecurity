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
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Expanded(
              child: DefaultTabController(
              length: 2,
              child: Scaffold(
                appBar: TabBar(
                    tabs: [
                      Tab(text: 'Login',),
                      Tab(text: 'Register'),
                    ],
                    labelColor: Colors.black,
                  ),
                body: TabBarView(
                  children: [
                    LoginTab(),
                    RegisterTab(),
                    ],
                  ),
                ),
              ),
            ),
            Image.asset('assets/logo.png',
              fit: BoxFit.contain,
              height: 55,
            ),
          ],
        ),
      ),
    );
  }
}

class LoginTab extends StatelessWidget {
  const LoginTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //TODO remove test data and add actual authentication
                context.read<LoginInfo>().login('test-user');
              },
              child: const Text('Login'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: const Text(
                'Forgot password?',
              ),
              onTap: () {
                //TODO go to forgot password page
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: const Text(
                'Privacy',
              ),
              onTap: () {
                //TODO go to privacy page
              },
            ),
          ),
        ),
      ],
    );
  }
}

class RegisterTab extends StatelessWidget {
  const RegisterTab({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Name',
              ),
            ),
          ),
        ),
       const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: TextField(
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Email',
              ),
            ),
          ),
        ),
        const Padding(
          padding: EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: TextField(
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Password',
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 15.0),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                //TODO remove test data and add actual authentication
                context.read<LoginInfo>().login('test-user');
              },
              child: const Text('Register'),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 20.0),
          child: Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              child: const Text(
                'Privacy',
              ),
              onTap: () {
                //TODO go to privacy page
              },
            ),
          ),
        ),
      ],
    );
  }
}